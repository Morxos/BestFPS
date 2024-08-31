local entries_table = {}
local entries_table_stats = {}

function BestFPS_SetupZoneUI()
    BestFPS_ZonesMainWindow = CreateFrame("Frame", "FPSListWindow", UIParent, "BasicFrameTemplateWithInset")
    BestFPS_ZonesMainWindow:SetSize(300, 400)  -- Width, Height
    BestFPS_ZonesMainWindow:SetPoint("CENTER")  -- Position it at the center of the screen
    BestFPS_ZonesMainWindow:EnableMouse(true)
    BestFPS_ZonesMainWindow:SetMovable(true)
    BestFPS_ZonesMainWindow:RegisterForDrag("LeftButton")
    BestFPS_ZonesMainWindow:SetScript("OnDragStart", BestFPS_ZonesMainWindow.StartMoving)
    BestFPS_ZonesMainWindow:SetScript("OnDragStop", BestFPS_ZonesMainWindow.StopMovingOrSizing)
    BestFPS_ZonesMainWindow:Hide()

    local title = BestFPS_ZonesMainWindow:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("TOP", BestFPS_ZonesMainWindow, "TOP", 0, -5)  -- Adjust the offset as needed
    title:SetText("Zone FPS Data")

    local scrollFrame = CreateFrame("ScrollFrame", nil, BestFPS_ZonesMainWindow, "UIPanelScrollFrameTemplate")
    scrollFrame:SetSize(280, 330)  -- Slightly smaller than the main window
    scrollFrame:SetPoint("TOP", 0, -30)

    --Add delete button
    local deleteButton = CreateFrame("Button", nil, BestFPS_ZonesMainWindow, "GameMenuButtonTemplate")
    deleteButton:SetPoint("BOTTOMRIGHT", -10, 10)
    deleteButton:SetSize(140, 20)
    deleteButton:SetText("Clear Data")
    deleteButton:SetNormalFontObject("GameFontNormalLarge")
    deleteButton:SetHighlightFontObject("GameFontHighlightLarge")
    deleteButton:SetScript("OnClick", function()
        BestFPS_ClearZoneData()
    end)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(280, 800)  -- Set a large height to test scrolling
    scrollFrame:SetScrollChild(content)

    C_Timer.NewTicker(1, function()
        --Clear scroll frame
        for i = 1, #entries_table do
            entries_table[i]:Hide()
            entries_table_stats[i]:Hide()
        end
        local y_offset = 0
        local i = 1
        local zone_data = BestFPS_GetZoneData()
        --Sort the table by zone name (the string from mapinfo) and always show the current zone first
        local sorted_table = {}
        for key, value in pairs(zone_data) do
            local zone_name = C_Map.GetMapInfo(key).name
            table.insert(sorted_table, {key, value, zone_name})
            
        end
        table.sort(sorted_table, function(a, b) return a[3] < b[3] end)
        local current_zone = C_Map.GetBestMapForUnit("player")
        for key, value in pairs(sorted_table) do
            if value[1] == current_zone then
                table.remove(sorted_table, key)
                table.insert(sorted_table, 1, {current_zone, value[2]})
                break
            end
        end
        -- Remove the zone name from the table
        for key, value in pairs(sorted_table) do
            table.remove(value, 3)
        end
        for _, value in ipairs(sorted_table) do
            local zone_name = C_Map.GetMapInfo(value[1]).name
            local avg_fps = value[2].avg_fps_sum / value[2].entry_count
            local one_percent_low_fps = value[2].one_percent_low_fps / value[2].entry_count
            if entries_table[i] == nil then
                entries_table[i] = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            end
            if entries_table_stats[i] == nil then
                entries_table_stats[i] = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            end
            local zoneLabel = entries_table[i]
            local zoneStats = entries_table_stats[i]
            zoneLabel:Show()
            zoneStats:Show()
            zoneLabel:SetPoint("TOPLEFT", 10, -y_offset)
            zoneStats:SetPoint("TOPRIGHT", -10, -y_offset)
            zoneLabel:SetText(BestFPS_LimitString(zone_name, 12))
            --Tooltip with the full zone name
            zoneLabel:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_TOP")
                GameTooltip:SetText(zone_name)
                GameTooltip:Show()
            end)
            zoneStats:SetText("Avg FPS: " ..BestFPS_GetFPSColor(avg_fps) .. string.format("%.0f",avg_fps) .. "|r (1% Low: " ..BestFPS_GetFPSColor(one_percent_low_fps).. string.format("%.0f",one_percent_low_fps).. "|r)")
            y_offset = y_offset + 20
            i = i + 1
        end
        
        content:SetHeight(y_offset)
    end)

end