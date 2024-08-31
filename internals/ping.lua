local homeLatency, worldLatency = 0,0
local i = 0
function GetHomeLatency()
    if homeLatency > 1000000 then
        return 0
    end
    return homeLatency
end

function GetWorldLatency()
    if worldLatency > 1000000 then
        return 0
    end
    return worldLatency
end


local function update_loop()
    i = i + 1
    _,_,homeLatency, worldLatency = GetNetStats()
    
end

C_Timer.NewTicker(1, update_loop)