local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player:WaitForChild("Character")
local Humanoid = Character:FindFirstChildOfClass("Humanoid")

if not Humanoid then
    return print("No player found.")
end

-- Function to create a modern button
local function CreateModernButton(text, callback)
    local button = Instance.new("TextButton")
    button.Parent = GuiService:GetGuiRoot()
    button.Size = UDim2.new(0, 150, 0, 30)
    button.Position = UDim2.new(0.5 - 0.075 * #GuiService:GetGuiRoot().Children, 0)
    button.AnchorPoint = Vector2.new(0.5, 0)
    button.Text = text
    button.Font = Enum.Font.SourceSansBold
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    button.BorderSizePixel = 0
    button.ZIndex = 5
    button.TextScaled = true
    button:SetAttribute("Callback", callback)
    button.MouseButton1Click:Connect(function()
        if button:GetAttribute("Callback") then
            button:GetAttribute("Callback")(button)
        end
    end)
    return button
end

-- Function to animate the menu appearance
local function AnimateMenuAppearance()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = GuiService:GetGuiRoot()
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.SiblingOrder
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Parent = screenGui
    frame.Size = UDim2.new(0, 300, 0, 450)
    frame.Position = UDim2.new(0.5 - 0.15 * #GuiService:GetGuiRoot().Children, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    frame.BorderSizePixel = 0
    frame.ZIndex = 10

    CreateModernButton("Jump Height +", function()
        Humanoid.JumpPower = Humanoid.JumpPower + 5
    end)
    CreateModernButton("Walk Speed +", function()
        Humanoid.WalkSpeed = Humanoid.WalkSpeed + 2
    end)
    CreateModernButton("NoClip Mode", function()
        if not Character:FindFirstChild("NoClip") then
            local noClip = Instance.new("BoolValue")
            noClip.Name = "NoClip"
            noClip.Parent = Character
            noClip.Value = true
        else
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            Character:FindFirstChild("NoClip"):Destroy()
        end
    end)
end

-- Initialize the menu with a subtle animation effect
GuiService.Changed:Connect(function(property)
    if property == "MenuShown" then
        AnimateMenuAppearance()
    end
end)
