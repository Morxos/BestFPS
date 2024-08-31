BestFPS.UI = BestFPS.UI or {}

function BestFPS.UI.SetupZoneUI()
    -- Create the zone data window

    -- Create the clear data popup
    StaticPopupDialogs["BESTFPS_CLEAR_ZONE_DATA"] = {
        text = "Are you sure you want to clear all zone data?",
        button1 = "Yes",
        button2 = "No",
        OnAccept = function()
            BestFPS.Zones.ClearZoneData()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }


    BestFPS.UI.ZonesMainWindow = CreateFrame("Frame", "FPSListWindow", UIParent, "BackdropTemplate")
    BestFPS.UI.ZonesMainWindow:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = BestFpsSavedVars.legacy_ui and "Interface/Tooltips/UI-Tooltip-Border" or nil,
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    BestFPS.UI.ZonesMainWindow:SetBackdropColor(0, 0, 0, BestFpsSavedVars.background_transparency)
    BestFPS.UI.ZonesMainWindow:SetSize(300, 400)  -- Width, Height
    BestFPS.UI.ZonesMainWindow:SetPoint("CENTER")  -- Position it at the center of the screen
    BestFPS.UI.ZonesMainWindow:EnableMouse(true)
    BestFPS.UI.ZonesMainWindow:SetMovable(true)
    BestFPS.UI.ZonesMainWindow:RegisterForDrag("LeftButton")
    BestFPS.UI.ZonesMainWindow:SetScript("OnDragStart", BestFPS.UI.ZonesMainWindow.StartMoving)
    BestFPS.UI.ZonesMainWindow:SetScript("OnDragStop", BestFPS.UI.ZonesMainWindow.StopMovingOrSizing)
    BestFPS.UI.ZonesMainWindow:SetClampedToScreen(true)
    BestFPS.UI.ZonesMainWindow:Hide()
    
    -- Set the border on options change
    BestFPS.Settings.LegacyUI:SetValueChangedCallback(function (setting, value)
        

        BestFPS.UI.ZonesMainWindow:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = value and "Interface/Tooltips/UI-Tooltip-Border" or nil,
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })

        BestFPS.UI.ZonesMainWindow:SetBackdropColor(0, 0, 0, BestFpsSavedVars.background_transparency)
        
        
    end)
    -- Set the background transparency on options change
    BestFPS.Settings.BackgroundTransparency:SetValueChangedCallback(function (setting, value)
        BestFPS.UI.ZonesMainWindow:SetBackdropColor(0, 0, 0, value)
    end)

        

    local title = BestFPS.UI.ZonesMainWindow:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("TOP", BestFPS.UI.ZonesMainWindow, "TOP", 0, -10)
    title:SetText("Zone FPS Data")

    local scrollFrame = CreateFrame("ScrollFrame", nil, BestFPS.UI.ZonesMainWindow, "UIPanelScrollFrameTemplate")
    scrollFrame:SetSize(280, 330)
    scrollFrame:SetPoint("TOP", 0, -30)

    -- Clear data button
    local deleteButton = CreateFrame("Button", nil, BestFPS.UI.ZonesMainWindow, "GameMenuButtonTemplate")
    deleteButton:SetPoint("BOTTOMLEFT", 10, 10)
    deleteButton:SetSize(100, 30)
    deleteButton:SetText("Clear Data")
    deleteButton:SetNormalFontObject("GameFontNormalLarge")
    deleteButton:SetHighlightFontObject("GameFontHighlightLarge")
    deleteButton:SetScript("OnClick", function()
        StaticPopup_Show("BESTFPS_CLEAR_ZONE_DATA")
    end)

    -- Close button
    local closeButton = CreateFrame("Button", nil, BestFPS.UI.ZonesMainWindow, "GameMenuButtonTemplate")
    closeButton:SetPoint("BOTTOMRIGHT", -10, 10)
    closeButton:SetSize(100, 30)
    closeButton:SetText("Close")
    closeButton:SetNormalFontObject("GameFontNormalLarge")
    closeButton:SetHighlightFontObject("GameFontHighlightLarge")
    closeButton:SetScript("OnClick", function()
        BestFPS.UI.ZonesMainWindow:Hide()
    end)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(280, 800) -- Height is arbitrary, it will be adjusted later automatically
    scrollFrame:SetScrollChild(content)

    local entriesTableZoneNamesElements = {}
    local entriesTableZoneStatsElements = {}

    C_Timer.NewTicker(1, function()
        --Clear scroll frame
        for i = 1, #entriesTableZoneNamesElements do
            entriesTableZoneNamesElements[i]:Hide()
            entriesTableZoneStatsElements[i]:Hide()
        end
        local yOffset = 0
        local i = 1
        local zonesRawdata = BestFPS.Zones.GetZoneData()
        --Sort the table by zone name and show the current zone first
        local sortedTable = {}
        for key, value in pairs(zonesRawdata) do
            local zone_name = C_Map.GetMapInfo(key).name
            table.insert(sortedTable, {key, value, zone_name})
            
        end
        table.sort(sortedTable, function(a, b) return a[3] < b[3] end)
        local currentZone = C_Map.GetBestMapForUnit("player")
        for key, value in pairs(sortedTable) do
            if value[1] == currentZone then
                table.remove(sortedTable, key)
                table.insert(sortedTable, 1, {currentZone, value[2]})
                break
            end
        end
        -- Remove the zone name from the table
        for key, value in pairs(sortedTable) do
            table.remove(value, 3)
        end
        -- Fill the scroll frame with the zone data
        for _, value in ipairs(sortedTable) do
            local zone_name = C_Map.GetMapInfo(value[1]).name
            local avg_fps = value[2].avgFpsSum / value[2].entryCount
            local one_percent_low_fps = value[2].onePercentLowFpsSum / value[2].entryCount
            if entriesTableZoneNamesElements[i] == nil then
                entriesTableZoneNamesElements[i] = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            end
            if entriesTableZoneStatsElements[i] == nil then
                entriesTableZoneStatsElements[i] = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            end
            local zoneLabel = entriesTableZoneNamesElements[i]
            local zoneStats = entriesTableZoneStatsElements[i]
            zoneLabel:Show()
            zoneStats:Show()
            zoneLabel:SetPoint("TOPLEFT", 10, -yOffset)
            zoneStats:SetPoint("TOPRIGHT", -10, -yOffset)
            zoneLabel:SetText(BestFPS.Utils.LimitString(zone_name, 12))
            --Tooltip with the full zone name
            zoneLabel:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_TOP")
                GameTooltip:SetText(zone_name)
                GameTooltip:Show()
            end)
            zoneLabel:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
            end)
            zoneStats:SetText("Avg FPS: " ..BestFPS.UI.GetFPSColor(avg_fps) .. string.format("%.0f",avg_fps) .. "|r (99% FPS: " ..BestFPS.UI.GetFPSColor(one_percent_low_fps).. string.format("%.0f",one_percent_low_fps).. "|r)")
            yOffset = yOffset + 20
            i = i + 1
        end
        
        content:SetHeight(yOffset)
    end)

end