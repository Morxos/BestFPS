BestFPS.Commands = BestFPS.Commands or {}

function BestFPS.Commands.Init()
    SLASH_BESTFPS1, SLASH_BESTFPS2 = "/bfps", "/bestfps"

    local function handler(msg, editbox)
        if msg == "reset" then
            BestFPS.Zones.ClearZoneData()
            print("BestFPS: Zone data has been reset")
        elseif msg == "zones" then
            BestFPS.UI.ZonesMainWindow:Show()
        elseif msg == "hide" then
            BestFPS.UI.FpsMainWindow:Hide()
        elseif msg == "show" then
            BestFPS.UI.FpsMainWindow:Show()
        elseif msg == "" or msg == "help" then
            print("BestFPS: Available commands:")
            print("  /bfps show - Shows the FPS window")
            print("  /bfps hide - Hides the FPS window")
            print("  /bfps reset - Resets the FPS zone data")
            print("  /bfps zones - Shows the FPS zone data window")
        else
            print("BestFPS: Invalid command. Type '/bfps help' for a list of available commands.")

        end
    end

    SlashCmdList["BESTFPS"] = handler
end

SLASH_BESTFPS1, SLASH_BESTFPS2 = "/bfps", "/bestfps"
