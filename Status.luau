local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")

local existing = nil
pcall(function()
    local CoreGui = game:GetService("CoreGui")
    existing = CoreGui:FindFirstChild("Status")
end)
if not existing then
    pcall(function()
        local lp = Players.LocalPlayer
        if lp and lp:FindFirstChild("PlayerGui") then
            existing = lp.PlayerGui:FindFirstChild("Status")
        end
    end)
end
if existing then
    existing:Destroy()
end

local Status = Instance.new("ScreenGui")
Status.Name = "Status"
Status.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Status.ResetOnSpawn = false

if gethui then
    Status.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(Status)
    Status.Parent = game:GetService("CoreGui")
else
    local ok, core = pcall(function()
        return game:GetService("CoreGui")
    end)
    if ok and core then
        Status.Parent = core
    else
        local lp = Players.LocalPlayer
        Status.Parent = (lp and lp:FindFirstChild("PlayerGui")) or game:GetService("StarterGui")
    end
end

local bg_color = Color3.fromRGB(31, 33, 35)

local okFont, chosenFont = pcall(function()
    return Enum.Font.BuilderSansMedium
end)
local defaultFont = okFont and chosenFont or Enum.Font.GothamMedium

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.BackgroundColor3 = Color3.new(0.122, 0.129, 0.137)
Main.BorderColor3 = Color3.new(0, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.116, 0, 0.011, 0)
Main.Size = UDim2.new(0, 160, 0, 45)
Main.ClipsDescendants = false
Main.Parent = Status

local MainCorner = Instance.new("UICorner")
MainCorner.BottomLeftRadius = UDim.new(1, 0)
MainCorner.BottomRightRadius = UDim.new(1, 0)
MainCorner.CornerRadius = UDim.new(1, 0)
MainCorner.TopLeftRadius = UDim.new(1, 0)
MainCorner.TopRightRadius = UDim.new(1, 0)
MainCorner.Parent = Main

local MainLayout = Instance.new("UIListLayout")
MainLayout.FillDirection = Enum.FillDirection.Horizontal
MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
MainLayout.VerticalAlignment = Enum.VerticalAlignment.Center
MainLayout.Parent = Main

local MainPadding = Instance.new("UIPadding")
MainPadding.PaddingLeft = UDim.new(0, 12)
MainPadding.PaddingRight = UDim.new(0, 12)
MainPadding.Parent = Main

local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

local Fps = Instance.new("TextButton")
Fps.Name = "Fps"
Fps.BackgroundColor3 = Color3.new(1, 1, 1)
Fps.BackgroundTransparency = 1
Fps.BorderColor3 = Color3.new(0, 0, 0)
Fps.BorderSizePixel = 0
Fps.Size = UDim2.new(0, 45, 0, 45)
Fps.ClipsDescendants = false
Fps.AutoButtonColor = false
Fps.Parent = Main

local FpsCorner = Instance.new("UICorner")
FpsCorner.BottomLeftRadius = UDim.new(1, 0)
FpsCorner.BottomRightRadius = UDim.new(1, 0)
FpsCorner.CornerRadius = UDim.new(1, 0)
FpsCorner.TopLeftRadius = UDim.new(1, 0)
FpsCorner.TopRightRadius = UDim.new(1, 0)
FpsCorner.Parent = Fps

do
    local button = Fps
    local fps_size = 14
    local fps_color = Color3.fromRGB(255, 255, 255)

    button.TextSize = fps_size
    button.TextColor3 = fps_color
    button.Font = defaultFont

    local tooltipFrame = Instance.new("Frame")
    tooltipFrame.Name = "Tooltip"
    tooltipFrame.Size = UDim2.new(0, 60, 0, 32)
    tooltipFrame.AnchorPoint = Vector2.new(0.5, 0)
    tooltipFrame.Position = UDim2.new(0.5, 0, 1, 8)
    tooltipFrame.BackgroundColor3 = bg_color
    tooltipFrame.BackgroundTransparency = 0.1
    tooltipFrame.BorderSizePixel = 0
    tooltipFrame.Visible = false
    tooltipFrame.ZIndex = 20
    tooltipFrame.Parent = button

    local tooltipCorner = Instance.new("UICorner")
    tooltipCorner.CornerRadius = UDim.new(0, 8)
    tooltipCorner.Parent = tooltipFrame

    local tooltipText = Instance.new("TextLabel")
    tooltipText.Name = "Label"
    tooltipText.Size = UDim2.new(1, 0, 1, 0)
    tooltipText.BackgroundTransparency = 1
    tooltipText.Text = "FPS"
    tooltipText.TextColor3 = Color3.fromRGB(255, 255, 255)
    tooltipText.TextSize = 14
    tooltipText.Font = defaultFont
    tooltipText.ZIndex = 22
    tooltipText.Parent = tooltipFrame

    local arrow = Instance.new("Frame")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 10, 0, 10)
    arrow.AnchorPoint = Vector2.new(0.5, 0.5)
    arrow.Position = UDim2.new(0.5, 0, 0, 1)
    arrow.Rotation = 45
    arrow.BackgroundColor3 = bg_color
    arrow.BackgroundTransparency = 0.1
    arrow.BorderSizePixel = 0
    arrow.ZIndex = 21
    arrow.Parent = tooltipFrame

    RunService.RenderStepped:Connect(function(deltaTime)
        local fps = math.floor(1 / deltaTime)
        button.Text = fps .. " FPS"
    end)

    button.MouseEnter:Connect(function()
        tooltipFrame.Visible = true
    end)

    button.MouseLeave:Connect(function()
        tooltipFrame.Visible = false
    end)
end

local Ping = Instance.new("TextButton")
Ping.Name = "Ping"
Ping.BackgroundColor3 = Color3.new(1, 1, 1)
Ping.BackgroundTransparency = 1
Ping.BorderColor3 = Color3.new(0, 0, 0)
Ping.BorderSizePixel = 0
Ping.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ping.LayoutOrder = 1
Ping.Size = UDim2.new(0, 45, 0, 45)
Ping.TextColor3 = Color3.new(1, 1, 1)
Ping.ClipsDescendants = false
Ping.AutoButtonColor = false
Ping.Parent = Main

local PingCorner = Instance.new("UICorner")
PingCorner.BottomLeftRadius = UDim.new(1, 0)
PingCorner.BottomRightRadius = UDim.new(1, 0)
PingCorner.CornerRadius = UDim.new(1, 0)
PingCorner.TopLeftRadius = UDim.new(1, 0)
PingCorner.TopRightRadius = UDim.new(1, 0)
PingCorner.Parent = Ping

do
    local button = Ping
    local ping_size = 14
    local ping_color = Color3.fromRGB(255, 255, 255)

    button.TextSize = ping_size
    button.TextColor3 = ping_color
    button.Font = defaultFont

    local tooltipFrame = Instance.new("Frame")
    tooltipFrame.Name = "Tooltip"
    tooltipFrame.Size = UDim2.new(0, 60, 0, 32)
    tooltipFrame.AnchorPoint = Vector2.new(0.5, 0)
    tooltipFrame.Position = UDim2.new(0.5, 0, 1, 8)
    tooltipFrame.BackgroundColor3 = bg_color
    tooltipFrame.BackgroundTransparency = 0.1
    tooltipFrame.BorderSizePixel = 0
    tooltipFrame.Visible = false
    tooltipFrame.ZIndex = 20
    tooltipFrame.Parent = button

    local tooltipCorner = Instance.new("UICorner")
    tooltipCorner.CornerRadius = UDim.new(0, 8)
    tooltipCorner.Parent = tooltipFrame

    local tooltipText = Instance.new("TextLabel")
    tooltipText.Name = "Label"
    tooltipText.Size = UDim2.new(1, 0, 1, 0)
    tooltipText.BackgroundTransparency = 1
    tooltipText.Text = "Ping"
    tooltipText.TextColor3 = Color3.fromRGB(255, 255, 255)
    tooltipText.TextSize = 14
    tooltipText.Font = defaultFont
    tooltipText.ZIndex = 22
    tooltipText.Parent = tooltipFrame

    local arrow = Instance.new("Frame")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 10, 0, 10)
    arrow.AnchorPoint = Vector2.new(0.5, 0.5)
    arrow.Position = UDim2.new(0.5, 0, 0, 1)
    arrow.Rotation = 45
    arrow.BackgroundColor3 = bg_color
    arrow.BackgroundTransparency = 0.1
    arrow.BorderSizePixel = 0
    arrow.ZIndex = 21
    arrow.Parent = tooltipFrame

    task.spawn(function()
        while Status and Status.Parent do
            local success, pingValue = pcall(function()
                return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)

            if success and pingValue then
                button.Text = tostring(pingValue) .. " ms"
            else
                button.Text = "0 ms"
            end

            task.wait(1)
        end
    end)

    button.MouseEnter:Connect(function()
        tooltipFrame.Visible = true
    end)

    button.MouseLeave:Connect(function()
        tooltipFrame.Visible = false
    end)
end

local Memory = Instance.new("TextButton")
Memory.Name = "Memory"
Memory.BackgroundColor3 = Color3.new(1, 1, 1)
Memory.BackgroundTransparency = 1
Memory.BorderColor3 = Color3.new(0, 0, 0)
Memory.BorderSizePixel = 0
Memory.LayoutOrder = 2
Memory.Size = UDim2.new(0, 45, 0, 45)
Memory.ClipsDescendants = false
Memory.AutoButtonColor = false
Memory.Parent = Main

local MemoryCorner = Instance.new("UICorner")
MemoryCorner.BottomLeftRadius = UDim.new(1, 0)
MemoryCorner.BottomRightRadius = UDim.new(1, 0)
MemoryCorner.CornerRadius = UDim.new(1, 0)
MemoryCorner.TopLeftRadius = UDim.new(1, 0)
MemoryCorner.TopRightRadius = UDim.new(1, 0)
MemoryCorner.Parent = Memory

do
    local button = Memory
    local mem_size = 14
    local mem_color = Color3.fromRGB(255, 255, 255)

    button.TextSize = mem_size
    button.TextColor3 = mem_color
    button.Font = defaultFont

    local tooltipFrame = Instance.new("Frame")
    tooltipFrame.Name = "Tooltip"
    tooltipFrame.Size = UDim2.new(0, 60, 0, 32)
    tooltipFrame.AnchorPoint = Vector2.new(0.5, 0)
    tooltipFrame.Position = UDim2.new(0.5, 0, 1, 8)
    tooltipFrame.BackgroundColor3 = bg_color
    tooltipFrame.BackgroundTransparency = 0.1
    tooltipFrame.BorderSizePixel = 0
    tooltipFrame.Visible = false
    tooltipFrame.ZIndex = 20
    tooltipFrame.Parent = button

    local tooltipCorner = Instance.new("UICorner")
    tooltipCorner.CornerRadius = UDim.new(0, 8)
    tooltipCorner.Parent = tooltipFrame

    local tooltipText = Instance.new("TextLabel")
    tooltipText.Name = "Label"
    tooltipText.Size = UDim2.new(1, 0, 1, 0)
    tooltipText.BackgroundTransparency = 1
    tooltipText.Text = "Memory"
    tooltipText.TextColor3 = Color3.fromRGB(255, 255, 255)
    tooltipText.TextSize = 14
    tooltipText.Font = defaultFont
    tooltipText.ZIndex = 22
    tooltipText.Parent = tooltipFrame

    local arrow = Instance.new("Frame")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 10, 0, 10)
    arrow.AnchorPoint = Vector2.new(0.5, 0.5)
    arrow.Position = UDim2.new(0.5, 0, 0, 1)
    arrow.Rotation = 45
    arrow.BackgroundColor3 = bg_color
    arrow.BackgroundTransparency = 0.1
    arrow.BorderSizePixel = 0
    arrow.ZIndex = 21
    arrow.Parent = tooltipFrame

    task.spawn(function()
        while Status and Status.Parent do
            local memoryMB = math.floor(Stats:GetTotalMemoryUsageMb())
            button.Text = memoryMB .. " MB"
            task.wait(1)
        end
    end)

    button.MouseEnter:Connect(function()
        tooltipFrame.Visible = true
    end)

    button.MouseLeave:Connect(function()
        tooltipFrame.Visible = false
    end)
end

return Status
