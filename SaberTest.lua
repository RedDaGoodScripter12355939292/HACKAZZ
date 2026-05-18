loadstring(game:HttpGet("https://raw.githubusercontent.com/AaronScriptz/RobloxScriptz/refs/heads/main/SaberSimulator.lua", true))()
-- ============================================
-- SERVICES & VARIABLES
-- ============================================
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
getgenv().currentFarmingElement = nil
-- ============================================
-- ALL FUNCTIONS
-- ============================================

-- ANTI-AFK FUNCTIONS
function removeIdleConnections()
    if getconnections then
        local connections = getconnections(Players.LocalPlayer.Idled) -- Fixed typo here (was get_signal_cons)
        for _, connection in pairs(connections or {}) do
            if connection.Disable then
                connection:Disable(connection)
            elseif connection.Disconnect then
                connection:Disconnect(connection)
            end
        end
    end
    
    if not getconnections then
        local virtualUser = cloneref(game:GetService("VirtualUser"))
        Players.LocalPlayer.Idled:Connect(function()
            virtualUser:CaptureController()
            virtualUser:ClickButton2(virtualUser)
        end)
    end
end

function movementAntiAFK()
    spawn(function()
        while getgenv().MovementAntiAFK and task do
            Players.LocalPlayer.PlayerScripts.AutoTimeout.Disabled = true
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, nil)
            task.wait(0.0001)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, nil)
            task.wait(900)
        end
    end)
end

function simulateMovement()
    spawn(function()
        while getgenv().SimulateMovement and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    local direction = getgenv().AntiAFKDirection or "Front then Back"
                    
                    if direction == "Front then Back" then
                        charRoot.CFrame = charRoot.CFrame * CFrame.new(0, 0, -0.5)
                        task.wait(0.1)
                        charRoot.CFrame = charRoot.CFrame * CFrame.new(0, 0, 0.5)
                    elseif direction == "Back then Front" then
                        charRoot.CFrame = charRoot.CFrame * CFrame.new(0, 0, 0.5)
                        task.wait(0.1)
                        charRoot.CFrame = charRoot.CFrame * CFrame.new(0, 0, -0.5)
                    elseif direction == "Left then Right" then
                        charRoot.CFrame = charRoot.CFrame * CFrame.new(-0.5, 0, 0)
                        task.wait(0.1)
                        charRoot.CFrame = charRoot.CFrame * CFrame.new(0.5, 0, 0)
                    elseif direction == "Right then Left" then
                        charRoot.CFrame = charRoot.CFrame * CFrame.new(0.5, 0, 0)
                        task.wait(0.1)
                        charRoot.CFrame = charRoot.CFrame * CFrame.new(-0.5, 0, 0)
                    end
                end
            end
            task.wait(getgenv().AntiAFKInterval or 60)
        end
    end)
end

function simulateClick()
    spawn(function()
        while getgenv().SimulateClick and task do
            UserInputService:Button1Down(0)
            task.wait(0.1)
            UserInputService:Button1Up(0)
            task.wait(getgenv().AntiAFKInterval or 60)
        end
    end)
end

function simulateJump()
    spawn(function()
        while getgenv().SimulateJump and task do
            if Players.LocalPlayer.Character then
                local humanoid = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
            task.wait(getgenv().AntiAFKInterval or 60)
        end
    end)
end

function combinedAntiAFK()
    spawn(function()
        local lastActionTime = 0
        
        while getgenv().CombinedAntiAFK and task do
            local currentTime = tick()
            if currentTime - lastActionTime >= (getgenv().AntiAFKInterval or 60) then
                lastActionTime = currentTime
                
                if getgenv().SimulateClick then
                    UserInputService:Button1Down(0)
                    task.wait(0.1)
                    UserInputService:Button1Up(0)
                end
                
                if getgenv().SimulateMovement and Players.LocalPlayer.Character then
                    local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if charRoot then
                        charRoot.CFrame = charRoot.CFrame * CFrame.new(0, 0, -0.5)
                        task.wait(0.1)
                        charRoot.CFrame = charRoot.CFrame * CFrame.new(0, 0, 0.5)
                    end
                end
                
                if getgenv().SimulateJump and Players.LocalPlayer.Character then
                    local humanoid = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

function getBossData()
    local gameplay = workspace:FindFirstChild("Gameplay")
    if not gameplay then return nil, nil end
    local bossFolder = gameplay:FindFirstChild("Boss")
    if not bossFolder then return nil, nil end
    local bossHolder = bossFolder:FindFirstChild("BossHolder")
    if not bossHolder then return nil, nil end
    local bossModel = bossHolder:FindFirstChildOfClass("Model")
    if not bossModel then return nil, nil end
    local bossRoot = bossModel:FindFirstChild("HumanoidRootPart")
    local bossController = bossModel:FindFirstChildOfClass("Humanoid") or bossModel:FindFirstChildOfClass("AnimationController")
    return bossRoot, bossController
end

-- EGG PRIORITY DATA FOR SMART REPLACEMENT
local EggPriorities = {
    ["SECRET"] = { priority = 4, ids = { "rbxassetid://139781637243765", "rbxassetid://103333899383000" } },
    ["THREE_MOON"] = { priority = 3, ids = { "rbxassetid://87936750091950", "rbxassetid://108817778982252" } },
    ["TWO_MOON"] = { priority = 2, ids = { "rbxassetid://83842678544135", "rbxassetid://135133438925164" } },
    ["ONE_MOON"] = { priority = 1, ids = { "rbxassetid://99262757782431", "rbxassetid://90375810566006" } }
}

local function GetEggPriority(imageId)
    for tierName, tierData in pairs(EggPriorities) do
        for _, id in pairs(tierData.ids) do
            if imageId == id then
                return tierData.priority, tierName
            end
        end
    end
    return 0, "UNKNOWN"
end

-- DUNGEON FUNCTIONS
function autoClaimIncubatedPet()
    task.spawn(function()
        while getgenv().autoClaimIncubated do
            pcall(function()
                local ps = Players.LocalPlayer:FindFirstChild("PlayerScripts")
                if not ps then return end
                local dataManager = require(ps.MainClient.ClientDataManager)
                local dateTimeManager = require(ps.MainClient.DateTimeManager)
                local hatchery = dataManager.Data and dataManager.Data.DungeonHatchery
                if not hatchery then return end
                for slot, data in pairs(hatchery) do
                    if data and data.HatchDT and dateTimeManager:Now() >= data.HatchDT then
                        ReplicatedStorage.Events.UIAction:FireServer("HatchDungeonEgg", slot)
                    end
                end
            end)
            task.wait(1)
        end
    end)
end

function autoJoinDungeon()
    task.spawn(function()
        while getgenv().autoJoinDungeon do
            pcall(function()
                local lp = Players.LocalPlayer
                local isInDungeon = false
                local dungeonStorage = workspace:FindFirstChild("DungeonStorage")
                if dungeonStorage then
                    for _, folder in pairs(dungeonStorage:GetChildren()) do
                        if #folder:GetChildren() > 0 then
                            isInDungeon = true
                            break
                        end
                    end
                end
                
                if not isInDungeon then
                    local dataManager = require(lp.PlayerScripts.MainClient.ClientDataManager)
                    local dateTimeManager = require(lp.PlayerScripts.MainClient.DateTimeManager)
                    local cooldownEnd = dataManager.Data and dataManager.Data.DungeonCooldownEndDT or 0
                    local currentTime = dateTimeManager:Now()
                    
                    if currentTime >= cooldownEnd then
                        local selectedDungeon = getgenv().SelectedDungeon or "Space"
                        local selectedDifficulty = getgenv().SelectedDifficulty or 1
                        ReplicatedStorage.Events.UIAction:FireServer("DungeonGroupAction", "Create", "Public", selectedDungeon, selectedDifficulty)
                        task.wait(1.5)
                        ReplicatedStorage.Events.UIAction:FireServer("DungeonGroupAction", "Start")
                    end
                end
            end)
            task.wait(3)
        end
    end)
end

function autoFarmDungeon()
    task.spawn(function()
        local lp = Players.LocalPlayer
        local savedCFrame = nil

        while getgenv().autoFarmDungeon do
            pcall(function()
                local char = lp.Character
                if not char then return end

                local hum = char:FindFirstChildOfClass("Humanoid")
                local charRoot = char:FindFirstChild("HumanoidRootPart")

                if not hum or not charRoot then return end

                if not savedCFrame then
                    savedCFrame = charRoot.CFrame
                end

                local dungeonStorage = workspace:FindFirstChild("DungeonStorage")
                if not dungeonStorage then return end

                local closest = nil
                local dist = math.huge

                for _, mapFolder in pairs(dungeonStorage:GetChildren()) do
                    local importantFolder = mapFolder:FindFirstChild("Important")
                    if importantFolder then
                        for _, spawner in pairs(importantFolder:GetChildren()) do
                            if spawner:IsA("BasePart") and spawner.Name:lower():find("spawner") then
                                for _, mob in pairs(spawner:GetChildren()) do
                                    if mob:IsA("Model") then
                                        local hrp = mob:FindFirstChild("HumanoidRootPart")
                                        if hrp then
                                            local d = (charRoot.Position - hrp.Position).Magnitude
                                            if d < dist then
                                                dist = d
                                                closest = hrp
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                if closest then
                    local targetPos = closest.Position + Vector3.new(0, getgenv().DunFarmingDistance or 6, 0)
                    hum.AutoRotate = false
                    charRoot.CFrame = CFrame.new(targetPos) * CFrame.Angles(math.rad(-90), 0, 0)
                    charRoot.AssemblyLinearVelocity = Vector3.zero
                end
            end)
            task.wait()
        end

        pcall(function()
            local char = lp.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum then
                hum.AutoRotate = true
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            if hrp then
                hrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 5, 0))
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
        end)
    end)
end

function autoCollectDungeonRewards()
    spawn(function()
        while getgenv().autoDungeonRewards do
            pcall(function()
                local dungeonStorage = workspace:FindFirstChild("DungeonStorage")
                if dungeonStorage then
                    for _, mapFolder in pairs(dungeonStorage:GetChildren()) do
                        for _, desc in pairs(mapFolder:GetDescendants()) do
                            if desc:IsA("ProximityPrompt") and desc.ActionText == "Claim Rewards" and desc.Enabled then
                                if Players.LocalPlayer.Character and desc.Parent and desc.Parent:IsA("BasePart") then
                                    local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    if charRoot then
                                        charRoot.CFrame = desc.Parent.CFrame + Vector3.new(0, 5, 0)
                                        task.wait(0.3)
                                    end
                                end
                                fireproximityprompt(desc)
                            end
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end

function autoIncubateDungeonEgg()
    task.spawn(function()
        while getgenv().autoIncubateDungeonEgg do
            pcall(function()
                local playerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
                if not playerGui then return end
                local mainGui = playerGui:FindFirstChild("MainGui")
                if not mainGui then return end
                local otherFrames = mainGui:FindFirstChild("OtherFrames")
                if not otherFrames then return end

                -- STEP 1: Check if the DungeonRewards UI is visible (We got an egg!)
                local dungeonRewards = otherFrames:FindFirstChild("DungeonRewards")
                if dungeonRewards and dungeonRewards.Visible then
                    local yesBtn = dungeonRewards:FindFirstChild("Frame") 
                        and dungeonRewards.Frame:FindFirstChild("Buttons") 
                        and dungeonRewards.Frame.Buttons:FindFirstChild("Yes") 
                        and dungeonRewards.Frame.Buttons.Yes:FindFirstChild("Button")
                        
                    if yesBtn then
                        firesignal(yesBtn.MouseButton1Click)
                        task.wait(0.5)
                    end
                end

                -- STEP 2: Check if the Replace Popup appeared (Incubator was full)
                local replacePopup = otherFrames:FindFirstChild("EggIncubatorReplacePopup")
                if replacePopup and replacePopup.Visible then
                    local newEggPriority = 0
                    local worstPriority = math.huge
                    local worstEggFrame = nil
                    
                    local itemFrame = replacePopup:FindFirstChild("Frame") and replacePopup.Frame:FindFirstChild("ItemFrame")
                    if itemFrame then
                        for _, slot in pairs(itemFrame:GetChildren()) do
                            if slot:IsA("Frame") and slot:FindFirstChild("ImageLabel") then
                                local priority, _ = GetEggPriority(slot.ImageLabel.Image)
                                local replaceButton = slot:FindFirstChild("Replace")
                                
                                if replaceButton then
                                    if priority < worstPriority then
                                        worstPriority = priority
                                        worstEggFrame = slot
                                    end
                                else
                                    if priority > newEggPriority then
                                        newEggPriority = priority
                                    end
                                end
                            end
                        end
                    end
                    
                    if worstEggFrame and newEggPriority > worstPriority then
                        local replaceButton = worstEggFrame:FindFirstChild("Replace")
                        if replaceButton and replaceButton:FindFirstChild("Button") then
                            firesignal(replaceButton.Button.MouseButton1Click)
                            task.wait(0.2)
                            
                            local popupFrame = otherFrames:FindFirstChild("PopupFrame")
                            if popupFrame and popupFrame.Visible then
                                local yesBtn = popupFrame:FindFirstChild("Frame") and popupFrame.Frame:FindFirstChild("Buttons") and popupFrame.Frame.Buttons:FindFirstChild("Yes") and popupFrame.Frame.Buttons.Yes:FindFirstChild("Button")
                                if yesBtn then
                                    firesignal(yesBtn.MouseButton1Click)
                                    task.wait(0.5)
                                    firesignal(yesBtn.MouseButton1Click)
                                end
                            end
                        end
                    end
                end
            end)
            
            -- NORMAL INCUBATION LOGIC (If there are empty slots)
            local ps = Players.LocalPlayer:FindFirstChild("PlayerScripts")
            if ps then
                local dataManager = require(ps.MainClient.ClientDataManager)
                local hatchery = dataManager.Data and dataManager.Data.DungeonHatchery
                if hatchery then
                    for slot, data in pairs(hatchery) do
                        if data and data.CanIncubate then
                            ReplicatedStorage.Events.UIAction:FireServer("IncubateDungeonEgg", slot)
                        end
                    end
                end
            end
            
            task.wait(1)
        end
    end)
end

-- MAIN FUNCTIONS
function autoSwing()
    spawn(function()
        local clientTool = require(Players.LocalPlayer.PlayerScripts.MainClient.ClientTool)
        while getgenv().autoSwing and task do
            if Players.LocalPlayer.Character then
                local humanoid = Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local tool = Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("RemoteClick") then
                        clientTool:Swing()
                    end
                    local backpackTool = Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                    if tool and backpackTool then
                        humanoid:EquipTool(backpackTool)
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end

function autoCollectCrowns()
    spawn(function()
        while getgenv().autoCrowns and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    for _, pickup in pairs(workspace.Gameplay.CurrencyPickup.CurrencyHolder:GetChildren()) do
                        if pickup.Transparency == 0 and pickup.Name == "Crown" then
                            pickup.CFrame = charRoot.CFrame
                            pickup.Anchored = true
                        end
                    end
                end
            end
            task.wait(0.3)
        end
    end)
end

function autoSellDNA()
    spawn(function()
        while getgenv().autoSellDNA and task do
            ReplicatedStorage.Events.SellStrength:FireServer()
            task.wait(0.2)
        end
    end)
end

function autoCollectDaily()
    spawn(function()
        while getgenv().autoCollectDaily and task do
            local dataManager = require(Players.LocalPlayer.PlayerScripts.MainClient.ClientDataManager)
            local hasVIP = table.find(dataManager.Data.Passes, "VIP") ~= nil
            local dailyGUI = workspace.Gameplay.Locations.DailyReward.BillboardGui
            if dailyGUI and dailyGUI.Frame and dailyGUI.Frame.Desc and dailyGUI.Frame.Desc.Text then
                local descText = dailyGUI.Frame.Desc.Text
                if not (descText:match("%d+[hH]") or descText:match("%d+[mM]") or descText:match("%d+[sS]") or descText:match("%d+:%d+") or descText:match("%d+:%d+:%d+")) then
                    ReplicatedStorage.Events.UIAction:FireServer("ClaimDailyReward")
                    ReplicatedStorage.Events.UIAction:FireServer("ClaimDailyTimedReward")
                    if hasVIP then
                        ReplicatedStorage.Events.UIAction:FireServer("ClaimVIPDailyReward")
                    end
                end
            end
            task.wait(1)
        end
    end)
end

function autoTeleportToBoss()
    task.spawn(function()
        while getgenv().autoTeleportToBoss do
            pcall(function()
                local char = Players.LocalPlayer.Character
                if not char then return end
                local charRoot = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if not charRoot or not humanoid then return end
                local bossRoot = getBossData()
                if bossRoot then
                    local newCFrame = CFrame.new(
                        bossRoot.Position.X,
                        bossRoot.Position.Y - bossRoot.Size.Y / 2 + humanoid.HipHeight + charRoot.Size.Y / 2 + 0.1,
                        bossRoot.Position.Z
                    )
                    charRoot.CFrame = newCFrame
                    humanoid:MoveTo(bossRoot.Position)
                end
            end)
            task.wait()
        end
    end)
end

function autoWalkBossPremium()
    task.spawn(function()
        local randomDistance = math.random(4, 8)
        while getgenv().autoWalkBossPremium do
            pcall(function()
                local char = Players.LocalPlayer.Character
                if not char then return end
                local charRoot = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if not charRoot or not humanoid then return end
                local bossRoot = getBossData()
                if bossRoot then
                    getgenv().BossKillerPremWlkAlive = true
                    local distance = (Vector3.new(charRoot.Position.X, 0, charRoot.Position.Z) - Vector3.new(bossRoot.Position.X, 0, bossRoot.Position.Z)).Magnitude
                    if distance > 50 then
                        charRoot.CFrame = bossRoot.CFrame + Vector3.new(0, 3, 0)
                    elseif distance > randomDistance then
                        humanoid:MoveTo(bossRoot.Position)
                    else
                        humanoid:MoveTo(charRoot.Position)
                    end
                else
                    getgenv().BossKillerPremWlkAlive = false
                end
            end)
            task.wait(0.3)
        end
    end)
end

function autoBringBoss()
    task.spawn(function()
        while getgenv().autoBringBoss do
            pcall(function()
                local char = Players.LocalPlayer.Character
                if not char then return end
                local charRoot = char:FindFirstChild("HumanoidRootPart")
                if not charRoot then return end
                local bossRoot = getBossData()
                if bossRoot then
                    local tween = TweenService:Create(bossRoot, TweenInfo.new(0.5), {CFrame = charRoot.CFrame})
                    tween:Play()
                end
            end)
            task.wait()
        end
    end)
end

-- UPGRADES FUNCTIONS
function autoBuySaber()
    spawn(function()
        while getgenv().autoBuySaber and task do
            ReplicatedStorage.Events.UIAction:FireServer("BuyAllWeapons")
            task.wait(1)
        end
    end)
end

function autoBuyDNA()
    spawn(function()
        while getgenv().autoBuyDNA and task do
            ReplicatedStorage.Events.UIAction:FireServer("BuyAllDNAs")
            task.wait(1)
        end
    end)
end

function autoBuyClass()
    spawn(function()
        while getgenv().autoBuyClass and task do
            local dataManager = require(Players.LocalPlayer.PlayerScripts.MainClient.ClientDataManager)
            local itemInfo = require(ReplicatedStorage.Modules.ItemInfo)
            local nextClass = itemInfo.Classes_Order[dataManager.Data.Best_Class_Index + 1]
            if nextClass then
                ReplicatedStorage.Events.UIAction:FireServer("BuyClass", nextClass)
            end
            task.wait(5)
        end
    end)
end

function autoBuyBossDamage()
    spawn(function()
        while getgenv().autoBuyBossDamage and task do
            ReplicatedStorage.Events.UIAction:FireServer("BuyAllBossBoosts")
            task.wait(1)
        end
    end)
end

function autoBuyAura()
    spawn(function()
        while getgenv().autoBuyAura and task do
            ReplicatedStorage.Events.UIAction:FireServer("BuyAllAuras")
            task.wait(1)
        end
    end)
end

function autoBuyPetAura()
    spawn(function()
        while getgenv().autoBuyPetAura and task do
            ReplicatedStorage.Events.UIAction:FireServer("BuyAllPetAuras")
            task.wait(1)
        end
    end)
end

function fetchEggShopList()
    local eggList = {}
    local eggMap = {}
    local succ, shopInfo = pcall(function()
        return require(ReplicatedStorage.Modules.PetsInfo.PetShopInfo)
    end)
    if succ and shopInfo then
        for eggName, eggData in pairs(shopInfo) do
            if type(eggName) == "string" and eggName:find("Egg") then
                table.insert(eggList, eggName)
                eggMap[eggName] = eggName
            end
        end
    end
    if #eggList == 0 then
        local succ2, petsInfo = pcall(function()
            return require(ReplicatedStorage.Modules.PetsInfo)
        end)
        if succ2 and petsInfo and petsInfo.Eggs then
            for eggName, eggData in pairs(petsInfo.Eggs) do
                if type(eggName) == "string" and not eggMap[eggName] then
                    table.insert(eggList, eggName)
                    eggMap[eggName] = eggName
                end
            end
        end
    end
    if #eggList == 0 then
        warn("Dynamic egg extraction failed. Using verified bytecode fallback list.")
        local hardcodedEggs = {
            "Basic Egg", "Wooden Egg", "Reinforced Egg", "Ancient", "Egg of life", 
            "Glory Egg", "Dominus Egg", "Silver Egg", "Golden Egg", "Premium Egg", 
            "Class Egg", "Diamond Egg", "Ruby Egg", "Alpha Egg", "Snow Egg", 
            "Reaper Egg", "Nature Egg", "Winter Egg", "Food Egg", "Fire Egg", 
            "Valk Egg", "Dragon Egg", "Star Egg", "Cow Egg", "Flame Egg", 
            "Water Egg", "Ooga Egg", "Round Egg", "Heart Egg", "Matrix Egg", 
            "Shadow Egg", "Pink Egg", "Candy Egg", "Rushed Egg", "Onetap Egg", 
            "Swag Egg", "Triangle Egg", "Square Egg", "Cringe Egg", "Boris Egg", 
            "Phantom Egg", "Business Egg", "Egg Egg"
        }
        for _, eggName in pairs(hardcodedEggs) do
            table.insert(eggList, eggName)
            eggMap[eggName] = eggName
        end
    end
    return eggList, eggMap
end

function autoOpenEgg()
    spawn(function()
        while getgenv().autoOpenEgg and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local petShopLocation = workspace.Gameplay.Locations:FindFirstChild("PetShop")
                if charRoot and petShopLocation then
                    local horizontalDistance = Vector2.new(charRoot.Position.X - petShopLocation.CFrame.Position.X, charRoot.Position.Z - petShopLocation.CFrame.Position.Z).Magnitude
                    if horizontalDistance > 5 then
                        charRoot.CFrame = petShopLocation.CFrame
                        task.wait(0.15) -- CRITICAL: Wait for server to register your new position!
                    end
                    
                    -- Default to Wooden Egg if no egg is selected
                    local eggToHatch = getgenv().SelectedEggIsHere
                    if not eggToHatch or eggToHatch == "" then
                        eggToHatch = "Wooden Egg"
                    end
                    
                    ReplicatedStorage.Events.UIAction:FireServer("BuyEgg", eggToHatch)
                end
            end
            task.wait(0.1)
        end
    end)
end

function autoCompletePetdex()
    spawn(function()
        while getgenv().autoCompletePetdex and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local petShopLocation = workspace.Gameplay.Locations:FindFirstChild("PetShop")
                if charRoot and petShopLocation then
                    local horizontalDistance = Vector2.new(charRoot.Position.X - petShopLocation.CFrame.Position.X, charRoot.Position.Z - petShopLocation.CFrame.Position.Z).Magnitude
                    if horizontalDistance > 5 then
                        charRoot.CFrame = petShopLocation.CFrame
                    end
                end
            end
            pcall(function()
                local dataManager = require(Players.LocalPlayer.PlayerScripts.MainClient.ClientDataManager)
                local petsInfo = require(ReplicatedStorage.Modules.PetsInfo)
                local ownedPets = {}
                for petId, petData in pairs(dataManager.Data.Pets or {}) do
                    ownedPets[petId] = true
                end
                local missingCount = 0
                for petId, petData in pairs(petsInfo.Pets) do
                    if not ownedPets[petId] then missingCount = missingCount + 1 end
                end
                local skipThreshold = getgenv().skipThreshold or 0
                if missingCount > skipThreshold then
                    for eggName, eggData in pairs(petsInfo.Eggs) do
                        if petsInfo.GetBestPetOfRarityFromUnlockedEgg and eggData.PetRarityToReward then
                            local bestPet = petsInfo:GetBestPetOfRarityFromUnlockedEgg(dataManager.Data, eggData.PetRarityToReward)
                            if bestPet and not ownedPets[bestPet] then
                                ReplicatedStorage.Events.UIAction:FireServer("BuyEgg", eggName)
                                task.wait(0.5)
                                break
                            end
                        end
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end

function autoRedeemPetdexRewards()
    spawn(function()
        while getgenv().autoRedeemPetdexRewards and task do
            local petdexRewards = require(ReplicatedStorage.Modules.PetdexRewardInfo)
            local dataManager = require(Players.LocalPlayer.PlayerScripts.MainClient.ClientDataManager)
            for rewardId, rewardData in pairs(petdexRewards.Items) do
                local isClaimed = table.find(dataManager.Data.PetdexRewardsClaimed, rewardId)
                if not isClaimed then
                    local petsNeeded = rewardData.PetsNeeded or 0
                    local eggsNeeded = rewardData.EggsNeeded or 0
                    local petsCompleted = petdexRewards:GetNumPetsDiscovered(dataManager.Data) or 0
                    local eggsCompleted = petdexRewards:GetNumEggsCompleted(dataManager.Data) or 0
                    if petsCompleted >= petsNeeded and eggsCompleted >= eggsNeeded then
                        ReplicatedStorage.Events.UIAction:FireServer("ClaimPetdexReward", rewardId)
                        task.wait(0.5)
                    end
                end
            end
            task.wait(2)
        end
    end)
end

function autoTeleportToPetShop()
    spawn(function()
        while getgenv().autoTeleportToPetShop and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    charRoot.CFrame = workspace.Gameplay.Locations.PetShop.CFrame
                end
            end
            task.wait(2)
        end
    end)
end

function autoCraftAllPets()
    spawn(function()
        while getgenv().autoCraftAllPets and task do
            ReplicatedStorage.Events.UIAction:FireServer("CombineAllPets")
            task.wait(1)
        end
    end)
end

function autoCraftBestPet()
    local dataManager = require(Players.LocalPlayer.PlayerScripts.MainClient.ClientDataManager)
    spawn(function()
        while getgenv().autoCraftBestPet and task do
            local petsByType = {}
            for petId, petData in pairs(dataManager.Data.Pets or {}) do
                local classType = petData.Class and tostring(petData.Class) or "Normal"
                local typeKey = petData.Type .. "_" .. classType
                if not petsByType[typeKey] then petsByType[typeKey] = {} end
                table.insert(petsByType[typeKey], { id = petId, rank = petData.Rank or 0, xp = petData.XP or 0 })
            end
            for _, petList in pairs(petsByType) do
                if #petList >= 10 then
                    table.sort(petList, function(a, b)
                        if a.rank == b.rank then return a.xp > b.xp end
                        return a.rank > b.rank
                    end)
                    ReplicatedStorage.Events.UIAction:FireServer("CombinePet", petList[1].id)
                end
            end
            task.wait(10)
        end
    end)
end

function autoEquipBestPets()
    spawn(function()
        while getgenv().autoEquipBestPets and task do
            ReplicatedStorage.Events.UIAction:FireServer("EquipBestPets")
            task.wait(1)
        end
    end)
end

function autoEquipBestEventPets()
    spawn(function()
        while getgenv().autoEquipBestEventPets and task do
            ReplicatedStorage.Events.UIAction:FireServer("EquipBestPets", true)
            task.wait(1)
        end
    end)
end

-- PET DELETION FUNCTION
local PetRarityMap = {}
pcall(function()
    local petsInfoModule = require(ReplicatedStorage.Modules.PetsInfo.Pets)
    for petType, info in pairs(petsInfoModule) do
        if info.Rarity then
            PetRarityMap[petType] = info.Rarity
        end
    end
end)

getgenv().selectedRarities = getgenv().selectedRarities or {}

function deletePetsByRarity(targetRarities)
    local dataManager = require(Players.LocalPlayer.PlayerScripts.MainClient.ClientDataManager)
    local petsToDelete = {}
    
    for uid, pet in pairs(dataManager.Data.Pets) do
        local isEquipped = table.find(dataManager.Data.PetsEquipped, uid)
        local isLocked = pet.Locked
        
        if not isEquipped and not isLocked then
            local rarity = PetRarityMap[pet.Type]
            if rarity and table.find(targetRarities, rarity) then
                table.insert(petsToDelete, uid)
            end
        end
    end
    
    if #petsToDelete > 0 then
        ReplicatedStorage.Events.UIAction:FireServer("DeletePets", petsToDelete)
    end
    
    return #petsToDelete
end

function autoDeletePets()
    spawn(function()
        while getgenv().autoDeletePets and task do
            if #getgenv().selectedRarities > 0 then
                pcall(function()
                    local deletedCount = deletePetsByRarity(getgenv().selectedRarities)
                    if deletedCount > 0 then
                        print("[Pet Delete] Deleted", deletedCount, "pets")
                    end
                end)
            end
            task.wait(2)
        end
    end)
end

-- ============================================
-- ELEMENT FARMING FUNCTIONS (FIXED YIELD ISSUE)
-- ============================================
local ElementZones = {
    Fire = {
        Normal = function() return workspace.Gameplay.Map.ElementZones.Fire.Fire end,
        Advanced = function() 
            local a = workspace.Gameplay.RegionsLoaded:FindFirstChild("AdvancedFireArea")
            return a and a:FindFirstChild("Important") and a.Important:FindFirstChild("Fire")
        end,
        Master = function() 
            local a = workspace.Gameplay.RegionsLoaded:FindFirstChild("MasterFireArea")
            return a and a:FindFirstChild("Important") and a.Important:FindFirstChild("Fire")
        end,
        Grandmaster = function() 
            local a = workspace.Gameplay.RegionsLoaded:FindFirstChild("GrandmasterFireArea")
            return a and a:FindFirstChild("Important") and a.Important:FindFirstChild("Fire")
        end
    },
    Water = {
        Normal = function() return workspace.Gameplay.Map.ElementZones.Water.Water end,
        Advanced = function() 
            local a = workspace.Gameplay.RegionsLoaded:FindFirstChild("AdvancedWaterArea")
            return a and a:FindFirstChild("Important") and a.Important:FindFirstChild("Water")
        end,
        Master = function() 
            local a = workspace.Gameplay.RegionsLoaded:FindFirstChild("MasterWaterArea")
            return a and a:FindFirstChild("Important") and a.Important:FindFirstChild("Water")
        end,
        Grandmaster = function() 
            local a = workspace.Gameplay.RegionsLoaded:FindFirstChild("GrandmasterWaterArea")
            return a and a:FindFirstChild("Important") and a.Important:FindFirstChild("Water")
        end
    },
    Earth = {
        Normal = function() return workspace.Gameplay.Map.ElementZones.Earth.Model.Earth end,
        Advanced = function() 
            local a = workspace.Gameplay.RegionsLoaded:FindFirstChild("AdvancedEarthArea")
            return a and a:FindFirstChild("Important") and a.Important:FindFirstChild("Earth")
        end,
        Master = function() 
            local a = workspace.Gameplay.RegionsLoaded:FindFirstChild("MasterEarthArea")
            return a and a:FindFirstChild("Important") and a.Important:FindFirstChild("Earth")
        end,
        Grandmaster = function() 
            local a = workspace.Gameplay.RegionsLoaded:FindFirstChild("GrandmasterEarthArea")
            return a and a:FindFirstChild("Important") and a.Important:FindFirstChild("Earth")
        end
    },
    Plasma = {
        Normal = function() return workspace.Gameplay.Map.ElementZones.Plasma.Plasma end,
        Advanced = function() 
            local a = workspace.Gameplay.RegionsLoaded:FindFirstChild("AdvancedPlasmaArea")
            return a and a:FindFirstChild("Important") and a.Important:FindFirstChild("Plasma")
        end,
        Master = function() 
            local a = workspace.Gameplay.RegionsLoaded:FindFirstChild("MasterPlasmaArea")
            return a and a:FindFirstChild("Important") and a.Important:FindFirstChild("Plasma")
        end,
        Grandmaster = function() 
            local a = workspace.Gameplay.RegionsLoaded:FindFirstChild("GrandmasterPlasmaArea")
            return a and a:FindFirstChild("Important") and a.Important:FindFirstChild("Plasma")
        end
    }
}

function FarmElement(elementName, level)
    spawn(function()
        local flagName = string.format("autoFarm%s%s", elementName, level)
        
        while getgenv()[flagName] do
            pcall(function()
                if Players.LocalPlayer.Character then
                    local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if charRoot then
                        local getZoneFolder = ElementZones[elementName] and ElementZones[elementName][level]
                        if getZoneFolder then
                            local success, zoneFolder = pcall(getZoneFolder)
                            
                            if success and zoneFolder then
                                local zonePos = nil
                                local zoneCFrame = nil
                                if zoneFolder:IsA("BasePart") then
                                    zonePos = zoneFolder.Position
                                    zoneCFrame = zoneFolder.CFrame + Vector3.new(0, 3, 0)
                                elseif zoneFolder:IsA("Model") and zoneFolder.PrimaryPart then
                                    zonePos = zoneFolder.PrimaryPart.Position
                                    zoneCFrame = zoneFolder.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
                                end

                                -- FIX: Only teleport if horizontally > 10 studs away (stops shaking)
                                if zonePos and zoneCFrame then
                                    local horizontalDist = (Vector3.new(charRoot.Position.X, 0, charRoot.Position.Z) - Vector3.new(zonePos.X, 0, zonePos.Z)).Magnitude
                                    if horizontalDist > 10 then
                                        charRoot.CFrame = zoneCFrame
                                    end
                                end
                                
                                -- FIX: Instantly bring elements (no delay)
                                for _, child in pairs(zoneFolder:GetChildren()) do
                                    if child:FindFirstChild("HumanoidRootPart") then
                                        child.HumanoidRootPart.Anchored = true
                                        child.HumanoidRootPart.CFrame = charRoot.CFrame * CFrame.new(0, 0, -2)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            task.wait()
        end
    end)
end

function hidePlasmaElements()
    spawn(function()
        while getgenv().hidePlasmaElements and task do
            for _, zone in pairs(workspace.Gameplay.RegionsLoaded.AdvancedPlasmaArea.Important:GetChildren()) do
                if zone.Name == "Plasma" then
                    for _, descendant in pairs(zone:GetChildren()) do
                        if descendant:IsA("BasePart") then
                            descendant.Transparency = 1
                            descendant.CanCollide = false
                        end
                    end
                end
            end
            task.wait(1)
        end
    end)
end

-- EVENT FUNCTIONS
function autoCollectEventCurrency()
    spawn(function()
        while getgenv().autoCollectEventCurrency and task do
            for _, region in pairs(workspace.Gameplay.RegionsLoaded:GetChildren()) do
                if region.Name:find("Event") then
                    local currencyPickup = region:FindFirstChild("CurrencyPickup")
                    if currencyPickup then
                        local currencyHolder = currencyPickup:FindFirstChild("CurrencyHolder")
                        if currencyHolder then
                            for _, currencyPart in pairs(currencyHolder:GetChildren()) do
                                if currencyPart.Transparency == 0 and currencyPart:IsA("BasePart") then
                                    if Players.LocalPlayer.Character then
                                        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                        if charRoot then
                                            currencyPart.CFrame = charRoot.CFrame
                                            currencyPart.Anchored = true
                                        end
                                    end
                                    task.wait()
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

function autoTeleportToEventBoss()
    spawn(function()
        while getgenv().autoTeleportToEventBoss and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                local humanoid = Players.LocalPlayer.Character:WaitForChild("Humanoid")
                for _, region in pairs(workspace.Gameplay.RegionsLoaded:GetChildren()) do
                    if region.Name:find("Event") then
                        local bossHolder = region.Boss and region.Boss:FindFirstChild("BossHolder")
                        if bossHolder then
                            for _, descendant in pairs(bossHolder:GetDescendants()) do
                                if descendant.Name == "HumanoidRootPart" then
                                    charRoot.CFrame = descendant.CFrame + Vector3.new(0, 5, 0)
                                    break
                                end
                            end
                        end
                    end
                end
            end
            task.wait()
        end
    end)
end

function autoWalkEventBoss()
    spawn(function()
        local randomDistance = math.random(4, 8)
        while getgenv().autoWalkEventBoss and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                for _, region in pairs(workspace.Gameplay.RegionsLoaded:GetChildren()) do
                    if region.Name:find("Event") then
                        local bossHolder = region.Boss and region.Boss:FindFirstChild("BossHolder")
                        if bossHolder then
                            for _, descendant in pairs(bossHolder:GetDescendants()) do
                                if descendant.Name == "HumanoidRootPart" then
                                    local bossHumanoid = descendant.Parent:FindFirstChildOfClass("Humanoid")
                                    if bossHumanoid and bossHumanoid.Health > 0 then
                                        local distance = (charRoot.Position - descendant.Position).Magnitude
                                        if distance > 50 then
                                            charRoot.CFrame = descendant.CFrame + Vector3.new(0, 3, 0)
                                        elseif distance > randomDistance then
                                            humanoid:MoveTo(descendant.Position)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.3)
        end
    end)
end

-- Placeholder for missing function
function autoBuyEventMerchant()
    -- Add event merchant logic here if needed
end

-- MISC FUNCTIONS
function changeWalkSpeed()
    spawn(function()
        while getgenv().changeWalkSpeed and task do
            if Players.LocalPlayer.Character then
                local humanoid = Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = getgenv().WalkSpeedValue or 45
                end
            end
            task.wait()
        end
    end)
end

function hideVisualEffects()
    spawn(function()
        while getgenv().hideVisualEffects and task do
            Players.LocalPlayer.PlayerGui.MainGui.EffectsFrame.Visible = false
            task.wait()
        end
    end)
end

function hideNameRankUI()
    spawn(function()
        while getgenv().hideNameRankUI and task do
            for _, player in pairs(Players:GetChildren()) do
                if player.Character and player.Character.Head and player.Character.Head.RankingGui then
                    local pName = player.Character.Head.RankingGui:FindFirstChild("PName")
                    if pName then pName.Text = "SaberSimulatorFucker" end
                    local tag1 = player.Character.Head.RankingGui:FindFirstChild("Tag1")
                    if tag1 then tag1.Text = "DEVIL" end
                    if Players.LocalPlayer.Character and Players.LocalPlayer.Character.Head then
                        Players.LocalPlayer.Character.Head.RankingGui.Tag2.Text = "Vip"
                        Players.LocalPlayer.Character.Head.RankingGui.Tag2.Visible = true
                        local elementAmount = Players.LocalPlayer.Character.Head.RankingGui.ImageFrame.Element:FindFirstChild("Amount")
                        if elementAmount then elementAmount.Text = "999+" end
                    end
                end
            end
            task.wait()
        end
    end)
end

function autoTeleportToSavedLocation()
    spawn(function()
        while getgenv().autoTeleportToSavedLocation and task do
            if getgenv().SavedLocation and Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    charRoot.CFrame = getgenv().SavedLocation
                end
            end
            task.wait(0.1)
        end
    end)
end

function infiniteJump()
    spawn(function()
        local jumpAnimation = Instance.new("Animation")
        jumpAnimation.AnimationId = "rbxassetid://4210710991"
        while getgenv().infiniteJump and task do
            if Players.LocalPlayer.Character then
                local humanoid = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    humanoid.JumpPower = 150
                end
            end
            task.wait(0.1)
        end
    end)
end

-- TELEPORT FUNCTIONS
function teleportToNormalFire()
    if Players.LocalPlayer.Character then
        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if charRoot then charRoot.CFrame = workspace.Gameplay.Map.ElementZones.Fire.Fire.CFrame end
    end
end

function teleportToAdvanceFire()
    if Players.LocalPlayer.Character then
        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if charRoot then charRoot.CFrame = workspace.Gameplay.RegionsLoaded.AdvancedFireArea.Important.Fire.CFrame end
    end
end

function teleportToMasterFire()
    if Players.LocalPlayer.Character then
        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if charRoot then charRoot.CFrame = workspace.Gameplay.RegionsLoaded.MasterFireArea.Important.Fire.InnerCircle.CFrame end
    end
end

function teleportToGMasterFire()
    if Players.LocalPlayer.Character then
        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if charRoot then charRoot.CFrame = workspace.Gameplay.RegionsLoaded.GrandmasterFireArea.Important.Fire.InnerCircle.CFrame end
    end
end

function teleportToNormalWater()
    if Players.LocalPlayer.Character then
        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if charRoot then charRoot.CFrame = workspace.Gameplay.Map.ElementZones.Water.Water.CFrame end
    end
end

function teleportToAdvanceWater()
    if Players.LocalPlayer.Character then
        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if charRoot then charRoot.CFrame = workspace.Gameplay.RegionsLoaded.AdvancedWaterArea.Important.Water.CFrame end
    end
end

function teleportToMasterWater()
    if Players.LocalPlayer.Character then
        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if charRoot then charRoot.CFrame = workspace.Gameplay.RegionsLoaded.MasterWaterArea.Important.Water.InnerCircle.CFrame end
    end
end

function teleportToGMasterWater()
    if Players.LocalPlayer.Character then
        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if charRoot then charRoot.CFrame = workspace.Gameplay.RegionsLoaded.GrandmasterWaterArea.Important.Water.InnerCircle.CFrame end
    end
end

function teleportToNormalEarth()
    if Players.LocalPlayer.Character then
        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if charRoot then charRoot.CFrame = workspace.Gameplay.Map.ElementZones.Earth.Model.Earth.CFrame end
    end
end

function teleportToAdvanceEarth()
    if Players.LocalPlayer.Character then
        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if charRoot then charRoot.CFrame = workspace.Gameplay.RegionsLoaded.AdvancedEarthArea.Important.Earth.CFrame end
    end
end

function teleportToMasterEarth()
    if Players.LocalPlayer.Character then
        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if charRoot then charRoot.CFrame = workspace.Gameplay.RegionsLoaded.MasterEarthArea.Important.Earth.InnerCircle.CFrame end
    end
end

function teleportToGMasterEarth()
    if Players.LocalPlayer.Character then
        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if charRoot then charRoot.CFrame = workspace.Gameplay.RegionsLoaded.GrandmasterEarthArea.Important.Earth.InnerCircle.CFrame end
    end
end

function teleportToNormalPlasma()
    if Players.LocalPlayer.Character then
        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if charRoot then charRoot.CFrame = workspace.Gameplay.Map.ElementZones.Plasma.PlasmaTeleport.PlasmaTeleportPart1.CFrame end
    end
end

function teleportToAdvancePlasma()
    if Players.LocalPlayer.Character then
        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if charRoot then charRoot.CFrame = workspace.Gameplay.RegionsLoaded.AdvancedPlasmaArea.Important.PlasmaTeleport.PlasmaTeleportPart2.CFrame end
    end
end

function teleportToMasterPlasma()
    if Players.LocalPlayer.Character then
        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if charRoot then charRoot.CFrame = workspace.Gameplay.RegionsLoaded.MasterPlasmaArea.Important.Plasma.InnerCircle.CFrame end
    end
end

function teleportToGMasterPlasma()
    if Players.LocalPlayer.Character then
        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if charRoot then charRoot.CFrame = workspace.Gameplay.RegionsLoaded.GrandmasterPlasmaArea.Important.Plasma.CFrame end
    end
end

function teleportToPetShop()
    if Players.LocalPlayer.Character then
        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if charRoot then charRoot.CFrame = workspace.Gameplay.Locations.PetShop.CFrame end
    end
end

function saveCurrentLocation()
    if Players.LocalPlayer.Character then
        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if charRoot then
            getgenv().SavedLocation = charRoot.CFrame
        end
    end
end

function teleportToSavedLocation()
    if getgenv().SavedLocation and Players.LocalPlayer.Character then
        local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if charRoot then charRoot.CFrame = getgenv().SavedLocation end
    end
end

-- MERCHANT & CLAN FUNCTIONS

function autoBuyTravelingMerchant()
    spawn(function()
        while getgenv().autoBuyTravelingMerchant and task do
            pcall(function()
                local dataManager = require(Players.LocalPlayer.PlayerScripts.MainClient.ClientDataManager)
                local merchantInfo = require(ReplicatedStorage.Modules.TravelingMerchantInfo)
                
                if not dataManager.Data.TravelingMerchant or not dataManager.Data.TravelingMerchant.Items then return end
                
                for slot, itemData in pairs(dataManager.Data.TravelingMerchant.Items) do
                    if itemData and itemData.BuysLeft and itemData.BuysLeft > 0 then
                        local listing = merchantInfo.Listings[itemData.Index]
                        -- Only buy if the specific item toggle is turned ON
                        if listing and getgenv()["tm_item_" .. itemData.Index] then
                            local price = listing.CrownsPrice or 0
                            local multiplier = dataManager.Data.TravelingMerchant.CrownMulti or 1
                            
                            if price * multiplier > 0 then
                                ReplicatedStorage.Events.UIAction:FireServer("TravelingMerchantBuyItem", slot, dataManager.Data.TravelingMerchant.ResetDT)
                                task.wait(0.5)
                            end
                        end
                    end
                end
            end)
            task.wait(1)
        end
    end)
end



function autoInviteTopRanks()
    spawn(function()
        while getgenv().autoInviteTopRanks and task do
            local itemInfo = require(ReplicatedStorage.Modules.ItemInfo)
            local topRanks = {}
            local startIndex = math.max(1, #itemInfo.Classes_Order - 4)
            for i = startIndex, #itemInfo.Classes_Order do
                table.insert(topRanks, itemInfo.Classes_Order[i])
            end
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer then
                    local leaderstats = player:FindFirstChild("leaderstats")
                    if leaderstats then
                        local playerClass = leaderstats:FindFirstChild("Class")
                        if playerClass then
                            for _, rank in pairs(topRanks) do
                                if playerClass.Value == rank then
                                    ReplicatedStorage.Events.UIAction:FireServer("InvitePlayerToClan", player.Name)
                                    task.wait(0.5)
                                    break
                                end
                            end
                        end
                    end
                end
            end
            task.wait(5)
        end
    end)
end

local DEBUG = true

local function qprint(...)
    if DEBUG then
        print("[AUTO QUEST]", ...)
    end
end

local function qwarn(...)
    warn("[AUTO QUEST]", ...)
end

-- ============================================
-- CONFIG
-- ============================================

local ELEMENTS = {"Fire", "Water", "Earth", "Plasma"}
local TIERS = {"Grandmaster", "Master", "Advanced", "Normal"}

-- ============================================
-- HELPERS
-- ============================================

local function getChar()
    local char = Players.LocalPlayer.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if not root or not hum then return end
    return char, root, hum
end

local function getZoneFolders()
    local folders = {}

    for _, element in ipairs(ELEMENTS) do
        local tierTable = ElementZones[element]
        if tierTable then
            for _, tier in ipairs(TIERS) do
                local getter = tierTable[tier]
                if getter then
                    local ok, folder = pcall(getter)
                    if ok and folder then
                        table.insert(folders, folder)
                    end
                end
            end
        end
    end

    return folders
end

-- ============================================
-- BOSS FARM
-- ============================================

function QuestFarmBossWalk()
    local _, charRoot, humanoid = getChar()
    if not charRoot then return end

    local bossRoot = getBossData()
    if not bossRoot then
        qwarn("Boss not found")
        return
    end

    local dist =
        (Vector3.new(charRoot.Position.X, 0, charRoot.Position.Z) -
         Vector3.new(bossRoot.Position.X, 0, bossRoot.Position.Z)).Magnitude

    if dist > 50 then
        charRoot.CFrame = bossRoot.CFrame + Vector3.new(0, 3, 0)

    elseif dist > 8 then
        humanoid:MoveTo(bossRoot.Position)

    else
        humanoid:MoveTo(charRoot.Position)
    end
end

-- ============================================
-- EGG FARM
-- ============================================

function QuestFarmEgg()
    local _, charRoot = getChar()
    if not charRoot then return end

    if not getgenv().SelectedEggIsHere then return end

    local petShop = workspace.Gameplay.Locations:FindFirstChild("PetShop")
    if petShop then
        charRoot.CFrame = petShop.CFrame + Vector3.new(0, 3, 0)
    end

    ReplicatedStorage.Events.UIAction:FireServer(
        "BuyEgg",
        getgenv().SelectedEggIsHere
    )
end

-- ============================================
-- DUNGEON FARM
-- ============================================

function QuestFarmDungeon()
    local lp = Players.LocalPlayer

    local dungeonStorage = workspace:FindFirstChild("DungeonStorage")
    local inDungeon = false

    if dungeonStorage then
        for _, folder in ipairs(dungeonStorage:GetChildren()) do
            if #folder:GetChildren() > 0 then
                inDungeon = true
                break
            end
        end
    end

    if inDungeon then
        qprint("Already in dungeon")
        return
    end

    local dataManager = require(lp.PlayerScripts.MainClient.ClientDataManager)
    local timeManager = require(lp.PlayerScripts.MainClient.DateTimeManager)

    local cooldownEnd = dataManager.Data and dataManager.Data.DungeonCooldownEndDT or 0
    if timeManager:Now() < cooldownEnd then
        qprint("Dungeon cooldown active")
        return
    end

    local dungeon = getgenv().SelectedDungeon or "Space"
    local diff = getgenv().SelectedDifficulty or 1

    qprint("Starting dungeon:", dungeon, diff)

    ReplicatedStorage.Events.UIAction:FireServer(
        "DungeonGroupAction",
        "Create",
        "Public",
        dungeon,
        diff
    )

    task.wait(1.5)

    ReplicatedStorage.Events.UIAction:FireServer(
        "DungeonGroupAction",
        "Start"
    )
end

-- ============================================
-- KOTH FARM
-- ============================================

function QuestFarmKOTH()
    local _, charRoot = getChar()
    if not charRoot then return end

    local koth = workspace.Gameplay:FindFirstChild("KOTH")
    if not koth then return end

    local boundary = koth:FindFirstChild("KOH_BOUNDARY")
    if not boundary then return end

    local ring =
        boundary:FindFirstChild("Meshes/ring")
        or boundary:FindFirstChild("ring")

    if ring then
        qprint("Moving to KOTH")
        charRoot.CFrame = ring.CFrame + Vector3.new(0, 3, 0)
    end
end

-- ============================================
-- FLAG FARM
-- ============================================

-- ============================================
-- ELEMENT FARM (MAIN OPTIMIZED VERSION)
-- ============================================

getgenv().currentFarmingFolder = nil

function FarmAnyAvailableElement(needsBoss)
    local _, charRoot = getChar()
    if not charRoot then return end

    -- STEP 1: Check if we are already committed to a folder that still has targets
    if getgenv().currentFarmingFolder and getgenv().currentFarmingFolder.Parent then
        local hasTargets = false
        for _, obj in ipairs(getgenv().currentFarmingFolder:GetChildren()) do
            local root = obj:FindFirstChild("HumanoidRootPart")
            -- ONLY check for HumanoidRootPart, no Humanoid health check!
            if root then
                if not needsBoss or obj.Name:lower():find("boss") then
                    hasTargets = true
                    -- Bring to player instantly
                    root.Anchored = true
                    root.CFrame = charRoot.CFrame * CFrame.new(0, 0, -2)
                end
            end
        end

        if hasTargets then
            -- Stay in the zone
            local zonePos = nil
            local zoneCFrame = nil
            if getgenv().currentFarmingFolder:IsA("BasePart") then
                zonePos = getgenv().currentFarmingFolder.Position
                zoneCFrame = getgenv().currentFarmingFolder.CFrame + Vector3.new(0, 3, 0)
            elseif getgenv().currentFarmingFolder:IsA("Model") and getgenv().currentFarmingFolder.PrimaryPart then
                zonePos = getgenv().currentFarmingFolder.PrimaryPart.Position
                zoneCFrame = getgenv().currentFarmingFolder.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
            end

            if zonePos and zoneCFrame then
                local horizontalDist = (Vector3.new(charRoot.Position.X, 0, charRoot.Position.Z) - Vector3.new(zonePos.X, 0, zonePos.Z)).Magnitude
                if horizontalDist > 10 then
                    charRoot.CFrame = zoneCFrame
                end
            end
            return -- DO NOT switch to another element yet, stay committed!
        else
            -- Folder is empty/dead, clear commitment
            getgenv().currentFarmingFolder = nil
        end
    end

    -- STEP 2: If not committed (or committed zone is cleared), find the highest priority element
    for _, element in ipairs(ELEMENTS) do
        local tiers = ElementZones[element]
        if tiers then
            for _, tier in ipairs(TIERS) do
                local getter = tiers[tier]
                if getter then
                    local ok, folder = pcall(getter)
                    if ok and folder then
                        local targets = {}
                        for _, obj in ipairs(folder:GetChildren()) do
                            local root = obj:FindFirstChild("HumanoidRootPart")
                            -- ONLY check for HumanoidRootPart
                            if root then
                                if not needsBoss or obj.Name:lower():find("boss") then
                                    table.insert(targets, root)
                                end
                            end
                        end

                        if #targets > 0 then
                            getgenv().currentFarmingFolder = folder -- Commit to this exact folder!
                            
                            local zonePos = nil
                            local zoneCFrame = nil
                            if folder:IsA("BasePart") then
                                zonePos = folder.Position
                                zoneCFrame = folder.CFrame + Vector3.new(0, 3, 0)
                            elseif folder:IsA("Model") and folder.PrimaryPart then
                                zonePos = folder.PrimaryPart.Position
                                zoneCFrame = folder.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
                            end

                            if zonePos and zoneCFrame then
                                local horizontalDist = (Vector3.new(charRoot.Position.X, 0, charRoot.Position.Z) - Vector3.new(zonePos.X, 0, zonePos.Z)).Magnitude
                                if horizontalDist > 10 then
                                    charRoot.CFrame = zoneCFrame
                                end
                            end

                            for _, t in ipairs(targets) do
                                t.Anchored = true
                                t.CFrame = charRoot.CFrame * CFrame.new(0, 0, -2)
                            end

                            return
                        end
                    end
                end
            end
        end
    end
end

-- ============================================
-- FAST LOOPS
-- ============================================

getgenv().QuestFarmElementActive = false
getgenv().QuestFarmBossActive = false

function QuestElementFastLoop()
    task.spawn(function()
        qprint("Element loop started")

        while getgenv().QuestFarmElementActive and getgenv().autoQuestExecute do
            pcall(FarmAnyAvailableElement, false)
            task.wait()
        end

        qprint("Element loop stopped")
    end)
end

function QuestBossFastLoop()
    task.spawn(function()
        qprint("Boss loop started")

        while getgenv().QuestFarmBossActive and getgenv().autoQuestExecute do
            pcall(QuestFarmBossWalk)
            task.wait(0.3)
        end

        qprint("Boss loop stopped")
    end)
end

-- ============================================
-- MAIN AUTO QUEST LOOP
-- ============================================

getgenv().questDungeonActive = false

local function startQuestDungeonAutomation()
    if not getgenv().questDungeonActive then
        getgenv().questDungeonActive = true
        qprint("Auto-activating Dungeon features for Quest")
        
        getgenv().autoJoinDungeon = true
        autoJoinDungeon()
        
        getgenv().autoFarmDungeon = true
        autoFarmDungeon()
        
        getgenv().autoDungeonRewards = true
        autoCollectDungeonRewards()
        
        getgenv().autoIncubateDungeonEgg = true
        autoIncubateDungeonEgg()
        
        getgenv().autoClaimIncubated = true
        autoClaimIncubatedPet()
    end
end

local function stopQuestDungeonAutomation()
    if getgenv().questDungeonActive then
        getgenv().questDungeonActive = false
        qprint("Quest done, deactivating Auto-Dungeon features")
        
        getgenv().autoJoinDungeon = false
        getgenv().autoFarmDungeon = false
        getgenv().autoDungeonRewards = false
        getgenv().autoIncubateDungeonEgg = false
        getgenv().autoClaimIncubated = false
    end
end

getgenv().questEggActive = false

local function startQuestEggAutomation()
    if not getgenv().questEggActive then
        getgenv().questEggActive = true
        qprint("Auto-activating Egg features for Quest")
        
        getgenv().autoOpenEgg = true
        autoOpenEgg()
    end
end

local function stopQuestEggAutomation()
    if getgenv().questEggActive then
        getgenv().questEggActive = false
        qprint("Quest done, deactivating Auto-Egg features")
        
        getgenv().autoOpenEgg = false
    end
end

function startAutoQuestLoop()
    task.spawn(function()
        qprint("Quest loop started")

        while getgenv().autoQuestExecute do

            local success, err = pcall(function()

                local ClientDataManager =
                    require(Players.LocalPlayer.PlayerScripts.MainClient.ClientDataManager)

                local QuestInfo =
                    require(ReplicatedStorage.Modules.QuestInfo)

                local quests = ClientDataManager.Data and ClientDataManager.Data.ClanQuests
                if not quests then task.wait(1) return end

                -- ============================================
                -- STEP 1: AUTO CLAIM COMPLETED QUESTS
                -- ============================================
                for questIndex, q in pairs(quests) do -- Changed to pairs
                    local cfg = QuestInfo.ClanQuests[q.Id]
                    if cfg and q.Amount >= cfg.GoalAmount then
                        qprint("Quest completed! Claiming reward for index:", questIndex)
                        pcall(function()
                            ReplicatedStorage.Events.UIAction:FireServer("ClaimClanQuest", questIndex)
                        end)
                        task.wait(1)
                        return -- Restart loop immediately to refresh the quest list
                    end
                end

                -- ============================================
                -- STEP 2: FIND ACTIVE QUEST & HANDLE SKIPPING
                -- ============================================
                local detected = nil
                local questText = ""

                for questIndex, q in pairs(quests) do -- Changed to pairs
                    local cfg = QuestInfo.ClanQuests[q.Id]

                    if cfg and q.Amount < cfg.GoalAmount then
                        local typeCfg = QuestInfo.QuestTypes[cfg.QuestType]
                        local currentDetected = nil
                        local text = ""

                        if typeCfg then
                            local ok, txt = pcall(function()
                                return typeCfg.InfoText(q.Amount, cfg.GoalAmount, cfg)
                            end)

                            if ok and txt then
                                text = tostring(txt):lower()

                                if text:find("element") and text:find("boss") then
                                    currentDetected = "elementboss"
                                elseif text:find("fire")
                                    or text:find("water")
                                    or text:find("earth")
                                    or text:find("plasma")
                                    or text:find("element") then
                                    currentDetected = "element"
                                elseif text:find("boss") then
                                    currentDetected = "boss"
                                elseif text:find("egg") or text:find("hatch") then
                                    currentDetected = "egg"
                                elseif text:find("dungeon") then
                                    currentDetected = "dungeon"
                                elseif text:find("koth") or text:find("king of the hill") then
                                    currentDetected = "koth"
                                elseif text:find("flag") then
                                    currentDetected = "flag"
                                end
                            else
                                -- Fallback: If reading text fails, guess from the QuestType name
                                local qType = tostring(cfg.QuestType):lower()
                                if qType:find("element") then currentDetected = "element"
                                elseif qType:find("boss") then currentDetected = "boss"
                                elseif qType:find("egg") or qType:find("hatch") then currentDetected = "egg"
                                elseif qType:find("dungeon") then currentDetected = "dungeon"
                                elseif qType:find("koth") then currentDetected = "koth"
                                elseif qType:find("flag") then currentDetected = "flag"
                                end
                            end
                        end

                        if currentDetected then
                            local shouldSkipThis = false
                            
                            if (currentDetected == "elementboss" or currentDetected == "element") and getgenv().skipElementQuest then shouldSkipThis = true end
                            if currentDetected == "boss" and getgenv().skipBossQuest then shouldSkipThis = true end
                            if currentDetected == "egg" and getgenv().skipEggQuest then shouldSkipThis = true end
                            if currentDetected == "dungeon" and getgenv().skipDungeonQuest then shouldSkipThis = true end
                            if currentDetected == "koth" and getgenv().skipKOTHQuest then shouldSkipThis = true end
                            if currentDetected == "flag" and getgenv().skipFlagQuest then shouldSkipThis = true end

                            if shouldSkipThis then
                                qprint("Found", currentDetected, "quest but it is marked for skip.")
                            else
                                -- If we aren't skipping this quest and haven't found one to do yet, select it!
                                if not detected then
                                    qprint("Found valid quest:", currentDetected)
                                    detected = currentDetected
                                    questText = text
                                end
                            end
                        end
                    end
                end

                -- ============================================
                -- STEP 3: EXECUTE QUEST LOGIC
                -- ============================================
                if detected then
                    qprint("Executing quest type:", detected)
                else
                    qprint("No valid quest found (or all are skipped). Idling...")
                end

                if detected == "dungeon" then
                    if questText:find("impossible") then
                        getgenv().SelectedDifficulty = 4
                    elseif questText:find("hard") then
                        getgenv().SelectedDifficulty = 3
                    elseif questText:find("medium") then
                        getgenv().SelectedDifficulty = 2
                    elseif questText:find("easy") then
                        getgenv().SelectedDifficulty = 1
                    end
                    
                    stopQuestEggAutomation()
                    startQuestDungeonAutomation()
                    QuestFarmDungeon()
                    
                elseif detected == "egg" then
                    stopQuestDungeonAutomation()
                    startQuestEggAutomation()

                elseif detected == "elementboss" then
                    stopQuestDungeonAutomation()
                    stopQuestEggAutomation()
                    getgenv().currentFarmingElement = nil
                    FarmAnyAvailableElement(true)
                    FarmAnyAvailableElement(false)

                elseif detected == "element" then
                    stopQuestDungeonAutomation()
                    stopQuestEggAutomation()
                    getgenv().currentFarmingElement = nil
                    FarmAnyAvailableElement(false)

                elseif detected == "boss" then
                    stopQuestDungeonAutomation()
                    stopQuestEggAutomation()
                    getgenv().currentFarmingElement = nil
                    QuestFarmBossWalk()

                elseif detected == "koth" then
                    stopQuestDungeonAutomation()
                    stopQuestEggAutomation()
                    getgenv().currentFarmingElement = nil
                    QuestFarmKOTH()

                elseif detected == "flag" then
                    stopQuestDungeonAutomation()
                    stopQuestEggAutomation()
                    getgenv().currentFarmingElement = nil
                    QuestFarmFlags()

                else
                    -- No quest detected, or all are skipped. Just idle.
                    stopQuestDungeonAutomation()
                    stopQuestEggAutomation()
                    getgenv().currentFarmingElement = nil
                    task.wait(1)
                end
            end)

            if not success then
                qwarn("Quest loop error:", err)
                task.wait(1)
            end
            
            task.wait(0.1)
        end

        stopQuestDungeonAutomation()
        stopQuestEggAutomation()
        getgenv().currentFarmingElement = nil
        qprint("Quest loop stopped")
    end)
end

-- QUEST & PRIORITY FUNCTIONS (For Debug Button)
function getHighestPriorityQuest()
    local quests = {
        { name = "Dungeon Farm", priority = 100, enabled = function() return getgenv().autoFarmDungeon end, available = function() return true end },
        { name = "Boss Killer Premium Walk", priority = 95, enabled = function() return getgenv().autoWalkBossPremium end, available = function() return true end },
        { name = "Boss Killer (Bring)", priority = 94, enabled = function() return getgenv().autoBringBoss end, available = function() return true end },
        { name = "Boss Killer (Teleport)", priority = 93, enabled = function() return getgenv().autoTeleportToBoss end, available = function() return true end },
        { name = "Event Boss Walk", priority = 85, enabled = function() return getgenv().autoWalkEventBoss end, available = function() return true end },
        { name = "Event Boss (Teleport)", priority = 84, enabled = function() return getgenv().autoTeleportToEventBoss end, available = function() return true end },
        { name = "Fire Elements", priority = 79, enabled = function() return getgenv().autoFarmFireNormal or getgenv().autoFarmFireAdvanced or getgenv().autoFarmFireMaster or getgenv().autoFarmFireGrandmaster end, available = function() return true end },
        { name = "Water Elements", priority = 78, enabled = function() return getgenv().autoFarmWaterNormal or getgenv().autoFarmWaterAdvanced or getgenv().autoFarmWaterMaster or getgenv().autoFarmWaterGrandmaster end, available = function() return true end },
        { name = "Earth Elements", priority = 77, enabled = function() return getgenv().autoFarmEarthNormal or getgenv().autoFarmEarthAdvanced or getgenv().autoFarmEarthMaster or getgenv().autoFarmEarthGrandmaster end, available = function() return true end },
        { name = "Plasma Elements", priority = 76, enabled = function() return getgenv().autoFarmPlasmaNormal or getgenv().autoFarmPlasmaAdvanced or getgenv().autoFarmPlasmaMaster or getgenv().autoFarmPlasmaGrandmaster end, available = function() return true end },
        { name = "Auto Complete Petdex", priority = 60, enabled = function() return getgenv().autoCompletePetdex end, available = function() return true end },
        { name = "Auto Open Egg", priority = 50, enabled = function() return getgenv().autoOpenEgg end, available = function() return true end },
        { name = "Auto Equip Pets", priority = 40, enabled = function() return getgenv().autoEquipBestPets or getgenv().autoEquipBestEventPets end, available = function() return true end },
        { name = "Auto Sell DNA", priority = 30, enabled = function() return getgenv().autoSellDNA end, available = function() return true end },
        { name = "Auto Swing", priority = 20, enabled = function() return getgenv().autoSwing end, available = function() return true end },
        { name = "Auto Collect Crowns", priority = 10, enabled = function() return getgenv().autoCrowns end, available = function() return true end }
    }
    table.sort(quests, function(a, b) return a.priority > b.priority end)
    for _, quest in pairs(quests) do
        local isEnabled = pcall(quest.enabled)
        local isAvailable = pcall(quest.available)
        if isEnabled and isAvailable then
            return quest
        end
    end
    return nil
end

function printPriorityDebug()
    local quests = {
        { name = "Dungeon Farm", priority = 100, enabled = function() return getgenv().autoFarmDungeon end, available = function() return true end },
        { name = "Boss Killer Premium Walk", priority = 95, enabled = function() return getgenv().autoWalkBossPremium end, available = function() return true end },
        { name = "Boss Killer (Bring)", priority = 94, enabled = function() return getgenv().autoBringBoss end, available = function() return true end },
        { name = "Boss Killer (Teleport)", priority = 93, enabled = function() return getgenv().autoTeleportToBoss end, available = function() return true end },
        { name = "Event Boss Walk", priority = 85, enabled = function() return getgenv().autoWalkEventBoss end, available = function() return true end },
        { name = "Event Boss (Teleport)", priority = 84, enabled = function() return getgenv().autoTeleportToEventBoss end, available = function() return true end },
        { name = "Fire Elements", priority = 79, enabled = function() return getgenv().autoFarmFireNormal or getgenv().autoFarmFireAdvanced or getgenv().autoFarmFireMaster or getgenv().autoFarmFireGrandmaster end, available = function() return true end },
        { name = "Water Elements", priority = 78, enabled = function() return getgenv().autoFarmWaterNormal or getgenv().autoFarmWaterAdvanced or getgenv().autoFarmWaterMaster or getgenv().autoFarmWaterGrandmaster end, available = function() return true end },
        { name = "Earth Elements", priority = 77, enabled = function() return getgenv().autoFarmEarthNormal or getgenv().autoFarmEarthAdvanced or getgenv().autoFarmEarthMaster or getgenv().autoFarmEarthGrandmaster end, available = function() return true end },
        { name = "Plasma Elements", priority = 76, enabled = function() return getgenv().autoFarmPlasmaNormal or getgenv().autoFarmPlasmaAdvanced or getgenv().autoFarmPlasmaMaster or getgenv().autoFarmPlasmaGrandmaster end, available = function() return true end },
        { name = "Auto Complete Petdex", priority = 60, enabled = function() return getgenv().autoCompletePetdex end, available = function() return true end },
        { name = "Auto Open Egg", priority = 50, enabled = function() return getgenv().autoOpenEgg end, available = function() return true end },
        { name = "Auto Equip Pets", priority = 40, enabled = function() return getgenv().autoEquipBestPets or getgenv().autoEquipBestEventPets end, available = function() return true end },
        { name = "Auto Sell DNA", priority = 30, enabled = function() return getgenv().autoSellDNA end, available = function() return true end },
        { name = "Auto Swing", priority = 20, enabled = function() return getgenv().autoSwing end, available = function() return true end },
        { name = "Auto Collect Crowns", priority = 10, enabled = function() return getgenv().autoCrowns end, available = function() return true end }
    }
    table.sort(quests, function(a, b) return a.priority > b.priority end)
    print("================ Priority Debug ================")
    print(string.format("%-35s %-8s %-10s %-10s", "Action", "Priority", "Enabled", "Available"))
    print(string.rep("-", 65))
    local currentQuest = getHighestPriorityQuest()
    for _, quest in pairs(quests) do
        local isEnabled = pcall(quest.enabled)
        local isAvailable = pcall(quest.available)
        local selected = ""
        if currentQuest and currentQuest.name == quest.name then selected = " <--" end
        print(string.format("%-35s %-8d %-10s %-10s%s", quest.name, quest.priority, tostring(isEnabled), tostring(isAvailable), selected))
    end
    print("================================================\n")
    if currentQuest then
        print("CURRENT: " .. currentQuest.name .. " (Priority: " .. currentQuest.priority .. ")")
    else
        print("NO ACTION SELECTED")
    end
end

-- ============================================
-- BLOODV3 UI LIBRARY SETUP
-- ============================================
local m0dznv1 = loadstring(game:HttpGet("https://raw.githubusercontent.com/m0dzn1/m0dzn-Roblox-UI-Library-V1.0/refs/heads/main/m0dzn-Ui-lib-V1.lua"))()

local Window = m0dznv1:CreateWindow({
    Title = "BloodV3",
    Keybind = Enum.KeyCode.RightShift,
    Theme = {
        Name = "Blood",
        Main = {20, 5, 5},
        Top = {35, 10, 10},
        Text = {255, 200, 200},
        Accent = {255, 30, 30},
        Stroke = {80, 20, 20},
    },
})

-- ============================================
-- TABS (Organized for best user experience)
-- ============================================
local Main = Window:Tab("Main")
local Quests = Window:Tab("Quests")
local Boss = Window:Tab("Boss")
local Dungeon = Window:Tab("Dungeon")
local Eggs = Window:Tab("Eggs")
local Pets = Window:Tab("Pets")
local Upgrades = Window:Tab("Upgrades")
local Elements = Window:Tab("Elements")
local Events = Window:Tab("Events")
local AntiAFK = Window:Tab("Anti-AFK")
local Misc = Window:Tab("Misc")

-- ============================================
-- MAIN TAB (Core Farming)
-- ============================================
Main:Section("Core Farming")

Main:Toggle("Auto Swing", false, function(state)
    getgenv().autoSwing = state
    if state then autoSwing() end
end)

Main:Toggle("Auto Sell DNA", false, function(state)
    getgenv().autoSellDNA = state
    if state then autoSellDNA() end
end)

Main:Toggle("Auto Collect Crowns", false, function(state)
    getgenv().autoCrowns = state
    if state then autoCollectCrowns() end
end)

Main:Toggle("Auto Collect Daily", false, function(state)
    getgenv().autoCollectDaily = state
    if state then autoCollectDaily() end
end)

-- ============================================
-- QUESTS TAB (Smart Auto Quest)
-- ============================================
Quests:Section("Clan Quests")

Quests:Toggle("Auto Clan Quests", false, function(state)
    getgenv().autoQuestExecute = state
    if state then startAutoQuestLoop() end
end)

Quests:Section("Skip Specific Quests")

Quests:Toggle("Skip Element Quests", false, function(state)
    getgenv().skipElementQuest = state
end)

Quests:Toggle("Skip Boss Quests", false, function(state)
    getgenv().skipBossQuest = state
end)

Quests:Toggle("Skip Egg Quests", false, function(state)
    getgenv().skipEggQuest = state
end)

Quests:Toggle("Skip Dungeon Quests", false, function(state)
    getgenv().skipDungeonQuest = state
end)

Quests:Toggle("Skip KOTH Quests", false, function(state)
    getgenv().skipKOTHQuest = state
end)

Quests:Toggle("Skip Flag Quests", false, function(state)
    getgenv().skipFlagQuest = state
end)

Quests:Button("Print Priority Debug", function()
    printPriorityDebug()
end)

-- ============================================
-- BOSS TAB
-- ============================================
Boss:Section("Boss Farm")

Boss:Toggle("Auto Teleport to Boss", false, function(state)
    getgenv().autoTeleportToBoss = state
    if state then autoTeleportToBoss() end
end)

Boss:Toggle("Auto Bring Boss", false, function(state)
    getgenv().autoBringBoss = state
    if state then autoBringBoss() end
end)

Boss:Toggle("Auto Walk Boss Premium", false, function(state)
    getgenv().autoWalkBossPremium = state
    if state then autoWalkBossPremium() end
end)

-- ============================================
-- DUNGEON TAB
-- ============================================
Dungeon:Section("Dungeon Setup")

Dungeon:Toggle("Auto Join Dungeon", false, function(state)
    getgenv().autoJoinDungeon = state
    if state then autoJoinDungeon() end
end)

Dungeon:Dropdown("Select Dungeon", {"Space"}, function(selected)
    getgenv().SelectedDungeon = selected
end)

Dungeon:Dropdown("Select Difficulty", {"Easy", "Medium", "Hard", "Impossible"}, function(selected)
    local difficultyMap = {["Easy"] = 1, ["Medium"] = 2, ["Hard"] = 3, ["Impossible"] = 4}
    getgenv().SelectedDifficulty = difficultyMap[selected] or 1
end)

Dungeon:Section("Dungeon Farming")

Dungeon:Toggle("Auto Farm Dungeon", false, function(state)
    getgenv().autoFarmDungeon = state
    if state then autoFarmDungeon() end
end)

Dungeon:Slider("Farming Distance", 2, 20, 8, function(value)
    getgenv().DunFarmingDistance = value
end)

Dungeon:Toggle("Auto Collect Dungeon Rewards", false, function(state)
    getgenv().autoDungeonRewards = state
    if state then autoCollectDungeonRewards() end
end)

Dungeon:Button("Teleport to Chest", teleportToChest)

Dungeon:Section("Dungeon Incubator")

Dungeon:Toggle("Auto Claim Incubated Pet", false, function(state)
    getgenv().autoClaimIncubated = state
    if state then autoClaimIncubatedPet() end
end)

Dungeon:Toggle("Auto Incubate Egg (Smart Replace)", false, function(state)
    getgenv().autoIncubateDungeonEgg = state
    if state then autoIncubateDungeonEgg() end
end)

-- ============================================
-- EGGS TAB (Hatching & Petdex)
-- ============================================
Eggs:Section("Egg Hatching")

local eggList, eggMap = fetchEggShopList()
getgenv().SelectedEggIsHere = "Wooden Egg"

Eggs:Dropdown("Select Egg", eggList, function(selected)
    getgenv().SelectedEggIsHere = eggMap[selected]
end)

Eggs:Toggle("Auto Open Egg", false, function(state)
    getgenv().autoOpenEgg = state
    if state then autoOpenEgg() end
end)

Eggs:Section("Petdex")

Eggs:Toggle("Auto Complete Petdex", false, function(state)
    getgenv().autoCompletePetdex = state
    if state then autoCompletePetdex() end
end)

Eggs:Toggle("Auto Redeem Petdex Rewards", false, function(state)
    getgenv().autoRedeemPetdexRewards = state
    if state then autoRedeemPetdexRewards() end
end)

-- ============================================
-- PETS TAB
-- ============================================
Pets:Section("Pet Management")

Pets:Toggle("Auto Equip Best Pets", false, function(state)
    getgenv().autoEquipBestPets = state
    if state then autoEquipBestPets() end
end)

Pets:Toggle("Auto Equip Best Event Pets", false, function(state)
    getgenv().autoEquipBestEventPets = state
    if state then autoEquipBestEventPets() end
end)

Pets:Toggle("Auto Craft All Pets", false, function(state)
    getgenv().autoCraftAllPets = state
    if state then autoCraftAllPets() end
end)

Pets:Toggle("Auto Craft Best Pet", false, function(state)
    getgenv().autoCraftBestPet = state
    if state then autoCraftBestPet() end
end)

Pets:Toggle("Auto Teleport to Pet Shop", false, function(state)
    getgenv().autoTeleportToPetShop = state
    if state then autoTeleportToPetShop() end
end)

Pets:Section("Pet Deletion")

Pets:Toggle("Auto Delete Pets", false, function(state)
    getgenv().autoDeletePets = state
    if state then autoDeletePets() end
end)

local rarityToggles = {
    {Name = "Delete 1 Star", Rarity = 1},
    {Name = "Delete 2 Star", Rarity = 2},
    {Name = "Delete 3 Star", Rarity = 3},
    {Name = "Delete 4 Star", Rarity = 4},
    {Name = "Delete 5 Star", Rarity = 5},
    {Name = "Delete 1 Moon", Rarity = 6},
    {Name = "Delete 2 Moon", Rarity = 7},
    {Name = "Delete 3 Moon", Rarity = 8},
    {Name = "Delete 1 Secret", Rarity = 9}
}

for _, toggleInfo in ipairs(rarityToggles) do
    Pets:Toggle(toggleInfo.Name, false, function(state)
        if state then
            if not table.find(getgenv().selectedRarities, toggleInfo.Rarity) then
                table.insert(getgenv().selectedRarities, toggleInfo.Rarity)
            end
            pcall(function()
                deletePetsByRarity({toggleInfo.Rarity})
            end)
        else
            local index = table.find(getgenv().selectedRarities, toggleInfo.Rarity)
            if index then
                table.remove(getgenv().selectedRarities, index)
            end
        end
    end)
end

-- ============================================
-- UPGRADES TAB
-- ============================================
Upgrades:Section("Auto Buy Upgrades")

Upgrades:Toggle("Auto Buy Saber", false, function(state)
    getgenv().autoBuySaber = state
    if state then autoBuySaber() end
end)

Upgrades:Toggle("Auto Buy DNA", false, function(state)
    getgenv().autoBuyDNA = state
    if state then autoBuyDNA() end
end)

Upgrades:Toggle("Auto Buy Class", false, function(state)
    getgenv().autoBuyClass = state
    if state then autoBuyClass() end
end)

Upgrades:Toggle("Auto Buy Boss Damage", false, function(state)
    getgenv().autoBuyBossDamage = state
    if state then autoBuyBossDamage() end
end)

Upgrades:Toggle("Auto Buy Aura", false, function(state)
    getgenv().autoBuyAura = state
    if state then autoBuyAura() end
end)

Upgrades:Toggle("Auto Buy Pet Aura", false, function(state)
    getgenv().autoBuyPetAura = state
    if state then autoBuyPetAura() end
end)

-- ============================================
-- ELEMENTS TAB
-- ============================================
local tiers = {"Normal", "Advanced", "Master", "Grandmaster"}

for elementName, levels in pairs(ElementZones) do
    Elements:Section(elementName)
    
    for _, tier in ipairs(tiers) do
        if levels[tier] then
            local flagName = string.format("autoFarm%s%s", elementName, tier)
            getgenv()[flagName] = false
            
            Elements:Toggle(string.format("Farm %s (%s)", elementName, tier), false, function(state)
                getgenv()[flagName] = state
                if state then
                    FarmElement(elementName, tier)
                end
            end)
        end
    end
end

Elements:Toggle("Hide Plasma Effects", false, function(state)
    getgenv().hidePlasmaElements = state
    if state then hidePlasmaEffects() end
end)

Elements:Section("Element Teleports")
Elements:Button("TP to Normal Fire", teleportToNormalFire)
Elements:Button("TP to Advanced Fire", teleportToAdvanceFire)
Elements:Button("TP to Master Fire", teleportToMasterFire)
Elements:Button("TP to Grandmaster Fire", teleportToGMasterFire)
Elements:Button("TP to Normal Water", teleportToNormalWater)
Elements:Button("TP to Advanced Water", teleportToAdvanceWater)
Elements:Button("TP to Master Water", teleportToMasterWater)
Elements:Button("TP to Grandmaster Water", teleportToGMasterWater)
Elements:Button("TP to Normal Earth", teleportToNormalEarth)
Elements:Button("TP to Advanced Earth", teleportToAdvanceEarth)
Elements:Button("TP to Master Earth", teleportToMasterEarth)
Elements:Button("TP to Grandmaster Earth", teleportToGMasterEarth)
Elements:Button("TP to Normal Plasma", teleportToNormalPlasma)
Elements:Button("TP to Advanced Plasma", teleportToAdvancePlasma)
Elements:Button("TP to Master Plasma", teleportToMasterPlasma)
Elements:Button("TP to Grandmaster Plasma", teleportToGMasterPlasma)

-- ============================================
-- EVENTS TAB
-- ============================================
Events:Section("Event Automation")

Events:Toggle("Auto Collect Event Currency", false, function(state)
    getgenv().autoCollectEventCurrency = state
    if state then autoCollectEventCurrency() end
end)

Events:Toggle("Auto Teleport to Event Boss", false, function(state)
    getgenv().autoTeleportToEventBoss = state
    if state then autoTeleportToEventBoss() end
end)

Events:Toggle("Auto Walk Event Boss", false, function(state)
    getgenv().autoWalkEventBoss = state
    if state then autoWalkEventBoss() end
end)

Events:Toggle("Auto Buy Event Merchant", false, function(state)
    getgenv().autoBuyEventMerchant = state
    if state then autoBuyEventMerchant() end
end)

Events:Toggle("Auto Buy Traveling Merchant", false, function(state)
    getgenv().autoBuyTravelingMerchant = state
    if state then autoBuyTravelingMerchant() end
end)

Events:Toggle("Auto Invite Top Ranks", false, function(state)
    getgenv().autoInviteTopRanks = state
    if state then autoInviteTopRanks() end
end)

-- TRAVELING MERCHANT DYNAMIC UI SETUP
Events:Section("Traveling Merchant Items")
local function setupTravelingMerchantUI()
    local succ, merchantInfo = pcall(function()
        return require(ReplicatedStorage.Modules.TravelingMerchantInfo)
    end)
    if not succ or not merchantInfo or not merchantInfo.Listings then return end
    
    local groupedItems = {}
    for index, listing in pairs(merchantInfo.Listings) do
        if listing and listing.Name then
            local itemType = listing.Type or "Other"
            if not groupedItems[itemType] then groupedItems[itemType] = {} end
            table.insert(groupedItems[itemType], {Index = index, Name = listing.Name})
        end
    end
    
    for itemType, items in pairs(groupedItems) do
        for _, item in pairs(items) do
            local toggleName = string.format("Buy %s [%s]", item.Name, itemType)
            getgenv()["tm_item_" .. item.Index] = false
            
            Events:Toggle(toggleName, false, function(state)
                getgenv()["tm_item_" .. item.Index] = state
            end)
        end
    end
end
pcall(setupTravelingMerchantUI)

-- ============================================
-- ANTI-AFK TAB
-- ============================================
AntiAFK:Section("Anti-AFK Methods")

AntiAFK:Toggle("Remove Idle Connections", false, function(state)
    if state then removeIdleConnections() end
end)

AntiAFK:Toggle("Movement Anti-AFK", false, function(state)
    getgenv().MovementAntiAFK = state
    if state then movementAntiAFK() end
end)

AntiAFK:Toggle("Simulate Movement", false, function(state)
    getgenv().SimulateMovement = state
    if state then simulateMovement() end
end)

AntiAFK:Dropdown("Movement Direction", {"Front then Back", "Back then Front", "Left then Right", "Right then Left"}, function(selected)
    getgenv().AntiAFKDirection = selected
end)

AntiAFK:Toggle("Simulate Click", false, function(state)
    getgenv().SimulateClick = state
    if state then simulateClick() end
end)

AntiAFK:Toggle("Simulate Jump", false, function(state)
    getgenv().SimulateJump = state
    if state then simulateJump() end
end)

AntiAFK:Toggle("Combined Anti-AFK", false, function(state)
    getgenv().CombinedAntiAFK = state
    if state then combinedAntiAFK() end
end)

AntiAFK:Slider("Anti-AFK Interval (seconds)", 30, 300, 60, function(value)
    getgenv().AntiAFKInterval = value
end)

-- ============================================
-- MISC TAB
-- ============================================
Misc:Section("Character")

Misc:Toggle("Change Walk Speed", false, function(state)
    getgenv().changeWalkSpeed = state
    if state then changeWalkSpeed() end
end)

Misc:Slider("Walk Speed Value", 16, 500, 45, function(value)
    getgenv().WalkSpeedValue = value
end)

Misc:Toggle("Infinite Jump", false, function(state)
    getgenv().infiniteJump = state
    if state then infiniteJump() end
end)

Misc:Section("Visuals")

Misc:Toggle("Hide Visual Effects", false, function(state)
    getgenv().hideVisualEffects = state
    if state then hideVisualEffects() end
end)

Misc:Toggle("Hide Name/Rank UI", false, function(state)
    getgenv().hideNameRankUI = state
    if state then hideNameRankUI() end
end)

Misc:Section("Location")

Misc:Button("Save Current Location", saveCurrentLocation)

Misc:Toggle("Auto TP to Saved Location", false, function(state)
    getgenv().autoTeleportToSavedLocation = state
    if state then autoTeleportToSavedLocation() end
end)

Misc:Button("Teleport to Saved Location", teleportToSavedLocation)

Misc:Button("Teleport to Pet Shop", teleportToPetShop)

Window:Notification("BloodV3 Loaded", "success")
