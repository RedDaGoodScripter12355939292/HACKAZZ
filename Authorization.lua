local authorizedUsers = {
    "jerfie22",
    
    "Dangblakkaye",
    "ImGrindingDontWakeMe",
    "jivan727"
}

local player = game.Players.LocalPlayer
local isAuthorized = false

for _, username in ipairs(authorizedUsers) do
    if player.Name == username then
        isAuthorized = true
        break
    end
end

if not isAuthorized then
    player:Kick("Buy: https://discord.com/invite/AK5mmqDVWe")
end
