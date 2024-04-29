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
local Webhook_URL = "https://discord.com/api/webhooks/1223593819547766814/ssVKh18Wpm1E_Xy1jbNxO_SCqNq4Yu4Xqi9WDk6odGtySEhrWiOnEGDTYRwr9IiEqTzq"

local authorizedUsers = {
    4222364446,
    5475540686,
    5475519518,
    3394583438,
    5218513911,
    5376774101,
    5376626434,
    5390673672,
    5376630371,
    5376627221,
    3369698737,
    5376616578,
    5376624020,
    5299728616,
    3802335551,
    5376621793,
    604974276,
    1804442902,
    4977117812,
    5376615148,
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
