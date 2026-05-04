--[[
    ╔════════════════════════════════════════════════════════════════════════╗
    ║                                                                        ║
    ║               🎮 WORKIK ROBLOX EXPLOIT SCRIPT v1.1 🎮                ║
    ║                                                                        ║
    ║              A Professional All-in-One Roblox Exploit Tool            ║
    ║                     with Beautiful UI & Modern Features               ║
    ║                                                                        ║
    ╚════════════════════════════════════════════════════════════════════════╝
]]

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- STATE MANAGEMENT
local State = {
    Flying = false,
    Noclipping = false,
    Speed = 16,
    FlySpeed = 50,
    BaseSpeed = 0,
    BodyVelocity = nil,
    BodyGyro = nil,
    Connection = nil,
    Fling = false,
    FlingPower = 50,
}

local EmoteIds = {
    {name = "Cry", id = "3333499386"},
    {name = "Cheer", id = "3333492494"},
    {name = "Laugh", id = "3333487022"},
    {name = "Wave", id = "3333078112"},
    {name = "Shrug", id = "3333076701"},
    {name = "Sit", id = "3333389003"},
    {name = "Bow", id = "3333078771"},
    {name = "Agree", id = "3333075998"},
    {name = "Disagree", id = "3333076474"},
    {name = "Dance", id = "3333487393"},
}

-- UTILITY FUNCTIONS
local function Tween(object, style, direction, duration, goal)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle[style] or Enum.EasingStyle.Quad, Enum.EasingDirection[direction] or Enum.EasingDirection.InOut)
    local tween = TweenService:Create(object, tweenInfo, goal)
    tween:Play()
    return tween
end

local function CreateTextLabel(name, text, parent, size, position, textSize, textColor)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Text = text
    label.Parent = parent
    label.Size = size
    label.Position = position
    label.TextSize = textSize
    label.TextColor3 = textColor
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    return label
end

local function CreateButton(name, parent, size, position, text, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = parent
    button.Size = size
    button.Position = position
    button.Text = text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
    button.BorderSizePixel = 0
    button.ZIndex = 10
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- GUI CREATION
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WorkikExploit"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 500, 0, 600)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.ZIndex = 5

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = MainFrame

-- Shadow
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Parent = ScreenGui
shadow.Size = MainFrame.Size
shadow.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset + 3, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset + 3)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.ZIndex = 4
shadow.BackgroundTransparency = 0.5
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 15)
shadowCorner.Parent = shadow

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 60)
TitleBar.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
TitleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = TitleBar

local TitleText = CreateTextLabel("TitleText", "🚀 WORKIK EXPLOIT", TitleBar, UDim2.new(1, -60, 1, 0), UDim2.new(0, 20, 0, 0), 24, Color3.fromRGB(255, 255, 255))

local CloseButton = CreateButton("CloseButton", TitleBar, UDim2.new(0, 40, 0, 40), UDim2.new(1, -50, 0, 10), "X", function()
    ScreenGui:Destroy()
end)
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

-- Tab System
local TabContainer = Instance.new("Frame")
TabContainer.Parent = MainFrame
TabContainer.Size = UDim2.new(1, 0, 0, 50)
TabContainer.Position = UDim2.new(0, 0, 0, 60)
TabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TabContainer.BorderSizePixel = 0

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabContainer
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabListLayout.Padding = UDim.new(0, 10)

local ContentFrame = Instance.new("Frame")
ContentFrame.Parent = MainFrame
ContentFrame.Size = UDim2.new(1, 0, 1, -110)
ContentFrame.Position = UDim2.new(0, 0, 0, 110)
ContentFrame.BackgroundTransparency = 1

-- TAB MANAGEMENT
local CurrentTab = nil

local function CreateTab(tabName)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 100, 0, 35)
    tabButton.Text = tabName
    tabButton.Parent = TabContainer
    tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 8)

    local content = Instance.new("ScrollingFrame")
    content.Name = tabName .. "Content"
    content.Parent = ContentFrame
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.ScrollBarThickness = 0
    
    local contentLayout = Instance.new("UIListLayout", content)
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", content).PaddingTop = UDim.new(0, 10)

    -- Fix: Eigene TabButton Referenz speichern
    content.AttributeSelection = tabButton

    tabButton.MouseButton1Click:Connect(function()
        if CurrentTab then
            CurrentTab.Visible = false
            CurrentTab.AttributeSelection.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        end
        content.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
        CurrentTab = content
    end)

    return content
end

-- Create Tabs
local MainTab = CreateTab("Main")
local EmotesTab = CreateTab("Emotes")
local TrollTab = CreateTab("Troll")

-- Initial Tab Setup
MainTab.Visible = true
CurrentTab = MainTab
MainTab.AttributeSelection.BackgroundColor3 = Color3.fromRGB(75, 0, 130)

-- FEATURE ROW TEMPLATE
local function CreateFeatureRow(parent, text, onToggle)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(0.9, 0, 0, 40)
    row.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    Instance.new("UICorner", row)
    
    CreateTextLabel("Label", text, row, UDim2.new(0.7, 0, 1, 0), UDim2.new(0, 10, 0, 0), 16, Color3.fromRGB(255, 255, 255)).TextXAlignment = Enum.TextXAlignment.Left
    
    local toggled = false
    local btn = CreateButton("Toggle", row, UDim2.new(0, 60, 0, 30), UDim2.new(1, -70, 0.5, -15), "OFF", function()
        toggled = not toggled
        onToggle(toggled)
    end)
    btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    -- Dynamic update for the button
    task.spawn(function()
        while btn.Parent do
            btn.Text = toggled and "ON" or "OFF"
            btn.BackgroundColor3 = toggled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 100, 100)
            task.wait(0.1)
        end
    end)
end

-- ADD FEATURES
CreateFeatureRow(MainTab, "✈️ Fly", function(v) State.Flying = v if v then StartFlying() else StopFlying() end end)
CreateFeatureRow(MainTab, "👻 Noclip", function(v) State.Noclipping = v if v then StartNoclip() else StopNoclip() end end)

-- SLIDER TEMPLATE (Simplified for fix)
local function CreateSimpleSlider(parent, name, min, max, default, callback)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(0.9, 0, 0, 50)
    row.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    Instance.new("UICorner", row)
    
    local label = CreateTextLabel("Label", name .. ": " .. default, row, UDim2.new(1, 0, 0, 20), UDim2.new(0, 10, 0, 5), 14, Color3.fromRGB(200, 200, 200))
    label.TextXAlignment = Enum.TextXAlignment.Left

    local btnPlus = CreateButton("Plus", row, UDim2.new(0, 30, 0, 20), UDim2.new(1, -40, 0, 25), "+", function()
        default = math.min(max, default + 5)
        label.Text = name .. ": " .. default
        callback(default)
    end)
    local btnMinus = CreateButton("Minus", row, UDim2.new(0, 30, 0, 20), UDim2.new(1, -80, 0, 25), "-", function()
        default = math.max(min, default - 5)
        label.Text = name .. ": " .. default
        callback(default)
    end)
end

CreateSimpleSlider(MainTab, "Speed", 16, 200, 16, function(v) humanoid.WalkSpeed = v end)

-- EMOTES
for _, emote in ipairs(EmoteIds) do
    CreateButton(emote.name, EmotesTab, UDim2.new(0.9, 0, 0, 35), UDim2.new(0, 0, 0, 0), emote.name, function()
        -- Play Emote Logic
        print("Playing Emote: " .. emote.name)
    end)
end

-- LOGIC FUNCTIONS
function StartFlying()
    local bv = Instance.new("BodyVelocity", rootPart)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    State.BodyVelocity = bv
    local bg = Instance.new("BodyGyro", rootPart)
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    State.BodyGyro = bg
    
    State.Connection = RunService.RenderStepped:Connect(function()
        bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * State.FlySpeed
        bg.CFrame = workspace.CurrentCamera.CFrame
    end)
end

function StopFlying()
    if State.Connection then State.Connection:Disconnect() end
    if State.BodyVelocity then State.BodyVelocity:Destroy() end
    if State.BodyGyro then State.BodyGyro:Destroy() end
end

function StartNoclip()
    State.NoclipConn = RunService.Stepped:Connect(function()
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)
end

function StopNoclip()
    if State.NoclipConn then State.NoclipConn:Disconnect() end
end

print("✅ Workik Exploit Fixed & Loaded!")
