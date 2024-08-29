local mainFrame = CreateFrame("Frame", "FPSGraphFrame", UIParent, "BackdropTemplate")
mainFrame:SetSize(300, 100)
mainFrame:SetPoint("CENTER")
mainFrame:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
mainFrame:SetBackdropColor(0, 0, 0, 1)
mainFrame:EnableMouse(true)
mainFrame:SetMovable(true)
mainFrame:RegisterForDrag("LeftButton")  -- Step 3: Register the left mouse button for drag

-- Define what happens when you start and stop dragging
mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
mainFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    -- Optional: save the new position here if needed
end)



-- Add FPS text to top of frame
local fpsText = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
fpsText:SetPoint("TOPLEFT", 10, -10)
fpsText:SetText("0")
fpsText:SetFont("Fonts\\FRIZQT__.TTF", 30, "OUTLINE")
-- Add average and 1% and 10% low FPS text to top of frame

local avgFPS = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal") 
avgFPS:SetPoint("TOPRIGHT",  -20, -10)
avgFPS:SetText("Avg: 0")

--local lowFPS1 = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--lowFPS1:SetPoint("TOPRIGHT",  -5, -20)
--lowFPS1:SetText("1% Low: 0")

local lowFPS10 = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
lowFPS10:SetPoint("TOPRIGHT", -10, -25)
lowFPS10:SetText("10% Low: 0")


-- Graph container
local graphWidth = 280
local graphHeight = 40



local graphFrame = CreateFrame("Frame", nil, mainFrame)
graphFrame:SetSize(graphWidth, graphHeight)
graphFrame:SetPoint("BOTTOM", mainFrame, "BOTTOM", 0, 10)


-- Constants for FPS marks
local FPS_MARK_30 = 30
local FPS_MARK_60 = 60
local maxFPS = 100  -- Adjust based on expected max FPS
local max_samples = 100
local fpsData = {}
Ten_percent_low = 0
One_percent_low = 0
Avg_fps = 0

-- Create horizontal line for 30 FPS
local line30FPS = graphFrame:CreateTexture(nil, "OVERLAY")
line30FPS:SetColorTexture(1, 0, 0, 1)  -- Red line
line30FPS:SetSize(graphWidth-2, 2)  -- 1 pixel high
line30FPS:SetPoint("BOTTOMLEFT", 0, graphHeight * (FPS_MARK_30 / maxFPS))

-- Create horizontal line for 60 FPS
local line60FPS = graphFrame:CreateTexture(nil, "OVERLAY")
line60FPS:SetColorTexture(1, 1, 0, 1)  -- Yellow line
line60FPS:SetSize(graphWidth-2, 2)  -- 1 pixel high
line60FPS:SetPoint("BOTTOMLEFT", 0, graphHeight * (FPS_MARK_60 / maxFPS))

-- Show text for 30 and 60 FPS
local text30FPS = graphFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text30FPS:SetText("30 FPS")
text30FPS:SetPoint("BOTTOMLEFT", 0, graphHeight * (FPS_MARK_30 / maxFPS) + 2)
text30FPS:SetTextColor(1, 0, 0, 1)

local text60FPS = graphFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text60FPS:SetText("60 FPS")
text60FPS:SetPoint("BOTTOMLEFT", 0, graphHeight * (FPS_MARK_60 / maxFPS) + 2)
text60FPS:SetTextColor(1, 1, 0, 1)

local numBars = 50
local barWidth = graphWidth / numBars
local bars = {}
local bar_values = {}
local update_index = 0
local curren_fps = 0

for i = 1, numBars do
    bar_values[i] = 0
    local bar = graphFrame:CreateTexture(nil, "BACKGROUND")
    bar:SetSize(barWidth-2, 0)
    bar:SetColorTexture(0, 1, 0, 0.8)
    bar:SetPoint("BOTTOMLEFT", (i - 1) * barWidth, 0)
    -- Show the bars behind the lines
    bar:SetDrawLayer("ARTWORK", 1)
    bars[i] = bar
end

function shallowCopyIntTable(orig)
    local copy = {}
    for key, value in pairs(orig) do
        copy[key] = value
    end
    return copy
end


local function updateGraph()
    if update_index % 5 == 0 then
        
        local local_fps_data = shallowCopyIntTable(fpsData)
        table.sort(local_fps_data)
        --Calculate the average FPS
        local sum = 0
        for i = 1, #local_fps_data do
            sum = sum + local_fps_data[i]
        end
        Avg_fps = sum / #local_fps_data

        --Calculate the 1% low FPS
        -- backup table
        
        --One_percent_low = local_fps_data[math.max(1,math.floor(#local_fps_data * 0.01))]
        Ten_percent_low = local_fps_data[math.max(1,math.floor(#local_fps_data * 0.1))]


        fpsText:SetText("" .. string.format("%.0f",curren_fps))
        avgFPS:SetText("Avg: " .. string.format("%.0f", Avg_fps))
        --lowFPS1:SetText("1% Low: " .. string.format("%.0f", One_percent_low))
        lowFPS10:SetText("10% Low: " .. string.format("%.0f", Ten_percent_low))

    end
    
    
    for i = 1, numBars - 1 do
        bar_values[i] = bar_values[i + 1]
    end


    bar_values[#bar_values] = curren_fps
    
    -- Find max fps from recorded values
    local max = 0
    for i = 1, #bar_values do
        if bar_values[i] > max then
            max = bar_values[i]
        end
    end
    maxFPS = max

    -- Update the bars
    for i = 1, numBars do
        bars[i]:SetHeight(graphHeight * (bar_values[i] / maxFPS))
        -- Change color of bars if they are below 30 or 60 FPS
        if bar_values[i] < FPS_MARK_30 then
            bars[i]:SetColorTexture(1, 0, 0, 0.8)
        elseif bar_values[i] < FPS_MARK_60 then
            bars[i]:SetColorTexture(1, 1, 0, 0.8)
        else
            bars[i]:SetColorTexture(0, 1, 0, 0.8)
        end
    end

    
    
    -- Update the horizontal lines
    line30FPS:SetPoint("BOTTOMLEFT", 0, graphHeight * (FPS_MARK_30 / maxFPS))
    line60FPS:SetPoint("BOTTOMLEFT", 0, graphHeight * (FPS_MARK_60 / maxFPS))
    -- Update the text
    text30FPS:SetPoint("BOTTOMLEFT", 0, graphHeight * (FPS_MARK_30 / maxFPS) + 2)
    text60FPS:SetPoint("BOTTOMLEFT", 0, graphHeight * (FPS_MARK_60 / maxFPS) + 2)
    -- Remove 30 and 60 FPS lines if they are not visible
    if FPS_MARK_30 > maxFPS or maxFPS > 100 then
        line30FPS:Hide()
        --Show the text
        text30FPS:Hide()
    else
        line30FPS:Show()
        --Show the text
        text30FPS:Show()
    end

    if FPS_MARK_60 > maxFPS or maxFPS > 200 then
        line60FPS:Hide()
        --Show the text
        text60FPS:Hide()
    else
        line60FPS:Show()
        --Show the text
        text60FPS:Show()
    end

    update_index = update_index + 1

end


local function fast_update()
    curren_fps = GetFramerate()
    table.insert(fpsData, curren_fps)
    if #fpsData > max_samples then
        table.remove(fpsData, 1)
    end
    
end



C_Timer.NewTicker(0.1, updateGraph) -- Update the graph every second
C_Timer.NewTicker(0.02, fast_update) -- Update the graph every second

local function OnSettingChanged(setting, value)
	-- This callback will be invoked whenever a setting is modified.
	print("Setting changed:", setting:GetVariable(), value)
end

BestFPS_SavedVars = {}
local category = Settings.RegisterVerticalLayoutCategory("BestFPS")

local name = "Show FPS"
local variable = "BestFPS_FPSToggle"
local variableKey = "fps_toggle"
local variableTbl = BestFPS_SavedVars
local defaultValue = false
local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
setting:SetValueChangedCallback(OnSettingChanged)

local tooltip = "This is a tooltip for the checkbox."
Settings.CreateCheckbox(category, setting, tooltip)

Settings.RegisterAddOnCategory(category)