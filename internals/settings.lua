BestFPS.Settings = BestFPS.Settings or {}
BestFpsSavedVars = BestFpsSavedVars or {}


function BestFPS.Settings.InitilizeSettingsUI()
    -- Create the settings UI 
    local category = Settings.RegisterVerticalLayoutCategory(BestFPS.Title)

    do
    -- Legacy UI Layout
    local name = "Show Borders"
    local variable = "BestFPS_legacy_ui"
    local variableKey = "legacy_ui"
    local variableTbl = BestFpsSavedVars
    local defaultValue = true
    BestFPS.Settings.LegacyUI = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
    Settings.CreateCheckbox(category, BestFPS.Settings.LegacyUI, "Show borders around the UI elements.")
    end

    do
    -- Background Transparency
    local name = "Background Transparency"
    local variable = "BestFPS_background_transparency"
    local variableKey = "background_transparency"
    local variableTbl = BestFpsSavedVars
    local defaultValue = 0.7
    local minValue = 0
    local maxValue = 1
    local step = 0.1
    BestFPS.Settings.BackgroundTransparency = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
    Settings.CreateSlider(category, BestFPS.Settings.BackgroundTransparency,options ,"Set the transparency of the background.")
    end

    do
    -- FPS update rate
    local name = "FPS Update Rate"
    local variable = "BestFPS_fps_update_rate"
    local variableKey = "fps_update_rate"
    local variableTbl = BestFpsSavedVars
    local defaultValue = 0.5
    local minValue = 0.1
    local maxValue = 2
    local step = 0.1
    BestFPS.Settings.FpsUpdateRate = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
    Settings.CreateSlider(category, BestFPS.Settings.FpsUpdateRate,options ,"Sets how often the FPS value is updated per second. This does not affect the graph update rate.")
    end

    do
    -- FPS Graph update rate
    local name = "FPS Graph Update Rate"
    local variable = "BestFPS_fps_graph_update_rate"
    local variableKey = "fps_graph_update_rate"
    local variableTbl = BestFpsSavedVars
    local defaultValue = 10
    local minValue = 0.1
    local maxValue = 50
    local step = 0.1
    BestFPS.Settings.FpsGraphUpdateRate = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
    Settings.CreateSlider(category, BestFPS.Settings.FpsGraphUpdateRate,options ,"Sets how often the FPS graph is updated per second. This does not affect the FPS value update rate.")
    end

    do
    -- FPS Data retention time
    local name = "FPS Data Retention Time"
    local variable = "BestFPS_fps_data_retention_time"
    local variableKey = "fps_data_retention_time"
    local variableTbl = BestFpsSavedVars
    local defaultValue = 2
    local minValue = 1
    local maxValue = 10
    local step = 0.1
    BestFPS.Settings.FpsDataRetentionTime = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
    Settings.CreateSlider(category, BestFPS.Settings.FpsDataRetentionTime,options ,"Sets how long the FPS data is retained in seconds for metrics calculations.")
    end
    

    BestFPS.Settings.FpsDataRetentionTime:SetValueChangedCallback(function(setting, value)
        BestFPS.Fps.SetRetentionTime(value)
    end)
    
    BestFPS.Fps.SetRetentionTime(BestFpsSavedVars.fps_data_retention_time)

    Settings.RegisterAddOnCategory(category)
end

