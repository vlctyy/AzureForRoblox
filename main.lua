local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Create Fluent Window (Optimized for Mobile)
local Window = Fluent:CreateWindow({
    Title = "Azure Mobile",
    SubTitle = "Bloxstrap for Roblox Mobile",
    TabWidth = 140,
    Size = UDim2.fromOffset(480, 360), -- Smaller size for mobile screens
    Acrylic = false, -- Disable blur for mobile performance
    Theme = "Dark"
})

-- Tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "gamepad" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Define Options for cross-feature integration
local Options = Fluent.Options

-- Main Features for Mobile
do
    Tabs.Main:AddParagraph({
        Title = "Welcome to Azure Mobile",
        Content = "Experience optimized Bloxstrap for Roblox on mobile."
    })

    -- FPS Unlocker
    local FPSUnlocker = Tabs.Main:AddSlider("FPSUnlocker", {
        Title = "FPS Unlocker",
        Description = "Adjust FPS cap",
        Default = 60,
        Min = 30,
        Max = 120, -- Limited max to fit mobile needs
        Rounding = 0,
        Callback = function(Value)
            print("FPS set to:", Value)
            setfpscap(Value) -- FPS Unlocker logic
        end
    })

    -- Anticrash Toggle
    Tabs.Main:AddToggle("Anticrash", {
        Title = "Enable Anticrash",
        Default = false
    }):OnChanged(function()
        if Options.Anticrash.Value then
            print("Anticrash enabled")
            -- Insert anticrash logic
        else
            print("Anticrash disabled")
        end
    end)

    -- Debug Mode
    Tabs.Main:AddToggle("FFlagDebugGreySky", {
        Title = "Enable Debug Mode",
        Default = false
    }):OnChanged(function()
        print("Debug Mode:", Options.FFlagDebugGreySky.Value)
    end)

    -- Texture Options
    Tabs.Main:AddDropdown("TextureOptions", {
        Title = "Texture Options",
        Values = { "Default", "No Textures", "Blurred Textures" },
        Default = "Default"
    }):OnChanged(function(Value)
        print("Selected Texture Option:", Value)
        -- Add texture handling logic here
    end)

    -- Font Customization
    Tabs.Main:AddDropdown("FontOptions", {
        Title = "Font",
        Values = { "Roboto", "Pixel", "Default" },
        Default = "Default"
    }):OnChanged(function(Value)
        print("Font changed to:", Value)
        -- Implement font application logic
    end)

    -- Notifications
    Tabs.Main:AddButton({
        Title = "Test Notification",
        Callback = function()
            Fluent:Notify({
                Title = "Azure Mobile",
                Content = "Notification test for mobile users.",
                Duration = 5
            })
        end
    })

    -- Mobile-friendly dropdown for toggling features
    Tabs.Main:AddDropdown("FeatureToggles", {
        Title = "Feature Toggles",
        Values = { "Option1", "Option2", "Option3" },
        Multi = true,
        Default = { "Option1" }
    }):OnChanged(function(Value)
        local enabled = {}
        for feature, state in next, Value do
            if state then
                table.insert(enabled, feature)
            end
        end
        print("Features enabled:", table.concat(enabled, ", "))
    end)
end

-- Save Manager & Settings Integration
do
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)

    SaveManager:IgnoreThemeSettings()
    InterfaceManager:SetFolder("AzureMobile")
    SaveManager:SetFolder("AzureMobile/Configs")

    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)

    -- Theme Settings
    Tabs.Settings:AddDropdown("Theme", {
        Title = "UI Theme",
        Values = { "Light", "Dark", "Minimal" },
        Default = "Dark"
    }):OnChanged(function(Value)
        Fluent:SetTheme(Value)
        print("Theme changed to:", Value)
    end)

    -- Auto-load Config
    Tabs.Settings:AddButton({
        Title = "Load Auto-Config",
        Callback = function()
            SaveManager:LoadAutoloadConfig()
        end
    })
end

-- Finalize
Window:SelectTab(1)
Fluent:Notify({
    Title = "Azure Mobile",
    Content = "Mobile UI fully loaded.",
    Duration = 8
})
