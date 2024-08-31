function ShallowCopyTable(orig)
    local copy = {}
    for key, value in pairs(orig) do
        copy[key] = value
    end
    return copy
end

function BestFPS_GetLatencyColor(latency)
    if latency < 32 then
        return "|cff00ff00" -- Green
    elseif latency < 64 then
        return "|cffffff00" -- Orange
    else
        return "|cffff0000" -- Red
    end
end

function BestFPS_GetFPSColor(fps)
    if fps < 30 then
        return "|cffff0000" -- Red
    elseif fps < 60 then
        return "|cffffff00" -- Yellow
    else
        return "|cff00ff00" -- Green
    end
end

function BestFPS_LimitString(str, maxLength)
    if #str > maxLength then
        return str:sub(1, maxLength) .. "..."
    else
        return str
    end
end