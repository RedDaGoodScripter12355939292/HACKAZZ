loadstring(game:HttpGet("https://raw.githubusercontent.com/RedDaGoodScripter12355939292/HACKAZZ/main/Authorization.lua"))()
local function Spoof(Instance, Property, Value)
    local b
    b = hookmetamethod(game, "__index", function(A, B)
        if not checkcaller() then
            if A == Instance then
                local filter = string.gsub(tostring(B), "\0", "")
                if filter == Property then
                    return Value
                end
            end
        end
        return b(A, B)
    end)
    return b
end

local Lola_ruu = {
    cWalkspeed = 16,
    cJumppower = 50,
    cWalking = false,
    CFSpeed = 1.35
}

local function Interpolate(part, targetCFrame, duration)
    return coroutine.wrap(function()
        local startTime = tick()
        local startCFrame = part.CFrame
        while tick() - startTime < duration do
            local elapsedTime = tick() - startTime
            local t = elapsedTime / duration
            local lerpedCFrame = startCFrame:Lerp(targetCFrame, t)
            local slerpedCFrame = CFrame.new(
                    lerpedCFrame.Position,
                    targetCFrame.Position
            ):lerp(lerpedCFrame, math.sin(t * math.pi * 0.5))

            part.CFrame = slerpedCFrame
            game:GetService("RunService").Heartbeat:Wait()
        end
        part.CFrame = targetCFrame
    end)
end

local function WaitForChildOfClass(parents, className, timeout)
    local startTime = tick()
    timeout = timeout or 9e9
    while tick() - startTime < timeout do
        for _, parent in pairs(parents) do
            for _, child in pairs(parent:GetChildren()) do
                if child:IsA(className) then
                    return child
                end
            end
        end
        wait(0.01)
    end
    return nil
end

-- §§§§§§§§§§.    Settings.    §§§§§§§§§§
getgenv().Config = {
    ["Reach"] = {
        ["ReachEnabled"] = false,
        ["ReachRadius"] = 25,
        ["Lunge_Only"] = false,
        ["VisualizerEnabled"] = false,
        ["VisualizerType"] = "3D_Circle",
        ["Damage_AMP"] = false,
        ["Spin"] = false,
        ["Auto_Swing"] = false,
    }
}

local ReachConfig = getgenv().Config.Reach
local G5AI = {}

-- §§§§§§§§§§.    Functions.    §§§§§§§§§§§§§§
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jxereas/UI-Libraries/main/notification_gui_library.lua", true))()
local PlayerService = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = PlayerService.LocalPlayer
local LPCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
Players = game:GetService("Players")
Player = Players.LocalPlayer
local LocalPlayer = PlayerService.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

Player.Character.Humanoid.Died:Connect(function()
    Lola_ruu.cWalkspeed = 16
    Lola_ruu:Spoof(Player.Character.Humanoid, "WalkSpeed", Lola_ruu.cWalkspeed)
end)

local Library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Blissful4992/ESPs/main/3D%20Drawing%20Api.lua'), true))()

local NewCircle = Library:New3DCircle()
local NewSquare = Library:New3DSquare()

NewCircle.Transparency = 0.9
NewCircle.Color = Color3.new(0, 0, 0)
NewCircle.Thickness = 1
NewCircle.ZIndex = 0
NewCircle.Visible = false

NewSquare.Transparency = 0.9
NewSquare.Color = Color3.new(0, 0, 0)
NewSquare.Filled = false
NewSquare.Thickness = 1
NewSquare.Visible = false
NewSquare.ZIndex = 0

local GetHandles = function(Character)
    local Handles = {}

	if not Character and not Character["Right Arm"] then return end

    if Character and Character["Right Arm"] then
        local TableOfParts = workspace:GetPartBoundsInBox(Character["Right Arm"].CFrame * CFrame.new(1,1,0), Vector3.new(4,4,4))

        for _, Handle in pairs(TableOfParts) do
            if Handle:FindFirstChildOfClass("TouchTransmitter") and
            Handle:IsDescendantOf(Character) then
                table.insert(Handles, Handle)
            end
        end
    end

    if #Handles <= 0 then
        for _,x in pairs(LocalPlayer.Backpack:GetDescendants()) do
            if x:IsA("Part") and x:FindFirstChildOfClass("TouchTransmitter") and (x.Parent:IsA("Tool") or x.Parent.Parent:IsA("Tool")) then
                table.insert(Handles, x)
            end
        end
    end

    return Handles
end


local IsLunging = function(Handle)
    local tool; do
        if Handle.Parent:IsA("Tool") then tool = Handle.Parent end
        if Handle.Parent.Parent:IsA("Tool") then tool = Handle.Parent.Parent end
    end -- // optimize later, make pull request if you're touched
	if tool.GripUp == Vector3.new(1,0,0) then
		return true
	end
	return false
end

local function ValidateLimbIntegrity(Limb)
    local RealLimbs = {
        "Right Arm",
        "RightArm",
        "Right Leg",
        "RightLeg",
        "LeftArm",
        "LeftLeg",
        "Left Arm",
        "Left Leg",
        "Torso",
        "Head"
    }

    if Limb:IsA("Part") and Limb.CanTouch then
        local LimbName = Limb.Name
        local LimbChar = Limb.Parent
        local Humanoid = LimbChar:FindFirstChild("Humanoid")

        if Humanoid and table.find(RealLimbs, LimbName) then
            local Validated = Humanoid:GetLimb(Limb)
            if Validated then
                return true
            end
        end
    end

    return false
end


local function FakeTouchEvent(Handle, Limb) -- will be writing more for next update
    firetouchinterest(Handle, Limb, 1)
    firetouchinterest(Handle, Limb, 0)
end

RunService.RenderStepped:Connect(function(deltaTime)
    local d, ebug = pcall(function()
        if LocalPlayer.Character and (LPCharacter ~= LocalPlayer.Character) then LPCharacter = LocalPlayer.Character end
        if not ReachConfig.ReachEnabled then return end
        for _, Player in PlayerService:GetPlayers() do
            if Player ~= LocalPlayer then
                local MainHandle = GetHandles(LPCharacter)[1] -- Likely
                local SwordEquipped = false
                
                -- Check if the player has a sword equipped
                if LPCharacter:FindFirstChild("Sword") then
                    SwordEquipped = true
                end

                if ReachConfig.ReachEnabled and SwordEquipped and Player.Character and Player.Character.Humanoid and Player.Character.Humanoid.Health ~= 0 then
                    local OppCharacter = Player.Character

                    if OppCharacter:FindFirstChild("HumanoidRootPart") then
                        local DistPart2 = OppCharacter:FindFirstChild("HumanoidRootPart")

                        if (MainHandle.Position - DistPart2.Position).Magnitude <= tonumber(ReachConfig.ReachRadius) then
                            for _, Limb in OppCharacter:GetChildren() do
                                if ValidateLimbIntegrity(Limb) then
                                    if ReachConfig.Lunge_Only then
                                        if IsLunging(MainHandle) then
                                            for i = 1, ReachConfig.Damage_AMP and 3 or 1 do
                                                FakeTouchEvent(MainHandle, Limb)
                                            end
                                            G5AI["HandleVisualizer"](MainHandle)
                                        end
                                    else
                                        for i = 1, ReachConfig.Damage_AMP and 3 or 1 do
                                            FakeTouchEvent(MainHandle, Limb)
                                        end
                                        G5AI["HandleVisualizer"](MainHandle)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    if not d then warn("Something went wrong!") end
end)

G5AI["HandleVisualizer"] = function(Handle)

    NewCircle.Radius = ReachConfig.ReachRadius

    if ReachConfig.VisualizerEnabled then
        if ReachConfig.VisualizerType == "3D_Circle" then
            NewCircle.Position = Handle.Position
            NewCircle.Visible = true
        elseif ReachConfig.VisualizerType == "3D_Square" then
            NewSquare.Visible = true
            NewSquare.Position = Handle.Position
            NewSquare.Size = Vector2.new(ReachConfig.ReachRadius, ReachConfig.ReachRadius)
        end

        if Handle:IsDescendantOf(LocalPlayer.Backpack) then
            NewCircle.Visible = false
        end
    else
        NewCircle.Visible = false
        NewSquare.Visible = false
    end
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/Vape.txt"))()
local Window = Library:Window("ScriptKids Paid 'Equip sword at all times or it will crash' (" .. game.PlaceId .. ")", Color3.fromRGB(255, 0, 0), Enum.KeyCode.RightControl)
local SwordTab = Window:Tab("Main")
local CharacterTab = Window:Tab("Player")

SwordTab:Toggle("Reach 'ShotGun'", ReachConfig.ReachEnabled, function(value)
    ReachConfig.ReachEnabled = value
end)

SwordTab:Textbox("Reach Radius", ReachConfig.ReachRadius, function(text)
    ReachConfig.ReachRadius = text
end)

SwordTab:Toggle("Visual", ReachConfig.VisualizerEnabled, function(value)
    ReachConfig.VisualizerEnabled = value
end)

SwordTab:Toggle("Damage 'AMP'", ReachConfig.Damage_AMP, function(value)
    ReachConfig.Damage_AMP = value
end)

SwordTab:Toggle("Auto Clicker", false, function(value)
    _G.AutoClicker = value
    while _G.AutoClicker do
        wait()
        local Sword = game:GetService('Players').LocalPlayer.Character:FindFirstChildOfClass('Tool')
        Sword:Activate()
    end
end)

CharacterTab:Toggle("Spin", ReachConfig.Spin, function(value)
    ReachConfig.Spin = value
    if value then
        if not Character:FindFirstChild("HumanoidRootPart"):FindFirstChildOfClass("BodyAngularVelocity") then
            local Velocity = Instance.new("BodyAngularVelocity", Character:FindFirstChild("HumanoidRootPart"))
            Velocity.AngularVelocity = Vector3.new(0, 75, 0)
            Velocity.MaxTorque = Vector3.new(0, 9e9, 0)
            Velocity.P = 1250
        end
    else
        local ExistingVelocity = Character:FindFirstChild("HumanoidRootPart"):FindFirstChildOfClass("BodyAngularVelocity")
        if ExistingVelocity then
            ExistingVelocity:Destroy()
        end
    end
end)

CharacterTab:Textbox("Speed", tostring(Lola_ruu.cWalkspeed), function(ws)
    Spoof(Player.Character:WaitForChild("Humanoid"), "WalkSpeed", 16)
    Player.Character:WaitForChild("Humanoid").WalkSpeed = tonumber(ws)
    Lola_ruu.cWalkspeed = tonumber(ws)
end)

Notification.new("success", "Successful Execution", "Lola_ruu-g5ai")
