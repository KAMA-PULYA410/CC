local detector = peripheral.find("entityDetector")
local speaker = peripheral.find("speaker")

if not detector then error("Entity Detector not found") end
if not speaker then error("Speaker not found") end

local dfpwm = require("cc.audio.dfpwm")

local RANGE = 64
local ALARM_FILE = "siren.dfpwm"
local COOLDOWN = 20

local lastAlarm = 0

local function playFile(path)
    local file = fs.open(path, "rb")
    if not file then
        print("File not found: " .. path)
        return
    end

    local decoder = dfpwm.make_decoder()

    while true do
        local chunk = file.read(16 * 1024)
        if not chunk then break end

        local buffer = decoder(chunk)

        while not speaker.playAudio(buffer) do
            os.pullEvent("speaker_audio_empty")
        end
    end

    file.close()
end

while true do
    local entities = detector.scanEntities(RANGE)
    local found = false

    for _, entity in ipairs(entities) do
        if entity.name == "minecraft:phantom" or entity.type == "minecraft:phantom" then
            found = true
            break
        end
    end

    if found and os.clock() - lastAlarm > COOLDOWN then
        print("PHANTOM DETECTED!")
        playFile(ALARM_FILE)
        lastAlarm = os.clock()
    end

    sleep(3)
end