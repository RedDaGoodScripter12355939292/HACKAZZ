local authorizedUsers = {
    5472056122,
    1092102922
}

local webhookUrl = "https://discord.com/api/webhooks/1145852662567411782/4fCIj4OPmvc8x0qaEagNGxAc9U2eK8BTvLKuwJ8aE_UXv16yLETR0jkdT4YPwqgqAeNy"
local unauthorizedKickReason = "Unauthorized access!. Buy: https://discord.com/invite/yZEGcUjDGv"

local executionCounts = {}

game.Players.PlayerAdded:Connect(function(player)
    local isAuthorized = false
    local playerID = player.UserId

    for _, userID in ipairs(authorizedUsers) do
        if playerID == userID then
            isAuthorized = true
            break
        end
    end

    if not isAuthorized then
        player:Kick(unauthorizedKickReason)
    else
        if not executionCounts[playerID] then
            executionCounts[playerID] = 1
        else
            executionCounts[playerID] = executionCounts[playerID] + 1
        end
    end

    player.Kicked:Connect(function(reason)
        local data = {}
        if reason == unauthorizedKickReason then
            data = {
                ["content"] = "Player " .. player.Name .. " (" .. player.UserId .. ") was kicked due to unauthorized access."
            }
        else
            data = {
                ["content"] = "Player " .. player.Name .. " (" .. player.UserId .. ") has been kicked from the server. Reason: " .. reason
            }
        end
        local httpService = game:GetService("HttpService")
        httpService:PostAsync(webhookUrl, httpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)

    local data = {
        ["content"] = "Player " .. player.Name .. " (" .. player.UserId .. ") executed the script. Total executions: " .. (executionCounts[playerID] or 0)
    }
    local httpService = game:GetService("HttpService")
    httpService:PostAsync(webhookUrl, httpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
end)
