getgenv().Config = {
    Enabled = false,
    ScaleReach = {
        X = 0,
        Y = 0,
        Z = 0.4
    },

    Speed = {
        Enabled = false,
        Power = 35
    },

    Closet = {
        Lunge_Only = false
    },
    
    Visualizer = {
        Enabled = true,
        Visible = false
    },
    
    Keybinds = {
        Increase = "e",
        Descrease = "r",
        Toggle = "z",
        Visibility = "t",
        Speed_Toggle = "u"
    },

    Options = {
        Increment = {
            X = 0,
            Y = 0,
            Z = 0.3
        },
        Decrement = {
            X = 0,
            Y = 0,
            Z = 0.3
        }
    }
}

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/Vape.txt"))()
local Window = Library:Window("ScriptKids BETA 'Equip sword at all times or it will crash' (" .. game.PlaceId .. ")", Color3.fromRGB(255, 0, 0), Enum.KeyCode.RightControl)
local SwordTab = Window:Tab("Main")
local CharacterTab = Window:Tab("Player")

SwordTab:Toggle("Classified Reach", Config.Enabled, function(value)
    Config.Enabled = value
end)

SwordTab:Textbox("X", tostring(Config.ScaleReach.X), function(text)
    Config.ScaleReach.X = tonumber(text)
end)

SwordTab:Textbox("Y", tostring(Config.ScaleReach.Y), function(text)
    Config.ScaleReach.Y = tonumber(text)
end

SwordTab:Textbox("Z", tostring(Config.ScaleReach.Z), function(text)
    Config.ScaleReach.Z = tonumber(text)
end)

SwordTab:Toggle("Closet (Lunge_Only)", Config.Closet.Lunge_Only, function(value)
    Config.Closet.Lunge_Only = value
end)

SwordTab:Toggle("Visualizer", Config.Visualizer.Visible, function(value)
    Config.Visualizer.Visible = value
end)

CharacterTab:Toggle("Speed Keybind 'u' ", Config.Speed.Enabled, function(value)
    Config.Speed.Enabled = value
end)

SwordTab:Textbox("Speed Level", tostring(Config.Speed.Power), function(text)
    Config.Speed.Power = tonumber(text)
end
loadstring(game:HttpGet("https://raw.githubusercontent.com/RedDaGoodScripter12355939292/HACKAZZ/main/ClassifiedProject.lua"))()
