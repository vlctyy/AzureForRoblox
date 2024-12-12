-- Azure: Bloxstrap for Mobile
-- discord.gg/azrdev

getgenv().Config = {
    Invite = "rPqV5Nhc8a",
    Version = "1.8",
}

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/drillygzzly/Other/main/ArrayFieldLib"))()

library:init()

local Window = library:New({
    Name = "Azure Utility",
    Size = UDim2.new(0, 600, 0, 650),
    SideBar = true,
    SearchBar = true,
})

local tabs = {
    Dashboard = Window:Tab("Dashboard"),
    Modules = Window:Tab("Modules"),
    Settings = Window:Tab("Settings"),
    About = Window:Tab("About"),
}

-- Section setup
local sections = {
    Dashboard = tabs.Dashboard:Section("Changelog"),
    ModulesPerformance = tabs.Modules:Section("Performance Tools"),
    ModulesCustomization = tabs.Modules:Section("Customizations"),
    FPSBoost = tabs.Modules:Section("FPS Boost"),
    Settings = tabs.Settings:Section("Settings"),
    About = tabs.About:Section("About Azure"),
}

-- Dashboard content
sections.Dashboard:Label("🟢 Version 1.0 - Initial release\n" ..
                         "🟡 Version 1.1 - Bug fixes\n" ..
                         "🔴 Version 1.2 - Major update pending")

sections.Dashboard:Button("Join Discord", function()
    setclipboard("https://discord.com/invite/rPqV5Nhc8a")
    library:Notify("Discord Invite Copied!", "success")
end)

-- Modules: FPS and Ping Viewer
sections.ModulesPerformance:Toggle("FPS Viewer", false, function(enabled)
    if enabled then
        local fpsLabel = Instance.new("TextLabel")
        fpsLabel.Size = UDim2.new(0, 200, 0, 50)
        fpsLabel.Position = UDim2.new(0, 10, 0, 10)
        fpsLabel.BackgroundTransparency = 0.5
        fpsLabel.TextScaled = true
        fpsLabel.Text = "FPS: ..."
        fpsLabel.Parent = game.CoreGui

        local pingLabel = Instance.new("TextLabel")
        pingLabel.Size = UDim2.new(0, 200, 0, 50)
        pingLabel.Position = UDim2.new(0, 10, 0, 70)
        pingLabel.BackgroundTransparency = 0.5
        pingLabel.TextScaled = true
        pingLabel.Text = "Ping: ..."
        pingLabel.Parent = game.CoreGui

        local fpsConnection = game:GetService("RunService").RenderStepped:Connect(function()
            fpsLabel.Text = "FPS: " .. math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
        end)

        local pingConnection = game:GetService("RunService").Heartbeat:Connect(function()
            pingLabel.Text = "Ping: " .. math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) .. " ms"
        end)

        getgenv().FPSPingConnections = {fpsConnection, pingConnection}
    else
        for _, v in pairs(game.CoreGui:GetChildren()) do
            if v:IsA("TextLabel") and (v.Text:find("FPS:") or v.Text:find("Ping:")) then
                v:Destroy()
            end
        end

        if getgenv().FPSPingConnections then
            for _, connection in pairs(getgenv().FPSPingConnections) do
                connection:Disconnect()
            end
            getgenv().FPSPingConnections = nil
        end
    end
end)

-- Modules: AutoClicker
sections.ModulesPerformance:Box("AutoClicker CPS", "8", function(value)
    getgenv().CPS = tonumber(value)
end)

sections.ModulesPerformance:Toggle("Enable AutoClicker", false, function(enabled)
    getgenv().AutoClickerEnabled = enabled
    if enabled then
        while getgenv().AutoClickerEnabled do
            task.wait(1 / (getgenv().CPS or 8))
            mouse1click()
        end
    end
end)

-- Modules: Skybox
sections.ModulesCustomization:Dropdown("Custom Skybox", {"Winter Skybox", "Galaxy Sky"}, function(selection)
    local Lighting = game:GetService("Lighting")
    if selection == "Winter Skybox" then
        local sky = Instance.new("Sky")
        sky.SkyboxUp = "rbxassetid://8139676647"
        sky.SkyboxLf = "rbxassetid://8139676988"
        sky.SkyboxFt = "rbxassetid://8139677111"
        sky.SkyboxBk = "rbxassetid://8139677359"
        sky.SkyboxDn = "rbxassetid://8139677253"
        sky.SkyboxRt = "rbxassetid://8139676842"
        sky.Parent = Lighting
    elseif selection == "Galaxy Sky" then
        local sky = Instance.new("Sky")
        local ID = 8281961896
        sky.SkyboxBk = "http://www.roblox.com/asset/?id="..ID
        sky.SkyboxDn = "http://www.roblox.com/asset/?id="..ID
        sky.SkyboxFt = "http://www.roblox.com/asset/?id="..ID
        sky.SkyboxLf = "http://www.roblox.com/asset/?id="..ID
        sky.SkyboxRt = "http://www.roblox.com/asset/?id="..ID
        sky.SkyboxUp = "http://www.roblox.com/asset/?id="..ID
        sky.Parent = Lighting
    end
end)

-- FPS Boost Module
sections.FPSBoost:Toggle("FPS Boost", false, function(Callback)
    FPSBoostEnabled = Callback
    if FPSBoostEnabled then
        fpsboosttextures()
        for i,v in next, (bedwars["KillEffectController"].killEffects) do 
            basetextures[i] = v
            bedwars["KillEffectController"].killEffects[i] = {new = function(char) return {onKill = function() end, isPlayDefaultKillEffect = function() return char == LocalPlayer.Character end} end}
        end
        old = bedwars["HighlightController"].highlight
        old2 = getmetatable(bedwars["StopwatchController"]).tweenOutGhost
        getmetatable(bedwars["StopwatchController"]).tweenOutGhost = function(p17, p18)
            p18:Destroy()
        end
        bedwars["HighlightController"].highlight = function() end
    else
        for i,v in next, (basetextures) do 
            bedwars["KillEffectController"].killEffects[i] = v
        end
        fpsboosttextures()
        debug.setupvalue(bedwars["KillEffectController"].KnitStart, 2, bedwars["ClientSyncEvents"])
        bedwars["HighlightController"].highlight = old
        getmetatable(bedwars["StopwatchController"]).tweenOutGhost = old2
        old = nil
        old2 = nil
    end
end)

sections.FPSBoost:Toggle("Remove Textures", true, function(Callback)
    FPSBoostTextureEnabled = Callback
end)

local function fpsboosttextures()
    task.spawn(function()
        repeat task.wait() until GetMatchState() ~= 0
        for i,v in next, (collectionService:GetTagged('block')) do
            if v:GetAttribute('PlacedByUserId') == 0 then
                v.Material = FPSBoostEnabled and FPSBoostTextureEnabled and Enum.Material.SmoothPlastic
                basetextures[v] = basetextures[v] or v.MaterialVariant
                v.MaterialVariant = FPSBoostEnabled and FPSBoostTextureEnabled and '' or basetextures[v]
                for i2,v2 in next, (v:GetChildren()) do 
                    pcall(function() 
                        v2.Material = FPSBoostEnabled and FPSBoostTextureEnabled and Enum.Material.SmoothPlastic
                        basetextures[v2] = basetextures[v2] or v2.MaterialVariant
                        v2.MaterialVariant = FPSBoostEnabled and FPSBoostTextureEnabled and '' or basetextures[v2]
                    end)
                end
            end
        end
    end)
end

-- FPS Unlocker Module
sections.FPSBoost:Toggle("FPS Unlocker", false, function(Callback)
    EnabledFPS = Callback
    if EnabledFPS then
        setfpscap(999)
    end
end)

-- About content
sections.About:Label("Azure is the #1 mobile utility for Roblox. Built for performance and customization.")

sections.About:Button("Join Discord", function()
    setclipboard("https://discord.com/invite/rPqV5Nhc8a")
    library:Notify("Discord Invite Copied!", "success")
end)

library:Notify("Azure Initialized", "success")
