local httpService = game:GetService("HttpService")
local webhookUrl = "https://discord.com/api/webhooks/1145852662567411782/4fCIj4OPmvc8x0qaEagNGxAc9U2eK8BTvLKuwJ8aE_UXv16yLETR0jkdT4YPwqgqAeNy"

local authorizedUsers = {
    123456789,
    987654321
}

local function isAuthorized(player)
    local playerID = player.UserId
    for _, userID in ipairs(authorizedUsers) do
        if playerID == userID then
            return true
        end
    end
    return false
end

local function sendWebhookNotification(player)
    local data = {
        ["content"] = "Player " .. player.Name .. " (" .. player.UserId .. ") executed the script",
        ["embeds"] = {
            {
                ["title"] = "Hardware ID:",
                ["color"] = tonumber("0xffffff"),
                ["fields"] = {
                    {
                        ["name"] = "Hardware ID:",
                        ["value"] = game:GetService("RbxAnalyticsService"):GetClientId(),
                        ["inline"] = true
                    }
                }
            }
        }
    }
    
    local encodedData = httpService:JSONEncode(data)
    local response = httpService:PostAsync(webhookUrl, encodedData, Enum.HttpContentType.ApplicationJson)
    
    print(response)
end

local player = game.Players.LocalPlayer
if isAuthorized(player) then
    sendWebhookNotification(player)
else
    player:Kick("Unauthorized!. Buy: https://discord.com/invite/yZEGcUjDGv")
end
