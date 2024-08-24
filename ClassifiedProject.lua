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

local CacheReplacing = {}
local EnriseXResize = {}
local Players = {}

local AllowedIndex = {
    ["name"] = true,
    ["parent"] = true,
    ["position"] = true,
    ["cframe"] = true,
    ["cancollide"] = true,
    ["canquery"] = true,
    ["cantouch"] = true,
    ["castshadow"] = true,
    ["transparency"] = true,
    ["localtransparencymodifier"] = true,
    ["orientation"] = true,
    ["isa"] = true
}

local Signals = {
    ["touched"] = true,
    ["touchended"] = true,
    ["stoppedtouching"] = true,
    ["localsimulationtouched"] = true,
    ["changed"] = true,
    ["childadded"] = true,
    ["descendantadded"] = true
}

local AllowedCall = {
    ["GetTouchingParts"] = true,
    ["getTouchingParts"] = true,
    ["GetConnectedParts"] = true,
    ["getConnectedParts"] = true,
    ["GetPartBoundsInBox"] = true,
    ["GetPartBoundsInRadius"] = true,
    ["FindPartsInRegion3"] = true,
    ["findPartsInRegion3"] = true,
    ["FindPartsInRegion3WithWhiteList"] = true,
    ["findPartsInRegion3WithWhiteList"] = true,
    ["GetRenderCFrame"] = true,
    ["getRenderCFrame"] = true,
    ["IsA"] = true,
    ["isA"] = true
}

EnriseXResize["Players"] = game:GetService("Players")
EnriseXResize["Client"] = EnriseXResize["Players"]["LocalPlayer"]
EnriseXResize["Mouse"] = EnriseXResize["Client"]:GetMouse()
EnriseXResize["Parents"] = {}
EnriseXResize["HandleReach"] = 1
local Library = loadstring(game:HttpGet("https://pastebin.com/raw/X3UN23xh"))()

-- dont ask
local Functions = {
    
    ----------------------------------------
    
    Instance.new("Part").Clone,
    Instance.new("Part").clone,
    
    Instance.new("WedgePart").Clone,
    Instance.new("WedgePart").clone,
    
    Instance.new("MeshPart").Clone,
    Instance.new("MeshPart").clone,
    
    Instance.new("BindableEvent").Clone,
    Instance.new("BindableEvent").clone,
    
    Instance.new("RemoteEvent").Clone,
    Instance.new("RemoteEvent").clone,
    
    Instance.new("RemoteFunction").Clone,
    Instance.new("RemoteFunction").clone,
    
    Instance.new("BindableFunction").Clone,
    Instance.new("BindableFunction").clone,
    
    Instance.new("StringValue").Clone,
    Instance.new("StringValue").clone,
    
    Instance.new("IntValue").Clone,
    Instance.new("IntValue").clone,
    
    Instance.new("Model").Clone,
    Instance.new("Model").clone,
    
    ----------------------------------------
    
    Instance.new("Part").Resize,
    Instance.new("Part").resize,
    
    Instance.new("MeshPart").Resize,
    Instance.new("MeshPart").resize,
    
    Instance.new("WedgePart").Resize,
    Instance.new("WedgePart").resize
    
    ----------------------------------------
    
}

for i, v in pairs(Functions) do
    local Old
    Old = hookfunction(v, newcclosure(function(Object, ...)
        if not checkcaller() and CacheReplacing[Object] then
            return Old(CacheReplacing[Object], ...)
        else
            if not checkcaller() then
                --for i, v in pairs(EnriseXResize:GetAllParents(Object)) do
                    if table.find(EnriseXResize["Parents"], Object) then
                        local OldObjects = {}
                        local ReplacedWith = nil
                        for i, v in pairs(Object:GetDescendants()) do
                            if CacheReplacing[v] then
                                table.insert(OldObjects, v)
                                v:SetAttribute("HANDLE", "h")
                                ReplacedWith = CacheReplacing[v]
                                break
                            end
                        end
                        local Callback = Old(Object, ...)
                        for i, v in pairs(Callback:GetDescendants()) do
                            if v:GetAttribute("HANDLE") == "h" and ReplacedWith then
                                local Old = v.Parent
                                v:Destroy()
                                ReplaceWith.Parent = Old
                                break
                            end
                        end
                        for i, v in pairs(OldObjects) do
                            v:SetAttribute("HANDLE", false)
                        end
                        return Callback
                    end
                --end
            end
        end
        return Old(Object, ...)
    end))
end

local synapseFunc = ""
local old = {}

function EnriseXResize:Disconnect(Signal)
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES

    for i, v in pairs(getconnections(Signal)) do if not islclosure(v.Function) then continue end if v.Function == synapseFunc then continue end if not old[v.Function] then old[v.Function] = hookfunction(v.Function, newcclosure(function() end)) else hookfunction(v.Function, newcclosure(function() end)) end end
end;

function EnriseXResize:Connect(Signal)
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES
    -- FUNCTION MODIFIED BECAUSE IT USED SYNAPSE V3 FEATURES

    for i, v in pairs(getconnections(Signal)) do if v.Function == synapseFunc then continue end hookfunction(v.Function, old[v.Function]) end
end;

function EnriseXResize:GetAllParents(Object)
    local CurrentParent = Object.Parent
    local Parents = {CurrentParent}
    local t = true
    
    repeat
        local s, e = pcall(function()
            CurrentParent = CurrentParent.Parent or nil
            table.insert(Parents, CurrentParent)
        end)
        t = s
    until
        not CurrentParent or not t
    
    return Parents
end;

local Current = nil
function EnriseXResize:Notify(Text2, Time, ...)
    -- // Always use Drawing API, or you are officially a skid
    if Current then
        Current:Remove()
        Current = nil
    end
    local Type = Drawing.new("Text")
    Current = Type
    local Old = Type
    Type.Outline = true
    Type.Size = 30.0
    Type.Center = true
    Type.Visible = true
    Type.Color = Color3.fromRGB(165, 0, 255)
    local screen = workspace.CurrentCamera.ViewportSize
    local goal = Vector2.new(screen.X / 2, screen.Y / 1.2)
    Type.Position = goal
    Type.Text = "[BLOODSCRIPT]: " .. Text2
    task.delay(Time, function(...)
        if not Current or Current ~= Old then
            return
        end
        local old = Current
        Current = nil
        old:Remove()
    end)
end

function EnriseXResize:GetTouchingParts(Object)
    local Parents = EnriseXResize:GetAllParents(Object)
    for i, v in pairs(Parents) do
        if v == Object.Parent then
            EnriseXResize:Disconnect(Object.ChildAdded)
            EnriseXResize:Disconnect(Object.childAdded)
        end
        EnriseXResize:Disconnect(Object.DescendantAdded)
        EnriseXResize:Disconnect(Object.descendantAdded)
    end
    
    local Connection = Object.Touched:Connect(function(...) end)
    local Touching = Object:GetTouchingParts()
    Connection:Disconnect()
    
    for i, v in pairs(Parents) do
        if v == Object.Parent then
            EnriseXResize:Connect(Object.ChildAdded)
            EnriseXResize:Connect(Object.childAdded)
        end
        EnriseXResize:Connect(Object.DescendantAdded)
        EnriseXResize:Connect(Object.descendantAdded)
    end
    
    return Touching
end;

function EnriseXResize:Get(Object, Char)
    local Touching = {}
    for i, v in pairs(EnriseXResize:GetTouchingParts(Object)) do
        if (not isnetworkowner(v) and v:FindFirstChildOfClass("TouchTransmitter") and tostring(v) ~= "Right Arm")
            or (v.Size ~= Vector3.new(1, 2, 1) and v.Size ~= Vector3.new(2, 2, 1) and v.Size ~= Vector3.new(2, 1, 1) and v.Size.X <= 10 and v.Size.Y <= 10 and v.Size.Z <= 10) then
                table.insert(Touching, v)
        end
    end
    return Touching
end;

local Update = nil;
function EnriseXResize:Initiate(Object, Char)
    local IndexedUpdate = 0
    local Spoofed = Object:Clone();
    CacheReplacing[Object] = Spoofed;
    EnriseXResize["Parents"] = EnriseXResize:GetAllParents(Object)
    Object.AncestryChanged:Connect(function(...)
        EnriseXResize["Parents"] = EnriseXResize:GetAllParents(Object)
    end)
    local ResizedParts = {}
    local Old = Object["Size"]
    Update = function(Old2, a, ...)
        if a == 1 then
            for i, v in pairs(ResizedParts) do
                EnriseXResize:Disconnect(v.Changed);
                EnriseXResize:Disconnect(v:GetPropertyChangedSignal("Size"));
                EnriseXResize:Disconnect(v:GetPropertyChangedSignal("Mass"));
                EnriseXResize:Disconnect(v:GetPropertyChangedSignal("Massless"));
                EnriseXResize:Disconnect(v:GetPropertyChangedSignal("AssemblyMass"));
                EnriseXResize:Disconnect(v:GetPropertyChangedSignal("CenterOfMass"));
                EnriseXResize:Disconnect(v:GetPropertyChangedSignal("AssemblyCenterOfMass"));
                EnriseXResize:Disconnect(v:GetPropertyChangedSignal("CanCollide"));
                
                if not Config.Closet.Lunge_Only then
                    v.Size = Vector3.new(v.Size.X + (Config.ScaleReach.X - Old2.X), v.Size.Y + (Config.ScaleReach.Y - Old2.Y), v.Size.Z + (Config.ScaleReach.Z - Old2.Z))
                end
                
                EnriseXResize:Connect(v.Changed);
                EnriseXResize:Connect(v:GetPropertyChangedSignal("Size"));
                EnriseXResize:Connect(v:GetPropertyChangedSignal("Mass"));
                EnriseXResize:Connect(v:GetPropertyChangedSignal("Massless"));
                EnriseXResize:Connect(v:GetPropertyChangedSignal("AssemblyMass"));
                EnriseXResize:Connect(v:GetPropertyChangedSignal("CenterOfMass"));
                EnriseXResize:Connect(v:GetPropertyChangedSignal("AssemblyCenterOfMass"));
                EnriseXResize:Connect(v:GetPropertyChangedSignal("CanCollide"));
            end
            return
        end
        IndexedUpdate = 1
        EnriseXResize:Disconnect(Object.Changed);
        EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("Size"));
        EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("Mass"));
        EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("Massless"));
        EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("AssemblyMass"));
        EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("CenterOfMass"));
        EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("AssemblyCenterOfMass"));
        EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("CanCollide"));
        local PossibleFakeParts = EnriseXResize:Get(Object, Char);
        if #PossibleFakeParts > 0 then
            for i, v in pairs(PossibleFakeParts) do
                if v.Size.X >= 15 or v.Size.Y >= 15 or v.Size.Z >= 15 then continue end
                table.insert(ResizedParts, v)
                CacheReplacing[v] = v:Clone()                
                local Scale = Vector3.new(v.Size.X + Config.ScaleReach.X, v.Size.Y + Config.ScaleReach.Y, v.Size.Z + Config.ScaleReach.Z)
                EnriseXResize:Disconnect(v.Changed);
                EnriseXResize:Disconnect(v:GetPropertyChangedSignal("Size"));
                EnriseXResize:Disconnect(v:GetPropertyChangedSignal("Mass"));
                EnriseXResize:Disconnect(v:GetPropertyChangedSignal("Massless"));
                EnriseXResize:Disconnect(v:GetPropertyChangedSignal("AssemblyMass"));
                EnriseXResize:Disconnect(v:GetPropertyChangedSignal("CenterOfMass"));
                EnriseXResize:Disconnect(v:GetPropertyChangedSignal("AssemblyCenterOfMass"));
                EnriseXResize:Disconnect(v:GetPropertyChangedSignal("CanCollide"));

                v.Size = Scale;
                v.CanCollide = false;
                v.Massless = true;

                EnriseXResize:Connect(v.Changed);
                EnriseXResize:Connect(v:GetPropertyChangedSignal("Size"));
                EnriseXResize:Connect(v:GetPropertyChangedSignal("Mass"));
                EnriseXResize:Connect(v:GetPropertyChangedSignal("Massless"));
                EnriseXResize:Connect(v:GetPropertyChangedSignal("AssemblyMass"));
                EnriseXResize:Connect(v:GetPropertyChangedSignal("CenterOfMass"));
                EnriseXResize:Connect(v:GetPropertyChangedSignal("AssemblyCenterOfMass"));
                EnriseXResize:Connect(v:GetPropertyChangedSignal("CanCollide"));
            end
        end
        
        if not Config.Closet.Lunge_Only then
            Object["Size"] = Vector3.new(Object["Size"].X + Config.ScaleReach.X, Object["Size"].Y + Config.ScaleReach.Y, Object["Size"].Z + Config.ScaleReach.Z);
        end
        EnriseXResize["HandleReach"] = Object["Size"]
        Object["CanCollide"] = false;
        Object["Massless"] = true;
        table.insert(ResizedParts, Object)
        
        EnriseXResize:Connect(Object.Changed);
        EnriseXResize:Connect(Object:GetPropertyChangedSignal("Size"));
        EnriseXResize:Connect(Object:GetPropertyChangedSignal("Mass"));
        EnriseXResize:Connect(Object:GetPropertyChangedSignal("Massless"));
        EnriseXResize:Connect(Object:GetPropertyChangedSignal("AssemblyMass"));
        EnriseXResize:Connect(Object:GetPropertyChangedSignal("CenterOfMass"));
        EnriseXResize:Connect(Object:GetPropertyChangedSignal("AssemblyCenterOfMass"));
        EnriseXResize:Connect(Object:GetPropertyChangedSignal("CanCollide"));
        
        if Config.Closet.Lunge_Only and Object.Parent:IsA("Tool") then
            local tool = Object.Parent
            tool:GetPropertyChangedSignal("Grip"):Connect(function(...)
                if tool.GripUp.Z == 0 then
                    if Object["Size"] == Vector3.new(Object["Size"].X + Config.ScaleReach.X, Object["Size"].Y + Config.ScaleReach.Y, Object["Size"].Z + Config.ScaleReach.Z) then
                        return
                    end
                    local PossibleFakeParts = EnriseXResize:Get(Object, Char);
                    if #PossibleFakeParts > 0 then
                        for i, v in pairs(PossibleFakeParts) do
                            table.insert(ResizedParts, v)
                            local Scale = Vector3.new(v.Size.X + Config.ScaleReach.X, v.Size.Y + Config.ScaleReach.Y, v.Size.Z + Config.ScaleReach.Z)
                            EnriseXResize:Disconnect(v.Changed);
                            EnriseXResize:Disconnect(v:GetPropertyChangedSignal("Size"));
                            EnriseXResize:Disconnect(v:GetPropertyChangedSignal("Mass"));
                            EnriseXResize:Disconnect(v:GetPropertyChangedSignal("Massless"));
                            EnriseXResize:Disconnect(v:GetPropertyChangedSignal("AssemblyMass"));
                            EnriseXResize:Disconnect(v:GetPropertyChangedSignal("CenterOfMass"));
                            EnriseXResize:Disconnect(v:GetPropertyChangedSignal("AssemblyCenterOfMass"));
                            EnriseXResize:Disconnect(v:GetPropertyChangedSignal("CanCollide"));
                
                            v.Size = Scale;
                            v.CanCollide = false;
                            v.Massless = true;

                            EnriseXResize:Connect(v.Changed);
                            EnriseXResize:Connect(v:GetPropertyChangedSignal("Size"));
                            EnriseXResize:Connect(v:GetPropertyChangedSignal("Mass"));
                            EnriseXResize:Connect(v:GetPropertyChangedSignal("Massless"));
                            EnriseXResize:Connect(v:GetPropertyChangedSignal("AssemblyMass"));
                            EnriseXResize:Connect(v:GetPropertyChangedSignal("CenterOfMass"));
                            EnriseXResize:Connect(v:GetPropertyChangedSignal("AssemblyCenterOfMass"));
                            EnriseXResize:Connect(v:GetPropertyChangedSignal("CanCollide"));
                        end
                    end
                    
                    EnriseXResize:Disconnect(Object.Changed);
                    EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("Size"));
                    EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("Mass"));
                    EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("Massless"));
                    EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("AssemblyMass"));
                    EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("CenterOfMass"));
                    EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("AssemblyCenterOfMass"));
                    EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("CanCollide"));
                    
                    Object["Size"] = Vector3.new(Object["Size"].X + Config.ScaleReach.X, Object["Size"].Y + Config.ScaleReach.Y, Object["Size"].Z + Config.ScaleReach.Z);
                   
                    EnriseXResize:Connect(Object.Changed);
                    EnriseXResize:Connect(Object:GetPropertyChangedSignal("Size"));
                    EnriseXResize:Connect(Object:GetPropertyChangedSignal("Mass"));
                    EnriseXResize:Connect(Object:GetPropertyChangedSignal("Massless"));
                    EnriseXResize:Connect(Object:GetPropertyChangedSignal("AssemblyMass"));
                    EnriseXResize:Connect(Object:GetPropertyChangedSignal("CenterOfMass"));
                    EnriseXResize:Connect(Object:GetPropertyChangedSignal("AssemblyCenterOfMass"));
                    EnriseXResize:Connect(Object:GetPropertyChangedSignal("CanCollide"));
                else
                    if Object["Size"] == CacheReplacing[Object].Size then
                        return
                    end
                    local PossibleFakeParts = EnriseXResize:Get(Object, Char);
                    if #PossibleFakeParts > 0 then
                        for i, v in pairs(PossibleFakeParts) do
                            table.insert(ResizedParts, v)
                            local Scale = nil
                            if CacheReplacing[v] then
                                Scale = CacheReplacing[v].Size
                            else
                                CacheReplacing[v] = v:Clone()
                                Scale = CacheReplacing[v].Size
                            end
                            EnriseXResize:Disconnect(v.Changed);
                            EnriseXResize:Disconnect(v:GetPropertyChangedSignal("Size"));
                            EnriseXResize:Disconnect(v:GetPropertyChangedSignal("Mass"));
                            EnriseXResize:Disconnect(v:GetPropertyChangedSignal("Massless"));
                            EnriseXResize:Disconnect(v:GetPropertyChangedSignal("AssemblyMass"));
                            EnriseXResize:Disconnect(v:GetPropertyChangedSignal("CenterOfMass"));
                            EnriseXResize:Disconnect(v:GetPropertyChangedSignal("AssemblyCenterOfMass"));
                            EnriseXResize:Disconnect(v:GetPropertyChangedSignal("CanCollide"));
                
                            v.Size = Scale;
                            v.CanCollide = false;
                            v.Massless = true;

                            EnriseXResize:Connect(v.Changed);
                            EnriseXResize:Connect(v:GetPropertyChangedSignal("Size"));
                            EnriseXResize:Connect(v:GetPropertyChangedSignal("Mass"));
                            EnriseXResize:Connect(v:GetPropertyChangedSignal("Massless"));
                            EnriseXResize:Connect(v:GetPropertyChangedSignal("AssemblyMass"));
                            EnriseXResize:Connect(v:GetPropertyChangedSignal("CenterOfMass"));
                            EnriseXResize:Connect(v:GetPropertyChangedSignal("AssemblyCenterOfMass"));
                            EnriseXResize:Connect(v:GetPropertyChangedSignal("CanCollide"));
                        end
                    end
                    EnriseXResize:Disconnect(Object.Changed);
                    EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("Size"));
                    EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("Mass"));
                    EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("Massless"));
                    EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("AssemblyMass"));
                    EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("CenterOfMass"));
                    EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("AssemblyCenterOfMass"));
                    EnriseXResize:Disconnect(Object:GetPropertyChangedSignal("CanCollide"));
                    
                    Object["Size"] = CacheReplacing[Object].Size
                    
                    EnriseXResize:Connect(Object.Changed);
                    EnriseXResize:Connect(Object:GetPropertyChangedSignal("Size"));
                    EnriseXResize:Connect(Object:GetPropertyChangedSignal("Mass"));
                    EnriseXResize:Connect(Object:GetPropertyChangedSignal("Massless"));
                    EnriseXResize:Connect(Object:GetPropertyChangedSignal("AssemblyMass"));
                    EnriseXResize:Connect(Object:GetPropertyChangedSignal("CenterOfMass"));
                    EnriseXResize:Connect(Object:GetPropertyChangedSignal("AssemblyCenterOfMass"));
                    EnriseXResize:Connect(Object:GetPropertyChangedSignal("CanCollide"));
                end
            end)
        end
    end
    Update()

    return Object["Size"] == Vector3.new(Old.X + Config.ScaleReach.X, Old.Y + Config.ScaleReach.Y, Old.Z + Config.ScaleReach.Z)
end;

function EnriseXResize:Resize(Object)
    local Call = EnriseXResize:Initiate(Object)
    return Call
end;

function EnriseXResize:GetHandle(Bool, ...)
    -- // Everything below looks stupid, but it bypasses hiding characters like retards (KAnti / INFLEX)
    local Character = nil
    for i, v in pairs(workspace:GetDescendants()) do
        if tostring(v) == EnriseXResize["Client"].Name and v:IsA("Model") and #v:GetChildren() >= 8 then
            Character = v
            break
        end
    end
    if not Character then
        return Character
    end
    local Tool = nil
    local Tool_2 = nil
    for i, v in pairs(Character:GetChildren()) do
        if v:IsA("Tool") then
            Tool = v
            break
        end
    end
    if not Tool and not Bool and not Tool_2 then
        return Tool
    else
        if not Tool and Bool and not Tool_2 then
            return nil
        end
    end
    local Handle = nil
    if not Tool and Tool_2 then
        for i, v in pairs(Tool_2:GetDescendants()) do
            if v:IsA("BasePart") and (v:FindFirstChildOfClass("TouchTransmitter") or (v.Size.X == 1 and v.Size.Y == 0.8 and v.Size.Z == 4) or (v.Position - Character.Torso.Position).Magnitude <= 15) and v.CFrame.X <= 88888 and v.CFrame.Y <= 88888 and v.CFrame.Z <= 88888 then
                Handle = v
                break
            end
        end
        return nil
    end
    for i, v in pairs(Tool:GetDescendants()) do
        if v:IsA("BasePart") and (v:FindFirstChildOfClass("TouchTransmitter") or (v.Size.X == 1 and v.Size.Y == 0.8 and v.Size.Z == 4) or (v.Position - Character.Torso.Position).Magnitude <= 15) and v.CFrame.X <= 88888 and v.CFrame.Y <= 88888 and v.CFrame.Z <= 88888 then
            Handle = v
            break
        end
    end
    if not Bool then
        return {Handle, Character}
    end
    return {Handle, Character}
end

EnriseXResize["IndexHook"] = nil;
EnriseXResize["IndexHook"] = hookmetamethod(game, "__index", function(Object, Index)
    if not checkcaller() and CacheReplacing[Object] then
        local Parsed = string.split(Index, [[\0]])[1];
        local Lowered = string.lower(Parsed);
        if not AllowedIndex[Lowered] and not AllowedCall[Parsed] and not Signals[Lowered] then
            return EnriseXResize["IndexHook"](CacheReplacing[Object], Index);
        end;
    end;
    return EnriseXResize["IndexHook"](Object, Index);
end);

local TS = game:GetService("TweenService")
EnriseXResize["StoredTweens"] = {}
EnriseXResize["Hooked"] = {}
EnriseXResize["NamecallHook"] = nil;
EnriseXResize["NamecallHook"] = hookmetamethod(game, "__namecall", function(Object, ...)
    if not checkcaller() and CacheReplacing[Object] then
        local Method = getnamecallmethod();
        if not AllowedCall[Method] then
            return EnriseXResize["NamecallHook"](CacheReplacing[Object], ...);
        end;
    else
        if not checkcaller() then
            if Object == TS then
                if getnamecallmethod() == "Create" or getnamecallmethod() == "create" then
                    local Args = {...}
                    if CacheReplacing[Args[1]] then
                        local tw = EnriseXResize["NamecallHook"](Object, ...)
                        Args[1] = CacheReplacing[Args[1]]
                        EnriseXResize["StoredTweens"][tw] = EnriseXResize["NamecallHook"](Object, unpack(Args))
                        local Old___2
                        Old___2 = hookfunction(tw.Play, newcclosure(function(...) -- // hook play to double hook the other tweenbase
                            local Args = {...}
                            if not checkcaller() and Args[1] == tw then
                                if EnriseXResize["StoredTweens"][tw] then -- // make sure the tween is still stored
                                    task.spawn(function() -- // create another thread in case of error hooking
                                        EnriseXResize["StoredTweens"][tw]:Play()
                                    end)
                                end
                            end
                            return Old___2(...)
                        end))
                        local Old___3
                        Old___3 = hookfunction(tw.play, newcclosure(function(...) -- // hook play to double hook the other tweenbase
                            local Args = {...}
                            if not checkcaller() and Args[1] == tw then
                                if EnriseXResize["StoredTweens"][tw] then -- // make sure the tween is still stored
                                    task.spawn(function() -- // create another thread in case of error hooking
                                        EnriseXResize["StoredTweens"][tw]:Play()
                                    end)
                                end
                            end
                            return Old___3(...)
                        end))
                        local Old___4
                        Old___4 = hookfunction(tw.Pause, newcclosure(function(...) -- // hook pause to prevent future detections
                            local Args = {...}
                            if not checkcaller() and Args[1] == tw then
                                if EnriseXResize["StoredTweens"][tw] then -- // make sure the tween is still stored
                                    task.spawn(function() -- // create another thread in case of error hooking
                                        EnriseXResize["StoredTweens"][tw]:Pause()
                                    end)
                                end
                            end
                            return Old___4(...)
                        end))
                        local Old___5
                        Old___5 = hookfunction(tw.pause, newcclosure(function(...) -- // hook pause to prevent future detections
                            local Args = {...}
                            if not checkcaller() and Args[1] == tw then
                                if EnriseXResize["StoredTweens"][tw] then -- // make sure the tween is still stored
                                    task.spawn(function() -- // create another thread in case of error hooking
                                        EnriseXResize["StoredTweens"][tw]:Pause()
                                    end)
                                end
                            end
                            return Old___5(...)
                        end))
                        return tw
                    end
                end
            else
                if EnriseXResize["StoredTweens"][Object] and (getnamecallmethod() == "Play" or getnamecallmethod() == "play") then
                    task.spawn(function()
                        EnriseXResize["StoredTweens"][Object].Play(EnriseXResize["StoredTweens"][Object])
                    end)
                else
                    if EnriseXResize["StoredTweens"][Object] and (getnamecallmethod() == "Pause" or getnamecallmethod() == "pause") then
                        task.spawn(function()
                            EnriseXResize["StoredTweens"][Object].Pause(EnriseXResize["StoredTweens"][Object])
                        end)
                    else
                        if getnamecallmethod() == "Clone" or getnamecallmethod() == "clone" then
                            --for i, v in pairs(EnriseXResize:GetAllParents(Object)) do
                                if table.find(EnriseXResize["Parents"], Object) then
                                    local OldObjects = {}
                                    local ReplacedWith = nil
                                    for i, v in pairs(Object.GetDescendants(Object)) do
                                        if CacheReplacing[v] then
                                            table.insert(OldObjects, v)
                                            v.SetAttribute(v, "HANDLE", "h")
                                            ReplacedWith = CacheReplacing[v]
                                            break
                                        end
                                    end
                                    local Callback = EnriseXResize["NamecallHook"](Object, ...);
                                    if Callback then
                                        for i, v in pairs(Callback.GetDescendants(Callback)) do
                                            local attr = v:GetAttribute("HANDLE")
                                            if attr and string.find(attr, "h") and ReplacedWith then
                                                local Old = v.Parent
                                                v.Destroy(v)
                                                ReplaceWith.Parent = Old
                                                break
                                            end
                                        end
                                        return Callback
                                    end
                                end
                            --end
                        end
                    end
                end
            end
        end
    end;
    return EnriseXResize["NamecallHook"](Object, ...);
end);

local Old___
Old___ = hookfunction(TS.Create, function(...)
    local Args = {...}
    local tw = Old___(...) -- // get the tween callback
    if not checkcaller() and Args[1] == TS then
        if CacheReplacing[Args[2]] then
            Args[2] = CacheReplacing[Args[2]]
            EnriseXResize["StoredTweens"][tw] = Old___(unpack(Args)) -- // store the tween for later
            if not EnriseXResize["Hooked"][tw] then
                EnriseXResize["Hooked"][tw] = true
                local Old___2
                Old___2 = hookfunction(tw.Play, newcclosure(function(...) -- // hook play to double hook the other tweenbase
                    local Args = {...}
                    if not checkcaller() and Args[1] == tw then
                        if EnriseXResize["StoredTweens"][tw] then -- // make sure the tween is still stored
                            task.spawn(function() -- // create another thread in case of error hooking
                                EnriseXResize["StoredTweens"][tw]:Play()
                            end)
                        end
                    end
                    return Old___2(...)
                end))
                local Old___3
                Old___3 = hookfunction(tw.play, newcclosure(function(...) -- // hook play to double hook the other tweenbase
                    local Args = {...}
                    if not checkcaller() and Args[1] == tw then
                        if EnriseXResize["StoredTweens"][tw] then -- // make sure the tween is still stored
                            task.spawn(function() -- // create another thread in case of error hooking
                                EnriseXResize["StoredTweens"][tw]:Play()
                            end)
                        end
                    end
                    return Old___3(...)
                end))
                local Old___4
                Old___4 = hookfunction(tw.Pause, newcclosure(function(...) -- // hook pause to prevent future detections
                    local Args = {...}
                    if not checkcaller() and Args[1] == tw then
                        if EnriseXResize["StoredTweens"][tw] then -- // make sure the tween is still stored
                            task.spawn(function() -- // create another thread in case of error hooking
                                EnriseXResize["StoredTweens"][tw]:Pause()
                            end)
                        end
                    end
                    return Old___4(...)
                end))
                local Old___5
                Old___5 = hookfunction(tw.pause, newcclosure(function(...) -- // hook pause to prevent future detections
                    local Args = {...}
                    if not checkcaller() and Args[1] == tw then
                        if EnriseXResize["StoredTweens"][tw] then -- // make sure the tween is still stored
                            task.spawn(function() -- // create another thread in case of error hooking
                                EnriseXResize["StoredTweens"][tw]:Pause()
                            end)
                        end
                    end
                    return Old___5(...)
                end))
            end
        end
    end
    return tw
end)

local Old___1
Old___1 = hookfunction(TS.create, function(...)
    local Args = {...}
    local tw = Old___1(...) -- // get the tween callback
    if not checkcaller() and Args[1] == TS then
        if CacheReplacing[Args[2]] then
            EnriseXResize["StoredTweens"][tw] = TS:Create(CacheReplacing[Args[2]], Args[3], Args[4]) -- // store the tween for later
            if not EnriseXResize["Hooked"][tw] then
                EnriseXResize["Hooked"][tw] = true
                local Old___2
                Old___2 = hookfunction(tw.Play, function(...) -- // hook play to double hook the other tweenbase
                    local Args = {...}
                    if not checkcaller() and Args[1] == tw then
                        if EnriseXResize["StoredTweens"][tw] then -- // make sure the tween is still stored
                            task.spawn(function() -- // create another thread in case of error hooking
                                EnriseXResize["StoredTweens"][tw]:Play()
                            end)
                        end
                    end
                    return Old___2(...)
                end)
                local Old___3
                Old___3 = hookfunction(tw.play, function(...) -- // hook play to double hook the other tweenbase
                    local Args = {...}
                    if not checkcaller() and Args[1] == tw then
                        if EnriseXResize["StoredTweens"][tw] then -- // make sure the tween is still stored
                            task.spawn(function() -- // create another thread in case of error hooking
                                EnriseXResize["StoredTweens"][tw]:Play()
                            end)
                        end
                    end
                    return Old___3(...)
                end)
                local Old___4
                Old___4 = hookfunction(tw.Pause, function(...) -- // hook pause to prevent future detections
                    local Args = {...}
                    if not checkcaller() and Args[1] == tw then
                        if EnriseXResize["StoredTweens"][tw] then -- // make sure the tween is still stored
                            task.spawn(function() -- // create another thread in case of error hooking
                                EnriseXResize["StoredTweens"][tw]:Pause()
                            end)
                        end
                    end
                    return Old___4(...)
                end)
                local Old___5
                Old___5 = hookfunction(tw.pause, function(...) -- // hook pause to prevent future detections
                    local Args = {...}
                    if not checkcaller() and Args[1] == tw then
                        if EnriseXResize["StoredTweens"][tw] then -- // make sure the tween is still stored
                            task.spawn(function() -- // create another thread in case of error hooking
                                EnriseXResize["StoredTweens"][tw]:Pause()
                            end)
                        end
                    end
                    return Old___5(...)
                end)
            end
        end
    end
    return tw
end)

EnriseXResize["NewindexHook"] = nil;
EnriseXResize["NewindexHook"] = hookmetamethod(game, "__newindex", function(Object, Index, SetProperty)
    if not checkcaller() and CacheReplacing[Object] then
        EnriseXResize["NewindexHook"](CacheReplacing[Object], Index, SetProperty);
    end;
    return EnriseXResize["NewindexHook"](Object, Index, SetProperty);
end);

protect_instance = function(a)
    a.Parent = game.CoreGui
end

local Visualizer = Instance.new("SelectionBox")
Visualizer.Name = "Humanoid"
syn.protect_gui(Visualizer)
syn.protect_gui(workspace.CurrentCamera)
protect_instance(Visualizer)
Visualizer.Color3 = Color3.fromRGB(255, 0, 0)
Visualizer.SurfaceColor3 = Color3.fromRGB(255, 0, 0)
Visualizer.SurfaceTransparency = 0.75
Visualizer.LineThickness = 0.01

EnriseXResize["Mouse"].KeyDown:Connect(function(Key)
    if Key == Config.Keybinds.Increase then
        local Old = Vector3.new(Config.ScaleReach.X, Config.ScaleReach.Y, Config.ScaleReach.Z)
        local Newx = math.clamp(0, Config.ScaleReach.X + Config.Options.Increment.X, math.huge)
        local Newy = math.clamp(0, Config.ScaleReach.Y + Config.Options.Increment.Y, math.huge)
        local Newz = math.clamp(0, Config.ScaleReach.Z + Config.Options.Increment.Z, math.huge)
        Config.ScaleReach.X = Newx
        Config.ScaleReach.Y = Newy
        Config.ScaleReach.Z = Newz
        EnriseXResize:Notify("Reach has been increased to " .. tostring(Newx) .. ", " .. tostring(Newy) .. ", " .. tostring(Newz), 3)
        if Update then
            Update(Old, 1)
        end
    elseif Key == Config.Keybinds.Descrease then
        local Old = Vector3.new(Config.ScaleReach.X, Config.ScaleReach.Y, Config.ScaleReach.Z)
        local Newx = math.clamp(0, Config.ScaleReach.X - Config.Options.Decrement.X, math.huge)
        local Newy = math.clamp(0, Config.ScaleReach.Y - Config.Options.Decrement.Y, math.huge)
        local Newz = math.clamp(0, Config.ScaleReach.Z - Config.Options.Decrement.Z, math.huge)
        Config.ScaleReach.X = Newx
        Config.ScaleReach.Y = Newy
        Config.ScaleReach.Z = Newz
        EnriseXResize:Notify("Reach has been descreased to " .. tostring(Newx) .. ", " .. tostring(Newy) .. ", " .. tostring(Newz), 3)
        if Update then
            Update(Old, 1)
        end
    elseif Key == Config.Keybinds.Toggle then
        Config.Enabled = not Config.Enabled
        local Status = Config.Enabled and "enabled" or "disabled"
        EnriseXResize:Notify("Script was " .. Status, 3)
    elseif Key == Config.Keybinds.Visibility then
        Config.Visualizer.Visible = not Config.Visualizer.Visible
        Visualizer.Visible = Config.Visualizer.Visible
        local State = Config.Visualizer.Visible and "visible" or "invisible"
        EnriseXResize:Notify("Visualizer is now " .. State, 3)
    elseif Key == Config.Keybinds.Speed_Toggle then
        Config.Speed.Enabled = not Config.Speed.Enabled
        local State = Config.Speed.Enabled and "enabled" or "disabled"
        EnriseXResize:Notify("Speed is now " .. State, 3)
    end
end)

task.spawn(function()
    while task.wait(1) and Config.Enabled do
        local Handle = EnriseXResize:GetHandle()
        if Handle and Handle[1] then
            if not CacheReplacing[Handle[1]] then
                EnriseXResize["Parents"] = EnriseXResize:GetAllParents(Handle[1])
                EnriseXResize:Resize(Handle[1], Handle[2])
                Visualizer.Adornee = Handle[1]
                local Old = CacheReplacing[Handle[1]].Size
                local NewCount = #getconnections(Handle[1]:GetPropertyChangedSignal("Size"))+1

                // server new-index
                local con
                con = Handle[1]:GetPropertyChangedSignal("Size"):Connect(function(...)
                    if Handle[1].Size.X <= 1.05 and Handle[1].Size.Y <= 0.85 and Handle[1].Size.Z <= 4.05 then
                        CacheReplacing[Handle[1]].Size = Handle[1].Size
                    end
                end)
                synapseFunc = getconnections(Handle[1]:GetPropertyChangedSignal("Size"))[NewCount].Function
            end
        end
        LatestUpdatedHRP = Handle and Handle[1] or nil
    end
end)
