BestFPS_SavedVars = BestFPS_SavedVars or {}


function InitilizeSettingsUI()

    local category = Settings.RegisterVerticalLayoutCategory("BestFPS")
    -- Legacy UI Layout
    local name = "Legacy UI"
    local variable = "BestFPS_legacy_ui"
    local variableKey = "legacy_ui"
    local variableTbl = BestFPS_SavedVars
    local defaultValue = false
    Setting_Legacy_UI = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
    Settings.CreateCheckbox(category, Setting_Legacy_UI, "Enable this setting to use the legacy UI.")

    -- Background Transparency
    local name = "Background Transparency"
    local variable = "BestFPS_background_transparency"
    local variableKey = "background_transparency"
    local variableTbl = BestFPS_SavedVars
    local defaultValue = 0.7
    local minValue = 0
    local maxValue = 1
    local step = 0.1
    Setting_Background_Transparency = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
    Settings.CreateSlider(category, Setting_Background_Transparency,options ,"Set the transparency of the background.")

    -- FPS update rate
    local name = "FPS Update Rate"
    local variable = "BestFPS_fps_update_rate"
    local variableKey = "fps_update_rate"
    local variableTbl = BestFPS_SavedVars
    local defaultValue = 0.5
    local minValue = 0.1
    local maxValue = 2
    local step = 0.1
    Setting_FPS_Update_Rate = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
    Settings.CreateSlider(category, Setting_FPS_Update_Rate,options ,"Sets how often the FPS value is updated per second. This does not affect the graph update rate.")

    -- FPS Graph update rate
    local name = "FPS Graph Update Rate"
    local variable = "BestFPS_fps_graph_update_rate"
    local variableKey = "fps_graph_update_rate"
    local variableTbl = BestFPS_SavedVars
    local defaultValue = 10
    local minValue = 0.1
    local maxValue = 50
    local step = 0.1
    Setting_FPS_Graph_Update_Rate = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
    Settings.CreateSlider(category, Setting_FPS_Graph_Update_Rate,options ,"Sets how often the FPS graph is updated per second. This does not affect the FPS value update rate.")

    -- FPS Data retention time
    local name = "FPS Data Retention Time"
    local variable = "BestFPS_fps_data_retention_time"
    local variableKey = "fps_data_retention_time"
    local variableTbl = BestFPS_SavedVars
    local defaultValue = 2
    local minValue = 1
    local maxValue = 10
    local step = 0.1
    Setting_FPS_Data_Retention_Time = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
    Settings.CreateSlider(category, Setting_FPS_Data_Retention_Time,options ,"Sets how long the FPS data is retained in seconds for metrics calculations.")

    Setting_FPS_Data_Retention_Time:SetValueChangedCallback(function(setting, value)
        BestFPS_SetRetentionTime(value)
    end)

    BestFPS_SetRetentionTime(BestFPS_SavedVars.fps_data_retention_time)

    Settings.RegisterAddOnCategory(category)
end

