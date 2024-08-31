local retention_time = 2
local fpsData = {}
local fpsDataTime = {}

function GetAvgFrameRate()
    local sum = 0
    if #fpsData == 0 then
        return 0
    end
    for i = 1, #fpsData do
        sum = sum + fpsData[i]
    end
    local avg = sum / #fpsData
    if avg == math.huge or avg == -math.huge then
        return 0
    end
    return avg
end

function GetCurrentFrameRate()
    if #fpsData == 0 then
        return 0
    end
    return fpsData[#fpsData]
end

function BestFPS_SetRetentionTime(time)
    retention_time = time
end

function BestFPS_GetRetentionTime()
    return retention_time
end

function OnUpdateHandler(self, elapsed)
    local framerate = 1 / elapsed
    table.insert(fpsData, framerate)
    table.insert(fpsDataTime, GetTime())
    while fpsDataTime[1] and GetTime() - fpsDataTime[1] > BestFPS_GetRetentionTime() do
        table.remove(fpsData, 1)
        table.remove(fpsDataTime, 1)
    end
end


function GetOnePercentLowFrameRate()
    if #fpsData == 0 then
        return 0
    end
    local local_fps_data = ShallowCopyTable(fpsData)
    table.sort(local_fps_data)
    local one_percent = local_fps_data[math.max(1,math.floor(#local_fps_data * 0.01))]
    if one_percent == math.huge or one_percent == -math.huge then
        return 0
    end
    return one_percent
end