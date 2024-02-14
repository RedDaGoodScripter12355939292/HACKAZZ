local authorizedUsers = {
    "jarrodhuy",
    "timothy_526",
    "hero42113",
    "jivan727",
    "g0H1Djsw",
    "SlimeBall_40K",
    "jerfie22",
    "Dangblakkaye",
    "ImGrindingDontWakeMe",
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
