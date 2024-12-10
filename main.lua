-- Azure: Bloxstrap for Mobile
-- discord.gg/azrdev

getgenv().Config = {
    Invite = "azrdev",
    Version = "1.0",
}

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/drillygzzly/Other/main/1"))()

library:init()

local Window = library.NewWindow({
    title = "Azure Utility",
    size = UDim2.new(0, 600, 0, 650)
})

local tabs = {
    Dashboard = Window:AddTab("Dashboard"),
    Modules = Window:AddTab("Modules"),
    Settings = library:CreateSettingsTab(Window),
    About = Window:AddTab("About"),
}

-- Section setup
local sections = {
    DashboardLeft = tabs.Dashboard:AddSection("Changelog", 1),
    ModulesLeft = tabs.Modules:AddSection("Performance Tools", 1),
    ModulesRight = tabs.Modules:AddSection("Customizations", 2),
    SettingsLeft = tabs.Settings:AddSection("Settings", 1),
    AboutLeft = tabs.About:AddSection("About Azure", 1),
}

-- Dashboard content
sections.DashboardLeft:AddText({
    enabled = true,
    text = "🟢 Version 1.0 - Initial release\n" ..
           "🟡 Version 1.1 - Bug fixes\n" ..
           "🔴 Version 1.2 - Major update pending",
    flag = "Changelog_Text",
    risky = false,
})

sections.DashboardLeft:AddButton({
    text = "Join Discord",
    tooltip = "Click to copy the invite link to your clipboard",
    callback = function()
        setclipboard("https://discord.com/invite/rPqV5Nhc8a")
        library:SendNotification("Discord Invite Copied!", 5, Color3.new(0, 255, 0))
    end,
})

-- Modules: FPS Unlocker
sections.ModulesLeft:AddToggle({
    text = "FPS Unlocker",
    flag = "FPS_Unlocker",
    tooltip = "Enable or disable the FPS unlocker",
    risky = true,
    callback = function(enabled)
        setfpscap(enabled and 240 or 60)
        library:SendNotification("FPS Unlocker " .. (enabled and "Enabled" or "Disabled"), 5, Color3.new(0, 255, 0))
    end,
})

-- Modules: FPS Viewer
sections.ModulesLeft:AddToggle({
    text = "FPS Viewer",
    flag = "FPS_Viewer",
    tooltip = "Show the current FPS on screen",
    risky = false,
    callback = function(enabled)
        if enabled then
            local fpsLabel = Instance.new("TextLabel")
            fpsLabel.Size = UDim2.new(0, 200, 0, 50)
            fpsLabel.Position = UDim2.new(0, 10, 0, 10)
            fpsLabel.BackgroundTransparency = 0.5
            fpsLabel.TextScaled = true
            fpsLabel.Text = "FPS: ..."
            fpsLabel.Parent = game.CoreGui
            game:GetService("RunService").RenderStepped:Connect(function()
                fpsLabel.Text = "FPS: " .. math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
            end)
        else
            for _, v in pairs(game.CoreGui:GetChildren()) do
                if v:IsA("TextLabel") and v.Text:find("FPS:") then
                    v:Destroy()
                end
            end
        end
    end,
})

-- Modules: AutoClicker
sections.ModulesLeft:AddBox({
    text = "AutoClicker CPS",
    input = "8",
    flag = "AutoClicker_CPS",
    tooltip = "Set the clicks per second",
    risky = false,
    callback = function(value)
        getgenv().CPS = tonumber(value)
    end,
})

sections.ModulesLeft:AddToggle({
    text = "Enable AutoClicker",
    flag = "AutoClicker",
    tooltip = "Automatically click at the defined CPS",
    risky = false,
    callback = function(enabled)
        getgenv().AutoClickerEnabled = enabled
        if enabled then
            while getgenv().AutoClickerEnabled do
                task.wait(1 / (getgenv().CPS or 8))
                mouse1click()
            end
        end
    end,
})

-- Modules: Skybox
sections.ModulesRight:AddButton({
    text = "Change Skybox",
    tooltip = "Set a custom skybox for the game",
    risky = false,
    callback = function()
        local Lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.SkyboxUp = "rbxassetid://8139676647"
        sky.SkyboxLf = "rbxassetid://8139676988"
        sky.SkyboxFt = "rbxassetid://8139677111"
        sky.SkyboxBk = "rbxassetid://8139677359"
        sky.SkyboxDn = "rbxassetid://8139677253"
        sky.SkyboxRt = "rbxassetid://8139676842"
        sky.Parent = Lighting
        library:SendNotification("Skybox Changed!", 5, Color3.new(0, 255, 255))
    end,
})

-- About content
sections.AboutLeft:AddText({
    text = "Azure is the #1 mobile utility for Roblox. Built for performance and customization.",
    flag = "About_Text",
    risky = false,
})

sections.AboutLeft:AddButton({
    text = "Join Discord",
    tooltip = "Click to copy the invite link",
    callback = function()
        setclipboard("https://discord.com/invite/rPqV5Nhc8a")
        library:SendNotification("Discord Invite Copied!", 5, Color3.new(0, 255, 0))
    end,
})

-- Initialize the window
Window:SetOpen(true)

library:SendNotification("Azure Initialized", 5, Color3.new(0, 255, 0))
