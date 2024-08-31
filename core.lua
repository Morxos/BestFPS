local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if arg1 == "BestFPS" then
        BestFPS.Settings.InitilizeSettingsUI()
        BestFPS.UI.SetupFpsUI()
        BestFPS.Zones.InitZoneUpdater()
        BestFPS.UI.SetupZoneUI()
        BestFPS.Commands.Init()
        eventFrame:UnregisterEvent("ADDON_LOADED")
    end
end)