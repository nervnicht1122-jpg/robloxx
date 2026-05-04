--[[
    ╔════════════════════════════════════════════════════════════════════════╗
    ║               🎮 WORKIK ROBLOX EXPLOIT V2.0 (CLEAN)                  ║
    ╚════════════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Config & State
local State = {
    Flying = false,
    Noclip = false,
    Flinging = false,
    Speed = 16,
    FlySpeed = 50,
    FlingPower = 5000, -- Erhöht für echte Wirkung
    Connections = {}
}

-- Utility: Aufräumen von Verbindungen
local function ToggleConnection(name, active, func)
    if State.Connections[name] then 
        State.Connections[name]:Disconnect() 
        State.Connections[name] = nil 
    end
    if active then
        State.Connections[name] = RunService.Stepped:Connect(func)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- CORE FEATURES
-- ═══════════════════════════════════════════════════════════════════════════

local function GetChar() return LocalPlayer.Character end
local function GetHum() return GetChar() and GetChar():FindFirstChildOfClass("Humanoid") end
local function GetRoot() return GetChar() and GetChar():FindFirstChild("HumanoidRootPart") end

-- Fly Logic
local function UpdateFly()
    if not State.Flying or not GetRoot() then return end
    
    local Camera = workspace.CurrentCamera
    local Direction = Vector3.new(0, 0, 0)
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then Direction = Direction + Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then Direction = Direction - Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then Direction = Direction + Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then Direction = Direction - Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Direction = Direction + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then Direction = Direction - Vector3.new(0, 1, 0) end

    GetRoot().Velocity = Direction * State.FlySpeed
    
    -- Verhindert das Fallen durch Schwerkraft
    if Direction.Magnitude == 0 then
        GetRoot().Velocity = Vector3.new(0, 0.1, 0)
    end
end

-- Noclip Logic
local function DoNoclip()
    if not State.Noclip or not GetChar() then return end
    for _, part in pairs(GetChar():GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end
end

-- Fling Logic (Dreht den eigenen Charakter extrem schnell)
local function DoFling()
    if not State.Flinging or not GetRoot() then return end
    local rot = Vector3.new(0, State.FlingPower, 0)
    GetRoot().RotVelocity = rot
    -- Kurzer Teleport-Offset zur Maus um Ziele zu treffen
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        GetRoot().CFrame = CFrame.new(Mouse.Hit.p) * CFrame.new(0, 3, 0)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- GUI SYSTEM (MODULAR)
-- ═══════════════════════════════════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "Workik_V2"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Einfaches Dragging für Exploiters

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(85, 0, 180)
local HeaderCorner = Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Text = "WORKIK EXPLOIT V2"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

-- Scroll Container
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -70)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
Scroll.ScrollBarThickness = 4

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 10)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Helper for Buttons
local function CreateToggleButton(text, callback)
    local Btn = Instance.new("TextButton", Scroll)
    Btn.Size = UDim2.new(0, 350, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    Btn.Text = text
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    
    local Corner = Instance.new("UICorner", Btn)
    local Active = false
    
    Btn.MouseButton1Click:Connect(function()
        Active = not Active
        Btn.BackgroundColor3 = Active and Color3.fromRGB(100, 0, 255) or Color3.fromRGB(45, 45, 60)
        callback(Active)
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- INITIALIZE FEATURES
-- ═══════════════════════════════════════════════════════════════════════════

CreateToggleButton("✈️ Toggle Flight", function(val)
    State.Flying = val
    if not val and GetRoot() then GetRoot().Velocity = Vector3.zero end
    ToggleConnection("Fly", val, UpdateFly)
end)

CreateToggleButton("👻 Toggle Noclip", function(val)
    State.Noclip = val
    ToggleConnection("Noclip", val, DoNoclip)
end)

CreateToggleButton("🚀 Toggle Fling (Click to TP)", function(val)
    State.Flinging = val
    ToggleConnection("Fling", val, DoFling)
end)

CreateToggleButton("🏃 Boost Walkspeed (100)", function(val)
    if GetHum() then GetHum().WalkSpeed = val and 100 or 16 end
end)

print("✅ Workik Exploit V2 loaded!")
