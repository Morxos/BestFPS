BestFPS.Ping = BestFPS.Ping or {}

local homeLatency = 0
local worldLatency = 0

function BestFPS.Ping.GetHomeLatency()
    -- Return the home latency
    if homeLatency > 1000000 then
        -- Return 0 if the latency is invalid. Happens sometimes when the game is loading
        return 0
    end
    return homeLatency
end

function BestFPS.Ping.GetWorldLatency()
    -- Return the world latency
    if worldLatency > 1000000 then
        -- Return 0 if the latency is invalid. Happens sometimes when the game is loading
        return 0
    end
    return worldLatency
end


local function updateLatencyHandler()
    _,_,homeLatency, worldLatency = GetNetStats()
end

-- Netstats are only updated all 30 seconds, so 1 seconds is a good compromise
C_Timer.NewTicker(1, updateLatencyHandler)