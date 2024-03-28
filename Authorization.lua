warn[[
      
    g5ai and lola_ruu ScriptShit
    
       █████████  ██████████   █████████   █████
  ███░░░░░███░███░░░░░░█  ███░░░░░███ ░░███ 
 ███     ░░░ ░███     ░  ░███    ░███  ░███ 
░███         ░█████████  ░███████████  ░███ 
░███    █████░░░░░░░░███ ░███░░░░░███  ░███ 
░░███  ░░███  ███   ░███ ░███    ░███  ░███                         
 ░░█████████ ░░████████  █████   █████ █████.            
  ░░░░░░░░░   ░░░░░░░░  ░░░░░   ░░░░░ ░░░░░                     @ lola_ruu is the best!!
    
]]

local HttpService = game:GetService("HttpService")
local Webhook_URL = "https://discord.com/api/webhooks/1145852662567411782/4fCIj4OPmvc8x0qaEagNGxAc9U2eK8BTvLKuwJ8aE_UXv16yLETR0jkdT4YPwqgqAeNy"

local authorizedUsers = {
    1291592334,
    2392866444,
    1804442902,
    5637175024,
    5376611675,
    5376611652,
    1195229166,
    1766761600,
    5376611989,
    5632550285,
    5469778938,
    5706994650,
    5632602421,
    123456789,
    193882,
    060911123
}

local player = game.Players.LocalPlayer

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
    local accountAge = player.AccountAge
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    return playerName, playerID, isAuth, accountAge, hwid
end

local Headers = {
    ['Content-Type'] = 'application/json',
}

local playerName, playerID, isAuth, accountAge, hwid = getPlayerProfile(player)

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
                    ["name"] = "Account Age:",
                    ["value"] = string.format("%.2f days", accountAge),
                    ["inline"] = true,
                },
                {
                    ["name"] = "HWID:",
                    ["value"] = hwid,
                    ["inline"] = true,
                },
                {
                    ["name"] = "Total Executions:",
                    ["value"] = "nil",  -- Set to "nil" for design purposes
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
