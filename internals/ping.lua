local homeLatency, worldLatency = GetNetStats()
local i = 0
function GetHomeLatency()
    return homeLatency
end

function GetWorldLatency()
    return worldLatency
end


local function update_loop()
    i = i + 1
    _,_,homeLatency, worldLatency = GetNetStats()
    
end

C_Timer.NewTicker(1, update_loop)