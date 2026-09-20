local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")

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
Status.IgnoreGuiInset = true

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

local function unlockFps(cap)
    local target = cap or 1000
    pcall(function()
        if setfpscap then
            setfpscap(target)
        elseif set_fps_cap then
            set_fps_cap(target)
        end
    end)
    pcall(function()
        local userSettings = UserSettings():GetService("UserGameSettings")
        if userSettings then
            pcall(function()
                userSettings.FramerateCap = target
            end)
        end
    end)
end

unlockFps(1000)

task.spawn(function()
    while Status and Status.Parent do
        unlockFps(1000)
        task.wait(10)
    end
end)

local bg_color = Color3.fromRGB(22, 22, 24)

local posFile = "statusposition.json"
local defaultPos = UDim2.new(1, -12, 0, 4)
local savedPos = defaultPos
local texturesRemoved = false
local fogRemoved = false
local vfxReduced = false
local isNightTarget = false
local hasManualTime = false

pcall(function()
    if isfile and readfile and isfile(posFile) then
        local content = readfile(posFile)
        if content and content ~= "" then
            local data = HttpService:JSONDecode(content)
            if data and data.XScale and data.XOffset and data.YScale and data.YOffset then
                savedPos = UDim2.new(data.XScale, data.XOffset, data.YScale, data.YOffset)
            end
            if data and data.RemoveTexture ~= nil then
                texturesRemoved = data.RemoveTexture
            end
            if data and data.RemoveFog ~= nil then
                fogRemoved = data.RemoveFog
            end
            if data and data.ReduceVfx ~= nil then
                vfxReduced = data.ReduceVfx
            end
            if data and data.ManualTime ~= nil then
                hasManualTime = true
                isNightTarget = (data.ManualTime == "night")
            end
        end
    end
end)

local okFont, chosenFont = pcall(function()
    return Enum.Font.BuilderSansBold
end)
local defaultFont = okFont and chosenFont or Enum.Font.GothamBold

local Holder = Instance.new("Frame")
Holder.Name = "Holder"
Holder.AnchorPoint = Vector2.new(1, 0)
Holder.BackgroundTransparency = 1
Holder.BorderSizePixel = 0
Holder.Position = (Config and Config.Position) or savedPos
Holder.Size = UDim2.new(0, 212, 0, 44)
Holder.ClipsDescendants = false
Holder.Parent = Status

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0, 0)
Main.BackgroundColor3 = bg_color
Main.BackgroundTransparency = 0
Main.BorderColor3 = Color3.new(0, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0, 0, 0, 0)
Main.Size = UDim2.new(0, 160, 0, 44)
Main.ClipsDescendants = false
Main.Parent = Holder

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

local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Name = "SettingsBtn"
SettingsBtn.AnchorPoint = Vector2.new(0, 0)
SettingsBtn.BackgroundColor3 = bg_color
SettingsBtn.BackgroundTransparency = 0
SettingsBtn.BorderColor3 = Color3.new(0, 0, 0)
SettingsBtn.BorderSizePixel = 0
SettingsBtn.Position = UDim2.new(0, 168, 0, 0)
SettingsBtn.Size = UDim2.new(0, 44, 0, 44)
SettingsBtn.Text = ""
SettingsBtn.AutoButtonColor = false
SettingsBtn.ClipsDescendants = false
SettingsBtn.Parent = Holder

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(1, 0)
SettingsCorner.Parent = SettingsBtn

local SettingsIcon = Instance.new("ImageLabel")
SettingsIcon.Name = "Icon"
SettingsIcon.AnchorPoint = Vector2.new(0.5, 0.5)
SettingsIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
SettingsIcon.Size = UDim2.new(0, 20, 0, 20)
SettingsIcon.BackgroundTransparency = 1
SettingsIcon.Image = "rbxassetid://109055224171498"
SettingsIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
SettingsIcon.Parent = SettingsBtn

local settingsTooltip = Instance.new("Frame")
settingsTooltip.Name = "Tooltip"
settingsTooltip.Size = UDim2.new(0, 70, 0, 32)
settingsTooltip.AnchorPoint = Vector2.new(0.5, 0)
settingsTooltip.Position = UDim2.new(0.5, 0, 1, 8)
settingsTooltip.BackgroundColor3 = bg_color
settingsTooltip.BackgroundTransparency = 0.1
settingsTooltip.BorderSizePixel = 0
settingsTooltip.Visible = false
settingsTooltip.ZIndex = 20
settingsTooltip.Parent = SettingsBtn

local settingsTooltipCorner = Instance.new("UICorner")
settingsTooltipCorner.CornerRadius = UDim.new(0, 8)
settingsTooltipCorner.Parent = settingsTooltip

local settingsTooltipText = Instance.new("TextLabel")
settingsTooltipText.Name = "Label"
settingsTooltipText.Size = UDim2.new(1, 0, 1, 0)
settingsTooltipText.BackgroundTransparency = 1
settingsTooltipText.Text = "Settings"
settingsTooltipText.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsTooltipText.TextSize = 14
settingsTooltipText.Font = defaultFont
settingsTooltipText.ZIndex = 22
settingsTooltipText.Parent = settingsTooltip

local settingsArrow = Instance.new("Frame")
settingsArrow.Name = "Arrow"
settingsArrow.Size = UDim2.new(0, 10, 0, 10)
settingsArrow.AnchorPoint = Vector2.new(0.5, 0.5)
settingsArrow.Position = UDim2.new(0.5, 0, 0, 1)
settingsArrow.Rotation = 45
settingsArrow.BackgroundColor3 = bg_color
settingsArrow.BackgroundTransparency = 0.1
settingsArrow.BorderSizePixel = 0
settingsArrow.ZIndex = 21
settingsArrow.Parent = settingsTooltip

SettingsBtn.MouseEnter:Connect(function()
    settingsTooltip.Visible = true
end)

SettingsBtn.MouseLeave:Connect(function()
    settingsTooltip.Visible = false
end)

local dragging = false
local dragInput, dragStart, startPos
local dragDistance = 0

local function updateDrag(input)
    local delta = input.Position - dragStart
    dragDistance = delta.Magnitude
    Holder.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

local function savePosition()
    pcall(function()
        if writefile then
            local data = {
                XScale = Holder.Position.X.Scale,
                XOffset = Holder.Position.X.Offset,
                YScale = Holder.Position.Y.Scale,
                YOffset = Holder.Position.Y.Offset,
                RemoveTexture = texturesRemoved,
                RemoveFog = fogRemoved,
                ReduceVfx = vfxReduced,
                ManualTime = hasManualTime and (isNightTarget and "night" or "day") or nil
            }
            writefile(posFile, HttpService:JSONEncode(data))
        end
    end)
end

local function enableDrag(frame)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Holder.Position
            dragDistance = 0

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    savePosition()
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
end

enableDrag(Holder)
enableDrag(Main)
enableDrag(SettingsBtn)

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
Fps.Size = UDim2.new(0, 45, 1, 0)
Fps.ClipsDescendants = false
Fps.AutoButtonColor = false
Fps.Parent = Main
enableDrag(Fps)

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

    button.MouseButton1Click:Connect(function()
        unlockFps(1000)
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
Ping.Size = UDim2.new(0, 45, 1, 0)
Ping.TextColor3 = Color3.new(1, 1, 1)
Ping.ClipsDescendants = false
Ping.AutoButtonColor = false
Ping.Parent = Main
enableDrag(Ping)

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
Memory.Size = UDim2.new(0, 45, 1, 0)
Memory.ClipsDescendants = false
Memory.AutoButtonColor = false
Memory.Parent = Main
enableDrag(Memory)

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

local SettingsWindow = Instance.new("Frame")
SettingsWindow.Name = "SettingsWindow"
SettingsWindow.AnchorPoint = Vector2.new(1, 0)
SettingsWindow.Position = UDim2.new(1, 0, 1, 8)
SettingsWindow.Size = UDim2.new(0, 192, 0, 0)
SettingsWindow.AutomaticSize = Enum.AutomaticSize.Y
SettingsWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
SettingsWindow.BackgroundTransparency = 0
SettingsWindow.BorderSizePixel = 0
SettingsWindow.Visible = false
SettingsWindow.ZIndex = 50
SettingsWindow.ClipsDescendants = true
SettingsWindow.Parent = Holder

local SettingsWindowCorner = Instance.new("UICorner")
SettingsWindowCorner.CornerRadius = UDim.new(0, 14)
SettingsWindowCorner.Parent = SettingsWindow

local SettingsWindowPadding = Instance.new("UIPadding")
SettingsWindowPadding.PaddingLeft = UDim.new(0, 6)
SettingsWindowPadding.PaddingRight = UDim.new(0, 6)
SettingsWindowPadding.PaddingTop = UDim.new(0, 6)
SettingsWindowPadding.PaddingBottom = UDim.new(0, 6)
SettingsWindowPadding.Parent = SettingsWindow

local SettingsWindowLayout = Instance.new("UIListLayout")
SettingsWindowLayout.SortOrder = Enum.SortOrder.LayoutOrder
SettingsWindowLayout.Padding = UDim.new(0, 2)
SettingsWindowLayout.Parent = SettingsWindow

local function createActionButton(order, iconId, text)
    local btn = Instance.new("TextButton")
    btn.Name = text
    btn.Size = UDim2.new(1, 0, 0, 48)
    btn.BackgroundColor3 = Color3.fromRGB(34, 35, 40)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.LayoutOrder = order
    btn.ZIndex = 52
    btn.Parent = SettingsWindow

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 22, 0, 22)
    icon.Position = UDim2.new(0, 14, 0.5, 0)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    icon.ZIndex = 53
    icon.Parent = btn

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -76, 1, 0)
    label.Position = UDim2.new(0, 48, 0.5, 0)
    label.AnchorPoint = Vector2.new(0, 0.5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 15
    label.Font = defaultFont
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 53
    label.Parent = btn

    local checkmark = Instance.new("ImageLabel")
    checkmark.Name = "Checkmark"
    checkmark.Size = UDim2.new(0, 16, 0, 16)
    checkmark.Position = UDim2.new(1, -14, 0.5, 0)
    checkmark.AnchorPoint = Vector2.new(1, 0.5)
    checkmark.BackgroundTransparency = 1
    checkmark.Image = "rbxassetid://10709790387"
    checkmark.ImageColor3 = Color3.fromRGB(255, 255, 255)
    checkmark.Visible = false
    checkmark.ZIndex = 53
    checkmark.Parent = btn

    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundTransparency = 1
    end)

    return btn, icon, label, checkmark
end

local texBtn, texIcon, texLabel, texCheck = createActionButton(1, "rbxassetid://132586630153447", "Remove Texture")

local origMaterials = {}
local origMeshTextures = {}
local origSpecialTextures = {}
local origDecals = {}

local function stripTextures(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            if origMaterials[obj] == nil then
                origMaterials[obj] = obj.Material
            end
            obj.Material = Enum.Material.SmoothPlastic
            if obj:IsA("MeshPart") then
                if origMeshTextures[obj] == nil then
                    origMeshTextures[obj] = obj.TextureID
                end
                obj.TextureID = ""
            end
        elseif obj:IsA("SpecialMesh") then
            if origSpecialTextures[obj] == nil then
                origSpecialTextures[obj] = obj.TextureId
            end
            obj.TextureId = ""
        elseif obj:IsA("SurfaceAppearance") then
            obj.Parent = nil
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            if origDecals[obj] == nil then
                origDecals[obj] = obj.Transparency
            end
            obj.Transparency = 1
        end
    end)
end

local function restoreTextures(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            if origMaterials[obj] ~= nil then
                obj.Material = origMaterials[obj]
            end
            if obj:IsA("MeshPart") and origMeshTextures[obj] ~= nil then
                obj.TextureID = origMeshTextures[obj]
            end
        elseif obj:IsA("SpecialMesh") and origSpecialTextures[obj] ~= nil then
            obj.TextureId = origSpecialTextures[obj]
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            if origDecals[obj] ~= nil then
                obj.Transparency = origDecals[obj]
            else
                obj.Transparency = 0
            end
        end
    end)
end

local function updateTextureState()
    texCheck.Visible = texturesRemoved
    if texturesRemoved then
        pcall(function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                stripTextures(obj)
            end
        end)
    else
        pcall(function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                restoreTextures(obj)
            end
        end)
    end
end

texBtn.MouseButton1Click:Connect(function()
    texturesRemoved = not texturesRemoved
    updateTextureState()
    savePosition()
end)

workspace.DescendantAdded:Connect(function(obj)
    if texturesRemoved then
        task.defer(function()
            stripTextures(obj)
        end)
    end
end)

local fogBtn, fogIcon, fogLabel, fogCheck = createActionButton(2, "rbxassetid://10709806740", "Remove Fog")

local origFogEnd = nil
local origFogStart = nil
local fogConnection = nil

local function updateFogState()
    fogCheck.Visible = fogRemoved
    pcall(function()
        if fogRemoved then
            if origFogEnd == nil then
                origFogEnd = Lighting.FogEnd
                origFogStart = Lighting.FogStart
            end
            Lighting.FogEnd = 9e9
            Lighting.FogStart = 9e9
            for _, v in ipairs(Lighting:GetDescendants()) do
                if v:IsA("Atmosphere") then
                    v.Density = 0
                    v.Haze = 0
                end
            end
            if not fogConnection then
                fogConnection = RunService.RenderStepped:Connect(function()
                    if fogRemoved and Lighting.FogEnd ~= 9e9 then
                        Lighting.FogEnd = 9e9
                        Lighting.FogStart = 9e9
                    end
                end)
            end
        else
            if fogConnection then
                fogConnection:Disconnect()
                fogConnection = nil
            end
            if origFogEnd then
                Lighting.FogEnd = origFogEnd
                Lighting.FogStart = origFogStart
            else
                Lighting.FogEnd = 100000
                Lighting.FogStart = 0
            end
            for _, v in ipairs(Lighting:GetDescendants()) do
                if v:IsA("Atmosphere") then
                    v.Density = 0.3
                end
            end
        end
    end)
end

fogBtn.MouseButton1Click:Connect(function()
    fogRemoved = not fogRemoved
    updateFogState()
    savePosition()
end)

local vfxBtn, vfxIcon, vfxLabel, vfxCheck = createActionButton(3, "rbxassetid://99094962222815", "Reduce VFX")

local origVfxEnabled = {}
local origGlobalShadows = nil

local function setVfxObj(obj, reduce)
    pcall(function()
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Highlight") then
            if reduce then
                if origVfxEnabled[obj] == nil then
                    origVfxEnabled[obj] = obj.Enabled
                end
                obj.Enabled = false
            else
                if origVfxEnabled[obj] ~= nil then
                    obj.Enabled = origVfxEnabled[obj]
                else
                    obj.Enabled = true
                end
            end
        elseif obj:IsA("PostEffect") then
            if reduce then
                if origVfxEnabled[obj] == nil then
                    origVfxEnabled[obj] = obj.Enabled
                end
                obj.Enabled = false
            else
                if origVfxEnabled[obj] ~= nil then
                    obj.Enabled = origVfxEnabled[obj]
                else
                    obj.Enabled = true
                end
            end
        elseif obj:IsA("Explosion") then
            if reduce then
                obj.Visible = false
            end
        end
    end)
end

local function updateVfxState()
    vfxCheck.Visible = vfxReduced
    pcall(function()
        if vfxReduced then
            if origGlobalShadows == nil then
                origGlobalShadows = Lighting.GlobalShadows
            end
            Lighting.GlobalShadows = false
            for _, obj in ipairs(Lighting:GetDescendants()) do
                setVfxObj(obj, true)
            end
            for _, obj in ipairs(workspace:GetDescendants()) do
                setVfxObj(obj, true)
            end
        else
            if origGlobalShadows ~= nil then
                Lighting.GlobalShadows = origGlobalShadows
            end
            for _, obj in ipairs(Lighting:GetDescendants()) do
                setVfxObj(obj, false)
            end
            for _, obj in ipairs(workspace:GetDescendants()) do
                setVfxObj(obj, false)
            end
        end
    end)
end

vfxBtn.MouseButton1Click:Connect(function()
    vfxReduced = not vfxReduced
    updateVfxState()
    savePosition()
end)

workspace.DescendantAdded:Connect(function(obj)
    if vfxReduced then
        task.defer(function()
            setVfxObj(obj, true)
        end)
    end
end)

Lighting.DescendantAdded:Connect(function(obj)
    if vfxReduced then
        task.defer(function()
            setVfxObj(obj, true)
        end)
    end
end)

local timeBtn, timeIcon, timeLabel, timeCheck = createActionButton(4, "rbxassetid://96136587006066", "Set Night")
timeCheck.Visible = false
local timeConnection = nil

local function updateTimeDisplay()
    if isNightTarget then
        timeIcon.Image = "rbxassetid://79170317076591"
        timeLabel.Text = "Set Day"
    else
        timeIcon.Image = "rbxassetid://96136587006066"
        timeLabel.Text = "Set Night"
    end
end

local function applyTime()
    pcall(function()
        if isNightTarget then
            Lighting.ClockTime = 0
            Lighting.TimeOfDay = "00:00:00"
        else
            Lighting.ClockTime = 14
            Lighting.TimeOfDay = "14:00:00"
        end
    end)
end

local function startTimeLock()
    if timeConnection then
        timeConnection:Disconnect()
        timeConnection = nil
    end
    if hasManualTime then
        timeConnection = RunService.RenderStepped:Connect(function()
            applyTime()
        end)
    end
end

timeBtn.MouseButton1Click:Connect(function()
    hasManualTime = true
    isNightTarget = not isNightTarget
    applyTime()
    updateTimeDisplay()
    startTimeLock()
    savePosition()
end)

if texturesRemoved then
    updateTextureState()
end

if fogRemoved then
    updateFogState()
end

if vfxReduced then
    updateVfxState()
end

if hasManualTime then
    applyTime()
    updateTimeDisplay()
    startTimeLock()
else
    local currentHour = 14
    pcall(function()
        currentHour = Lighting.ClockTime
    end)
    if currentHour < 6 or currentHour >= 18 then
        isNightTarget = true
    else
        isNightTarget = false
    end
    updateTimeDisplay()
end

SettingsBtn.MouseButton1Click:Connect(function()
    if dragDistance < 5 then
        SettingsWindow.Visible = not SettingsWindow.Visible
    end
end)

return Status

