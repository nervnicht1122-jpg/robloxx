--[[
    ╔════════════════════════════════════════════════════════════════════════╗
    ║                                                                        ║
    ║               🎮 WORKIK ROBLOX EXPLOIT SCRIPT v1.0 🎮                ║
    ║                                                                        ║
    ║              A Professional All-in-One Roblox Exploit Tool            ║
    ║                     with Beautiful UI & Modern Features               ║
    ║                                                                        ║
    ╚════════════════════════════════════════════════════════════════════════╝
    
    Features:
    • Fly | Noclip | Walkspeed Control
    • Emotes (All Roblox Emotes)
    • Teleportation
    • Advanced Troll Menu
    • Smooth Animations & Modern GUI
    • Loadstring Compatible
]]

-- ═══════════════════════════════════════════════════════════════════════════
-- CONFIGURATION & SETUP
-- ═══════════════════════════════════════════════════════════════════════════

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ═══════════════════════════════════════════════════════════════════════════
-- STATE MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════

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

-- ═══════════════════════════════════════════════════════════════════════════
-- ROBLOX EMOTES DATABASE
-- ═══════════════════════════════════════════════════════════════════════════

local Emotes = {
    "Cry", "Cheer", "Laugh", "Wave", "Shrug", "Sit", "Bow", 
    "Agree", "Disagree", "Dance", "Idle", "Jump", "Fall",
    "Swim", "Climb", "Faint", "Friction",
}

-- Complete emote list with IDs
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

-- ═══════════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

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
    label.TextScaled = false
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
    button.ClipsDescendants = true
    
    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

local function Tween(object, style, direction, duration, goal)
    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle[style] or Enum.EasingStyle.Quad,
        Enum.EasingDirection[direction] or Enum.EasingDirection.InOut
    )
    local tween = TweenService:Create(object, tweenInfo, goal)
    tween:Play()
    return tween
end

-- ═══════════════════════════════════════════════════════════════════════════
-- GUI CREATION
-- ═══════════════════════════════════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WorkikExploit"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 500, 0, 600)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = MainFrame

-- Shadow effect
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Parent = ScreenGui
shadow.Size = MainFrame.Size
shadow.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset + 3, 
                           MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset + 3)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.ZIndex = MainFrame.ZIndex - 1
shadow.BorderSizePixel = 0

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

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(75, 0, 130)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(138, 43, 226))
}
titleGradient.Parent = TitleBar

local TitleText = CreateTextLabel("TitleText", "🎮 WORKIK EXPLOIT", TitleBar, 
    UDim2.new(1, -60, 1, 0), UDim2.new(0, 20, 0, 0), 24, Color3.fromRGB(255, 255, 255))

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.Size = UDim2.new(0, 50, 0, 50)
CloseButton.Position = UDim2.new(1, -55, 0, 5)
CloseButton.Text = "×"
CloseButton.TextSize = 32
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    Tween(MainFrame, "Quad", "In", 0.3, {Size = UDim2.new(0, 500, 0, 0)})
    Tween(shadow, "Quad", "In", 0.3, {Size = UDim2.new(0, 500, 0, 0)})
    wait(0.3)
    ScreenGui:Destroy()
end)

-- Tab System
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
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

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.Size = UDim2.new(1, 0, 1, -110)
ContentFrame.Position = UDim2.new(0, 0, 0, 110)
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ContentFrame.BorderSizePixel = 0

local contentLayout = Instance.new("UIListLayout")
contentLayout.Parent = ContentFrame
contentLayout.FillDirection = Enum.FillDirection.Vertical
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
contentLayout.VerticalAlignment = Enum.VerticalAlignment.Top
contentLayout.Padding = UDim.new(0, 10)

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingLeft = UDim.new(0, 15)
contentPadding.PaddingRight = UDim.new(0, 15)
contentPadding.PaddingTop = UDim.new(0, 15)
contentPadding.Parent = ContentFrame

-- ═══════════════════════════════════════════════════════════════════════════
-- TAB MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════

local CurrentTab = nil
local Tabs = {}

local function CreateTab(tabName)
    local tab = Instance.new("TextButton")
    tab.Name = tabName
    tab.Parent = TabContainer
    tab.Size = UDim2.new(0, 120, 0, 40)
    tab.Text = tabName
    tab.Font = Enum.Font.GothamBold
    tab.TextSize = 14
    tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    tab.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    tab.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = tab
    
    local content = Instance.new("Frame")
    content.Name = tabName .. "Content"
    content.Parent = ContentFrame
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Visible = false
    
    local contentList = Instance.new("UIListLayout")
    contentList.Parent = content
    contentList.FillDirection = Enum.FillDirection.Vertical
    contentList.VerticalAlignment = Enum.VerticalAlignment.Top
    contentList.Padding = UDim.new(0, 8)
    
    tab.MouseButton1Click:Connect(function()
        if CurrentTab then
            CurrentTab.Visible = false
            CurrentTab.Parent.TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        end
        content.Visible = true
        tab.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
        CurrentTab = content
        content.TabButton = tab
    end)
    
    Tabs[tabName] = {
        Button = tab,
        Content = content,
        List = contentList
    }
    
    return content
end

-- Create tabs
local MainTab = CreateTab("Main")
CurrentTab = MainTab
Tabs["Main"].Button.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
MainTab.Visible = true
MainTab.TabButton = Tabs["Main"].Button

local EmotesTab = CreateTab("Emotes")
local TrollTab = CreateTab("Troll")

-- ═══════════════════════════════════════════════════════════════════════════
-- MAIN TAB - FEATURES
-- ═══════════════════════════════════════════════════════════════════════════

-- Fly Feature
local function CreateFeatureRow(parent, featureName, onToggle)
    local row = Instance.new("Frame")
    row.Parent = parent
    row.Size = UDim2.new(1, 0, 0, 35)
    row.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    row.BorderSizePixel = 0
    
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row
    
    local label = CreateTextLabel("Label", featureName, row, UDim2.new(0.6, 0, 1, 0), 
        UDim2.new(0, 10, 0, 0), 16, Color3.fromRGB(255, 255, 255))
    
    local toggle = Instance.new("TextButton")
    toggle.Name = "Toggle"
    toggle.Parent = row
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(1, -65, 0.5, -12.5)
    toggle.Text = ""
    toggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggle.BorderSizePixel = 0
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggle
    
    local dot = Instance.new("Frame")
    dot.Name = "Dot"
    dot.Parent = toggle
    dot.Size = UDim2.new(0, 20, 0, 20)
    dot.Position = UDim2.new(0, 2, 0.5, -10)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.BorderSizePixel = 0
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(0.5, 0)
    dotCorner.Parent = dot
    
    local toggled = false
    
    toggle.MouseButton1Click:Connect(function()
        toggled = not toggled
        onToggle(toggled)
        
        if toggled then
            toggle.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
            Tween(dot, "Quad", "Out", 0.2, {Position = UDim2.new(0, 28, 0.5, -10)})
        else
            toggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            Tween(dot, "Quad", "Out", 0.2, {Position = UDim2.new(0, 2, 0.5, -10)})
        end
    end)
    
    return {Toggle = toggle, IsActive = function() return toggled end, SetActive = function(active)
        if active ~= toggled then
            toggle.MouseButton1Click:Fire()
        end
    end}
end

-- Walkspeed Control
local function CreateSlider(parent, name, minVal, maxVal, defaultVal, onChanged)
    local row = Instance.new("Frame")
    row.Parent = parent
    row.Size = UDim2.new(1, 0, 0, 50)
    row.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    row.BorderSizePixel = 0
    
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row
    
    local label = CreateTextLabel("Label", name, row, UDim2.new(1, 0, 0, 15), 
        UDim2.new(0, 10, 0, 0), 14, Color3.fromRGB(255, 255, 255))
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Parent = row
    sliderBg.Size = UDim2.new(1, -30, 0, 6)
    sliderBg.Position = UDim2.new(0, 15, 0, 28)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    sliderBg.BorderSizePixel = 0
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0.5, 0)
    sliderCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderBg
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
    sliderFill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0.5, 0)
    fillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Parent = sliderBg
    sliderButton.Size = UDim2.new(0, 15, 0, 15)
    sliderButton.Position = UDim2.new(0, -7.5, 0.5, -7.5)
    sliderButton.Text = ""
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0.5, 0)
    btnCorner.Parent = sliderButton
    
    local valueLabel = CreateTextLabel("Value", tostring(defaultVal), row, UDim2.new(0, 40, 0, 15),
        UDim2.new(1, -45, 0, 0), 12, Color3.fromRGB(200, 200, 200))
    
    local currentVal = defaultVal
    local dragging = false
    
    local function UpdateSlider(input)
        local mouse = UserInputService:GetMouseLocation()
        local sliderSize = sliderBg.AbsoluteSize.X
        local sliderPos = sliderBg.AbsolutePosition.X
        local relativePos = math.max(0, math.min(mouse.X - sliderPos, sliderSize))
        local percentage = relativePos / sliderSize
        currentVal = math.floor(minVal + (maxVal - minVal) * percentage)
        
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderButton.Position = UDim2.new(percentage, -7.5, 0.5, -7.5)
        valueLabel.Text = tostring(currentVal)
        onChanged(currentVal)
    end
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function()
        dragging = false
    end)
    
    UserInputService.InputChanged:Connect(function()
        if dragging then
            UpdateSlider()
        end
    end)
    
    sliderBg.MouseButton1Click:Connect(function()
        UpdateSlider()
    end)
    
    return {GetValue = function() return currentVal end}
end

-- Add Fly Feature
local FlyToggle = CreateFeatureRow(MainTab, "✈️ Fly", function(active)
    if active then
        State.Flying = true
        StartFlying()
    else
        State.Flying = false
        StopFlying()
    end
end)

-- Add Noclip Feature
local NoclipToggle = CreateFeatureRow(MainTab, "👻 Noclip", function(active)
    if active then
        State.Noclipping = true
        StartNoclip()
    else
        State.Noclipping = false
        StopNoclip()
    end
end)

-- Add Walkspeed Slider
local SpeedSlider = CreateSlider(MainTab, "🏃 Walkspeed", 0, 100, 16, function(val)
    State.Speed = val
    if humanoid then
        humanoid.WalkSpeed = val
    end
end)

-- Add Fly Speed Slider
local FlySpeedSlider = CreateSlider(MainTab, "📈 Fly Speed", 10, 200, 50, function(val)
    State.FlySpeed = val
end)

-- Teleport to Player Button
local function CreatePlayerSelector(parent, onPlayerSelected)
    local row = Instance.new("Frame")
    row.Parent = parent
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    row.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = row
    
    local button = CreateButton("SelectBtn", row, UDim2.new(1, -20, 1, -10), UDim2.new(0, 10, 0, 5),
        "Select Player to Teleport", function()
            local playerList = {}
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player then
                    table.insert(playerList, p)
                end
            end
            
            if #playerList == 0 then
                print("No other players found")
                return
            end
            
            -- Simple selection: teleport to first player
            onPlayerSelected(playerList[1])
        end)
    
    return row
end

CreatePlayerSelector(MainTab, function(targetPlayer)
    if targetPlayer and targetPlayer.Character then
        rootPart.CFrame = targetPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0, 3, 0)
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- EMOTES TAB
-- ═══════════════════════════════════════════════════════════════════════════

for _, emote in ipairs(EmoteIds) do
    local btn = CreateButton(emote.name, EmotesTab.Content, UDim2.new(1, -20, 0, 35),
        UDim2.new(0, 10, 0, 0), emote.name, function()
            PlayEmote(emote.id)
        end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- TROLL TAB
-- ═══════════════════════════════════════════════════════════════════════════

-- Fling Player
local FlingPowerSlider = CreateSlider(TrollTab, "💥 Fling Power", 10, 500, 50, function(val)
    State.FlingPower = val
end)

local function CreatePlayerSelectorForTroll(parent, action, onPlayerSelected)
    local row = Instance.new("Frame")
    row.Parent = parent
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    row.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = row
    
    local button = CreateButton("ActionBtn", row, UDim2.new(1, -20, 1, -10), UDim2.new(0, 10, 0, 5),
        action, function()
            local playerList = {}
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player then
                    table.insert(playerList, p)
                end
            end
            
            if #playerList == 0 then
                print("No other players found")
                return
            end
            
            onPlayerSelected(playerList[1])
        end)
    
    return row
end

CreatePlayerSelectorForTroll(TrollTab, "🚀 Fling Player", function(targetPlayer)
    FlingPlayer(targetPlayer)
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- FEATURE IMPLEMENTATIONS
-- ═══════════════════════════════════════════════════════════════════════════

function StartFlying()
    if not character or not rootPart then return end
    
    State.BodyVelocity = Instance.new("BodyVelocity")
    State.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    State.BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    State.BodyVelocity.Parent = rootPart
    
    State.BodyGyro = Instance.new("BodyGyro")
    State.BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    State.BodyGyro.CFrame = rootPart.CFrame
    State.BodyGyro.Parent = rootPart
    
    local camera = workspace.CurrentCamera
    local lastUpdate = tick()
    
    State.Connection = RunService.RenderStepped:Connect(function()
        if not State.Flying then return end
        
        local keyboard = {
            W = UserInputService:IsKeyDown(Enum.KeyCode.W),
            A = UserInputService:IsKeyDown(Enum.KeyCode.A),
            S = UserInputService:IsKeyDown(Enum.KeyCode.S),
            D = UserInputService:IsKeyDown(Enum.KeyCode.D),
            Space = UserInputService:IsKeyDown(Enum.KeyCode.Space),
            Ctrl = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl),
        }
        
        local moveDirection = Vector3.new(0, 0, 0)
        
        if keyboard.W then moveDirection = moveDirection + (camera.CFrame.LookVector) end
        if keyboard.S then moveDirection = moveDirection - (camera.CFrame.LookVector) end
        if keyboard.D then moveDirection = moveDirection + (camera.CFrame.RightVector) end
        if keyboard.A then moveDirection = moveDirection - (camera.CFrame.RightVector) end
        if keyboard.Space then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if keyboard.Ctrl then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
        end
        
        State.BodyVelocity.Velocity = moveDirection * State.FlySpeed
        State.BodyGyro.CFrame = camera.CFrame
    end)
end

function StopFlying()
    if State.Connection then
        State.Connection:Disconnect()
        State.Connection = nil
    end
    if State.BodyVelocity then
        State.BodyVelocity:Destroy()
        State.BodyVelocity = nil
    end
    if State.BodyGyro then
        State.BodyGyro:Destroy()
        State.BodyGyro = nil
    end
end

function StartNoclip()
    if not character then return end
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    State.Connection = RunService.RenderStepped:Connect(function()
        if not State.Noclipping then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

function StopNoclip()
    if State.Connection then
        State.Connection:Disconnect()
        State.Connection = nil
    end
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and not part.Name:find("Humanoid") then
                part.CanCollide = true
            end
        end
    end
end

function PlayEmote(emoteId)
    local loadCharacterAsset = function(assetId)
        return game:GetObjects("rbxassetid://" .. assetId)[1]
    end
    
    pcall(function()
        local emoteAnimation = loadCharacterAsset(emoteId)
        if emoteAnimation then
            local animator = humanoid:FindFirstChild("Animator")
            if animator then
                local animTrack = animator:LoadAnimation(emoteAnimation)
                animTrack:Play()
                animTrack:AdjustSpeed(1)
            end
        end
    end)
end

function FlingPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = targetRoot
    
    bv.Velocity = (targetRoot.Position - rootPart.Position).Unit * State.FlingPower + Vector3.new(0, State.FlingPower / 2, 0)
    
    game:GetService("Debris"):AddItem(bv, 0.1)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- INITIALIZATION & ANIMATIONS
-- ═══════════════════════════════════════════════════════════════════════════

Tween(MainFrame, "Quad", "Out", 0.5, {Size = UDim2.new(0, 500, 0, 600)})
Tween(shadow, "Quad", "Out", 0.5, {Size = UDim2.new(0, 500, 0, 600)})

-- Handle character respawn
player.CharacterAdded:Connect(function(newCharacter)
    wait(0.1)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    if State.Flying then
        StopFlying()
        FlyToggle.SetActive(false)
    end
    if State.Noclipping then
        StopNoclip()
        NoclipToggle.SetActive(false)
    end
end)

-- Cleanup on script exit
game:GetService("CoreGui").DescendantRemoving:Connect(function(obj)
    if obj == ScreenGui then
        StopFlying()
        StopNoclip()
    end
end)

print("✅ Workik Exploit loaded successfully!")
