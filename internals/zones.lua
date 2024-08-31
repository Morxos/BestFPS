BestFPS_ZoneData = BestFPS_ZoneData or {}

function BestFPS_AddZoneData(zone, avg_fps_entry, one_percent_low_fps_entry)
    if zone == nil then
        return
    end
--Check if the zone exists in the table
    if BestFPS_ZoneData[zone] == nil then
        -- Add zone data with two empty arrays for the avg_fps and one_percent_low_fps
        BestFPS_ZoneData[zone] = {avg_fps_sum = 0, one_percent_low_fps = 0, entry_count = 0}
    end
    -- Add the new data to the zone
    BestFPS_ZoneData[zone].avg_fps_sum = BestFPS_ZoneData[zone].avg_fps_sum + avg_fps_entry
    BestFPS_ZoneData[zone].one_percent_low_fps = BestFPS_ZoneData[zone].one_percent_low_fps + one_percent_low_fps_entry
    BestFPS_ZoneData[zone].entry_count = BestFPS_ZoneData[zone].entry_count + 1
end

function BestFPS_ClearZoneData()
    BestFPS_ZoneData = {}
end

function BestFPS_GetZoneData()
    return BestFPS_ZoneData
end

function BestFPS_InitZoneUpdate()

    C_Timer.NewTicker(1, function()
        local avg_fps = GetAvgFrameRate()
        local one_percent_low_fps = GetOnePercentLowFrameRate()
        local mapID = C_Map.GetBestMapForUnit("player")
        -- Only update the data if the game has focus
        BestFPS_AddZoneData(mapID, avg_fps, one_percent_low_fps)
        -- print("Zone: " .. mapID .. " Avg FPS: " .. avg_fps .. " 1% Low: " .. one_percent_low_fps)
        
    end)
end