-- Azure: Bloxstrap for Mobile
-- discord.gg/azrdev (vanity lmao)

-- Services
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LightingService = game:GetService("Lighting")
local RunService = game:GetService("RunService")
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
    game.StarterGui:SetCore("SendNotification", {
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
local autoclickerEnabled = false
local autoclickerCPS = 8
local AutoClickerThread

-- Autoclicker Logic
function AutoClick()
    AutoClickerThread = task.spawn(function()
        while autoclickerEnabled do
            task.wait(1 / autoclickerCPS)
            if autoclickerEnabled then
                mouse1click() -- Simulates mouse click
            end
        end
    end)
end

Tabs.Modules:AddTextBox({
    Title = "Autoclicker CPS",
    Description = "Set clicks per second (default: 8)",
    Default = "8",
    Callback = function(text)
        local cps = tonumber(text)
        if cps and cps > 0 then
            autoclickerCPS = cps
        else
            Azure:Notify("Autoclicker", "Invalid CPS value. Using default (8).")
            autoclickerCPS = 8
        end
    end
})

Tabs.Modules:AddSwitch({
    Title = "Enable Autoclicker",
    Description = "Toggle autoclicker functionality",
    Default = false,
    Callback = function(enabled)
        autoclickerEnabled = enabled
        if enabled then
            AutoClick()
        else
            if AutoClickerThread then
                task.cancel(AutoClickerThread)
                AutoClickerThread = nil
            end
        end
    end
})

-- FPS Boost Logic
Tabs.Modules:AddSwitch({
    Title = "FPS Boost",
    Description = "Boost FPS and remove unnecessary textures",
    Default = false,
    Callback = function(enabled)
        if enabled then
            setfpscap(240)
            Azure:Notify("FPS Boost", "FPS Boost Enabled")
        else
            setfpscap(60)
            Azure:Notify("FPS Boost", "FPS Boost Disabled")
        end
    end
})

-- Game Fixer Logic
Tabs.Modules:AddSwitch({
    Title = "Game Fixer",
    Description = "Fix common game bugs",
    Default = false,
    Callback = function(enabled)
        debug.setconstant(bedwars.SwordController.swingSwordAtMouse, 23, enabled and "raycast" or "Raycast")
        debug.setupvalue(bedwars.SwordController.swingSwordAtMouse, 4, enabled and bedwars.QueryUtil or workspace)
        Azure:Notify("Game Fixer", enabled and "Enabled" or "Disabled")
    end
})

-- Skybox Logic
Tabs.Modules:AddButton({
    Title = "Change Skybox",
    Description = "Change to a custom Skybox",
    Callback = function()
        local sky = Instance.new("Sky")
        sky.SkyboxUp = "rbxassetid://8139676647"
        sky.SkyboxLf = "rbxassetid://8139676988"
        sky.SkyboxFt = "rbxassetid://8139677111"
        sky.SkyboxBk = "rbxassetid://8139677359"
        sky.SkyboxDn = "rbxassetid://8139677253"
        sky.SkyboxRt = "rbxassetid://8139676842"
        sky.Parent = LightingService
        Azure:Notify("Skybox", "Skybox Changed!")
    end
})

-- FPS Viewer Module
Tabs.Modules:AddSwitch({
    Title = "FPS Viewer",
    Description = "Enable or disable the FPS Viewer",
    Default = false,
    Callback = function(enabled)
        Azure:FPSViewer(enabled)
    end
})

-- Notification
Azure:Notify("Azure Loaded", "All features are ready to use.", 8)
