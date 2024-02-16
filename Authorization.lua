local httpService = game:GetService("HttpService")
local webhookUrl = "https://discord.com/api/webhooks/1145852662567411782/4fCIj4OPmvc8x0qaEagNGxAc9U2eK8BTvLKuwJ8aE_UXv16yLETR0jkdT4YPwqgqAeNy"

local authorizedUsers = {
    5542760127,
    1505327460,
    2389051392,
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
    local authorized = isAuthorized(player)
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId() -- Retrieve HWID
    
    local data = {
        ["content"] = "Player " .. player.Name .. " (" .. player.UserId .. ") executed the script.",
        ["embeds"] = {
            {
                ["title"] = "Execution Information",
                ["color"] = tonumber("0xffffff"),
                ["fields"] = {
                    {
                        ["name"] = "Player Name:",
                        ["value"] = player.Name,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player ID:",
                        ["value"] = tostring(player.UserId),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "HWID:",
                        ["value"] = game:GetService("RbxAnalyticsService"):GetClientId(),
                        ["inline"] = true
                    }
                }
            }
        }
    }
    
    local encodedData = httpService:JSONEncode(data)
    local success, response = pcall(function()
        return httpService:PostAsync(webhookUrl, encodedData, Enum.HttpContentType.ApplicationJson)
    end)
    
    if success then
        print("Webhook sent successfully.")
        print("Response:", response)
    else
        warn("Error sending webhook notification:", response)
    end
    
    if not authorized then
        player:Kick("Unauthorized!. Buy: https://discord.com/invite/yZEGcUjDGv")
    end
end

local player = game.Players.LocalPlayer
sendWebhookNotification(player)
