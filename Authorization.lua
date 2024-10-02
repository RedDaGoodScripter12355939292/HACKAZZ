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
    7300478356,
    4351425906,
    7296785251,
    1856841694,
    7296781146,
    5426514636,
    7269558441,
    1201656207,
    5148135834,
    3458716366,
    5407676263,
    7232739694,
    1937193879,
    3713791320,
    7154133006,
    3652182205,
    5426543104
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
    local executor = identifyexecutor()
    local accountAge = player.AccountAge
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId() or "Unknown"
    return playerName, playerID, isAuth, executor, accountAge, hwid
end

local Headers = {
    ['Content-Type'] = 'application/json',
}

local playerName, playerID, isAuth, executor, accountAge, hwid = getPlayerProfile(player)

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
                    ["name"] = "Executor:",
                    ["value"] = executor,
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
if Request then
    Request({Url = Webhook_URL, Body = PlayerData, Method = "POST", Headers = Headers})
else
    warn("No supported HTTP request function found.")
end

local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jxereas/UI-Libraries/main/notification_gui_library.lua", true))()
if isAuth then
    Notification.new("success", "Successful Execution", "https://discord.com/invite/yZEGcUjDGv")
else
    player:Kick("Unauthorized! Buy: https://discord.com/invite/yZEGcUjDGv")
end
