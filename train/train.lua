local speaker = peripheral.find("speaker")
if not speaker then error("Speaker not found") end

local dfpwm = require("cc.audio.dfpwm")

local INPUT_SIDE = "back"

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

local wasPowered = false

print("Train announcer started")

while true do
    local powered = redstone.getInput(INPUT_SIDE)

    if powered and not wasPowered then
        print("Train detected")
        playFile("prib.dfpwm")

        sleep(8) -- пауза перед объявлением отправления
        playFile("otb.dfpwm")
    end

    wasPowered = powered
    os.pullEvent("redstone")
end
