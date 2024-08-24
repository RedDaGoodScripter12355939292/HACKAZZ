-- Load necessary libraries
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jxereas/UI-Libraries/main/notification_gui_library.lua", true))()
local PlayerService = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = PlayerService.LocalPlayer
local LPCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Configuration for reach
getgenv().Config = {
    ["Reach"] = {
        ["ReachEnabled"] = false,
        ["ReachRadius"] = 25,
        ["Lunge_Only"] = true,
        ["Damage_AMP"] = false,
        ["Auto_Swing"] = true,
    }
}

local ReachConfig = getgenv().Config.Reach

-- UI creation
local OpenGui = Instance.new("ScreenGui")
OpenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.3, 0, 0.4, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(230, 200, 255)
frame.BorderColor3 = Color3.new(0, 0, 0)
frame.BorderSizePixel = 4
frame.Parent = OpenGui

local bloodText = Instance.new("TextLabel")
bloodText.Text = "BLOOD REACH"
bloodText.Size = UDim2.new(0, 200, 0, 50)
bloodText.Position = UDim2.new(0.175, 0, 0.01, 0)
bloodText.Parent = frame
bloodText.TextColor3 = Color3.fromRGB(255, 0, 0)
bloodText.BackgroundTransparency = 1

local freeText = Instance.new("TextLabel")
freeText.Text = "(BETA PAID)"
freeText.Size = UDim2.new(0, 200, 0, 50)
freeText.Position = UDim2.new(0.175, 0, 0.1, 0)
freeText.Parent = frame
freeText.TextColor3 = Color3.fromRGB(255, 0, 0)
freeText.BackgroundTransparency = 1

local Radius = Instance.new("TextBox")
Radius.Text = "Reach Radius (Must be a number)"
Radius.Size = UDim2.new(0.5, 0, 0.1, 0)
Radius.Position = UDim2.new(0.25, 0, 0.4, 0)
Radius.Parent = frame

local ReachToggle = Instance.new("TextButton")
ReachToggle.Text = "Reach = false"
ReachToggle.Size = UDim2.new(0.4, 0, 0.15, 0)
ReachToggle.Position = UDim2.new(0.3, 0, 0.6, 0)
ReachToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ReachToggle.Parent = frame
ReachToggle.TextColor3 = Color3.fromRGB(255, 0, 0)

local DAMP = Instance.new("TextButton")
DAMP.Text = "Damage AMP = false"
DAMP.Size = UDim2.new(0.4, 0, 0.15, 0)
DAMP.Position = UDim2.new(0.3, 0, 0.8, 0)
DAMP.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
DAMP.Parent = frame
DAMP.TextColor3 = Color3.fromRGB(255, 0, 0)

local function showMessage(message)
    Radius.Text = message
end

-- Handle drag
local dragging = false
local dragInput
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Overpowered Reach Logic
local function GetHandles(Character)
    local Handles = {}

    if Character and Character:FindFirstChild("Right Arm") then
        local TableOfParts = workspace:GetPartBoundsInBox(Character["Right Arm"].CFrame * CFrame.new(1,1,0), Vector3.new(4,4,4))

        for _, Handle in pairs(TableOfParts) do
            if Handle:FindFirstChildOfClass("TouchTransmitter") and Handle:IsDescendantOf(Character) then
                table.insert(Handles, Handle)
            end
        end
    end

    if #Handles <= 0 then
        for _, x in pairs(LocalPlayer.Backpack:GetDescendants()) do
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

local function FakeTouchEvent(Handle, Limb)
    for _ = 1, ReachConfig.Damage_AMP and 3 or 1 do
        firetouchinterest(Handle, Limb, 1)
        firetouchinterest(Handle, Limb, 0)
    end
end

RunService.RenderStepped:Connect(function(deltaTime)
    local success, errorMessage = pcall(function()
        -- Update character reference if needed
        if LocalPlayer.Character and (LPCharacter ~= LocalPlayer.Character) then
            LPCharacter = LocalPlayer.Character
        end

        if not ReachConfig.ReachEnabled then return end

        -- Check for players in the game
        for _, Player in PlayerService:GetPlayers() do
            if Player ~= LocalPlayer then
                local MainHandle = GetHandles(LPCharacter)[1] -- Get the handle
                local SwordEquipped = LPCharacter:FindFirstChild("Sword") ~= nil -- Check if sword is equipped

                -- Validate conditions for applying reach
                if SwordEquipped and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    local OppCharacter = Player.Character
                    local Humanoid = OppCharacter:FindFirstChildOfClass("Humanoid")

                    if Humanoid and Humanoid.Health > 0 then
                        local TargetPosition = OppCharacter:FindFirstChild("HumanoidRootPart").Position

                        -- §Check if the target is within reach radius§
                        if (MainHandle.Position - TargetPosition).Magnitude <= tonumber(ReachConfig.ReachRadius) then
                            for _, Limb in pairs(OppCharacter:GetChildren()) do
                                if ValidateLimbIntegrity(Limb) then
                                    -- §§§§§§§§§§§§§§
                                    local function applyDamage()
                                        for i = 1, ReachConfig.Damage_AMP and 3 or 1 do
                                            FakeTouchEvent(MainHandle, Limb)
                                        end
                                    end

                                    if ReachConfig.Lunge_Only then
                                        if IsLunging(MainHandle) then
                                            applyDamage()
                                        end
                                    else
                                        applyDamage()
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    -- Handle any potential errors
    if not success then
        warn(errorMessage)
    end
end)

local function toggleReach()
    ReachConfig.ReachEnabled = not ReachConfig.ReachEnabled
    ReachToggle.Text = ReachConfig.ReachEnabled and "Reach = true" or "Reach = false"
    ReachToggle.TextColor3 = ReachConfig.ReachEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end

local function updateReachRadius()
    local radiusValue = tonumber(Radius.Text)
    if radiusValue then
        ReachConfig.ReachRadius = radiusValue
    else
        showMessage("Please enter a valid number for Reach Radius.")
    end
end

local function toggleDamageAMP()
    ReachConfig.Damage_AMP = not ReachConfig.Damage_AMP
    DAMP.Text = ReachConfig.Damage_AMP and "Damage AMP = true" or "Damage AMP = false"
    DAMP.TextColor3 = ReachConfig.Damage_AMP and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end

Radius.FocusLost:Connect(updateReachRadius)
ReachToggle.MouseButton1Click:Connect(toggleReach)
DAMP.MouseButton1Click:Connect(toggleDamageAMP)

Notification.new("success", "Successful Execution", "Lola_ruu-g5ai")
