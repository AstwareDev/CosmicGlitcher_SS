--[[
===============================================================================
Cosmic Glitcher Script - Developed by AstwareDev
===============================================================================

Purpose:
This script was developed for educational and experimental purposes.
All code is original and authored by AstwareDev unless otherwise noted.

Inspiration:
The "Star Glitcher" concept was originally created by Birdmaid.
This script is an independent creation inspired by that concept,
and does not use or redistribute any original copyrighted code or assets.

Credits:
- AstwareDev: Sole developer and author of this codebase.
- Base/Vanguard: Granted permission to reuse certain assets (e.g., aura rocks).
- IceMinisterq: Notification System (https://github.com/IceMinisterq/)

Legal Notice:
All code within this script is protected under copyright law.
Unauthorized copying, reposting, editing, repackaging, or selling of this code
without explicit permission will result in DMCA takedown notices and legal action.

You are permitted to:
- Study or learn from this code privately.
You are NOT permitted to:
- Rebrand, reupload, sell, or claim this work as your own.

DMCA protection active as of 2025.

===============================================================================
]]

-- [[ Services ]] --
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")

-- [[ Variables ]] --
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local BettyMoves = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BettyMoves")

-- [[ Global Variables ]] --
getgenv().CosmicGlitcher = {
    SystemValues = {
        AlreadyExecuted = false
    },
    MainValues = {
        hasWings = false,
        slashes = {},
        current_glitcher = "Mayhem",
        glitchers = {
            ["Mayhem"] = {Color3.fromRGB(255,0,0), {
                ["Idle"] = "rbxassetid://6416819199",
                ["Walk"] = "rbxassetid://7005162082",
                ["Run"] = "rbxassetid://6492501335",
                ["Jump"] = "rbxassetid://3198665507",
                ["Fall"] = "rbxassetid://5111359205",
                ["Block"] = "rbxassetid://3290775773"
            }},
            ["Death"] = {Color3.fromRGB(0,0,0), {
                ["Idle"] = "rbxassetid://6416819199",
                ["Walk"] = "rbxassetid://7005162082",
                ["Run"] = "rbxassetid://6492501335",
                ["Jump"] = "rbxassetid://3198665507",
                ["Fall"] = "rbxassetid://5111359205",
                ["Block"] = "rbxassetid://3290775773"
            }},
            ["Purity"] = {Color3.fromRGB(18, 238, 212), {
                ["Idle"] = "rbxassetid://6136039008",
                ["Walk"] = "rbxassetid://7005162082",
                ["Run"] = "rbxassetid://6492501335",
                ["Jump"] = "rbxassetid://3198665507",
                ["Fall"] = "rbxassetid://5111359205",
                ["Block"] = "rbxassetid://3290775773"
            }},
            ["Corruption"] = {Color3.fromRGB(170, 0, 255), {
                ["Idle"] = "rbxassetid://4283811527",
                ["Walk"] = "rbxassetid://7005162082",
                ["Run"] = "rbxassetid://6492501335",
                ["Jump"] = "rbxassetid://3198665507",
                ["Fall"] = "rbxassetid://5111359205",
                ["Block"] = "rbxassetid://3290775773"
            }}
        },
        stocked = 0,
        used = 0
    },
    OtherStuff = {
        AXIS_LIMIT = 10000,
        SAFE_POSITION = CFrame.new(0,10,0)
    },
    Assets = {
        models = {
            Cosmic_Wings = {name = "Cosmic_Wings.rbxm", url = "https://github.com/AstwareDev/CosmicGlitcher_SS/raw/refs/heads/main/CosmicGlitcher.rbxm"}
        },
        music = {
            Mayhem = {name = "Mayhem.mp3", url = "https://github.com/AstwareDev/CosmicGlitcher_SS/raw/refs/heads/main/D-Mode-D%20-%20Shriek%20-%20128.mp3"},
            Purity = {name = "Purity.mp3", url = "https://github.com/AstwareDev/CosmicGlitcher_SS/raw/refs/heads/main/EBIMAYO%20-%20GOODTEK%20(Extended)%20-%20128.mp3"},
            Corruption = {name = "Corruption.mp3", url = "https://github.com/AstwareDev/CosmicGlitcher_SS/raw/refs/heads/main/CORRUPTION%20STAR%20GLITCHER%20THEME%20-%20128.mp3"},
            Death = {name = "Death.mp3", url = "https://github.com/AstwareDev/CosmicGlitcher_SS/raw/refs/heads/main/Warak%20-%20Reanimate%20-%20128.mp3"}
        }
    }
}

-- [[ Download Assets ]] --
local notif = loadstring(game:HttpGet("https://raw.githubusercontent.com/IceMinisterq/Notification-Library/Main/Library.lua"))()

makefolder("CosmicGlitcher")
function GitDownload(GIT_URL, ASSET_NAME)
    local fileName = "CosmicGlitcher/" .. tostring(ASSET_NAME)
    if not isfile(fileName) then
        notif:SendNotification('Info','Downloading '..ASSET_NAME,3)
        local success, result = pcall(function()
            return game:HttpGet(GIT_URL)
        end)
        if success then
            writefile(fileName, result)
            notif:SendNotification('Success','Downloaded '..ASSET_NAME,3)
        else
            notif:SendNotification('Error','Failed to download '..ASSET_NAME,3)
            warn("[ Cosmic Glitcher ]:// "..tostring(result))
            return nil
        end
    end
    return (getcustomasset or getsynasset)(fileName)
end

for category, files in pairs(CosmicGlitcher.Assets) do
    for key, file in pairs(files) do
        if file.name and file.url and file.url ~= "" then
            CosmicGlitcher.Assets[category][key] = GitDownload(file.url,file.name)
        end
    end
end

-- [[ RemoteSecurity Bypass ]]
task.spawn(function()
    local attmpt, retries, pass = 0, 12, nil
    getgenv().getPass = function()
        if pass then return pass end
        for _, obj in next, getgc(true) do
            if typeof(obj) == "table" and rawget(obj, "RootPartFollow") ~= nil then
                if typeof(rawget(obj, "Pass")) == "Instance" then
                    pass = rawget(obj, "Pass")
                    break
                end
            end
        end
        return pass
    end
    while not getPass() and attmpt < retries do
        task.wait(1)
        warn("retrying getPass()...")
        attmpt += 1
    end
    if not getPass() then
        warn("Pass not found:", pass)
    else 
        print("Pass found:", pass)
    end
end)

-- [[ Character Selection ]] --
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
PlayerGui.CharacterSelection.Character.Value = "Betty"
task.wait(2)

-- [[ Other Variables ]] --
local char = player.Character or player.CharacterAdded:Wait()
local root = char:FindFirstChild("HumanoidRootPart")
local UI = PlayerGui:WaitForChild("UI"):WaitForChild("Ui")
local remotes = ReplicatedStorage.Remotes
local HealthBar = char.Head.HealthBar.Frame

-- [[ Increasing ManaBar and Summoning Weapon ]] --
BettyMoves:InvokeServer({getPass(), "Rhabdophobia" })
remotes:WaitForChild("XSansMoves"):InvokeServer({getPass(),"SummonKnife","Hit", true})
local arguments = { [1] = { [1] = getPass(), [2] = "KumuFused" } } 
game:GetService("ReplicatedStorage").Remotes.BettyMoves:InvokeServer(unpack(arguments)) 

-- [[ Reanimate ]] --
local function ca(animationTable)
	local humanoid = char and char:FindFirstChild("Humanoid")
	if not humanoid then return end
	for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
	end
	local main = player.Backpack:WaitForChild("Main")
	local extra
	for _, tool in ipairs(main:GetChildren()) do
		if tool:IsA("Tool") and tool:FindFirstChild("Animations") and string.lower(tool.Name):find("moves") then
			for _, pair in ipairs(animationTable) do
				local animName, animId = pair[1], pair[2]
				local anim = tool.Animations:FindFirstChild(animName)
				if anim then
					anim.AnimationId = animId
				end
			end
		end
	end
	for _, obj in ipairs(main:GetDescendants()) do
		if obj.Name == "Extra" then
			extra = obj
			break
		end
	end
	if not extra then return end
	for _, obj in ipairs(main:GetChildren()) do
		if obj:IsA("LocalScript") and obj.Name:find("Moves") then
			obj.Disabled = true
			main = obj
		end
	end
	local uiRoot = player.PlayerGui:FindFirstChild("UI") and player.PlayerGui.UI:FindFirstChild("Ui")
	if uiRoot then
		for _, ui in ipairs(uiRoot:GetChildren()) do
			if ui.Name:lower():find("move") then
				ui.Parent = extra
			end
		end
	end
	for _, ui in ipairs(player.PlayerGui:GetChildren()) do
		local name = ui.Name:lower()
		if name:find("food") or name:find("weapon") then
			ui.Parent = extra
		end
	end
	local lastIndicatorName
	for _, obj in ipairs(player:GetDescendants()) do
		if obj.Name ~= "Indicator" and obj.Name:lower():find("indicator") then
			obj.Parent = extra
			lastIndicatorName = obj.Name
		end
	end
	if lastIndicatorName then
		local count = 0
		for _, obj in ipairs(extra:GetChildren()) do
			if obj.Name == lastIndicatorName then
				count += 1
				if count > 1 then
					obj:Destroy()
				end
			end
		end
	end
	if main then
		main.Disabled = false
	end
end
local Base = {
{'Idle','rbxassetid://6416819199'},{'Walk','rbxassetid://7005162082'},{'Run','rbxassetid://5657151699'},{'Jump','rbxassetid://3198665507'},{'Fall','rbxassetid://5111359205'},{'Block','rbxassetid://3290775773'}
}
ca(Base)

game.Players.LocalPlayer.Backpack:WaitForChild("Main").BettyMoves.ModuleScript.Animations.BasicCombat.Light1.AnimationId = "rbxassetid://5973915611"
game.Players.LocalPlayer.Backpack:WaitForChild("Main").BettyMoves.ModuleScript.Animations.BasicCombat.Light2.AnimationId = "rbxassetid://5973918259"
game.Players.LocalPlayer.Backpack:WaitForChild("Main").BettyMoves.ModuleScript.Animations.BasicCombat.Light3.AnimationId = "rbxassetid://5973919830"
game.Players.LocalPlayer.Backpack:WaitForChild("Main").BettyMoves.ModuleScript.Animations.BasicCombat.Light4.AnimationId = "rbxassetid://5973921873"
game.Players.LocalPlayer.Backpack:WaitForChild("Main").BettyMoves.ModuleScript.Animations.BasicCombat.Light5.AnimationId = "rbxassetid://5973923761"
game.Players.LocalPlayer.Backpack:WaitForChild("Main").BettyMoves.ModuleScript.Animations.BasicCombat.Light6.AnimationId = "rbxassetid://5973928930"

-- [[ Chat ]] --
local ExperienceChat = CoreGui:WaitForChild("ExperienceChat")
local ChatInputBar = ExperienceChat:WaitForChild("appLayout"):WaitForChild("chatInputBar")
local TextBox = ChatInputBar.Background.Container.TextContainer.TextBoxContainer:WaitForChild("TextBox")
TextBox.FocusLost:Connect(function(enterPressed)
	if not enterPressed then return end
	local input = TextBox.Text
	if input == "" then return end
	local lower = input:lower()
	if lower == "/rejoin" or lower == "!rejoin" then
		return
	end
	TextBox.Text = ""
	local finalMessage = ` {CosmicGlitcher.MainValues.current_glitcher} *\n` .. input
	Players:Chat(finalMessage)
end)

-- [[ Controls UI ]] --
UI.UpdateLogInfo.Top.TextXAlignment = "Center"
UI.UpdateLogInfo.Top.Text = "Cosmic Glitcher Info"
UI.UpdateLogInfo["1"].TextLabel.Text = "* [ Credits ]\n+ AstwareDev : Owner of the script\n+ Base/Vanguard : Helped out with some stuff\n+ IceMinisterq : Notification UI \n* [ Controls ]\n No Controls Yet."

UI.UpdateLog.Text = "Cosmic Info"

-- [[ Anti Fling/Void ]] --
workspace.FallenPartsDestroyHeight = "-nan"
RunService.Stepped:Connect(function()
	if math.abs(root.Position.X) > CosmicGlitcher.OtherStuff.AXIS_LIMIT or math.abs(root.Position.Y) > CosmicGlitcher.OtherStuff.AXIS_LIMIT or math.abs(root.Position.Z) > CosmicGlitcher.OtherStuff.AXIS_LIMIT then
		root.CFrame = CosmicGlitcher.OtherStuff.SAFE_POSITION
	end
end)

-- [[ Hit Remote Blocking ]] -- (For slash permanance)
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	local args = { ... }
	if self == BettyMoves and method == "InvokeServer" then
		local a = args[1]
		if typeof(a) == "table" and #a == 6 then
			local arg1, arg2, arg3, arg4, arg5, arg6 = unpack(a)

			if typeof(arg1) == "Instance"
				and arg1:IsDescendantOf(ReplicatedStorage:FindFirstChild("RemoteSecurity") or Instance.new("Folder"))
				and arg2 == "Move1"
				and arg3 == "Hit"
				and typeof(arg4) == "Instance"
				and typeof(arg5) == "CFrame"
				and typeof(arg6) == "Instance"
				and arg6:IsDescendantOf(workspace:FindFirstChild("Live") or Instance.new("Model")) then
				return
			end
		end
	end
	return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [[ Slash Stocker ]] --
local Attacks_Folder = char:FindFirstChild("Attacks") or char:WaitForChild("Attacks")
Attacks_Folder.ChildAdded:Connect(function(child)
	if child.Name == "BettyHandProjectile" then
		CosmicGlitcher.MainValues.stocked += 1
		child.Name = "Cosmic_Slash" .. tostring(CosmicGlitcher.MainValues.stocked)
		local touch = child:WaitForChild("Touch", 5)
		local burst = child:WaitForChild("Burst", 5)
		local ParticleEmitter = child:WaitForChild("ParticleEmitter", 5)
		if touch then touch:Destroy() end
		if burst then burst:Destroy() end
		if ParticleEmitter then ParticleEmitter:Destroy() end
		for _, v in child:GetChildren() do
			if v:IsA("Beam") or v:IsA("Trail") then v:Destroy() end
		end
		local conn
		conn = RunService.RenderStepped:Connect(function()
			if not child or not child.Parent then
				conn:Disconnect()
				return
			end
			child.Color = CosmicGlitcher.MainValues.glitchers[CosmicGlitcher.MainValues.current_glitcher][1]
		end)
		task.spawn(BettyMoves.InvokeServer, BettyMoves, {
			getPass(),
			"Move1",
			"Hit",
			{ Hitted = child:WaitForChild("Hitted") },
			CFrame.new(0, 0, 0),
			{ Parent = workspace, Name = "ye", Material = Enum.Material.Neon, Color = Color3.new(1, 165, 1), Transparency = 0 }
		})
	end
end)

-- [[ Rocks Aura ]] --
local function MakeRocks(color)
    local args = {
        {
            getPass(),
            "Move1",
            "Hit",
            {
                Hitted = { char }
            },
            char.HumanoidRootPart.CFrame - Vector3.new(0, 35, 0),
            {
                Parent = workspace.ServerEffects,
                Material = Enum.Material.Neon,
                Color = color,
                Transparency = 0
            },
            nil,
            nil,
            nil,
            "AllowedRemote"
        }
    }
    BettyMoves:InvokeServer(unpack(args))
end

task.spawn(function()
    while task.wait(1/5) do
        MakeRocks(CosmicGlitcher.MainValues.glitchers[CosmicGlitcher.MainValues.current_glitcher][1])
    end
end)

-- [[ Useless Stuff Removal ]] --
char:WaitForChild("KumuArmL"):Destroy()
char:WaitForChild("KumuArmR"):Destroy()
char:WaitForChild("BettyFinalKnife"):Destroy()
char:WaitForChild("BettyFinalKnife"):Destroy()
char:WaitForChild("CrossSansBlade"):FindFirstChild("ActualBlade").TextureID = ""

RunService.RenderStepped:Connect(function()
    char:WaitForChild("CrossSansBlade"):FindFirstChild("ActualBlade").Color = CosmicGlitcher.MainValues.glitchers[CosmicGlitcher.MainValues.current_glitcher][1]
    char.Humanoid.WalkSpeed = 70
    HealthBar.PName.Text = CosmicGlitcher.MainValues.current_glitcher
    HealthBar.PName.TextColor3 = CosmicGlitcher.MainValues.glitchers[CosmicGlitcher.MainValues.current_glitcher][1]
    player:WaitForChild("TransformationPlaylist", 10)["1"].SoundId = CosmicGlitcher.Assets.music[CosmicGlitcher.MainValues.current_glitcher]
    player:WaitForChild("TransformationPlaylist", 10)["1"].Volume = 1.2
end)

-- [[ Glitchers ]] --
repeat
    local BettyProj = { { getPass(), "Move1", "Spawn" } }
    BettyMoves:InvokeServer(unpack(BettyProj))
    task.wait(.3)
until CosmicGlitcher.MainValues.stocked >= 6

local currentWingsFolder = nil
local usedSlashes = {}
local slashState = {}
local activeThreads = {}
local alreadyUsedThisSetup = {}

local function clearOldWings()
	if currentWingsFolder then
		currentWingsFolder:Destroy()
		currentWingsFolder = nil
	end
	for slash, state in pairs(slashState) do
		state.running = false
		if slash and slash.Parent then
			slash.Anchored = true
			if not table.find(usedSlashes, slash) then
				table.insert(usedSlashes, slash)
			end
		end
	end
	table.clear(activeThreads)
	table.clear(alreadyUsedThisSetup)
end

local function fetchOrCreateSlash()
	for i, v in ipairs(usedSlashes) do
		if v and v.Parent and not alreadyUsedThisSetup[v] then
			alreadyUsedThisSetup[v] = true
			v.Transparency = 0
			v.Anchored = false
			return v
		end
	end
	for _, obj in char:WaitForChild("Attacks"):GetChildren() do
		if obj.Name:match("^Cosmic_Slash%d+$") and not obj:GetAttribute("Used") and not alreadyUsedThisSetup[obj] then
			obj:SetAttribute("Used", true)
			alreadyUsedThisSetup[obj] = true
			obj.Anchored = false
			return obj
		end
	end
	return nil
end

local function glitcherDialogue(glitcher)
	if glitcher == "Mayhem" then
		Players:Chat(" Mayhem *\nEnough is enough...")
	elseif glitcher == "Purity" then
		Players:Chat(" Purity *\nThey deserve a second chance.")
	elseif glitcher == "Corruption" then
		Players:Chat(" Corruption *\nLet's rot them from the inside.")
    elseif glitcher == "Death" then
        Players:Chat(" Death *\nI am everywhere\nYou can't escape from me.")
	elseif glitcher == "Void" then
		Players:Chat(" Void *\nNothing will remain.")
	elseif glitcher == "Anomaly" then
		Players:Chat(" Anomaly *\nReality bends. I don’t.")
	elseif glitcher == "Rage" then
		Players:Chat(" Rage *\nYOU DARE DEFY ME?!")
	elseif glitcher == "Silence" then
		Players:Chat(" Silence *\n...")
	end
end

char.Head.ChildAdded:Connect(function(child)
	if child.Name == "TextBar" then
		local conn
		conn = RunService.RenderStepped:Connect(function()
			if not child or not child.Parent then
				conn:Disconnect()
				return
			end
			child.TextLabel.TextColor3 = CosmicGlitcher.MainValues.glitchers[CosmicGlitcher.MainValues.current_glitcher][1]
		end)
	end
end)

local function setupWings(glitcher)
	clearOldWings()
    glitcherDialogue(glitcher)
    player.Backpack:WaitForChild("Main").BettyMoves.Animations.Walk.AnimationId = CosmicGlitcher.MainValues.glitchers[CosmicGlitcher.MainValues.current_glitcher][2]["Walk"]
    player.Backpack:WaitForChild("Main").BettyMoves.Animations.Walk2.AnimationId = CosmicGlitcher.MainValues.glitchers[CosmicGlitcher.MainValues.current_glitcher][2]["Walk"]
    player.Backpack:WaitForChild("Main").BettyMoves.Animations.Walk3.AnimationId = CosmicGlitcher.MainValues.glitchers[CosmicGlitcher.MainValues.current_glitcher][2]["Walk"]
    player.Backpack:WaitForChild("Main").BettyMoves.Animations.Idle.AnimationId = CosmicGlitcher.MainValues.glitchers[CosmicGlitcher.MainValues.current_glitcher][2]["Idle"]
    player.Backpack:WaitForChild("Main").BettyMoves.Animations.Idle2.AnimationId = CosmicGlitcher.MainValues.glitchers[CosmicGlitcher.MainValues.current_glitcher][2]["Idle"]
    player.Backpack:WaitForChild("Main").BettyMoves.Animations.Idle3.AnimationId = CosmicGlitcher.MainValues.glitchers[CosmicGlitcher.MainValues.current_glitcher][2]["Idle"]
    player.Backpack:WaitForChild("Main").BettyMoves.Animations.Run.AnimationId = CosmicGlitcher.MainValues.glitchers[CosmicGlitcher.MainValues.current_glitcher][2]["Run"]
    player.Backpack:WaitForChild("Main").BettyMoves.Animations.Run2.AnimationId = CosmicGlitcher.MainValues.glitchers[CosmicGlitcher.MainValues.current_glitcher][2]["Run"]
    player.Backpack:WaitForChild("Main").BettyMoves.Animations.Run3.AnimationId = CosmicGlitcher.MainValues.glitchers[CosmicGlitcher.MainValues.current_glitcher][2]["Run"]
    
	local Cos_Wings = game:GetObjects(CosmicGlitcher.Assets.models.Cosmic_Wings)[1]
	Cos_Wings.Parent = ReplicatedStorage
	local initial = Cos_Wings:WaitForChild(glitcher)
	local WingsFolder = initial:WaitForChild("Attacks"):Clone()
	WingsFolder.Name = glitcher .. " Wings"
	WingsFolder.Parent = char
	currentWingsFolder = WingsFolder
	CosmicGlitcher.MainValues.used = 0

	for _, wing in WingsFolder:GetChildren() do
		local weld = wing:WaitForChild("Weld")
		weld.Part0 = char:WaitForChild("Torso")
		local slash = fetchOrCreateSlash()
		if slash then
			CosmicGlitcher.MainValues.used += 1
			wing.Color = CosmicGlitcher.MainValues.glitchers[glitcher][1]
			local offsetSeed = math.random() * math.pi * 2
			local state = { running = true }
			slashState[slash] = state
			local thread = task.spawn(function()
				while state.running and slash and slash.Parent and wing and wing.Parent do
					local t = tick()
					local x = math.sin(t * 8 + offsetSeed) * 0.05
					local y = math.cos(t * 10 + offsetSeed) * 0.05
					local z = math.sin(t * 6 + offsetSeed) * 0.05
					slash.CFrame = wing.CFrame * CFrame.new(x, y, z)
					task.wait()
				end
				if slash and slash.Parent and not table.find(usedSlashes, slash) then
					slash.Anchored = true
					table.insert(usedSlashes, slash)
				end
			end)
			table.insert(activeThreads, thread)
		end
	end
end

setupWings(CosmicGlitcher.MainValues.current_glitcher)

-- [[ Betty Buffs ]] --
local function changeValue(data) 
    local args = {
        {
            getPass(),
            "Move1",
            "Hit",
            {
                ["Hitted"] = data
            },
            CFrame.new(0, 10^10, 0)
        }
    }
    BettyMoves:InvokeServer(unpack(args))
end

RunService.RenderStepped:Connect(function()
    changeValue(char.Data.Blocking)
    changeValue(char.Data.PerfectBlocking)
    changeValue(char.Hate)
    changeValue(char.SoulsTaken)
end)

-- [[ Block Attacks and ect ]] --
task.spawn(function()
    local keys={Enum.KeyCode.Zero,Enum.KeyCode.One,Enum.KeyCode.Two,Enum.KeyCode.Three,Enum.KeyCode.Four,Enum.KeyCode.Five,Enum.KeyCode.Six,Enum.KeyCode.Seven,Enum.KeyCode.Eight,Enum.KeyCode.Nine,Enum.KeyCode.Q,Enum.KeyCode.E,Enum.KeyCode.R}
    getgenv().KeyActions=getgenv().KeyActions or {}
    local function h(i,p)
        if not p and i.UserInputType==Enum.UserInputType.Keyboard then
            local f=getgenv().KeyActions[i.KeyCode]
            if f then f(i) end
        end
    end
    UIS.InputBegan:Connect(h)
    CAS:BindActionAtPriority("BlockKeys",function(_,s,i)
        if s==Enum.UserInputState.Begin then h(i,false) end
        return Enum.ContextActionResult.Sink
    end,false,Enum.ContextActionPriority.High.Value,table.unpack(keys))
end)

-- [[ Controls stuff ]] --
getgenv().KeyActions[Enum.KeyCode.R] = function()
	local lockOn = player.Backpack:WaitForChild("Main"):WaitForChild("LockOnScript"):WaitForChild("LockOn")
	if not lockOn.Value then
		local mouse = game.Players.LocalPlayer:GetMouse()
		local cfr = mouse.Hit
		char:SetPrimaryPartCFrame(cfr * CFrame.new(0, 2, 0))
	else
		local target = lockOn.Value
		char:SetPrimaryPartCFrame(target:GetPrimaryPartCFrame() * CFrame.new(0, 0, 3))
	end
end

local orderlist_glitchers = {
    [1] = "Mayhem",
    [2] = "Purity",
    [3] = "Corruption",
    [4] = "Death"
}

local orderlist_glitchers_index = 1

getgenv().KeyActions[Enum.KeyCode.Q] = function()
	orderlist_glitchers_index -= 1
	if orderlist_glitchers_index < 1 then
		orderlist_glitchers_index = #orderlist_glitchers
	end
	local g = orderlist_glitchers[orderlist_glitchers_index]
	if CosmicGlitcher.MainValues.current_glitcher ~= g then
		CosmicGlitcher.MainValues.current_glitcher = g
		setupWings(g)
	end
end

getgenv().KeyActions[Enum.KeyCode.E] = function()
	orderlist_glitchers_index += 1
	if orderlist_glitchers_index > #orderlist_glitchers then
		orderlist_glitchers_index = 1
	end
	local g = orderlist_glitchers[orderlist_glitchers_index]
	if CosmicGlitcher.MainValues.current_glitcher ~= g then
		CosmicGlitcher.MainValues.current_glitcher = g
		setupWings(g)
	end
end

getgenv().KeyActions[Enum.KeyCode.One] = function()
    for i=1,20 do
        local args = {
        {
            getPass(),
            "Move1",
            "Hit",
            {
                Hitted = { player.Backpack:WaitForChild("Main"):WaitForChild("LockOnScript"):WaitForChild("LockOn").Value }
            },
            CFrame.new(player.Backpack:WaitForChild("Main"):WaitForChild("LockOnScript"):WaitForChild("LockOn").Value.Torso.Position),
            {
                Parent = workspace,
                Material = Enum.Material.Plastic,
                Color = Color3.new(1, 1, 1),
                Transparency = 1
            },
            nil,
            nil,
            nil,
            "AllowedRemote"
        }
    }
        BettyMoves:InvokeServer(unpack(args))
    end
end

getgenv().KeyActions[Enum.KeyCode.Two] = function()
    BettyMoves:InvokeServer({getPass(), "Rhabdophobia" })
    remotes.FacelessMoves:InvokeServer({getPass(), "GuardBreak", "Hit"})
end

getgenv().KeyActions[Enum.KeyCode.Three] = function()
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local direction = root.CFrame.LookVector
	local origin = root.Position
	local targetPos = origin + (direction * 50)

	local lockOnTarget = player.Backpack:WaitForChild("Main"):WaitForChild("LockOnScript"):WaitForChild("LockOn").Value
	if not lockOnTarget then return end

    local animation1 = Instance.new("Animation")
    animation1.AnimationId = "rbxassetid://9522665233"
    local anim1 = char.Humanoid:LoadAnimation(animation1)
    anim1:Play()
    anim1:AdjustSpeed(1)
    task.wait(.3)
    remotes.Functions:InvokeServer({ [1] = getPass(), [2] = "PlaySound", [3] = ReplicatedStorage.Objects.Moves.Kamehameha.Sound.Fire, [4] = char.Head })

	for ia=1,4 do
        for i = 1, 20 do
		    task.spawn(function()
                local stepPos = origin + direction * (i * (200 / 20))

		        local args = {
		        	{
		        		getPass(),
		        		"Move1",
		        		"Hit",
		        		{
		        			Hitted = { lockOnTarget }
		        		},
		        		CFrame.new(stepPos),
		        		{
		        			Parent = workspace,
		        			Material = Enum.Material.Plastic,
		        			Color = Color3.new(1, 1, 1),
		        			Transparency = 1
		        		},
		        		nil,
		        		nil,
		        		nil,
		        		"AllowedRemote"
		        	}
		        }
		        BettyMoves:InvokeServer(unpack(args))
                task.wait(1)
            end)
	    end
        task.wait(.5)
    end
end
