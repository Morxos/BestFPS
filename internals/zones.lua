BestFpsZoneData = BestFpsZoneData or {}
BestFPS.Zones = BestFPS.Zones or {}

function BestFPS.Zones.AddZoneData(zoneId, avgFpsEntry, onePercentLowFpsEntry)
    -- Add the zone with the avg_fps and one_percent_low_fps to the table
    if zoneId == nil then
        return
    end
    --Check if the zone exists in the table
    if BestFpsZoneData[zoneId] == nil then
        -- Add zone data with two empty arrays for the avg_fps and one_percent_low_fps
        BestFpsZoneData[zoneId] = {avgFpsSum = 0, onePercentLowFpsSum = 0, entryCount = 0}
    end
    -- Add the new data to the zone
    BestFpsZoneData[zoneId].avgFpsSum = BestFpsZoneData[zoneId].avgFpsSum + avgFpsEntry
    BestFpsZoneData[zoneId].onePercentLowFpsSum = BestFpsZoneData[zoneId].onePercentLowFpsSum + onePercentLowFpsEntry
    BestFpsZoneData[zoneId].entryCount = BestFpsZoneData[zoneId].entryCount + 1
end

function BestFPS.Zones.ClearZoneData()
    -- Clear the zone data
    BestFpsZoneData = {}
end

function BestFPS.Zones.GetZoneData()
    -- Return the raw zone data
    return BestFpsZoneData
end

function BestFPS.Zones.InitZoneUpdater()
    -- Starts the zone updater
    C_Timer.NewTicker(1, function()
        local avgFps = BestFPS.Fps.GetAvgFrameRate()
        local onePercentLowFps = BestFPS.Fps.GetOnePercentLowFrameRate()
        local mapID = C_Map.GetBestMapForUnit("player")
        BestFPS.Zones.AddZoneData(mapID, avgFps, onePercentLowFps)
        
    end)
end