BestFPS.UI = BestFPS.UI or {}

function BestFPS.UI.GetLatencyColor(latency)
    -- Return the color based on the latency for the latency text
    if latency < 32 then
        return "|cff00ff00" -- Green
    elseif latency < 64 then
        return "|cffffff00" -- Orange
    else
        return "|cffff0000" -- Red
    end
end

function BestFPS.UI.GetFPSColor(fps)
    -- Return the color based on the FPS for the FPS text
    if fps < 30 then
        return "|cffff0000" -- Red
    elseif fps < 60 then
        return "|cffffff00" -- Yellow
    else
        return "|cff00ff00" -- Green
    end
end


function BestFPS.UI.SetupFpsUI()
    -- Create the main frame for the FPS display

    BestFPS.UI.FpsMainWindow = CreateFrame("Frame", "FPSGraphFrame", UIParent, "BackdropTemplate")
    BestFPS.UI.FpsMainWindow:SetScript("OnUpdate", BestFPS.Fps.OnUpdateHandler)
    BestFPS.UI.FpsMainWindow:SetSize(250, 100)
    BestFPS.UI.FpsMainWindow:SetResizeBounds(100,50,250,100)
    BestFPS.UI.FpsMainWindow:SetPoint("CENTER")
    BestFPS.UI.FpsMainWindow:SetClampedToScreen(true)
    BestFPS.UI.FpsMainWindow:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = BestFpsSavedVars.legacy_ui and "Interface/Tooltips/UI-Tooltip-Border" or nil,
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    -- Update the backdrop when the setting changes
    BestFPS.Settings.LegacyUI:SetValueChangedCallback(function (setting, value)
        BestFPS.UI.FpsMainWindow:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = value and "Interface/Tooltips/UI-Tooltip-Border" or nil,
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        BestFPS.UI.FpsMainWindow:SetBackdropColor(0, 0, 0, BestFpsSavedVars.background_transparency)
        
        
    end)

    BestFPS.Settings.BackgroundTransparency:SetValueChangedCallback(function (setting, value)
        BestFPS.UI.FpsMainWindow:SetBackdropColor(0, 0, 0, value)
    end)

    BestFPS.UI.FpsMainWindow:SetBackdropColor(0, 0, 0, BestFpsSavedVars.background_transparency)
    BestFPS.UI.FpsMainWindow:EnableMouse(true)
    BestFPS.UI.FpsMainWindow:SetMovable(true)
    BestFPS.UI.FpsMainWindow:SetResizable(true)
    BestFPS.UI.FpsMainWindow:RegisterForDrag("LeftButton")  -- Step 3: Register the left mouse button for drag




    -- Function to show tooltip on mouse over
    local function OnEnter(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        -- Add title
        GameTooltip:SetText(BestFPS.Title.." "..BestFPS.Version)
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
    BestFPS.UI.FpsMainWindow:SetScript("OnEnter", OnEnter)
    BestFPS.UI.FpsMainWindow:SetScript("OnLeave", OnLeave)

    local fpsFrame = CreateFrame("Frame", nil, BestFPS.UI.FpsMainWindow)
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

    

    local home_latency = BestFPS.UI.FpsMainWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal") 
    home_latency:SetPoint("TOPRIGHT",  -10, -10)

    --local lowFPS1 = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    --lowFPS1:SetPoint("TOPRIGHT",  -5, -20)
    --lowFPS1:SetText("1% Low: 0")

    local world_latency = BestFPS.UI.FpsMainWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    world_latency:SetPoint("TOPRIGHT", -10, -25)


    -- Graph container
    local graphWidth = 280
    local graphHeight = 40

    local graphFrame = CreateFrame("Frame", nil, BestFPS.UI.FpsMainWindow)
    graphFrame:SetSize(graphWidth, graphHeight)
    graphFrame:SetPoint("BOTTOM", BestFPS.UI.FpsMainWindow, "BOTTOM", 0, 10)


    -- Constants for FPS marks
    local FPS_MARK_30 = 30
    local FPS_MARK_60 = 60
    local maxFPS = 100  -- Is adjusted dynamically

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

    local numTraceBars = 25
    local barWidth = graphWidth / numTraceBars
    local bars = {}
    local traceBarValues = {}

    for i = 1, numTraceBars do
        traceBarValues[i] = 0
        local bar = graphFrame:CreateTexture(nil, "BACKGROUND")
        bar:SetSize(barWidth-2, 0)
        bar:SetColorTexture(0, 1, 0, 0.8)
        bar:SetPoint("BOTTOMLEFT", (i - 1) * barWidth, 0)
        -- Show the bars behind the lines
        bar:SetDrawLayer("ARTWORK", 1)
        bars[i] = bar
    end

    

    local function updateFpsUI()
        -- Update the FPS and latency text
        local home_latency_value = BestFPS.Ping.GetHomeLatency()
            local world_latency_value = BestFPS.Ping.GetWorldLatency()
            local fps = BestFPS.Fps.GetAvgFrameRate()
            local low_fps_99 = BestFPS.Fps.GetOnePercentLowFrameRate()
            lowFPS99:SetText("99% FPS: " ..BestFPS.UI.GetFPSColor(low_fps_99).. string.format("%.0f",low_fps_99).."|r")
            fpsText:SetText("" ..BestFPS.UI.GetFPSColor(fps).. string.format("%.0f",fps).."|r FPS")
            fpsFrame:SetSize(fpsText:GetStringWidth(), 50)

            --Set background color of the fps frame
            if graphWidth > 160 then
                home_latency:SetText("Home: " ..BestFPS.UI.GetLatencyColor(home_latency_value) .. tostring(home_latency_value).. "|r ms")
                world_latency:SetText("World: "..BestFPS.UI.GetLatencyColor(world_latency_value) .. tostring(world_latency_value).. "|r ms")
            else
                home_latency:SetText("H: " ..BestFPS.UI.GetLatencyColor(home_latency_value) .. tostring(home_latency_value).. "|r ms")
                world_latency:SetText("W: "..BestFPS.UI.GetLatencyColor(world_latency_value) .. tostring(world_latency_value).. "|r ms")
            end
    end


    local function updateGraph()
        -- Update the graph with the current FPS value
        
        for i = 1, numTraceBars - 1 do
            traceBarValues[i] = traceBarValues[i + 1]
        end


        traceBarValues[#traceBarValues] = BestFPS.Fps.GetCurrentFrameRate()
        
        -- Find max fps from recorded values
        local max = 0
        for i = 1, #traceBarValues do
            if traceBarValues[i] > max then
                max = traceBarValues[i]
            end
        end
        maxFPS = math.max(30,max)

        -- Update the bars
        for i = 1, numTraceBars do
            bars[i]:SetHeight(graphHeight * (traceBarValues[i] / maxFPS))
            -- Change color of bars if they are below 30 or 60 FPS
            if traceBarValues[i] < FPS_MARK_30 then
                bars[i]:SetColorTexture(1, 0, 0, 0.8)
            elseif traceBarValues[i] < FPS_MARK_60 then
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
            --Hide the text if 60 fps text is shown
            text30FPS:Hide()
        end

    end

    local function OnSizeChanged(self)
        -- Update the UI elements when the frame is resized
        graphWidth = self:GetWidth() - 20
        graphHeight = self:GetHeight() - 70
        local show_meta = graphWidth > 135
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
            fpsFrame:SetPoint("CENTER", BestFPS.UI.FpsMainWindow, "CENTER")
            
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
        
        barWidth = graphWidth / numTraceBars
        for i = 1, numTraceBars do
            bars[i]:SetSize(barWidth-2, 0)
            bars[i]:SetPoint("BOTTOMLEFT", (i - 1) * barWidth, 0)
        end

        -- Update the text
        updateFpsUI()
    end

    local function OnMouseDown(self, button)
        -- Actions for resizing, moving and showing the zone window
        if IsShiftKeyDown() and button == "LeftButton" then
            self:StartMoving()
        end
        if IsControlKeyDown() and button == "LeftButton" then
            BestFPS.UI.FpsMainWindow:StartSizing("BOTTOMRIGHT")
        end
        if button == "RightButton" then
            BestFPS.UI.ZonesMainWindow:Show()
        end
    end

    local function OnMouseUp(self, button)
        -- Stop resizing and moving when the mouse button is released
        self:StopMovingOrSizing()
    end

    BestFPS.UI.FpsMainWindow:SetScript("OnMouseDown", OnMouseDown)
    BestFPS.UI.FpsMainWindow:SetScript("OnMouseUp", OnMouseUp)
    BestFPS.UI.FpsMainWindow:SetScript("OnSizeChanged", OnSizeChanged)

    -- Update graph on width change
    local updateGraphTicker = C_Timer.NewTicker(1/BestFpsSavedVars.fps_graph_update_rate, updateGraph)
    local updateFpsTicker = C_Timer.NewTicker(1/BestFpsSavedVars.fps_update_rate, updateFpsUI)

    BestFPS.Settings.FpsUpdateRate:SetValueChangedCallback(function (setting, value)
        updateFpsTicker:Cancel()
        updateFpsTicker = C_Timer.NewTicker(1/value, updateFpsUI)
    end)

    BestFPS.Settings.FpsGraphUpdateRate:SetValueChangedCallback(function (setting, value)
        updateGraphTicker:Cancel()
        updateGraphTicker = C_Timer.NewTicker(1/value, updateGraph)
    end)

    
end