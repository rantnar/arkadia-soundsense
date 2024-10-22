arkadia_soundsense = arkadia_soundsense or {}

arkadia_soundsense.soundtable = {
    ["walka"] = {
        ["zadane"] = {
            ["1"] = "sounds/walka_zadane_1.mp3",
            ["2"] = "sounds/walka_zadane_2.mp3",
            ["3"] = "sounds/walka_zadane_3.mp3",
        },
        ["otrzymane"] = {
            ["1"] = "sounds/walka_otrzymane_1.mp3",
            ["2"] = "sounds/walka_otrzymane_2.mp3",
            ["3"] = "sounds/walka_otrzymane_3.mp3",
        },
        ["uniki"] = {
            ["1"] = "sounds/walka_uniki_1.mp3",
            ["2"] = "sounds/walka_uniki_2.mp3",
            ["3"] = "sounds/walka_uniki_3.mp3",
        },
        ["parowanie"] = {
            ["1"] = "sounds/walka_parowanie_1.mp3",
            ["2"] = "sounds/walka_parowanie_2.mp3",
            ["3"] = "sounds/walka_parowanie_3.mp3",
        }
    },
    ["env"] = {
        ["deszcz"] = "sounds/deszcz.mp3",
        ["burza"] = "sounds/burza.mp3",
        ["wiatr"] = "sounds/wiatr.mp3",
    }
}

local sound_map = {
    ["ledwo muskasz"] = arkadia_soundsense.soundtable["walka"]["zadane"]["1"],
    ["uuu wieje wiatr"] = arkadia_soundsense.soundtable["env"]["wiatr"]
}

-- Function to play sound
function arkadia_soundsense:play_sound(sound)
    if sound == "" or sound == nil then
        return
    end
    playSoundFile(sound)
end

-- Function to register sound handlers
function arkadia_soundsense:register_sound_handler(pattern, sound)
    registerAnonymousEventHandler("gmcp.gmcp_msgs", function()
        if gmcp.gmcp_msgs then
            local lines = {}
            local numberOfExtraLines = getLineCount() - getLineNumber()
            while true do
                local currentLine = getCurrentLine():trim()
                table.insert(lines, currentLine)
                selectCurrentLine()
                copy()
                deleteLine()
                if currentLine:ends(".") or currentLine:ends("?") or currentLine:ends("!") or currentLine == "ERROR: invalid line number" or currentLine == "" then
                    break
                end
                if #lines >= numberOfExtraLines then
                    scripts:print_log("Cos poszlo nie tak. Zglos blad zalaczajac linie ponizej.", true)
                    display({
                        type = gmcp.gmcp_msgs.type,
                        lines = lines
                    })
                    break
                end
            end
            local message = table.concat(lines, " ")
            if message:find(pattern) then
                arkadia_soundsense:play_sound(sound)
                --display message  if sound was played
                cecho("\n<" .. pattern .. "> " .. message .. "\n")
                

            end
        end
    end)
end

-- Register handlers for each pattern in the sound_map
for pattern, sound in pairs(sound_map) do
    arkadia_soundsense:register_sound_handler(pattern, sound)
end