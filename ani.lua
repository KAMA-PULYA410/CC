local mon = peripheral.find("monitor")
if not mon then error("Monitor not found") end

mon.setTextScale(0.5)
term.redirect(mon)

local W, H = term.getSize()

-- Чем больше PIXEL, тем быстрее, но грубее картинка.
-- 1 = красиво, медленно
-- 2 = быстро
-- 3 = очень быстро
local PIXEL = 2

-- Чем меньше ITER, тем быстрее.
local ITER = 24

-- Пауза между кадрами.
local FRAME_DELAY = 0.7

-- Смена цели каждые 4 секунды.
local CHANGE_TIME = 4

local spots = {
  {-0.743643887,  0.131825904, 0.35},
  {-0.1011,       0.9563,      0.45},
  {-1.25066,      0.02012,     0.35},
  {-0.75,         0.1,         0.55},
  { 0.285,        0.01,        0.55},
  {-0.15652,      1.03225,     0.35},
}

local palette = {
  colors.blue,
  colors.purple,
  colors.magenta,
  colors.red,
  colors.orange,
  colors.yellow,
  colors.lime,
  colors.cyan,
  colors.lightBlue,
  colors.white
}

local function mandel(cx, cy)
  local x, y = 0, 0
  local xx, yy = 0, 0

  for i = 1, ITER do
    y = 2 * x * y + cy
    x = xx - yy + cx
    xx = x * x
    yy = y * y

    if xx + yy > 4 then
      return i
    end
  end

  return ITER
end

local function drawBlock(x, y, size, color)
  paintutils.drawFilledBox(x, y, math.min(x + size - 1, W), math.min(y + size - 1, H), color)
end

local function drawFrame(cx, cy, scale)
  local aspect = W / H
  local halfScale = scale / 2
  local halfScaleX = halfScale * aspect

  for py = 1, H, PIXEL do
    local my = cy + ((py - 1) / H - 0.5) * scale

    for px = 1, W, PIXEL do
      local mx = cx + ((px - 1) / W - 0.5) * scale * aspect

      local n = mandel(mx, my)

      if n == ITER then
        drawBlock(px, py, PIXEL, colors.black)
      else
        drawBlock(px, py, PIXEL, palette[(n % #palette) + 1])
      end
    end

    if py % 6 == 1 then
      sleep(0)
    end
  end
end

local function smooth(t)
  return t * t * (3 - 2 * t)
end

local function lerp(a, b, t)
  return a + (b - a) * t
end

local current = 1
local nextSpot = 2

local startX, startY, startScale = -0.5, 0, 3.0
local endX, endY, endScale = spots[nextSpot][1], spots[nextSpot][2], spots[nextSpot][3]

local startTime = os.clock()

term.setBackgroundColor(colors.black)
term.clear()

while true do
  local elapsed = os.clock() - startTime
  local t = elapsed / CHANGE_TIME

  if t >= 1 then
    current = nextSpot
    nextSpot = nextSpot + 1
    if nextSpot > #spots then nextSpot = 1 end

    startX = endX
    startY = endY
    startScale = endScale

    endX = spots[nextSpot][1]
    endY = spots[nextSpot][2]
    endScale = spots[nextSpot][3]

    startTime = os.clock()
    t = 0
  end

  local s = smooth(t)

  local cx = lerp(startX, endX, s)
  local cy = lerp(startY, endY, s)

  -- Плавное приближение внутри каждого перехода
  local scale = lerp(startScale, endScale * 0.35, s)

  drawFrame(cx, cy, scale)

  sleep(FRAME_DELAY)
end