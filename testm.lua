local speaker = peripheral.find("speaker")
local dfpwm = require("cc.audio.dfpwm")
local decoder = dfpwm.make_decoder()

local file = fs.open("ariel.dfpwm", "rb")

local buffer = decoder("chunk")

while true do
    local chunk = file.read(16 * 1024)
    if not chunk then break end
    
    while not speaker.playAudio(buffer) do
            os.pullEvent("speaker_audio_empty")
    end
end
file.close()
