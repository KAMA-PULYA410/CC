local mon = peripheral.find("monitor")
if not mon then error("Monitor not found") end

mon.setTextScale(0.5)
term.redirect(mon)

local W, H = term.getSize()

local FRAME_DELAY = 0.12
local SHAPE_TIME = 5
local SCALE = math.min(W, H) * 0.33

local palette = {
  colors.red,
  colors.orange,
  colors.yellow,
  colors.lime,
  colors.cyan,
  colors.lightBlue,
  colors.purple,
  colors.magenta,
}

local phi = (1 + math.sqrt(5)) / 2

local shapes = {
  {
    name = "Cube",
    color = colors.cyan,
    verts = {
      {-1,-1,-1},{1,-1,-1},{1,1,-1},{-1,1,-1},
      {-1,-1,1},{1,-1,1},{1,1,1},{-1,1,1}
    },
    edges = {
      {1,2},{2,3},{3,4},{4,1},
      {5,6},{6,7},{7,8},{8,5},
      {1,5},{2,6},{3,7},{4,8}
    }
  },

  {
    name = "Tetra",
    color = colors.orange,
    verts = {
      {1,1,1},{-1,-1,1},{-1,1,-1},{1,-1,-1},
      {0,0,0},{0,0,0},{0,0,0},{0,0,0}
    },
    edges = {
      {1,2},{1,3},{1,4},{2,3},{2,4},{3,4}
    }
  },

  {
    name = "Octa",
    color = colors.lime,
    verts = {
      {1,0,0},{-1,0,0},{0,1,0},{0,-1,0},{0,0,1},{0,0,-1},
      {0,0,0},{0,0,0}
    },
    edges = {
      {1,3},{1,4},{1,5},{1,6},
      {2,3},{2,4},{2,5},{2,6},
      {3,5},{5,4},{4,6},{6,3}
    }
  },

  {
    name = "Icosa",
    color = colors.magenta,
    verts = {
      {-1, phi, 0},{1, phi, 0},{-1,-phi,0},{1,-phi,0},
      {0,-1, phi},{0,1, phi},{0,-1,-phi},{0,1,-phi},
      {phi,0,-1},{phi,0,1},{-phi,0,-1},{-phi,0,1}
    },
    edges = {
      {1,2},{1,6},{1,8},{1,11},{1,12},
      {2,6},{2,8},{2,9},{2,10},
      {3,4},{3,5},{3,7},{3,11},{3,12},
      {4,5},{4,7},{4,9},{4,10},
      {5,6},{5,10},{5,12},
      {6,10},{6,12},
      {7,8},{7,9},{7,11},
      {8,9},{8,11},
      {9,10},
      {11,12}
    }
  },

  {
    name = "Dodeca-ish",
    color = colors.yellow,
    verts = {
      {-1,-1,-1},{-1,-1,1},{-1,1,-1},{-1,1,1},
      {1,-1,-1},{1,-1,1},{1,1,-1},{1,1,1},
      {0,-1/phi,-phi},{0,-1/phi,phi},{0,1/phi,-phi},{0,1/phi,phi}
    },
    edges = {
      {1,2},{1,3},{1,5},{1,9},
      {2,4},{2,6},{2,10},
      {3,4},{3,7},{3,11},
      {4,8},{4,12},
      {5,6},{5,7},{5,9},
      {6,8},{6,10},
      {7,8},{7,11},
      {8,12},
      {9,11},{10,12}
    }
  }
}

local function smooth(t)
  return t * t * (3 - 2 * t)
end

local function lerp(a, b, t)
  return a + (b - a) * t
end

local function normalizeShape(shape)
  local maxLen = 0

  for _, v in ipairs(shape.verts) do
    local len = math.sqrt(v[1]^2 + v[2]^2 + v[3]^2)
    if len > maxLen then maxLen = len end
  end

  for _, v in ipairs(shape.verts) do
    v[1] = v[1] / maxLen
    v[2] = v[2] / maxLen
    v[3] = v[3] / maxLen
  end
end

for _, s in ipairs(shapes) do
  normalizeShape(s)
end

local function rotate(v, ax, ay, az)
  local x, y, z = v[1], v[2], v[3]

  local c, s = math.cos(ax), math.sin(ax)
  y, z = y * c - z * s, y * s + z * c

  c, s = math.cos(ay), math.sin(ay)
  x, z = x * c - z * s, x * s + z * c

  c, s = math.cos(az), math.sin(az)
  x, y = x * c - y * s, x * s + y * c

  return x, y, z
end

local function project(x, y, z)
  local dist = 3.2
  local p = dist / (z + dist)

  local sx = math.floor(W / 2 + x * SCALE * p)
  local sy = math.floor(H / 2 + y * SCALE * p * 0.65)

  return sx, sy
end

local function drawMorph(a, b, t, angle)
  term.setBackgroundColor(colors.black)
  term.clear()

  local points = {}

  for i = 1, 12 do
    local va = a.verts[((i - 1) % #a.verts) + 1]
    local vb = b.verts[((i - 1) % #b.verts) + 1]

    local x = lerp(va[1], vb[1], t)
    local y = lerp(va[2], vb[2], t)
    local z = lerp(va[3], vb[3], t)

    x, y, z = rotate(x and {x,y,z} or {0,0,0}, angle, angle * 0.73, angle * 0.31)
    points[i] = { project(x, y, z) }
  end

  local edgeSource = t < 0.5 and a.edges or b.edges
  local color = t < 0.5 and a.color or b.color

  for _, e in ipairs(edgeSource) do
    local p1 = points[e[1]]
    local p2 = points[e[2]]

    if p1 and p2 then
      paintutils.drawLine(p1[1], p1[2], p2[1], p2[2], color)
    end
  end

  term.setCursorPos(2, 2)
  term.setTextColor(color)
  term.setBackgroundColor(colors.black)
  write(a.name .. " -> " .. b.name)
end

local index = 1
local startTime = os.clock()
local angle = 0

while true do
  local nextIndex = index + 1
  if nextIndex > #shapes then nextIndex = 1 end

  local elapsed = os.clock() - startTime
  local t = elapsed / SHAPE_TIME

  if t >= 1 then
    index = nextIndex
    startTime = os.clock()
    t = 0
  end

  local st = smooth(t)

  drawMorph(shapes[index], shapes[nextIndex], st, angle)

  angle = angle + 0.08
  sleep(FRAME_DELAY)
end