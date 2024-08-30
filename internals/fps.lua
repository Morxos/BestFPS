local max_samples = 100
local fpsData = {}

function GetAvgFrameRate()
    local sum = 0
    if #fpsData == 0 then
        return 0
    end
    for i = 1, #fpsData do
        sum = sum + fpsData[i]
    end
    
    return sum / #fpsData
end

function GetCurrentFrameRate()
    if #fpsData == 0 then
        return 0
    end
    return fpsData[#fpsData]
end

function GetOnePercentLowFrameRate()
    if #fpsData == 0 then
        return 0
    end
    local local_fps_data = ShallowCopyTable(fpsData)
    table.sort(local_fps_data)
    return local_fps_data[math.max(1,math.floor(#local_fps_data * 0.01))]
end


local function fast_update()
    table.insert(fpsData, GetFramerate())
    if #fpsData > max_samples then
        table.remove(fpsData, 1)
    end
    
end

C_Timer.NewTicker(0.02, fast_update)