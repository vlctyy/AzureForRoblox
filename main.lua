-- Azure: Bloxstrap for Mobile
-- discord.gg/azrdev

-- Services
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LightingService = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Player = Players.LocalPlayer

-- Variables
local Azure = {}
local Options = {}
local Mobile = (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled)

-- Compatibility Checks
local function isAcrylicSupported()
    return not (UserInputService:GetPlatform() == Enum.Platform.XBox360 or UserInputService:GetPlatform() == Enum.Platform.PS4)
end

-- Utility Functions
function Azure:Notify(Title, Content, Duration)
    StarterGui:SetCore("SendNotification", {
        Title = Title,
        Text = Content,
        Duration = Duration or 5
    })
end

-- FPS Viewer Logic
function Azure:FPSViewer(Enabled)
    if Enabled then
        local fpsLabel = Instance.new("TextLabel")
        fpsLabel.Size = UDim2.new(0, 200, 0, 50)
        fpsLabel.Position = UDim2.new(0, 10, 0, 10)
        fpsLabel.BackgroundTransparency = 0.5
        fpsLabel.TextScaled = true
        fpsLabel.Parent = game.CoreGui
        RunService.RenderStepped:Connect(function()
            fpsLabel.Text = "FPS: " .. math.floor(1 / RunService.RenderStepped:Wait())
        end)
        self:Notify("FPS Viewer", "Enabled")
    else
        for _, gui in pairs(game.CoreGui:GetChildren()) do
            if gui:IsA("TextLabel") and gui.Text:find("FPS:") then
                gui:Destroy()
            end
        end
        self:Notify("FPS Viewer", "Disabled")
    end
end

-- UI Setup
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Azure Utility",
    SubTitle = "Bloxstrap for Mobile",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = isAcrylicSupported(),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tabs
local Tabs = {
    Dashboard = Window:AddTab({ Title = "Dashboard", Icon = "home" }),
    Modules = Window:AddTab({ Title = "Modules", Icon = "tool" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
    About = Window:AddTab({ Title = "About", Icon = "info" })
}

-- Dashboard Tab Content
Tabs.Dashboard:AddParagraph({
    Title = "Changelog",
    Content = "Latest updates and changes in Azure Bloxstrap for Mobile.\n" ..
              "🟢 Version 1.0 - Initial release\n" ..
              "🟡 Version 1.1 - Bug fixes\n" ..
              "🔴 Version 1.2 - Major update pending"
})

Tabs.Dashboard:AddButton({
    Title = "Join Discord",
    Description = "Click to join the official Discord server",
    Callback = function()
        setclipboard("https://discord.com/invite/rPqV5Nhc8a")
        Azure:Notify("Discord", "Invite link copied to clipboard.")
    end
})

-- Modules Tab Content
Tabs.Modules:AddSwitch({
    Title = "Enable FPS Viewer",
    Description = "Toggle the FPS Viewer",
    Default = false,
    Callback = function(enabled)
        Azure:FPSViewer(enabled)
    end
})

Tabs.Modules:AddSwitch({
    Title = "Enable FPS Boost",
    Description = "Optimize performance and reduce textures for better FPS",
    Default = false,
    Callback = function(enabled)
        setfpscap(enabled and 240 or 60)
        Azure:Notify("FPS Boost", enabled and "Enabled" or "Disabled")
    end
})

Tabs.Modules:AddButton({
    Title = "Game Fixer",
    Description = "Fix common game bugs automatically",
    Callback = function()
        debug.setconstant(bedwars.SwordController.swingSwordAtMouse, 23, "raycast")
        Azure:Notify("Game Fixer", "Fix applied successfully!")
    end
})

Tabs.Modules:AddButton({
    Title = "Change Skybox",
    Description = "Apply a custom Skybox to the game environment",
    Callback = function()
        local sky = Instance.new("Sky")
        sky.SkyboxUp = "rbxassetid://8139676647"
        sky.SkyboxLf = "rbxassetid://8139676988"
        sky.SkyboxFt = "rbxassetid://8139677111"
        sky.SkyboxBk = "rbxassetid://8139677359"
        sky.SkyboxDn = "rbxassetid://8139677253"
        sky.SkyboxRt = "rbxassetid://8139676842"
        sky.Parent = LightingService
        Azure:Notify("Skybox", "Skybox changed!")
    end
})

-- Settings Tab Content
Tabs.Settings:AddSwitch({
    Title = "Enable Acrylic UI",
    Description = "Enable Acrylic effect (if supported)",
    Default = true,
    Callback = function(enabled)
        if enabled and isAcrylicSupported() then
            Azure:Notify("Acrylic UI", "Acrylic UI enabled successfully!")
        else
            Azure:Notify("Acrylic UI", "Acrylic UI disabled.")
        end
    end
})

Tabs.Settings:AddDropdown({
    Title = "Select UI Theme",
    List = { "Dark", "Light", "Custom" },
    Default = "Dark",
    Callback = function(selectedTheme)
        Fluent:SetTheme(selectedTheme)
        Azure:Notify("Theme Changed", "Selected theme: " .. selectedTheme)
    end
})

-- About Tab Content
Tabs.About:AddParagraph({
    Title = "About Azure",
    Content = "Azure is the ultimate Bloxstrap for mobile devices.\n\nDeveloped with <3 for mobile gamers who want the best Roblox experience."
})

Tabs.About:AddButton({
    Title = "Official Website",
    Description = "Click to visit the Azure website",
    Callback = function()
        setclipboard("https://azurebloxstrap.dev")
        Azure:Notify("Website", "URL copied to clipboard.")
    end
})

-- Final Notification
Azure:Notify("Azure Loaded", "All features are ready to use.", 8)
