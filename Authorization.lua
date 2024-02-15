local httpService = game:GetService("HttpService")
local webhookUrl = "https://discord.com/api/webhooks/1145852662567411782/4fCIj4OPmvc8x0qaEagNGxAc9U2eK8BTvLKuwJ8aE_UXv16yLETR0jkdT4YPwqgqAeNy"

local authorizedUsers = {
    4084311717,
    123456789,  -- Add authorized user IDs here
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

local function sendWebhookNotification(player, callback)
    local authorized = isAuthorized(player)
    
    local data = {
        ["content"] = "Player " .. player.Name .. " (" .. player.UserId .. ") executed the script. Authorized: " .. tostring(authorized),
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
    local success, response = pcall(function()
        return httpService:PostAsync(webhookUrl, encodedData, Enum.HttpContentType.ApplicationJson)
    end)
    
    if success then
        print(response)
    else
        warn("Error sending webhook notification:", response)
    end
    
    if not isAuthorized(player) then
        player:Kick("Unauthorized access detected!")
    end
end

local player = game.Players.LocalPlayer
sendWebhookNotification(player)
