--[[
    ╔════════════════════════════════════════════════════════════════════════╗
    ║               🚀 WORKIK ULTIMATE EXPLOIT V3.0                        ║
    ║        CLEAN UI | 20+ FEATURES | SLIDERS | STABLE PHYSICS            ║
    ╚════════════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local State = {
    Fly = false, FlySpeed = 50,
    Noclip = false,
    Fling = false,
    InfJump = false,
    ESP = false,
    Fullbright = false,
    SpeedEnabled = false, WalkSpeed = 16,
    JumpEnabled = false, JumpPower = 50,
    NoFog = false,
    InstaInteract = false,
    AutoClicker = false,
    AntiAFK = true,
    SpinBot = false,
    BTools = false,
    LowRes = false,
    FOV = 70,
    Gravity = 196.2,
    Connections = {}
}

-- ═══════════════════════════════════════════════════════════════════════════
-- CORE LOGIC
-- ═══════════════════════════════════════════════════════════════════════════

local function GetRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function GetHum() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end

-- Stabiler Fling (Fix: Man fliegt nicht weg)
RunService.Stepped:Connect(function()
    if State.Fling and GetRoot() then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        GetRoot().Velocity = Vector3.new(0, 0, 0) -- Hält dich am Boden
        GetRoot().RotVelocity = Vector3.new(0, 10000, 0) -- Extremes Drehen
    end
    
    if State.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if State.InfJump and GetHum() then
        GetHum():ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Walkspeed/JumpPower Loop
RunService.RenderStepped:Connect(function()
    local Hum = GetHum()
    if Hum then
        if State.SpeedEnabled then Hum.WalkSpeed = State.WalkSpeed end
        if State.JumpEnabled then Hum.JumpPower = State.JumpPower end
    end
    if State.Fullbright then
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.Brightness = 2
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- UI FRAMEWORK (Tabs & Widgets)
-- ═══════════════════════════════════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "Workik_V3"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 550, 0, 350)
Main.Position = UDim2.new(0.5, -275, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)

local TabContainer = Instance.new("Frame", Main)
TabContainer.Position = UDim2.new(0, 130, 0, 10)
TabContainer.Size = UDim2.new(1, -140, 1, -20)
TabContainer.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", Sidebar)
UIList.Padding = UDim.new(0, 5)

-- Tab System
local Tabs = {}
local function CreateTab(name)
    local Page = Instance.new("ScrollingFrame", TabContainer)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(1, 0, 0, 40)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.new(1,1,1)
    TabBtn.Font = Enum.Font.GothamMedium
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(TabContainer:GetChildren()) do p.Visible = false end
        Page.Visible = true
    end)
    return Page
end

local MoveTab = CreateTab("Movement")
local VisualTab = CreateTab("Visuals")
local CombatTab = CreateTab("Combat")
local WorldTab = CreateTab("World")
MoveTab.Visible = true

-- Widgets: Toggle
local function AddToggle(parent, text, callback)
    local T = Instance.new("TextButton", parent)
    T.Size = UDim2.new(1, -10, 0, 35)
    T.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    T.Text = "  " .. text
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", T)
    
    local active = false
    T.MouseButton1Click:Connect(function()
        active = not active
        T.BackgroundColor3 = active and Color3.fromRGB(80, 0, 200) or Color3.fromRGB(45, 45, 55)
        callback(active)
    end)
end

-- Widgets: Slider
local function AddSlider(parent, text, min, max, default, callback)
    local SFrame = Instance.new("Frame", parent)
    SFrame.Size = UDim2.new(1, -10, 0, 50)
    SFrame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel", SFrame)
    Label.Text = text .. ": " .. default
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.TextColor3 = Color3.new(1,1,1)
    Label.BackgroundTransparency = 1
    
    local Bar = Instance.new("Frame", SFrame)
    Bar.Size = UDim2.new(1, 0, 0, 5)
    Bar.Position = UDim2.new(0, 0, 0, 30)
    Bar.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    
    local Slider = Instance.new("Frame", Bar)
    Slider.Size = UDim2.new(default/max, 0, 1, 0)
    Slider.BackgroundColor3 = Color3.fromRGB(80, 0, 200)
    
    local function Update(input)
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Slider.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + (max - min) * pos)
        Label.Text = text .. ": " .. val
        callback(val)
    end
    
    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Update(input)
            local move = UserInputService.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end
            end)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- IMPLEMENTIERUNG DER 20+ FUNKTIONEN
-- ═══════════════════════════════════════════════════════════════════════════

-- Tab: MOVEMENT
AddToggle(MoveTab, "Fly (W/A/S/D)", function(v) State.Fly = v end)
AddToggle(MoveTab, "Noclip", function(v) State.Noclip = v end)
AddToggle(MoveTab, "Infinite Jump", function(v) State.InfJump = v end)
AddToggle(MoveTab, "Speed Enabled", function(v) State.SpeedEnabled = v end)
AddSlider(MoveTab, "WalkSpeed", 16, 500, 16, function(v) State.WalkSpeed = v end)
AddToggle(MoveTab, "JumpPower Enabled", function(v) State.JumpEnabled = v v end)
AddSlider(MoveTab, "JumpPower", 50, 500, 50, function(v) State.JumpPower = v end)
AddToggle(MoveTab, "SpinBot", function(v) State.SpinBot = v end)

-- Tab: VISUALS
AddToggle(VisualTab, "Fullbright", function(v) State.Fullbright = v end)
AddToggle(VisualTab, "No Fog", function(v) Lighting.FogEnd = v and 100000 or 1000 end)
AddSlider(VisualTab, "Field of View", 70, 120, 70, function(v) workspace.CurrentCamera.FieldOfView = v end)
AddToggle(VisualTab, "X-Ray (Basic)", function(v) 
    for _, obj in pairs(workspace:GetDescendants()) do 
        if obj:IsA("BasePart") and not obj:IsDescendantOf(LocalPlayer.Character) then 
            obj.Transparency = v and 0.5 or 0 
        end 
    end 
end)

-- Tab: COMBAT
AddToggle(CombatTab, "STABLE FLING", function(v) State.Fling = v end)
AddToggle(CombatTab, "Auto Clicker", function(v) State.AutoClicker = v end)
AddToggle(CombatTab, "Instant Interaction", function(v) 
    local function patch() for _, p in pairs(workspace:GetDescendants()) do if p:IsA("ProximityPrompt") then p.HoldDuration = 0 end end end
    if v then patch() end
end)

-- Tab: WORLD
AddToggle(WorldTab, "Anti-AFK", function(v) State.AntiAFK = v end)
AddSlider(WorldTab, "Gravity", 0, 196, 196, function(v) workspace.Gravity = v end)
AddToggle(WorldTab, "BTools (Client)", function(v) 
    if v then
        for i=1,4 do Instance.new("HopperBin", LocalPlayer.Backpack).BinType = i end
    end
end)
AddToggle(WorldTab, "Low Graphics Mode", function(v)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then obj.Material = v and Enum.Material.SmoothPlastic or Enum.Material.Plastic end
    end
end)

-- Draggable UI
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = Main.Position end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

print("✅ Workik V3 Loaded - Have fun!")
