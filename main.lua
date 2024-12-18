-- Azure: Bloxstrap for Mobile
-- discord.gg/azrdev

-- Load up ArrayField, the UI lib
local ArrayField = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source.lua'))()

-- Create the main window for the UI
local Window = ArrayField:CreateWindow({
    Name = "Azure Utility", -- Name of the window
    LoadingTitle = "Azure Utility", -- Loading screen title
    LoadingSubtitle = "by wavezq", -- Loading screen subtitle
        ConfigurationSaving = { -- Config saving stuff
            Enabled = true, -- Enable config saving
			FolderName = "AzureSaves", -- Custom folder for saves
            FileName = "AzureConfig" -- The name of the save file
        },
        Discord = { -- Discord stuff
            Enabled = true, -- Enable Discord integration
            Invite = "rPqV5Nhc8a", -- Discord invite code
            RememberJoins = true -- Remember if the user joined the discord already
        },
     KeySystem = true, -- Enable the Key System
     KeySettings = { -- Key settings
        Title = "Azure Utility", -- Key system title
        Subtitle = "Key System", -- Key system subtitle
        Note = "Complete the Linkvertise to get the key", -- Custom Note to Explain Key is from Linkvertise
        FileName = "AzureKeys", -- Change the key file name if you want
        SaveKey = true, -- Save the key
        GrabKeyFromSite = true, -- Set to true to Grab the key from linkvertise
        Key = "https://link-target.net/1267303/key-system-for-azure", -- Set the linkvertise url
        Actions = {
            [1] = {
                Text = 'Click here to copy the key link',
                    OnPress = function()
                        setclipboard("https://link-target.net/1267303/key-system-for-azure") -- copies link
                    end,
            }
        },
    }
})

-- Create the tabs for the UI
local tabs = {
    Dashboard = Window:CreateTab("Dashboard"), -- Main tab
    Modules = Window:CreateTab("Modules"), -- Modules tab
    Settings = Window:CreateTab("Settings"), -- Settings tab
    About = Window:CreateTab("About"), -- About tab
}

-- Dashboard Section
local dashboardSection = tabs.Dashboard:CreateSection("Changelog", true)
tabs.Dashboard:CreateParagraph({Title = "Changelog", Content = "🟢 Version 1.0 - Initial release\n🟡 Version 1.1 - Bug fixes\n🔴 Version 1.2 - Major update pending"}, dashboardSection)
tabs.Dashboard:CreateSpacing(dashboardSection,10)
tabs.Dashboard:CreateButton({
    Name = "Join Discord", -- Button text
    SectionParent = dashboardSection, -- Parent section
    Callback = function() -- When the button is pressed, this is executed
        setclipboard("https://discord.com/invite/rPqV5Nhc8a") -- Copy discord link to clipboard
        ArrayField:Notify("Discord Invite Copied!", "success") -- Show a notification
    end,
})

-- Modules: Performance Tools Section
local modulesPerformanceSection = tabs.Modules:CreateSection("Performance Tools", true)

-- FPS Viewer Dropdown
local fpsViewerDropdown
local fpsLabel, pingLabel, fpsConnection, pingConnection -- Variables for the original FPS viewer

-- Load the UI for FPS Viewer BETA
local FPSUI = game:GetObjects("rbxassetid://8524217009")[1]
if game.CoreGui:FindFirstChild("FPSCounter") then
	game.CoreGui:FindFirstChild("FPSCounter"):Destroy()
end
FPSUI.Parent = game.CoreGui
FPSUI.Main.Position = UDim2.new(0, 959,0, 49)
FPSUI.Main.BackgroundTransparency = 1
FPSUI.Main.Title.TextTransparency = 1
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local DR = false

-- Load and set saved position of UI, if available
if isfile and readfile then
	local YOffset = 49
	local XOffset = 959
	if isfile("FPS Position Y Offset.txt") then
		YOffset = readfile("FPS Position Y Offset.txt")
	end
	if isfile("FPS Position X Offset.txt") then
		XOffset = readfile("FPS Position X Offset.txt")
	end
	
	local Position = UDim2.new(0,XOffset,0,YOffset)
	FPSUI.Main.Position = Position
end

-- Animate UI when added
local transitionInfo = TweenInfo.new(0.8, Enum.EasingStyle.Back)
local tween = TweenService:Create(FPSUI.Main, transitionInfo, {BackgroundTransparency = 0.8})
tween:Play()
local transitionInfo = TweenInfo.new(0.8, Enum.EasingStyle.Back)
local tween = TweenService:Create(FPSUI.Main.Title, transitionInfo, {TextTransparency = 0.4})
tween:Play()


-- Make UI Draggable
local function MakeDraggable(objecttodragfrom, object) 
	pcall(function()
		local dragging = false
		local dragInput, mousePos, framePos

		objecttodragfrom.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				DR = true
				mousePos = input.Position
				framePos = object.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)

		objecttodragfrom.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				dragInput = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				local delta = input.Position - mousePos
				local transitionInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint)
				local tween = TweenService:Create(object, transitionInfo, {Position = UDim2.new(0, framePos.X.Offset + delta.X, 0, framePos.Y.Offset + delta.Y)})
				tween:Play()
				wait(0.1)
			end
		end)
	end)
end

MakeDraggable(FPSUI.Main,FPSUI.Main)

-- Set UI Effects when Hovered Over
FPSUI.Main.MouseEnter:Connect(function()
	local transitionInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quint)
	local tween = TweenService:Create(FPSUI.Main, transitionInfo, {BackgroundTransparency = 0.4})
	tween:Play()
	local transitionInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quint)
	local tween = TweenService:Create(FPSUI.Main.Title, transitionInfo, {TextTransparency = 0.1})
	tween:Play()
end)

FPSUI.Main.MouseLeave:Connect(function()
	local transitionInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quint)
	local tween = TweenService:Create(FPSUI.Main, transitionInfo, {BackgroundTransparency = 0.8})
	tween:Play()
	local transitionInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quint)
	local tween = TweenService:Create(FPSUI.Main.Title, transitionInfo, {TextTransparency = 0.4})
	tween:Play()
end)


-- FPS counter for BETA
local FPSLabel = FPSUI.Main.Title
local Heartbeat = game:GetService("RunService").Heartbeat

local LastIteration, Start
local FrameUpdateTable = { }

local function HeartbeatUpdate()
	LastIteration = tick()
	for Index = #FrameUpdateTable, 1, -1 do
		FrameUpdateTable[Index + 1] = (FrameUpdateTable[Index] >= LastIteration - 1) and FrameUpdateTable[Index] or nil
	end
	FrameUpdateTable[1] = LastIteration
	local CurrentFPS = (tick() - Start >= 1 and #FrameUpdateTable) or (#FrameUpdateTable / (tick() - Start))
	CurrentFPS = math.floor(CurrentFPS)
	
	FPSLabel.Text = tostring(CurrentFPS).." FPS"
end

Start = tick()
local BetaFPSConnection = Heartbeat:Connect(HeartbeatUpdate)

-- Save position of UI
local BetaPositionSaver = task.spawn(function()
	while true do
		task.wait(2)
		writefile("FPS Position Y Offset.txt",FPSUI.Main.Position.Y.Offset)
		writefile("FPS Position X Offset.txt",FPSUI.Main.Position.X.Offset)
	end
end)

fpsViewerDropdown = tabs.Modules:CreateDropdown({
    Name = "FPS Viewer", -- Dropdown name
    SectionParent = modulesPerformanceSection, -- Parent section
    Options = {"None", "FPS Viewer LITE", "FPS Viewer BETA"}, -- Options in the dropdown
    Flag = "FPSViewerMode", -- Flag for config saving
    CurrentOption = "None", -- Default selected option
    Callback = function(selection) -- When the option is changed, this executes
        -- Disable all existing FPS counters
        if fpsLabel then
            fpsLabel:Destroy()
            fpsLabel = nil
        end
         if pingLabel then
                pingLabel:Destroy()
                pingLabel = nil
            end
        if fpsConnection then
            fpsConnection:Disconnect()
            fpsConnection = nil
        end
        if pingConnection then
                pingConnection:Disconnect()
                pingConnection = nil
            end
		FPSUI.Main.Visible = false
		BetaPositionSaver:Cancel()
		BetaFPSConnection:Disconnect()
        -- Enable the selected FPS counter
        if selection == "FPS Viewer LITE" then
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
        elseif selection == "FPS Viewer BETA" then
			FPSUI.Main.Visible = true
			BetaFPSConnection = Heartbeat:Connect(HeartbeatUpdate)
			BetaPositionSaver = task.spawn(function()
				while true do
					task.wait(2)
					writefile("FPS Position Y Offset.txt",FPSUI.Main.Position.Y.Offset)
					writefile("FPS Position X Offset.txt",FPSUI.Main.Position.X.Offset)
				end
			end)
        end
    end,
})

tabs.Modules:CreateInput({
    Name = "AutoClicker CPS", -- Input name
    PlaceholderText = "8", -- Placeholder text
    SectionParent = modulesPerformanceSection, -- Parent section
	Flag = "AutoClickerCPS", -- Flag for config saving
    NumbersOnly = true, -- Only allow numbers
    OnEnter = true, -- Enter triggers callback
    RemoveTextAfterFocusLost = true, -- Remove text when focus is lost
    Callback = function(value) -- When the input is entered, this executes
        getgenv().CPS = tonumber(value) -- Assign the inputted number to the CPS variable
    end,
})

tabs.Modules:CreateToggle({
    Name = "Enable AutoClicker", -- Toggle name
    SectionParent = modulesPerformanceSection, -- Parent section
        Flag = "AutoClicker", -- Flag for config saving
    CurrentValue = false, -- Default toggle value
    Callback = function(enabled) -- When the toggle is changed, this executes
        getgenv().AutoClickerEnabled = enabled -- Assign the inputted value to the AutoClickerEnabled variable
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
    },
    ["Galaxy Sky"] = {
        ["SkyboxBk"] = "http://www.roblox.com/asset/?id=8281961896",
        ["SkyboxDn"] = "http://www.roblox.com/asset/?id=8281961896",
        ["SkyboxFt"] = "http://www.roblox.com/asset/?id=8281961896",
        ["SkyboxLf"] = "http://www.roblox.com/asset/?id=8281961896",
        ["SkyboxRt"] = "http://www.roblox.com/asset/?id=8281961896",
        ["SkyboxUp"] = "http://www.roblox.com/asset/?id=8281961896"
    }
}

local skybox_names = {}
for k,v in pairs(Skyboxes) do
	table.insert(skybox_names, k)
end

tabs.Modules:CreateDropdown({
        Name = "Custom Skybox", -- Dropdown name
        SectionParent = modulesCustomizationSection, -- Parent section
        Options = skybox_names, -- Options in the dropdown
         Flag = "CustomSkybox", -- Flag for config saving
        CurrentOption = nil, -- Default selected option
        Callback = function(selection) -- When the option is changed, this executes
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
    Name = "FPS Boost", -- Toggle name
    SectionParent = fpsBoostSection, -- Parent section
       Flag = "FPSBoost", -- Flag for config saving
    CurrentValue = false, -- Default toggle value
    Callback = function(Callback) -- When the toggle is changed, this executes
        FPSBoostEnabled = Callback -- Assign the inputted value to the FPSBoostEnabled variable
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
    Name = "Remove Textures", -- Toggle name
    SectionParent = fpsBoostSection, -- Parent section
       Flag = "RemoveTextures", -- Flag for config saving
    CurrentValue = true, -- Default toggle value
    Callback = function(Callback) -- When the toggle is changed, this executes
        FPSBoostTextureEnabled = Callback -- Assign the inputted value to the FPSBoostTextureEnabled variable
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
    Name = "FPS Unlocker", -- Toggle name
    SectionParent = fpsBoostSection, -- Parent section
       Flag = "FPSUnlocker", -- Flag for config saving
    CurrentValue = false, -- Default toggle value
    Callback = function(Callback) -- When the toggle is changed, this executes
        EnabledFPS = Callback -- Assign the inputted value to the EnabledFPS variable
        if EnabledFPS then
            setfpscap(999)
        end
    end,
})

-- Chat Tag Module
local chatTagSection = tabs.Modules:CreateSection("Chat Tag", true)

tabs.Modules:CreateToggle({
    Name = "Azure User Chat Tag", -- Toggle name
    SectionParent = chatTagSection, -- Parent section
       Flag = "ChatTag", -- Flag for config saving
    CurrentValue = false, -- Default toggle value
    Callback = function(Callback) -- When the toggle is changed, this executes
        AzureTagEnabled = Callback -- Assign the inputted value to the AzureTagEnabled variable
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
