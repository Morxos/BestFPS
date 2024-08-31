local addonName = "BestFPS"
local title = C_AddOns.GetAddOnMetadata(addonName, "Title")
local version = C_AddOns.GetAddOnMetadata(addonName, "Version")


local function SetupUI()



    local mainFrame = CreateFrame("Frame", "FPSGraphFrame", UIParent, "BackdropTemplate")
    mainFrame:SetScript("OnUpdate", OnUpdateHandler)
    mainFrame:SetSize(250, 100)
    mainFrame:SetResizeBounds(125,50,250,100)
    mainFrame:SetPoint("CENTER")
    mainFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = BestFPS_SavedVars.legacy_ui and "Interface/Tooltips/UI-Tooltip-Border" or nil,
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    -- Update the backdrop when the setting changes
    Setting_Legacy_UI:SetValueChangedCallback(function (setting, value)
        mainFrame:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = value and "Interface/Tooltips/UI-Tooltip-Border" or nil,
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        mainFrame:SetBackdropColor(0, 0, 0, BestFPS_SavedVars.background_transparency)
        
        
    end)

    Setting_Background_Transparency:SetValueChangedCallback(function (setting, value)
        mainFrame:SetBackdropColor(0, 0, 0, value)
    end)

    mainFrame:SetBackdropColor(0, 0, 0, BestFPS_SavedVars.background_transparency)
    mainFrame:EnableMouse(true)
    mainFrame:SetMovable(true)
    mainFrame:SetResizable(true)
    mainFrame:RegisterForDrag("LeftButton")  -- Step 3: Register the left mouse button for drag




    -- Function to show tooltip on mouse over
    local function OnEnter(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        -- Add title
        GameTooltip:SetText(title.." "..version)
        GameTooltip:AddLine("Hold |cffffffffShift|r to move", nil, nil, nil, true)  -- true for wrap text
        GameTooltip:AddLine("Hold |cffffffffCtrl|r to resize", nil, nil, nil, true)  -- true for wrap text
        GameTooltip:AddLine("|cffffffffRight click|r to show zones", nil, nil, nil, true)  -- true for wrap text
        GameTooltip:Show()
    end

    -- Function to hide tooltip when the mouse leaves
    local function OnLeave(self)
        GameTooltip:Hide()
    end

    -- Attach the mouse over and leave scripts to the frame
    mainFrame:SetScript("OnEnter", OnEnter)
    mainFrame:SetScript("OnLeave", OnLeave)

    local fpsFrame = CreateFrame("Frame", nil, mainFrame)
    fpsFrame:SetSize(125, 50)


    -- Add FPS text to top of frame
    local fpsText = fpsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fpsText:SetPoint("TOPLEFT", 0, -10)
    fpsText:SetText("0")
    fpsText:SetFont("Fonts\\FRIZQT__.TTF", 20, "OUTLINE")
    -- Add average and 1% and 10% low FPS text to top of frame


    -- Small text in the top middle for the 99th percentile
    local lowFPS99 = fpsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    lowFPS99:SetPoint("TOPLEFT", 5, -30)
    lowFPS99:SetText("99%: 0")
    lowFPS99:SetFont(GameFontNormal:GetFont(), 10)

    

    local home_latency = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal") 
    home_latency:SetPoint("TOPRIGHT",  -10, -10)

    --local lowFPS1 = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    --lowFPS1:SetPoint("TOPRIGHT",  -5, -20)
    --lowFPS1:SetText("1% Low: 0")

    local world_latency = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    world_latency:SetPoint("TOPRIGHT", -10, -25)


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

    local numBars = 25
    local barWidth = graphWidth / numBars
    local bars = {}
    local bar_values = {}
    local update_index = 0

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

    

    local function UpdateFpsUI()
        local home_latency_value = GetHomeLatency()
            local world_latency_value = GetWorldLatency()
            local fps = GetAvgFrameRate()
            local low_fps_99 = GetOnePercentLowFrameRate()
            lowFPS99:SetText("99% FPS: " ..BestFPS_GetFPSColor(low_fps_99).. string.format("%.0f",low_fps_99).."|r")
            fpsText:SetText("" ..BestFPS_GetFPSColor(fps).. string.format("%.0f",fps).."|r FPS")
            fpsFrame:SetSize(fpsText:GetStringWidth(), 50)

            --Set background color of the fps frame
            if graphWidth > 190 then
                home_latency:SetText("Home: " ..BestFPS_GetLatencyColor(home_latency_value) .. tostring(home_latency_value).. "|r ms")
                world_latency:SetText("World: "..BestFPS_GetLatencyColor(world_latency_value) .. tostring(world_latency_value).. "|r ms")
            else
                home_latency:SetText("H: " ..BestFPS_GetLatencyColor(home_latency_value) .. tostring(home_latency_value).. "|r ms")
                world_latency:SetText("W: "..BestFPS_GetLatencyColor(world_latency_value) .. tostring(world_latency_value).. "|r ms")
            end
    end


    local function updateGraph()
        
        
        for i = 1, numBars - 1 do
            bar_values[i] = bar_values[i + 1]
        end


        bar_values[#bar_values] = GetCurrentFrameRate()
        
        -- Find max fps from recorded values
        local max = 0
        for i = 1, #bar_values do
            if bar_values[i] > max then
                max = bar_values[i]
            end
        end
        maxFPS = math.max(30,max)

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

    local function OnSizeChanged(self)
        graphWidth = self:GetWidth() - 20
        graphHeight = self:GetHeight() - 70
        local show_meta = graphWidth > 160
        local show_trace = graphHeight > 5

        if show_meta then
            home_latency:Show()
            world_latency:Show()
        else
            home_latency:Hide()
            world_latency:Hide()
        end

        if show_trace then
            graphFrame:Show()
        else
            graphFrame:Hide()
        end
        fpsFrame:ClearAllPoints()
        if not show_meta and not show_trace then
            fpsFrame:SetPoint("CENTER", mainFrame, "CENTER")
            
        elseif not show_meta then
            fpsFrame:SetPoint("TOP", 0,0)
        elseif not show_trace then
            fpsFrame:SetPoint("LEFT", 10,0)
        else
            fpsFrame:SetPoint("TOPLEFT", 10,0)
        end

        home_latency:ClearAllPoints()
        world_latency:ClearAllPoints()
        if show_trace then
            home_latency:SetPoint("TOPRIGHT", -10, -10)
            world_latency:SetPoint("TOPRIGHT", -10, -25)
        else
            home_latency:SetPoint("RIGHT", -10, 7.5)
            world_latency:SetPoint("RIGHT", -10, -7.5)
        end

        graphFrame:SetSize(graphWidth, graphHeight)
        line30FPS:SetSize(graphWidth-2, 2)
        line30FPS:SetPoint("BOTTOMLEFT", 0, graphHeight * (FPS_MARK_30 / maxFPS))
        line60FPS:SetSize(graphWidth-2, 2)
        line60FPS:SetPoint("BOTTOMLEFT", 0, graphHeight * (FPS_MARK_60 / maxFPS))
        
        barWidth = graphWidth / numBars
        for i = 1, numBars do
            bars[i]:SetSize(barWidth-2, 0)
            bars[i]:SetPoint("BOTTOMLEFT", (i - 1) * barWidth, 0)
        end
    end

    local function OnMouseDown(self, button)
        if IsShiftKeyDown() and button == "LeftButton" then -- Check if Shift is held and the left button is used
            self:StartMoving()
        end
        if IsControlKeyDown() and button == "LeftButton" then
            mainFrame:StartSizing("BOTTOMRIGHT")
            print("resizing")
        end
        if button == "RightButton" then
            BestFPS_ZonesMainWindow:Show()
        end
    end

    local function OnMouseUp(self, button)
        self:StopMovingOrSizing()
    end

    mainFrame:SetScript("OnMouseDown", OnMouseDown)
    mainFrame:SetScript("OnMouseUp", OnMouseUp)
    mainFrame:SetScript("OnSizeChanged", OnSizeChanged)

    -- Update graph on width change
    local update_graph_ticker = C_Timer.NewTicker(1/BestFPS_SavedVars.fps_graph_update_rate, updateGraph)
    local update_fps_ticker = C_Timer.NewTicker(1/BestFPS_SavedVars.fps_update_rate, UpdateFpsUI)

    Setting_FPS_Update_Rate:SetValueChangedCallback(function (setting, value)
        update_fps_ticker:Cancel()
        update_fps_ticker = C_Timer.NewTicker(1/value, UpdateFpsUI)
    end)

    Setting_FPS_Graph_Update_Rate:SetValueChangedCallback(function (setting, value)
        update_graph_ticker:Cancel()
        update_graph_ticker = C_Timer.NewTicker(1/value, updateGraph)
    end)

    
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if arg1 == "BestFPS" then
        InitilizeSettingsUI()
        SetupUI()
        BestFPS_InitZoneUpdate()
        BestFPS_SetupZoneUI()
        eventFrame:UnregisterEvent("ADDON_LOADED")
    end
end)