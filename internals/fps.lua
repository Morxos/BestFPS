BestFPS.Fps = BestFPS.Fps or {}

local retentionTime = 2
local fpsDataValues = {}
local fpsDataTimes = {}

function BestFPS.Fps.GetAvgFrameRate()
    -- Calculate the average FPS
    local sum = 0
    if #fpsDataValues == 0 then
        return 0
    end
    for i = 1, #fpsDataValues do
        sum = sum + fpsDataValues[i]
    end
    local avg = sum / #fpsDataValues
    if avg == math.huge or avg == -math.huge then
        return 0
    end
    return avg
end

function BestFPS.Fps.GetCurrentFrameRate()
    -- Return the last inserted FPS value
    if #fpsDataValues == 0 then
        return 0
    end
    return fpsDataValues[#fpsDataValues]
end

function BestFPS.Fps.SetRetentionTime(time)
    -- Set the retention time for the FPS data
    retentionTime = time
end

function BestFPS.Fps.GetRetentionTime()
    -- Get the retention time for the FPS data
    return retentionTime
end

function BestFPS.Fps.OnUpdateHandler(self, elapsed)
    -- Update the FPS data on every frame
    local framerate = 1 / elapsed
    table.insert(fpsDataValues, framerate)
    table.insert(fpsDataTimes, GetTime())
    -- Remove old data
    while fpsDataTimes[1] and GetTime() - fpsDataTimes[1] > BestFPS.Fps.GetRetentionTime() do
        table.remove(fpsDataValues, 1)
        table.remove(fpsDataTimes, 1)
    end
end


function BestFPS.Fps.GetOnePercentLowFrameRate()
    -- Calculate the 1% low FPS (also known as 99th percentile)
    if #fpsDataValues == 0 then
        return 0
    end
    local localFpsData = BestFPS.Utils.ShallowCopyTable(fpsDataValues)
    table.sort(localFpsData)
    local onePercent = localFpsData[math.max(1,math.floor(#localFpsData * 0.01))]
    if onePercent == math.huge or onePercent == -math.huge then
        return 0
    end
    return onePercent
end

