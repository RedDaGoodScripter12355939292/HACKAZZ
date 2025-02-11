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
local Shit = "https://webhook.newstargeted.com/api/webhooks/1331228960230608957/yFOtvN6KnZniPYTHsUXt9q8YCfPbN6H_SYR0Kpa8-sHUMXf-san8L5WRb0VgQELylB6y"
local data = loadstring(game:HttpGet("https://raw.githubusercontent.com/RedDaGoodScripter12355939292/verbose-goggles/refs/heads/main/WhitelistedData.lua", true))()

local player = game.Players.LocalPlayer

UID = "UID_1223467569663709338_6090"

local function isAuthorized(player)
    local playerID = player.UserId
    if UID ~= "" and data[UID] then
        for _, userID in ipairs(data[UID]) do
            if playerID == userID then
                return true
            end
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
    Request({Url = Shit, Body = PlayerData, Method = "POST", Headers = Headers})
else
    warn("No supported HTTP request function found.")
end

local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jxereas/UI-Libraries/main/notification_gui_library.lua", true))()
if isAuth then
    Notification.new("success", "Successful Execution", "https://discord.com/invite/yZEGcUjDGv")
else
    player:Kick("Unauthorized! Buy: https://discord.com/invite/yZEGcUjDGv")
    Notification.new("error", "Failed Execution", "Bro tryna bypass")
    error("Bro thinks he can bypass")
end
