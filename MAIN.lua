--[[
    ╔════════════════════════════════════════════════════════════════════════╗
    ║               🎮 WORKIK ROBLOX EXPLOIT SCRIPT v1.2 🎮                ║
    ║                    STABILE VERSION (FIXED TABS)                      ║
    ╚════════════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- State
local State = { Flying = false, Noclipping = false, FlySpeed = 50 }
local TabsList = {} -- Speichert die Tab-Referenzen

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WorkikFixed"
-- Versuche in CoreGui zu laden (besser für Exploits), sonst PlayerGui
local success, err = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = player:WaitForChild("PlayerGui") end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 500, 0, 450)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 

local mainCorner = Instance.new("UICorner", MainFrame)
mainCorner.CornerRadius = UDim.new(0, 12)

-- Title
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.Size = UDim2.new(1, -50, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.Text = "WORKIK EXPLOIT v1.2"
TitleText.TextColor3 = Color3.new(1, 1, 1)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 20
TitleText.BackgroundTransparency = 1
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -42, 0, 7)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Tab Container
local TabHolder = Instance.new("Frame", MainFrame)
TabHolder.Size = UDim2.new(1, 0, 0, 40)
TabHolder.Position = UDim2.new(0, 0, 0, 50)
TabHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TabHolder.BorderSizePixel = 0

local TabLayout = Instance.new("UIListLayout", TabHolder)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.Padding = UDim.new(0, 5)

-- Content Area
local ContentHolder = Instance.new("Frame", MainFrame)
ContentHolder.Size = UDim2.new(1, 0, 1, -100)
ContentHolder.Position = UDim2.new(0, 0, 0, 95)
ContentHolder.BackgroundTransparency = 1

-- TAB LOGIK
local function SwitchTab(tabName)
    for name, data in pairs(TabsList) do
        if name == tabName then
            data.Frame.Visible = true
            data.Button.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
        else
            data.Frame.Visible = false
            data.Button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        end
    end
end

local function AddTab(name)
    local btn = Instance.new("TextButton", TabHolder)
    btn.Size = UDim2.new(0, 100, 1, -5)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    Instance.new("UICorner", btn)

    local frame = Instance.new("ScrollingFrame", ContentHolder)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.ScrollBarThickness = 0
    local layout = Instance.new("UIListLayout", frame)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding = UDim.new(0, 8)

    TabsList[name] = {Button = btn, Frame = frame}
    btn.MouseButton1Click:Connect(function() SwitchTab(name) end)
    return frame
end

-- TABS ERSTELLEN
local MainTab = AddTab("Main")
local EmotesTab = AddTab("Emotes")
local TrollTab = AddTab("Troll")

-- BUTTON TEMPLATE
local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- FEATURES HINZUFÜGEN
CreateButton(MainTab, "✈️ Fly: OFF", function(btn)
    State.Flying = not State.Flying
    btn.Text = State.Flying and "✈️ Fly: ON" or "✈️ Fly: OFF"
    btn.BackgroundColor3 = State.Flying and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(45, 45, 60)
    if State.Flying then StartFlying() else StopFlying() end
end)

CreateButton(MainTab, "👻 Noclip: OFF", function(btn)
    State.Noclipping = not State.Noclipping
    btn.Text = State.Noclipping and "👻 Noclip: ON" or "👻 Noclip: OFF"
    btn.BackgroundColor3 = State.Noclipping and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(45, 45, 60)
end)

CreateButton(MainTab, "🏃 Reset Speed", function()
    player.Character.Humanoid.WalkSpeed = 16
end)

-- EMOTES
local emotes = {
    {n="Dance", id="3333487393"}, {n="Laugh", id="3333487022"}, {n="Sit", id="3333389003"}
}
for _, e in pairs(emotes) do
    CreateButton(EmotesTab, "🎭 " .. e.n, function() print("Play " .. e.id) end)
end

-- LOGIC
function StartFlying()
    local bv = Instance.new("BodyVelocity", player.Character.HumanoidRootPart)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Name = "WorkikFly"
    task.spawn(function()
        while State.Flying do
            bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * State.FlySpeed
            task.wait()
        end
        bv:Destroy()
    end)
end

function StopFlying() State.Flying = false end

RunService.Stepped:Connect(function()
    if State.Noclipping and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- Startzustand
SwitchTab("Main")
print("✅ FIXED: Menü ist jetzt klickbar!")
