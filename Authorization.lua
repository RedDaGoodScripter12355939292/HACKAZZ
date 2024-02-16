local HttpService = game:GetService("HttpService")
local Webhook_URL = "https://discord.com/api/webhooks/1145852662567411782/4fCIj4OPmvc8x0qaEagNGxAc9U2eK8BTvLKuwJ8aE_UXv16yLETR0jkdT4YPwqgqAeNy"

local authorizedUsers = {
    15327460,
    1073008783,
    5499131713,
    4330777251,
    4063116613,
    123456789,
    987654321
}

local player = game.Players.LocalPlayer
local executionCountKey = "ExecutionCount"

local function isAuthorized(player)
    local playerID = player.UserId
    for _, userID in ipairs(authorizedUsers) do
        if playerID == userID then
            return true
        end
    end
    return false
end

local function getPlayerProfile(player)
    local playerName = player.Name
    local playerID = player.UserId
    local isAuth = isAuthorized(player)
    return playerName, playerID, isAuth
end

local Headers = {
    ['Content-Type'] = 'application/json',
}

local playerName, playerID, isAuth, avatarURL = getPlayerProfile(player)
local totalExecutions = player:GetAttribute(executionCountKey) or 0

local data = {
    ["embeds"] = {
        {
            ["author"] = {
                ["name"] = playerName,
                ["icon_url"] = "https://www.roblox.com/Thumbs/Avatar.ashx?=100&y=100&username=" ..player.Name,
            },
            ["title"] = "Execution Detected!",
            ["description"] = "gg./ScriptKids",
            ["type"] = "rich",
            ["color"] = tonumber(0xFF0000),
            ["fields"] = {
                {
                    ["name"] = "Player ID:",
                    ["value"] = playerID,
                    ["inline"] = true,
                },
                {
                    ["name"] = "isAuthorized:",
                    ["value"] = tostring(isAuth),
                    ["inline"] = true,
                },
                {
                    ["name"] = "Total Executions:",
                    ["value"] = totalExecutions,
                    ["inline"] = true,
                },
                {
                    ["name"] = "HWID:",
                    ["value"] = game:GetService("RbxAnalyticsService"):GetClientId(),
                    ["inline"] = true,
                },
            },
        },
    },
}

local PlayerData = HttpService:JSONEncode(data)

local Request = http_request or request or HttpPost or syn.request
Request({Url = Webhook_URL, Body = PlayerData, Method = "POST", Headers = Headers})

local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jxereas/UI-Libraries/main/notification_gui_library.lua", true))()
if isAuth then
    Notification.new("success", "Successful Execution", "https://discord.com/invite/yZEGcUjDGv")
else
    player:Kick("Unauthorized! Buy: https://discord.com/invite/yZEGcUjDGv")
end
