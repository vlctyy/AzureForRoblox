-- Azure: Bloxstrap for Mobile
-- discord.gg/azrdev

local ArrayField = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source'))()

local Window = ArrayField:CreateWindow({
    Name = "Azure Utility",
    LoadingTitle = "Azure Utility",
    LoadingSubtitle = "by drillygzzly",
        ConfigurationSaving = {
            Enabled = false,
        },
        Discord = {
            Enabled = true,
            Invite = "rPqV5Nhc8a",
            RememberJoins = true
        },
     KeySystem = false,
})

local tabs = {
    Dashboard = Window:CreateTab("Dashboard"),
    Modules = Window:CreateTab("Modules"),
    Settings = Window:CreateTab("Settings"),
    About = Window:CreateTab("About"),
}

-- Dashboard Section
local dashboardSection = tabs.Dashboard:CreateSection("Changelog", true)
tabs.Dashboard:CreateParagraph({Title = "Changelog", Content = "🟢 Version 1.0 - Initial release\n🟡 Version 1.1 - Bug fixes\n🔴 Version 1.2 - Major update pending"}, dashboardSection)
tabs.Dashboard:CreateSpacing(dashboardSection,10)
tabs.Dashboard:CreateButton({
    Name = "Join Discord",
    SectionParent = dashboardSection,
    Callback = function()
        setclipboard("https://discord.com/invite/rPqV5Nhc8a")
        ArrayField:Notify("Discord Invite Copied!", "success")
    end,
})

-- Modules: Performance Tools Section
local modulesPerformanceSection = tabs.Modules:CreateSection("Performance Tools", true)
local fpsPingToggle
fpsPingToggle = tabs.Modules:CreateToggle({
    Name = "FPS Viewer",
    SectionParent = modulesPerformanceSection,
        Flag = "FPSViewer",
    CurrentValue = false,
    Callback = function(enabled)
    local fpsLabel, pingLabel, fpsConnection, pingConnection
        if enabled then
            fpsLabel = Instance.new("TextLabel")
            fpsLabel.Size = UDim2.new(0, 200, 0, 50)
            fpsLabel.Position = UDim2.new(0, 10, 0, 10)
            fpsLabel.BackgroundTransparency = 0.5
            fpsLabel.TextScaled = true
            fpsLabel.Text = "FPS: ..."
            fpsLabel.Parent = game.CoreGui
    
            pingLabel = Instance.new("TextLabel")
            pingLabel.Size = UDim2.new(0, 200, 0, 50)
            pingLabel.Position = UDim2.new(0, 10, 0, 70)
            pingLabel.BackgroundTransparency = 0.5
            pingLabel.TextScaled = true
            pingLabel.Text = "Ping: ..."
            pingLabel.Parent = game.CoreGui
    
             fpsConnection = game:GetService("RunService").RenderStepped:Connect(function()
                fpsLabel.Text = "FPS: " .. math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
            end)
    
            pingConnection = game:GetService("RunService").Heartbeat:Connect(function()
                pingLabel.Text = "Ping: " .. math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) .. " ms"
            end)
    
            getgenv().FPSPingConnections = {fpsConnection, pingConnection}
           getgenv().FPSTextLabel = fpsLabel
            getgenv().PingTextLabel = pingLabel
        else
           if getgenv().FPSTextLabel then
                getgenv().FPSTextLabel:Destroy()
                getgenv().FPSTextLabel = nil
            end
            if getgenv().PingTextLabel then
                getgenv().PingTextLabel:Destroy()
                getgenv().PingTextLabel = nil
            end
              if getgenv().FPSPingConnections then
                for _, connection in pairs(getgenv().FPSPingConnections) do
                    connection:Disconnect()
                end
                getgenv().FPSPingConnections = nil
            end
        end
    end,
})

tabs.Modules:CreateInput({
    Name = "AutoClicker CPS",
    PlaceholderText = "8",
    SectionParent = modulesPerformanceSection,
	Flag = "AutoClickerCPS",
    NumbersOnly = true,
    OnEnter = true,
    RemoveTextAfterFocusLost = true,
    Callback = function(value)
        getgenv().CPS = tonumber(value)
    end,
})

tabs.Modules:CreateToggle({
    Name = "Enable AutoClicker",
    SectionParent = modulesPerformanceSection,
        Flag = "AutoClicker",
    CurrentValue = false,
    Callback = function(enabled)
        getgenv().AutoClickerEnabled = enabled
        if enabled then
            while getgenv().AutoClickerEnabled do
                task.wait(1 / (getgenv().CPS or 8))
                mouse1click()
            end
        end
    end,
})

-- Modules: Customizations Section
local modulesCustomizationSection = tabs.Modules:CreateSection("Customizations", true)

local Skyboxes = {
    ["Purple Nebula"] = {
        ["SkyboxBk"] = "rbxassetid://159454299",
        ["SkyboxDn"] = "rbxassetid://159454296",
        ["SkyboxFt"] = "rbxassetid://159454293",
        ["SkyboxLf"] = "rbxassetid://159454286",
        ["SkyboxRt"] = "rbxassetid://159454300",
        ["SkyboxUp"] = "rbxassetid://159454288"
    },
    ["Night Sky"] = {
        ["SkyboxBk"] = "rbxassetid://12064107",
        ["SkyboxDn"] = "rbxassetid://12064152",
        ["SkyboxFt"] = "rbxassetid://12064121",
        ["SkyboxLf"] = "rbxassetid://12063984",
        ["SkyboxRt"] = "rbxassetid://12064115",
        ["SkyboxUp"] = "rbxassetid://12064131"
    },
    ["Pink Daylight"] = {
        ["SkyboxBk"] = "rbxassetid://271042516",
        ["SkyboxDn"] = "rbxassetid://271077243",
        ["SkyboxFt"] = "rbxassetid://271042556",
        ["SkyboxLf"] = "rbxassetid://271042310",
        ["SkyboxRt"] = "rbxassetid://271042467",
        ["SkyboxUp"] = "rbxassetid://271077958"
    },
    ["Morning Glow"] = {
        ["SkyboxBk"] = "rbxassetid://1417494030",
        ["SkyboxDn"] = "rbxassetid://1417494146",
        ["SkyboxFt"] = "rbxassetid://1417494253",
        ["SkyboxLf"] = "rbxassetid://1417494402",
        ["SkyboxRt"] = "rbxassetid://1417494499",
        ["SkyboxUp"] = "rbxassetid://1417494643"
    },
    ["Setting Sun"] = {
        ["SkyboxBk"] = "rbxassetid://626460377",
        ["SkyboxDn"] = "rbxassetid://626460216",
        ["SkyboxFt"] = "rbxassetid://626460513",
        ["SkyboxLf"] = "rbxassetid://626473032",
        ["SkyboxRt"] = "rbxassetid://626458639",
        ["SkyboxUp"] = "rbxassetid://626460625"
    },
    ["Fade Blue"] = {
        ["SkyboxBk"] = "rbxassetid://153695414",
        ["SkyboxDn"] = "rbxassetid://153695352",
        ["SkyboxFt"] = "rbxassetid://153695452",
        ["SkyboxLf"] = "rbxassetid://153695320",
        ["SkyboxRt"] = "rbxassetid://153695383",
        ["SkyboxUp"] = "rbxassetid://153695471"
    },
    ["Elegant Morning"] = {
        ["SkyboxBk"] = "rbxassetid://153767241",
        ["SkyboxDn"] = "rbxassetid://153767216",
        ["SkyboxFt"] = "rbxassetid://153767266",
        ["SkyboxLf"] = "rbxassetid://153767200",
        ["SkyboxRt"] = "rbxassetid://153767231",
        ["SkyboxUp"] = "rbxassetid://153767288"
    },
     ["Neptune"] = {
        ["SkyboxBk"] = "rbxassetid://218955819",
        ["SkyboxDn"] = "rbxassetid://218953419",
        ["SkyboxFt"] = "rbxassetid://218954524",
        ["SkyboxLf"] = "rbxassetid://218958493",
        ["SkyboxRt"] = "rbxassetid://218957134",
        ["SkyboxUp"] = "rbxassetid://218950090"
    },
    ["Redshift"] = {
        ["SkyboxBk"] = "rbxassetid://401664839",
        ["SkyboxDn"] = "rbxassetid://401664862",
        ["SkyboxFt"] = "rbxassetid://401664960",
        ["SkyboxLf"] = "rbxassetid://401664881",
        ["SkyboxRt"] = "rbxassetid://401664901",
        ["SkyboxUp"] = "rbxassetid://401664936"
    },
    ["Aesthetic Night"] = {
        ["SkyboxBk"] = "rbxassetid://1045964490",
        ["SkyboxDn"] = "rbxassetid://1045964368",
        ["SkyboxFt"] = "rbxassetid://1045964655",
        ["SkyboxLf"] = "rbxassetid://1045964655",
        ["SkyboxRt"] = "rbxassetid://1045964655",
        ["SkyboxUp"] = "rbxassetid://1045962969"
    },
    ["Winter Skybox"] = {
        ["SkyboxBk"] = "rbxassetid://1398422565",
        ["SkyboxDn"] = "rbxassetid://1398422712",
        ["SkyboxFt"] = "rbxassetid://1398422897",
        ["SkyboxLf"] = "rbxassetid://1398423035",
        ["SkyboxRt"] = "rbxassetid://1398423150",
        ["SkyboxUp"] = "rbxassetid://1398423360"
    }
}


local skybox_names = {}
for k,v in pairs(Skyboxes) do
	table.insert(skybox_names, k)
end

tabs.Modules:CreateDropdown({
        Name = "Custom Skybox",
        SectionParent = modulesCustomizationSection,
        Options = skybox_names,
         Flag = "CustomSkybox",
        CurrentOption = nil,
        Callback = function(selection)
            local Lighting = game:GetService("Lighting")
            local sky = Instance.new("Sky")
            local skybox = Skyboxes[selection]
            sky.SkyboxBk = skybox.SkyboxBk
            sky.SkyboxDn = skybox.SkyboxDn
            sky.SkyboxFt = skybox.SkyboxFt
            sky.SkyboxLf = skybox.SkyboxLf
            sky.SkyboxRt = skybox.SkyboxRt
            sky.SkyboxUp = skybox.SkyboxUp
            sky.Parent = Lighting
        end,
    })

-- FPS Boost Module
local fpsBoostSection = tabs.Modules:CreateSection("FPS Boost", true)

tabs.Modules:CreateToggle({
    Name = "FPS Boost",
    SectionParent = fpsBoostSection,
       Flag = "FPSBoost",
    CurrentValue = false,
    Callback = function(Callback)
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
    end,
})

tabs.Modules:CreateToggle({
    Name = "Remove Textures",
    SectionParent = fpsBoostSection,
       Flag = "RemoveTextures",
    CurrentValue = true,
    Callback = function(Callback)
        FPSBoostTextureEnabled = Callback
    end,
})

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

tabs.Modules:CreateToggle({
    Name = "FPS Unlocker",
    SectionParent = fpsBoostSection,
       Flag = "FPSUnlocker",
    CurrentValue = false,
    Callback = function(Callback)
        EnabledFPS = Callback
        if EnabledFPS then
            setfpscap(999)
        end
    end,
})

-- Chat Tag Module
local chatTagSection = tabs.Modules:CreateSection("Chat Tag", true)

tabs.Modules:CreateToggle({
    Name = "Azure User Chat Tag",
    SectionParent = chatTagSection,
       Flag = "ChatTag",
    CurrentValue = false,
    Callback = function(Callback)
        AzureTagEnabled = Callback
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local TextChatService = game:GetService("TextChatService")

        TextChatService.OnIncomingMessage = function(message)
            local properties = Instance.new("TextChatMessageProperties")
            if message.TextSource then
                local getidplayer = Players:GetPlayerByUserId(message.TextSource.UserId)
                if getidplayer and getidplayer.UserId == LocalPlayer.UserId then
                    if AzureTagEnabled then
                        properties.PrefixText = "<font color='#1E90FF'>[AZURE USER]</font> " .. message.PrefixText
                    else
                        properties.PrefixText = message.PrefixText
                    end
                end
            end
            return properties
        end
    end,
})

-- About Section
local aboutSection = tabs.About:CreateSection("About Azure", true)
tabs.About:CreateParagraph({Title = "About Azure", Content = "Azure is the #1 mobile utility for Roblox. Built for performance and customization."}, aboutSection)
tabs.About:CreateSpacing(aboutSection, 10)
tabs.About:CreateButton({
    Name = "Join Discord",
    SectionParent = aboutSection,
    Callback = function()
        setclipboard("https://discord.com/invite/rPqV5Nhc8a")
       ArrayField:Notify("Discord Invite Copied!", "success")
    end,
})

ArrayField:Notify("Azure Initialized", "success")
