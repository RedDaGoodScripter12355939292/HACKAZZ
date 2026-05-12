print("v1")
-- ============================================
-- SERVICES & VARIABLES
-- ============================================
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- ============================================
-- ALL FUNCTIONS
-- ============================================

-- ANTI-AFK FUNCTIONS
function removeIdleConnections()
    if getconnections then
        local connections = get_signal_cons(Players.LocalPlayer.Idled)
        for _, connection in pairs(connections or {}) do
            if connection.Disable then
                connection:Disable(connection)
            elseif connection.Disconnect then
                connection:Disconnect(connection)
            end
        end
    end
    
    if not get_signal_cons then
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
    local bossRoot = nil
    local bossHumanoid = nil
    if workspace.Gameplay and workspace.Gameplay.Boss and workspace.Gameplay.Boss.BossHolder then
        for _, descendant in pairs(workspace.Gameplay.Boss.BossHolder:GetDescendants()) do
            if descendant.Name == "HumanoidRootPart" then
                bossRoot = descendant
                bossHumanoid = descendant.Parent:FindFirstChildOfClass("Humanoid")
                break
            end
        end
    end
    return bossRoot, bossHumanoid
end

-- DUNGEON FUNCTIONS
function autoClaimIncubatedPet()
    spawn(function()
        while getgenv().autoClaimIncubated and task do
            local dataManager = require(Players.LocalPlayer.PlayerScripts.MainClient.ClientDataManager)
            local dateTimeManager = require(Players.LocalPlayer.PlayerScripts.MainClient.DateTimeManager)
            
            for slot, data in pairs(dataManager.Data.DungeonHatchery) do
                if data and dateTimeManager:Now() >= data.HatchDT then
                    ReplicatedStorage.Events.UIAction:FireServer("HatchDungeonEgg", slot)
                end
            end
            task.wait(1)
        end
    end)
end

function autoJoinDungeon()
    spawn(function()
        while getgenv().autoJoinDungeon and task do
            local dungeonId = Players.LocalPlayer:GetAttribute("DungeonId")
            if not dungeonId then
                local selectedDungeon = getgenv().SelectedDungeon or "Space"
                local selectedDifficulty = getgenv().SelectedDifficulty or "Normal"
                
                ReplicatedStorage.Events.UIAction:FireServer("DungeonGroupAction", "Create", "Private", selectedDungeon, selectedDifficulty)
                task.wait(0.5)
                ReplicatedStorage.Events.UIAction:FireServer("DungeonGroupAction", "Start")
            end
            task.wait(0.1)
        end
    end)
end

function autoFarmDungeon()
    spawn(function()
        while getgenv().autoFarmDungeon and task do
            if Players.LocalPlayer.Character then
                local dungeonId = Players.LocalPlayer:GetAttribute("DungeonId")
                if dungeonId then
                    local dungeonStorage = workspace.DungeonStorage:FindFirstChild(dungeonId)
                    if dungeonStorage then
                        local importantFolder = dungeonStorage:FindFirstChild("Important")
                        if importantFolder then
                            local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if charRoot then
                                local enemies = {}
                                for _, spawner in pairs(importantFolder:GetChildren()) do
                                    if spawner.Name:lower():find("enemyspawner") then
                                        for _, child in pairs(spawner:GetChildren()) do
                                            if child:IsA("Model") and child:FindFirstChild("Head") then
                                                table.insert(enemies, child.Head)
                                            end
                                        end
                                    end
                                end
                                
                                if #enemies > 0 then
                                    charRoot.CFrame = enemies[1].CFrame + Vector3.new(0, getgenv().DunFarmingDistance or 6, 0)
                                    charRoot.AssemblyLinearVelocity = Vector3.zero
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

function autoCollectDungeonRewards()
    spawn(function()
        while getgenv().autoDungeonRewards and task do
            local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
            local mainGui = playerGui:FindFirstChild("MainGui")
            
            if mainGui and mainGui.OtherFrames and mainGui.OtherFrames.DungeonRewards and mainGui.OtherFrames.DungeonRewards.Visible then
                local yesButton = mainGui.OtherFrames.DungeonRewards.Frame.Buttons.Yes.Button
                if yesButton then
                    firesignal(yesButton.MouseButton1Click)
                end
            end
            task.wait(0.005)
        end
    end)
end

function autoIncubateDungeonEgg()
    spawn(function()
        while getgenv().autoIncubateDungeonEgg and task do
            local dataManager = require(Players.LocalPlayer.PlayerScripts.MainClient.ClientDataManager)
            
            for slot, data in pairs(dataManager.Data.DungeonHatchery or {}) do
                if data and data.CanIncubate then
                    ReplicatedStorage.Events.UIAction:FireServer("IncubateDungeonEgg", slot)
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
    spawn(function()
        while getgenv().autoTeleportToBoss and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                local humanoid = Players.LocalPlayer.Character:WaitForChild("Humanoid")
                local bossRoot, bossHumanoid = getBossData()
                
                if bossRoot then
                    local newCFrame = CFrame.new(
                        bossRoot.Position.X,
                        bossRoot.Position.Y - bossRoot.Size.Y / 2 + humanoid.HipHeight + charRoot.Size.Y / 2 + 0.1,
                        bossRoot.Position.Z
                    )
                    charRoot.CFrame = newCFrame
                    humanoid:MoveTo(bossRoot.Position)
                end
            end
            task.wait()
        end
    end)
end

function autoTeleportBossPremium()
    spawn(function()
        while getgenv().autoTeleportBossPremium and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                local bossRoot, bossHumanoid = getBossData()
                
                if bossRoot and bossHumanoid and bossHumanoid.Health > 0 then
                    local distance = (charRoot.Position - bossRoot.Position).Magnitude
                    if distance > 50 then
                        charRoot.CFrame = bossRoot.CFrame + Vector3.new(0, 3, 0)
                    elseif distance > 15 then
                        charRoot.CFrame = bossRoot.CFrame
                    else
                        -- Bring boss to in front of player (Original Premium Boss behavior)
                        local tween = TweenService:Create(bossRoot, TweenInfo.new(0.5, Enum.EasingStyle.Linear), { CFrame = charRoot.CFrame * CFrame.new(0, 0, -2) })
                        tween:Play()
                    end
                end
            end
            task.wait(0.2)
        end
    end)
end

function autoWalkBossPremium()
    spawn(function()
        local randomDistance = math.random(4, 8)
        
        while getgenv().autoWalkBossPremium and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                local bossRoot, bossHumanoid = getBossData()
                
                if bossRoot and bossHumanoid and bossHumanoid.Health > 0 then
                    getgenv().BossKillerPremWlkAlive = true
                    local distance = (charRoot.Position - bossRoot.Position).Magnitude
                    
                    if distance > 50 then
                        charRoot.CFrame = bossRoot.CFrame + Vector3.new(0, 3, 0)
                    elseif distance > randomDistance then
                        humanoid:MoveTo(bossRoot.Position)
                        humanoid:MoveTo(bossRoot.Position)
                        humanoid:MoveTo(bossRoot.Position)
                        humanoid:MoveTo(bossRoot.Position)
                    else
                        humanoid:MoveTo(charRoot.Position)
                    end
                else
                    getgenv().BossKillerPremWlkAlive = false
                end
            end
            task.wait(0.3)
        end
    end)
end

function autoBringBoss()
    spawn(function()
        while getgenv().autoBringBoss and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                local bossRoot, bossHumanoid = getBossData()
                if bossRoot and bossHumanoid and bossHumanoid.Health > 0 then
                    local tween = TweenService:Create(bossRoot, TweenInfo.new(0.5), { CFrame = charRoot.CFrame })
                    tween:Play()
                end
            end
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

-- EGGS & PETS FUNCTIONS
function autoOpenEgg()
    spawn(function()
        while getgenv().autoOpenEgg and task do
            if getgenv().SelectedEgg then
                ReplicatedStorage.Events.UIAction:FireServer("OpenEgg", getgenv().SelectedEgg)
            end
            task.wait()
        end
    end)
end

function autoCompletePetdex()
    spawn(function()
        while getgenv().autoCompletePetdex and task do
            local dataManager = require(Players.LocalPlayer.PlayerScripts.MainClient.ClientDataManager)
            local petsInfo = require(ReplicatedStorage.Modules.PetsInfo)
            
            local ownedPets = {}
            for petId, _ in pairs(dataManager.Data.Pets or {}) do
                ownedPets[petId] = true
            end
            
            for eggName, eggData in pairs(petsInfo.Eggs) do
                local bestPet = petsInfo:GetBestPetOfRarityFromUnlockedEgg(dataManager.Data, eggData.PetRarityToReward)
                if bestPet and not ownedPets[bestPet] then
                    ReplicatedStorage.Events.UIAction:FireServer("OpenEgg", eggName)
                    task.wait(0.5)
                    break
                end
            end
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
                
                if not petsByType[typeKey] then
                    petsByType[typeKey] = {}
                end
                
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
function deletePetsByRarity()
    local dataManager = require(Players.LocalPlayer.PlayerScripts.MainClient.ClientDataManager)
    local petsToDelete = {}
    
    local rarityMap = {
        ["1_star"] = 1, ["2_star"] = 2, ["3_star"] = 3, 
        ["4_star"] = 4, ["5_star"] = 5, ["1_moon"] = 6, ["2_moon"] = 7
    }
    
    for petId, petData in pairs(dataManager.Data.Pets or {}) do
        local isEquipped = table.find(dataManager.Data.PetsEquipped, petId) ~= nil
        local isLocked = petData.Locked == true
        
        if not isEquipped and not isLocked then
            local rarityNumber = rarityMap[petData.Rarity or ""]
            
            if rarityNumber == 1 and getgenv().delete1Star then table.insert(petsToDelete, petId)
            elseif rarityNumber == 2 and getgenv().delete2Star then table.insert(petsToDelete, petId)
            elseif rarityNumber == 3 and getgenv().delete3Star then table.insert(petsToDelete, petId)
            elseif rarityNumber == 4 and getgenv().delete4Star then table.insert(petsToDelete, petId)
            elseif rarityNumber == 5 and getgenv().delete5Star then table.insert(petsToDelete, petId)
            elseif rarityNumber == 6 and getgenv().delete1Moon then table.insert(petsToDelete, petId)
            elseif rarityNumber == 7 and getgenv().delete2Moon then table.insert(petsToDelete, petId)
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
            deletePetsByRarity()
            task.wait(2)
        end
    end)
end

-- ELEMENT FARMING FUNCTIONS
function bringFireElementsNormal()
    spawn(function()
        while getgenv().bringFireElementsNormal and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    local fireZone = workspace.Gameplay.Map.ElementZones.Fire.Fire
                    if fireZone then
                        for _, child in pairs(fireZone:GetChildren()) do
                            if child:FindFirstChild("HumanoidRootPart") then
                                child.HumanoidRootPart.Anchored = true
                                child.HumanoidRootPart.CFrame = charRoot.CFrame * CFrame.new(0, 0, -2)
                            end
                        end
                    end
                end
            end
            task.wait()
        end
    end)
end

function bringFireElementsAdvance()
    spawn(function()
        while getgenv().bringFireElementsAdvance and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    local fireZone = workspace.Gameplay.RegionsLoaded.AdvancedFireArea.Important.Fire
                    if fireZone then
                        for _, child in pairs(fireZone:GetChildren()) do
                            if child:FindFirstChild("HumanoidRootPart") then
                                child.HumanoidRootPart.Anchored = true
                                child.HumanoidRootPart.CFrame = charRoot.CFrame * CFrame.new(0, 0, -2)
                            end
                        end
                    end
                end
            end
            task.wait()
        end
    end)
end

function bringFireElementsMaster()
    spawn(function()
        while getgenv().bringFireElementsMaster and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    local fireZone = workspace.Gameplay.RegionsLoaded.MasterFireArea.Important.Fire
                    if fireZone then
                        for _, child in pairs(fireZone:GetChildren()) do
                            if child:FindFirstChild("HumanoidRootPart") then
                                child.HumanoidRootPart.Anchored = true
                                child.HumanoidRootPart.CFrame = charRoot.CFrame * CFrame.new(0, 0, -2)
                            end
                        end
                    end
                end
            end
            task.wait()
        end
    end)
end

function bringFireElementsGMaster()
    spawn(function()
        while getgenv().bringFireElementsGMaster and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    local fireZone = workspace.Gameplay.RegionsLoaded.GrandmasterFireArea.Important.Fire
                    if fireZone then
                        for _, child in pairs(fireZone:GetChildren()) do
                            if child:FindFirstChild("HumanoidRootPart") then
                                child.HumanoidRootPart.Anchored = true
                                child.HumanoidRootPart.CFrame = charRoot.CFrame * CFrame.new(0, 0, -2)
                            end
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end

function bringWaterElementsNormal()
    spawn(function()
        while getgenv().bringWaterElementsNormal and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    local waterZone = workspace.Gameplay.Map.ElementZones.Water.Water
                    if waterZone then
                        for _, child in pairs(waterZone:GetChildren()) do
                            if child:FindFirstChild("HumanoidRootPart") then
                                child.HumanoidRootPart.Anchored = true
                                child.HumanoidRootPart.CFrame = charRoot.CFrame * CFrame.new(0, 0, -2)
                            end
                        end
                    end
                end
            end
            task.wait()
        end
    end)
end

function bringWaterElementsAdvance()
    spawn(function()
        while getgenv().bringWaterElementsAdvance and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    local waterZone = workspace.Gameplay.RegionsLoaded.AdvancedWaterArea.Important.Water
                    if waterZone then
                        for _, child in pairs(waterZone:GetChildren()) do
                            if child:FindFirstChild("HumanoidRootPart") then
                                child.HumanoidRootPart.Anchored = true
                                child.HumanoidRootPart.CFrame = charRoot.CFrame * CFrame.new(0, 0, -2)
                            end
                        end
                    end
                end
            end
            task.wait()
        end
    end)
end

function bringWaterElementsMaster()
    spawn(function()
        while getgenv().bringWaterElementsMaster and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    local waterZone = workspace.Gameplay.RegionsLoaded.MasterWaterArea.Important.Water
                    if waterZone then
                        for _, child in pairs(waterZone:GetChildren()) do
                            if child:FindFirstChild("HumanoidRootPart") then
                                child.HumanoidRootPart.Anchored = true
                                child.HumanoidRootPart.CFrame = charRoot.CFrame * CFrame.new(0, 0, -2)
                            end
                        end
                    end
                end
            end
            task.wait()
        end
    end)
end

function bringWaterElementsGMaster()
    spawn(function()
        while getgenv().bringWaterElementsGMaster and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    local waterZone = workspace.Gameplay.RegionsLoaded.GrandmasterWaterArea.Important.Water
                    if waterZone then
                        for _, child in pairs(waterZone:GetChildren()) do
                            if child:FindFirstChild("HumanoidRootPart") then
                                child.HumanoidRootPart.Anchored = true
                                child.HumanoidRootPart.CFrame = charRoot.CFrame * CFrame.new(0, 0, -2)
                            end
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end

function bringEarthElementsNormal()
    spawn(function()
        while getgenv().bringEarthElementsNormal and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    local earthZone = workspace.Gameplay.Map.ElementZones.Earth.Model.Earth
                    if earthZone then
                        for _, child in pairs(earthZone:GetChildren()) do
                            if child:FindFirstChild("HumanoidRootPart") then
                                child.HumanoidRootPart.Anchored = true
                                child.HumanoidRootPart.CFrame = charRoot.CFrame * CFrame.new(0, 0, -2)
                            end
                        end
                    end
                end
            end
            task.wait()
        end
    end)
end

function bringEarthElementsAdvance()
    spawn(function()
        while getgenv().bringEarthElementsAdvance and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    local earthZone = workspace.Gameplay.RegionsLoaded.AdvancedEarthArea.Important.Earth
                    if earthZone then
                        for _, child in pairs(earthZone:GetChildren()) do
                            if child:FindFirstChild("HumanoidRootPart") then
                                child.HumanoidRootPart.Anchored = true
                                child.HumanoidRootPart.CFrame = charRoot.CFrame * CFrame.new(0, 0, -2)
                            end
                        end
                    end
                end
            end
            task.wait()
        end
    end)
end

function bringEarthElementsMaster()
    spawn(function()
        while getgenv().bringEarthElementsMaster and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    local earthZone = workspace.Gameplay.RegionsLoaded.MasterEarthArea.Important.Earth
                    if earthZone then
                        for _, child in pairs(earthZone:GetChildren()) do
                            if child:FindFirstChild("HumanoidRootPart") then
                                child.HumanoidRootPart.Anchored = true
                                child.HumanoidRootPart.CFrame = charRoot.CFrame * CFrame.new(0, 0, -2)
                            end
                        end
                    end
                end
            end
            task.wait()
        end
    end)
end

function bringEarthElementsGMaster()
    spawn(function()
        while getgenv().bringEarthElementsGMaster and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    local earthZone = workspace.Gameplay.RegionsLoaded.GrandmasterEarthArea.Important.Earth
                    if earthZone then
                        for _, child in pairs(earthZone:GetChildren()) do
                            if child:FindFirstChild("HumanoidRootPart") then
                                child.HumanoidRootPart.Anchored = true
                                child.HumanoidRootPart.CFrame = charRoot.CFrame * CFrame.new(0, 0, -2)
                            end
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end

function bringPlasmaElementsNormal()
    spawn(function()
        while getgenv().bringPlasmaElementsNormal and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    local plasmaZone = workspace.Gameplay.Map.ElementZones.Plasma.Plasma
                    if plasmaZone then
                        for _, child in pairs(plasmaZone:GetChildren()) do
                            if child:FindFirstChild("HumanoidRootPart") then
                                child.HumanoidRootPart.Anchored = true
                                child.HumanoidRootPart.CFrame = charRoot.CFrame * CFrame.new(0, 0, -2)
                            end
                        end
                    end
                end
            end
            task.wait()
        end
    end)
end

function bringPlasmaElementsAdvance()
    spawn(function()
        while getgenv().bringPlasmaElementsAdvance and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    local plasmaZone = workspace.Gameplay.RegionsLoaded.AdvancedPlasmaArea.Important.Plasma
                    if plasmaZone then
                        for _, child in pairs(plasmaZone:GetChildren()) do
                            if child:FindFirstChild("HumanoidRootPart") then
                                child.HumanoidRootPart.Anchored = true
                                child.HumanoidRootPart.CFrame = charRoot.CFrame * CFrame.new(0, 0, -2)
                            end
                        end
                    end
                end
            end
            task.wait()
        end
    end)
end

function bringPlasmaElementsMaster()
    spawn(function()
        while getgenv().bringPlasmaElementsMaster and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    local plasmaZone = workspace.Gameplay.RegionsLoaded.MasterPlasmaArea.Important.Plasma
                    if plasmaZone then
                        for _, child in pairs(plasmaZone:GetChildren()) do
                            if child:FindFirstChild("HumanoidRootPart") then
                                child.HumanoidRootPart.Anchored = true
                                child.HumanoidRootPart.CFrame = charRoot.CFrame * CFrame.new(0, 0, -2)
                            end
                        end
                    end
                end
            end
            task.wait()
        end
    end)
end

function bringPlasmaElementsGMaster()
    spawn(function()
        while getgenv().bringPlasmaElementsGMaster and task do
            if Players.LocalPlayer.Character then
                local charRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if charRoot then
                    local plasmaZone = workspace.Gameplay.RegionsLoaded.GrandmasterPlasmaArea.Important.Plasma
                    if plasmaZone then
                        for _, child in pairs(plasmaZone:GetChildren()) do
                            if child:FindFirstChild("HumanoidRootPart") then
                                child.HumanoidRootPart.Anchored = true
                                child.HumanoidRootPart.CFrame = charRoot.CFrame * CFrame.new(0, 0, -2)
                            end
                        end
                    end
                end
            end
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
function autoBuyEventMerchant()
    spawn(function()
        while getgenv().autoBuyEventMerchant and task do
            local dataManager = require(Players.LocalPlayer.PlayerScripts.MainClient.ClientDataManager)
            local merchantInfo = require(ReplicatedStorage.Modules.EventMerchantInfo)
            
            for slot, itemData in pairs(dataManager.Data.EventMerchant.Items or {}) do
                if itemData and itemData.BuysLeft and itemData.BuysLeft > 0 then
                    local listing = merchantInfo.Listings[itemData.Index]
                    if listing then
                        local price = listing.EventCoinsPrice or 0
                        local multiplier = dataManager.Data.EventMerchant.Multi or 1
                        
                        if price * multiplier <= dataManager.Data.EventCoins then
                            ReplicatedStorage.Events.UIAction:FireServer("EventMerchantBuyItem", slot, dataManager.Data.EventMerchant.ResetDT)
                            task.wait(0.5)
                        end
                    end
                end
            end
            task.wait(1)
        end
    end)
end

function autoBuyTravelingMerchant()
    spawn(function()
        while getgenv().autoBuyTravelingMerchant and task do
            local dataManager = require(Players.LocalPlayer.PlayerScripts.MainClient.ClientDataManager)
            local merchantInfo = require(ReplicatedStorage.Modules.TravelingMerchantInfo)
            
            for slot, itemData in pairs(dataManager.Data.TravelingMerchant.Items or {}) do
                if itemData and itemData.BuysLeft and itemData.BuysLeft > 0 then
                    local listing = merchantInfo.Listings[itemData.Index]
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

-- QUEST & PRIORITY FUNCTIONS
function getHighestPriorityQuest()
    local quests = {
        { name = "Dungeon Farm", priority = 100, enabled = function() return getgenv().autoFarmDungeon end, available = function() return Players.LocalPlayer:GetAttribute("DungeonId") ~= nil end },
        { name = "Fire Farm Beta", priority = 99, enabled = function() return getgenv().FireFarmBeta end, available = function() return getgenv().FireFarmBetaAlive ~= false end },
        { name = "Water Farm Beta", priority = 89, enabled = function() return getgenv().WaterFarmBeta end, available = function() return getgenv().WaterFarmBetaAlive ~= false end },
        { name = "Earth Farm Beta", priority = 79, enabled = function() return getgenv().EarthFarmBeta end, available = function() return getgenv().EarthFarmBetaAlive ~= false end },
        { name = "Plasma Farm", priority = 69, enabled = function() return getgenv().NewElementPlasmaFarmingMethodAll or getgenv().NewElementPlasmaFarmingMethodGAll end, available = function() return true end },
        { name = "Boss Killer Premium Walk", priority = 95, enabled = function() return getgenv().autoWalkBossPremium end, available = function() return getgenv().BossKillerPremWlkAlive ~= false end },
        { name = "Boss Killer Premium", priority = 94, enabled = function() return getgenv().autoTeleportBossPremium end, available = function() return true end },
        { name = "Boss Killer", priority = 93, enabled = function() return getgenv().autoTeleportToBoss end, available = function() return true end },
        { name = "Event Boss Walk", priority = 85, enabled = function() return getgenv().autoWalkEventBoss end, available = function() return getgenv().BossKillerPremWlkeventAlive ~= false end },
        { name = "Event Boss", priority = 84, enabled = function() return getgenv().autoTeleportToEventBoss end, available = function() return true end },
        { name = "Auto Equip Pets", priority = 50, enabled = function() return getgenv().autoEquipBestPets or getgenv().autoEquipBestEventPets end, available = function() return true end },
        { name = "Auto Sell DNA", priority = 40, enabled = function() return getgenv().autoSellDNA end, available = function() return true end },
        { name = "Auto Swing", priority = 30, enabled = function() return getgenv().autoSwing end, available = function() return true end },
        { name = "Auto Collect Crowns", priority = 20, enabled = function() return getgenv().autoCrowns end, available = function() return true end },
        { name = "Auto Open Egg", priority = 10, enabled = function() return getgenv().autoOpenEgg end, available = function() return getgenv().SelectedEgg ~= nil end }
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

function executeHighestPriorityQuest()
    spawn(function()
        while getgenv().autoQuestExecute and task do
            local quest = getHighestPriorityQuest()
            if quest then
                print("Executing:", quest.name, "Priority:", quest.priority)
            end
            task.wait(1)
        end
    end)
end

function printPriorityDebug()
    local quests = {
        { name = "Dungeon Farm", priority = 100, enabled = function() return getgenv().autoFarmDungeon end, available = function() return Players.LocalPlayer:GetAttribute("DungeonId") ~= nil end },
        { name = "Fire Farm Beta", priority = 99, enabled = function() return getgenv().FireFarmBeta end, available = function() return getgenv().FireFarmBetaAlive ~= false end },
        { name = "Water Farm Beta", priority = 89, enabled = function() return getgenv().WaterFarmBeta end, available = function() return getgenv().WaterFarmBetaAlive ~= false end },
        { name = "Earth Farm Beta", priority = 79, enabled = function() return getgenv().EarthFarmBeta end, available = function() return getgenv().EarthFarmBetaAlive ~= false end },
        { name = "Plasma Farm", priority = 69, enabled = function() return getgenv().NewElementPlasmaFarmingMethodAll or getgenv().NewElementPlasmaFarmingMethodGAll end, available = function() return true end },
        { name = "Boss Killer Premium Walk", priority = 95, enabled = function() return getgenv().autoWalkBossPremium end, available = function() return getgenv().BossKillerPremWlkAlive ~= false end },
        { name = "Boss Killer Premium", priority = 94, enabled = function() return getgenv().autoTeleportBossPremium end, available = function() return true end },
        { name = "Boss Killer", priority = 93, enabled = function() return getgenv().autoTeleportToBoss end, available = function() return true end },
        { name = "Auto Swing", priority = 30, enabled = function() return getgenv().autoSwing end, available = function() return true end },
        { name = "Auto Sell DNA", priority = 40, enabled = function() return getgenv().autoSellDNA end, available = function() return true end },
        { name = "Auto Crowns", priority = 20, enabled = function() return getgenv().autoCrowns end, available = function() return true end },
        { name = "Auto Open Egg", priority = 10, enabled = function() return getgenv().autoOpenEgg end, available = function() return getgenv().SelectedEgg ~= nil end }
    }
    
    table.sort(quests, function(a, b) return a.priority > b.priority end)
    
    print("================ Priority Debug ================")
    print(string.format("%-40s %-8s %-10s %-10s", "Action", "Priority", "Enabled", "Available"))
    print(string.rep("-", 65))
    
    local currentQuest = getHighestPriorityQuest()
    
    for _, quest in pairs(quests) do
        local isEnabled = pcall(quest.enabled)
        local isAvailable = pcall(quest.available)
        local selected = ""
        if currentQuest and currentQuest.name == quest.name then selected = " <--" end
        print(string.format("%-40s %-8d %-10s %-10s%s", quest.name, quest.priority, tostring(isEnabled), tostring(isAvailable), selected))
    end
    
    print("================================================\n")
    if currentQuest then
        print("CURRENT: " .. currentQuest.name .. " (Priority: " .. currentQuest.priority .. ")")
    else
        print("NO ACTION SELECTED")
    end
end


-- ============================================
-- FLUENT UI LIBRARY SETUP
-- ============================================
local Fluent = loadstring(game:HttpGet("https://github.com/StyearX/Fluent-Modded/releases/download/Fluent/FluentLite"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/StyearX/Fluent-modded/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/StyearX/Fluent-modded/main/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Saber Simulator Hub",
    SubTitle = "Ultimate Automation",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main" }),
    Dungeon = Window:AddTab({ Title = "Dungeon" }),
    Upgrades = Window:AddTab({ Title = "Upgrades" }),
    Pets = Window:AddTab({ Title = "Pets" }),
    Elements = Window:AddTab({ Title = "Elements" }),
    Events = Window:AddTab({ Title = "Events" }),
    AntiAFK = Window:AddTab({ Title = "Anti-AFK" }),
    Misc = Window:AddTab({ Title = "Misc" })
}

-- ============================================
-- TAB: MAIN
-- ============================================
Tabs.Main:AddSection("Automation")
Tabs.Main:AddToggle("AutoSwing", {Title = "Auto Swing", Default = false}):OnChanged(function(v) getgenv().autoSwing = v if v then autoSwing() end end)
Tabs.Main:AddToggle("AutoSellDNA", {Title = "Auto Sell DNA", Default = false}):OnChanged(function(v) getgenv().autoSellDNA = v if v then autoSellDNA() end end)
Tabs.Main:AddToggle("AutoCrowns", {Title = "Auto Collect Crowns", Default = false}):OnChanged(function(v) getgenv().autoCrowns = v if v then autoCollectCrowns() end end)
Tabs.Main:AddToggle("AutoDaily", {Title = "Auto Collect Daily", Default = false}):OnChanged(function(v) getgenv().autoCollectDaily = v if v then autoCollectDaily() end end)

Tabs.Main:AddSection("Boss")
Tabs.Main:AddToggle("AutoTeleportToBoss", {Title = "Auto Teleport To Boss", Default = false}):OnChanged(function(v) getgenv().autoTeleportToBoss = v if v then autoTeleportToBoss() end end)
Tabs.Main:AddToggle("AutoTeleportBossPremium", {Title = "Auto Teleport Boss Premium", Default = false}):OnChanged(function(v) getgenv().autoTeleportBossPremium = v if v then autoTeleportBossPremium() end end)
Tabs.Main:AddToggle("AutoWalkBossPremium", {Title = "Auto Walk Boss Premium", Default = false}):OnChanged(function(v) getgenv().autoWalkBossPremium = v if v then autoWalkBossPremium() end end)
Tabs.Main:AddToggle("AutoBringBoss", {Title = "Auto Bring Boss", Default = false}):OnChanged(function(v) getgenv().autoBringBoss = v if v then autoBringBoss() end end)

-- ============================================
-- TAB: DUNGEON
-- ============================================
Tabs.Dungeon:AddSection("Dungeon Farm")
Tabs.Dungeon:AddToggle("AutoJoinDungeon", {Title = "Auto Join Dungeon", Default = false}):OnChanged(function(v) getgenv().autoJoinDungeon = v if v then autoJoinDungeon() end end)
Tabs.Dungeon:AddDropdown("SelectedDungeon", {Title = "Select Dungeon", Values = {"Space"}, Default = 1}):OnChanged(function(v) getgenv().SelectedDungeon = v end)
Tabs.Dungeon:AddDropdown("SelectedDifficulty", {Title = "Select Difficulty", Values = {"Normal", "Hard", "Nightmare"}, Default = 1}):OnChanged(function(v) getgenv().SelectedDifficulty = v end)
Tabs.Dungeon:AddToggle("AutoFarmDungeon", {Title = "Auto Farm Dungeon", Default = false}):OnChanged(function(v) getgenv().autoFarmDungeon = v if v then autoFarmDungeon() end end)
Tabs.Dungeon:AddSlider("DunFarmingDistance", {Title = "Farming Distance", Default = 6, Min = 1, Max = 20, Rounding = 0}):OnChanged(function(v) getgenv().DunFarmingDistance = v end)

Tabs.Dungeon:AddSection("Dungeon Eggs & Rewards")
Tabs.Dungeon:AddToggle("AutoIncubateDungeonEgg", {Title = "Auto Incubate Dungeon Egg", Default = false}):OnChanged(function(v) getgenv().autoIncubateDungeonEgg = v if v then autoIncubateDungeonEgg() end end)
Tabs.Dungeon:AddToggle("AutoClaimIncubatedPet", {Title = "Auto Claim Incubated Pet", Default = false}):OnChanged(function(v) getgenv().autoClaimIncubated = v if v then autoClaimIncubatedPet() end end)
Tabs.Dungeon:AddToggle("AutoDungeonRewards", {Title = "Auto Collect Dungeon Rewards", Default = false}):OnChanged(function(v) getgenv().autoDungeonRewards = v if v then autoCollectDungeonRewards() end end)

-- ============================================
-- TAB: UPGRADES
-- ============================================
Tabs.Upgrades:AddSection("Auto Buy Upgrades")
Tabs.Upgrades:AddToggle("AutoBuySaber", {Title = "Auto Buy Saber", Default = false}):OnChanged(function(v) getgenv().autoBuySaber = v if v then autoBuySaber() end end)
Tabs.Upgrades:AddToggle("AutoBuyDNA", {Title = "Auto Buy DNA", Default = false}):OnChanged(function(v) getgenv().autoBuyDNA = v if v then autoBuyDNA() end end)
Tabs.Upgrades:AddToggle("AutoBuyClass", {Title = "Auto Buy Class", Default = false}):OnChanged(function(v) getgenv().autoBuyClass = v if v then autoBuyClass() end end)
Tabs.Upgrades:AddToggle("AutoBuyBossDamage", {Title = "Auto Buy Boss Damage", Default = false}):OnChanged(function(v) getgenv().autoBuyBossDamage = v if v then autoBuyBossDamage() end end)
Tabs.Upgrades:AddToggle("AutoBuyAura", {Title = "Auto Buy Aura", Default = false}):OnChanged(function(v) getgenv().autoBuyAura = v if v then autoBuyAura() end end)
Tabs.Upgrades:AddToggle("AutoBuyPetAura", {Title = "Auto Buy Pet Aura", Default = false}):OnChanged(function(v) getgenv().autoBuyPetAura = v if v then autoBuyPetAura() end end)

Tabs.Upgrades:AddSection("Merchants")
Tabs.Upgrades:AddToggle("AutoBuyEventMerchant", {Title = "Auto Buy Event Merchant", Default = false}):OnChanged(function(v) getgenv().autoBuyEventMerchant = v if v then autoBuyEventMerchant() end end)
Tabs.Upgrades:AddToggle("AutoBuyTravelingMerchant", {Title = "Auto Buy Traveling Merchant", Default = false}):OnChanged(function(v) getgenv().autoBuyTravelingMerchant = v if v then autoBuyTravelingMerchant() end end)

-- ============================================
-- TAB: PETS
-- ============================================
Tabs.Pets:AddSection("Eggs")
Tabs.Pets:AddDropdown("SelectedEgg", {Title = "Select Egg", Values = {"Starter Egg", "Forest Egg", "Cave Egg", "Volcano Egg", "Ice Egg", "Ocean Egg"}, Default = 1}):OnChanged(function(v) getgenv().SelectedEgg = v end)
Tabs.Pets:AddToggle("AutoOpenEgg", {Title = "Auto Open Egg", Default = false}):OnChanged(function(v) getgenv().autoOpenEgg = v if v then autoOpenEgg() end end)
Tabs.Pets:AddToggle("AutoCompletePetdex", {Title = "Auto Complete Petdex", Default = false}):OnChanged(function(v) getgenv().autoCompletePetdex = v if v then autoCompletePetdex() end end)
Tabs.Pets:AddToggle("AutoRedeemPetdexRewards", {Title = "Auto Redeem Petdex Rewards", Default = false}):OnChanged(function(v) getgenv().autoRedeemPetdexRewards = v if v then autoRedeemPetdexRewards() end end)

Tabs.Pets:AddSection("Pet Management")
Tabs.Pets:AddToggle("AutoEquipBestPets", {Title = "Auto Equip Best Pets", Default = false}):OnChanged(function(v) getgenv().autoEquipBestPets = v if v then autoEquipBestPets() end end)
Tabs.Pets:AddToggle("AutoEquipBestEventPets", {Title = "Auto Equip Best Event Pets", Default = false}):OnChanged(function(v) getgenv().autoEquipBestEventPets = v if v then autoEquipBestEventPets() end end)
Tabs.Pets:AddToggle("AutoCraftAllPets", {Title = "Auto Craft All Pets", Default = false}):OnChanged(function(v) getgenv().autoCraftAllPets = v if v then autoCraftAllPets() end end)
Tabs.Pets:AddToggle("AutoCraftBestPet", {Title = "Auto Craft Best Pet", Default = false}):OnChanged(function(v) getgenv().autoCraftBestPet = v if v then autoCraftBestPet() end end)
Tabs.Pets:AddButton("Teleport to Pet Shop", function() teleportToPetShop() end)

Tabs.Pets:AddSection("Pet Deletion")
Tabs.Pets:AddToggle("AutoDeletePets", {Title = "Auto Delete Selected Rarities", Default = false}):OnChanged(function(v) getgenv().autoDeletePets = v if v then autoDeletePets() end end)
Tabs.Pets:AddToggle("Delete1Star", {Title = "Delete 1 Star", Default = false}):OnChanged(function(v) getgenv().delete1Star = v end)
Tabs.Pets:AddToggle("Delete2Star", {Title = "Delete 2 Star", Default = false}):OnChanged(function(v) getgenv().delete2Star = v end)
Tabs.Pets:AddToggle("Delete3Star", {Title = "Delete 3 Star", Default = false}):OnChanged(function(v) getgenv().delete3Star = v end)
Tabs.Pets:AddToggle("Delete4Star", {Title = "Delete 4 Star", Default = false}):OnChanged(function(v) getgenv().delete4Star = v end)
Tabs.Pets:AddToggle("Delete5Star", {Title = "Delete 5 Star", Default = false}):OnChanged(function(v) getgenv().delete5Star = v end)
Tabs.Pets:AddToggle("Delete1Moon", {Title = "Delete 1 Moon", Default = false}):OnChanged(function(v) getgenv().delete1Moon = v end)
Tabs.Pets:AddToggle("Delete2Moon", {Title = "Delete 2 Moon", Default = false}):OnChanged(function(v) getgenv().delete2Moon = v end)

-- ============================================
-- TAB: ELEMENTS (Fixed Buttons)
-- ============================================
Tabs.Elements:AddSection("Fire Elements")
Tabs.Elements:AddToggle("BringFireNormal", {Title = "Bring Normal Fire", Default = false}):OnChanged(function(v) getgenv().bringFireElementsNormal = v if v then bringFireElementsNormal() end end)
Tabs.Elements:AddToggle("BringFireAdvance", {Title = "Bring Advance Fire", Default = false}):OnChanged(function(v) getgenv().bringFireElementsAdvance = v if v then bringFireElementsAdvance() end end)
Tabs.Elements:AddToggle("BringFireMaster", {Title = "Bring Master Fire", Default = false}):OnChanged(function(v) getgenv().bringFireElementsMaster = v if v then bringFireElementsMaster() end end)
Tabs.Elements:AddToggle("BringFireGMaster", {Title = "Bring GMaster Fire", Default = false}):OnChanged(function(v) getgenv().bringFireElementsGMaster = v if v then bringFireElementsGMaster() end end)

Tabs.Elements:AddSection("Water Elements")
Tabs.Elements:AddToggle("BringWaterNormal", {Title = "Bring Normal Water", Default = false}):OnChanged(function(v) getgenv().bringWaterElementsNormal = v if v then bringWaterElementsNormal() end end)
Tabs.Elements:AddToggle("BringWaterAdvance", {Title = "Bring Advance Water", Default = false}):OnChanged(function(v) getgenv().bringWaterElementsAdvance = v if v then bringWaterElementsAdvance() end end)
Tabs.Elements:AddToggle("BringWaterMaster", {Title = "Bring Master Water", Default = false}):OnChanged(function(v) getgenv().bringWaterElementsMaster = v if v then bringWaterElementsMaster() end end)
Tabs.Elements:AddToggle("BringWaterGMaster", {Title = "Bring GMaster Water", Default = false}):OnChanged(function(v) getgenv().bringWaterElementsGMaster = v if v then bringWaterElementsGMaster() end end)

Tabs.Elements:AddSection("Earth Elements")
Tabs.Elements:AddToggle("BringEarthNormal", {Title = "Bring Normal Earth", Default = false}):OnChanged(function(v) getgenv().bringEarthElementsNormal = v if v then bringEarthElementsNormal() end end)
Tabs.Elements:AddToggle("BringEarthAdvance", {Title = "Bring Advance Earth", Default = false}):OnChanged(function(v) getgenv().bringEarthElementsAdvance = v if v then bringEarthElementsAdvance() end end)
Tabs.Elements:AddToggle("BringEarthMaster", {Title = "Bring Master Earth", Default = false}):OnChanged(function(v) getgenv().bringEarthElementsMaster = v if v then bringEarthElementsMaster() end end)
Tabs.Elements:AddToggle("BringEarthGMaster", {Title = "Bring GMaster Earth", Default = false}):OnChanged(function(v) getgenv().bringEarthElementsGMaster = v if v then bringEarthElementsGMaster() end end)

Tabs.Elements:AddSection("Plasma Elements")
Tabs.Elements:AddToggle("BringPlasmaNormal", {Title = "Bring Normal Plasma", Default = false}):OnChanged(function(v) getgenv().bringPlasmaElementsNormal = v if v then bringPlasmaElementsNormal() end end)
Tabs.Elements:AddToggle("BringPlasmaAdvance", {Title = "Bring Advance Plasma", Default = false}):OnChanged(function(v) getgenv().bringPlasmaElementsAdvance = v if v then bringPlasmaElementsAdvance() end end)
Tabs.Elements:AddToggle("BringPlasmaMaster", {Title = "Bring Master Plasma", Default = false}):OnChanged(function(v) getgenv().bringPlasmaElementsMaster = v if v then bringPlasmaElementsMaster() end end)
Tabs.Elements:AddToggle("BringPlasmaGMaster", {Title = "Bring GMaster Plasma", Default = false}):OnChanged(function(v) getgenv().bringPlasmaElementsGMaster = v if v then bringPlasmaElementsGMaster() end end)
Tabs.Elements:AddToggle("HidePlasmaElements", {Title = "Hide Plasma Elements", Default = false}):OnChanged(function(v) getgenv().hidePlasmaElements = v if v then hidePlasmaElements() end end)

Tabs.Elements:AddSection("Element Teleports")
Tabs.Elements:AddButton({Title = "TP Normal Fire"}, function() teleportToNormalFire() end)
Tabs.Elements:AddButton({Title = "TP Advance Fire"}, function() teleportToAdvanceFire() end)
Tabs.Elements:AddButton({Title = "TP Master Fire"}, function() teleportToMasterFire() end)
Tabs.Elements:AddButton({Title = "TP GMaster Fire"}, function() teleportToGMasterFire() end)
Tabs.Elements:AddButton({Title = "TP Normal Water"}, function() teleportToNormalWater() end)
Tabs.Elements:AddButton({Title = "TP Advance Water"}, function() teleportToAdvanceWater() end)
Tabs.Elements:AddButton({Title = "TP Master Water"}, function() teleportToMasterWater() end)
Tabs.Elements:AddButton({Title = "TP GMaster Water"}, function() teleportToGMasterWater() end)
Tabs.Elements:AddButton({Title = "TP Normal Earth"}, function() teleportToNormalEarth() end)
Tabs.Elements:AddButton({Title = "TP Advance Earth"}, function() teleportToAdvanceEarth() end)
Tabs.Elements:AddButton({Title = "TP Master Earth"}, function() teleportToMasterEarth() end)
Tabs.Elements:AddButton({Title = "TP GMaster Earth"}, function() teleportToGMasterEarth() end)
Tabs.Elements:AddButton({Title = "TP Normal Plasma"}, function() teleportToNormalPlasma() end)
Tabs.Elements:AddButton({Title = "TP Advance Plasma"}, function() teleportToAdvancePlasma() end)
Tabs.Elements:AddButton({Title = "TP Master Plasma"}, function() teleportToMasterPlasma() end)
Tabs.Elements:AddButton({Title = "TP GMaster Plasma"}, function() teleportToGMasterPlasma() end)

-- ============================================
-- TAB: EVENTS
-- ============================================
Tabs.Events:AddSection("Event Automation")
Tabs.Events:AddToggle("AutoCollectEventCurrency", {Title = "Auto Collect Event Currency", Default = false}):OnChanged(function(v) getgenv().autoCollectEventCurrency = v if v then autoCollectEventCurrency() end end)
Tabs.Events:AddToggle("AutoTeleportToEventBoss", {Title = "Auto Teleport To Event Boss", Default = false}):OnChanged(function(v) getgenv().autoTeleportToEventBoss = v if v then autoTeleportToEventBoss() end end)
Tabs.Events:AddToggle("AutoWalkEventBoss", {Title = "Auto Walk Event Boss", Default = false}):OnChanged(function(v) getgenv().autoWalkEventBoss = v if v then autoWalkEventBoss() end end)

-- ============================================
-- TAB: ANTI-AFK (Fixed Button)
-- ============================================
Tabs.AntiAFK:AddSection("Anti-AFK Settings")
Tabs.AntiAFK:AddButton({Title = "Remove Idle Connections"}, function() removeIdleConnections() end)
Tabs.AntiAFK:AddToggle("MovementAntiAFK", {Title = "Movement Anti-AFK (W Key)", Default = false}):OnChanged(function(v) getgenv().MovementAntiAFK = v if v then movementAntiAFK() end end)
Tabs.AntiAFK:AddToggle("CombinedAntiAFK", {Title = "Combined Anti-AFK", Default = false}):OnChanged(function(v) getgenv().CombinedAntiAFK = v if v then combinedAntiAFK() end end)
Tabs.AntiAFK:AddToggle("SimulateMovement", {Title = "Simulate Movement", Default = false}):OnChanged(function(v) getgenv().SimulateMovement = v if v then simulateMovement() end end)
Tabs.AntiAFK:AddToggle("SimulateClick", {Title = "Simulate Click", Default = false}):OnChanged(function(v) getgenv().SimulateClick = v if v then simulateClick() end end)
Tabs.AntiAFK:AddToggle("SimulateJump", {Title = "Simulate Jump", Default = false}):OnChanged(function(v) getgenv().SimulateJump = v if v then simulateJump() end end)
Tabs.AntiAFK:AddDropdown("AntiAFKDirection", {Title = "Simulate Movement Direction", Values = {"Front then Back", "Back then Front", "Left then Right", "Right then Left"}, Default = 1}):OnChanged(function(v) getgenv().AntiAFKDirection = v end)
Tabs.AntiAFK:AddSlider("AntiAFKInterval", {Title = "Anti-AFK Interval (Seconds)", Default = 60, Min = 5, Max = 300, Rounding = 0}):OnChanged(function(v) getgenv().AntiAFKInterval = v end)

-- ============================================
-- TAB: MISC (Fixed Buttons)
-- ============================================
Tabs.Misc:AddSection("Character Modifiers")
Tabs.Misc:AddToggle("ChangeWalkSpeed", {Title = "Custom Walk Speed", Default = false}):OnChanged(function(v) getgenv().changeWalkSpeed = v if v then changeWalkSpeed() end end)
Tabs.Misc:AddSlider("WalkSpeedValue", {Title = "Walk Speed Value", Default = 45, Min = 16, Max = 200, Rounding = 0}):OnChanged(function(v) getgenv().WalkSpeedValue = v end)
Tabs.Misc:AddToggle("InfiniteJump", {Title = "Infinite Jump", Default = false}):OnChanged(function(v) getgenv().infiniteJump = v if v then infiniteJump() end end)

Tabs.Misc:AddSection("Visual Tweaks")
Tabs.Misc:AddToggle("HideVisualEffects", {Title = "Hide Visual Effects", Default = false}):OnChanged(function(v) getgenv().hideVisualEffects = v if v then hideVisualEffects() end end)
Tabs.Misc:AddToggle("HideNameRankUI", {Title = "Hide/Modify Name Rank UI", Default = false}):OnChanged(function(v) getgenv().hideNameRankUI = v if v then hideNameRankUI() end end)

Tabs.Misc:AddSection("Custom Teleport")
Tabs.Misc:AddButton({Title = "Save Current Location"}, function() saveCurrentLocation() end)
Tabs.Misc:AddButton({Title = "Teleport To Saved Location"}, function() teleportToSavedLocation() end)
Tabs.Misc:AddToggle("AutoTeleportToSavedLocation", {Title = "Loop Teleport To Saved", Default = false}):OnChanged(function(v) getgenv().autoTeleportToSavedLocation = v if v then autoTeleportToSavedLocation() end end)

Tabs.Misc:AddSection("Clan & Quest")
Tabs.Misc:AddToggle("AutoInviteTopRanks", {Title = "Auto Invite Top Ranks", Default = false}):OnChanged(function(v) getgenv().autoInviteTopRanks = v if v then autoInviteTopRanks() end end)
Tabs.Misc:AddToggle("AutoQuestExecute", {Title = "Execute Highest Priority Quest", Default = false}):OnChanged(function(v) getgenv().autoQuestExecute = v if v then executeHighestPriorityQuest() end end)
Tabs.Misc:AddButton({Title = "Print Priority Debug"}, function() printPriorityDebug() end)
-- ============================================
-- FLUENT ADDONS SETUP
-- ============================================
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

SaveManager:BuildConfigSection(Tabs.Misc)
InterfaceManager:BuildInterfaceSection(Tabs.Misc)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Hub Loaded",
    Content = "Saber Simulator script is ready!",
    Duration = 5
})
