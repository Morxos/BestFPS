BestFPS.Utils = BestFPS.Utils or {}

function BestFPS.Utils.ShallowCopyTable(orig)
    -- Shallow copy a table
    local copy = {}
    for key, value in pairs(orig) do
        copy[key] = value
    end
    return copy
end

function BestFPS.Utils.LimitString(str, maxLength)
    -- Limit the string to a certain length. If the string is longer than the maxLength, add "..." at the end
    if #str > maxLength then
        return str:sub(1, maxLength) .. "..."
    else
        return str
    end
end