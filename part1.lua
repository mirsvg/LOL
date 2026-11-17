--[[
    Универсальное меню для Roblox (Solara-совместимое) — Part 1
]]

if _G.__MyMenuLoaded and _G.__MyMenu then
    pcall(function() _G.__MyMenu:Destroy() end)
end
_G.__MyMenuLoaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local COL_BG      = Color3.fromRGB(18, 18, 22)
local COL_PANEL   = Color3.fromRGB(28, 28, 34)
local COL_ACCENT  = Color3.fromRGB(0, 170, 255)
local COL_TEXT    = Color3.fromRGB(235, 235, 240)
local COL_SUB     = Color3.fromRGB(150, 150, 160)
local COL_OFF     = Color3.fromRGB(60, 60, 70)
local COL_ON      = Color3.fromRGB(0, 200, 120)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyUniversalMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
_G.__MyMenu = ScreenGui

local Island = Instance.new("TextButton")
Island.Name = "Island"
Island.Size = UDim2.new(0, 54, 0, 54)
Island.Position = UDim2.new(0, 20, 0.5, -27)
Island.BackgroundColor3 = COL_ACCENT
Island.BackgroundTransparency = 0.1
Island.Text = "≡"
Island.TextColor3 = Color3.new(1, 1, 1)
Island.TextSize = 28
Island.Font = Enum.Font.GothamBold
Island.AutoButtonColor = false
Island.BorderSizePixel = 0
Island.ZIndex = 30
Island.Parent = ScreenGui

local IslandCorner = Instance.new("UICorner")
IslandCorner.CornerRadius = UDim.new(1, 0)
IslandCorner.Parent = Island

local IslandStroke = Instance.new("UIStroke")
IslandStroke.Color = Color3.fromRGB(0, 120, 200)
IslandStroke.Thickness = 1.5
IslandStroke.Parent = Island

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 520, 0, 340)
Main.Position = UDim2.new(0.5, -260, 0.5, -170)
Main.BackgroundColor3 = COL_BG
Main.BorderSizePixel = 0
Main.Visible = false
Main.ClipsDescendants = true
Main.ZIndex = 40
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(50, 50, 60)
MainStroke.Thickness = 1
MainStroke.Parent = Main

local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Size = UDim2.new(0, 18, 0, 18)
ResizeHandle.Position = UDim2.new(1, -18, 1, -18)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Text = "◢"
ResizeHandle.TextColor3 = COL_SUB
ResizeHandle.TextSize = 14
ResizeHandle.Font = Enum.Font.GothamBold
ResizeHandle.AutoButtonColor = false
ResizeHandle.ZIndex = 45
ResizeHandle.Parent = Main

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = COL_PANEL
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 41
TitleBar.Parent = Main

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -80, 1, 0)
TitleText.Position = UDim2.new(0, 14, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Universal Menu"
TitleText.TextColor3 = COL_TEXT
TitleText.TextSize = 15
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 42
TitleText.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 42
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 130, 1, -38)
TabBar.Position = UDim2.new(0, 0, 0, 38)
TabBar.BackgroundColor3 = COL_PANEL
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 41
TabBar.Parent = Main

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 6)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabBar

local TabPad = Instance.new("UIPadding")
TabPad.PaddingTop = UDim.new(0, 10)
TabPad.PaddingLeft = UDim.new(0, 8)
TabPad.PaddingRight = UDim.new(0, 8)
TabPad.Parent = TabBar

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -130, 1, -38)
Content.Position = UDim2.new(0, 130, 0, 38)
Content.BackgroundColor3 = COL_BG
Content.BorderSizePixel = 0
Content.ZIndex = 41
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = COL_SUB
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.ScrollingDirection = Enum.ScrollingDirection.Y
Content.Parent = Main

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = Content

local ContentPad = Instance.new("UIPadding")
ContentPad.PaddingTop = UDim.new(0, 12)
ContentPad.PaddingLeft = UDim.new(0, 12)
ContentPad.PaddingRight = UDim.new(0, 12)
ContentPad.PaddingBottom = UDim.new(0, 12)
ContentPad.Parent = Content

local function makeTabButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = COL_BG
    btn.Text = text
    btn.TextColor3 = COL_SUB
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.LayoutOrder = order
    btn.ZIndex = 42
    btn.Parent = TabBar
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.Parent = btn
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local function makeToggle(parent, text, order, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = COL_PANEL
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.ZIndex = 42
    row.Parent = parent
    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 8)
    rc.Parent = row

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = COL_TEXT
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 43
    label.Parent = row

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 44, 0, 22)
    switch.Position = UDim2.new(1, -54, 0.5, -11)
    switch.BackgroundColor3 = default and COL_ON or COL_OFF
    switch.Text = ""
    switch.BorderSizePixel = 0
    switch.AutoButtonColor = false
    switch.ZIndex = 43
    switch.Parent = row
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(1, 0)
    sc.Parent = switch

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = default and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.ZIndex = 44
    knob.Parent = switch
    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = knob

    local state = default
    local function setState(v)
        state = v
        switch.BackgroundColor3 = v and COL_ON or COL_OFF
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = v and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)
        }):Play()
        if callback then
            local ok, err = pcall(callback, v)
            if not ok then warn("[Toggle] " .. tostring(err)) end
        end
    end

    switch.MouseButton1Click:Connect(function()
        setState(not state)
    end)

    return setState
end

local function makeButton(parent, text, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = COL_ACCENT
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.LayoutOrder = order
    btn.ZIndex = 42
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    btn.MouseButton1Click:Connect(function()
        local ok, err = pcall(callback)
        if not ok then warn("[Button] " .. tostring(err)) end
    end)
    return btn
end

local function makeSlider(parent, text, order, minVal, maxVal, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 54)
    row.BackgroundColor3 = COL_PANEL
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.ZIndex = 42
    row.Parent = parent
    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 8)
    rc.Parent = row

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = COL_TEXT
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 43
    label.Parent = row

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -62, 0, 6)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = COL_ACCENT
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 43
    valueLabel.Parent = row

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -24, 0, 6)
    barBg.Position = UDim2.new(0, 12, 0, 34)
    barBg.BackgroundColor3 = COL_OFF
    barBg.BorderSizePixel = 0
    barBg.ZIndex = 43
    barBg.Parent = row
    local barBgCorner = Instance.new("UICorner")
    barBgCorner.CornerRadius = UDim.new(1, 0)
    barBgCorner.Parent = barBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = COL_ACCENT
    fill.BorderSizePixel = 0
    fill.ZIndex = 44
    fill.Parent = barBg
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((default - minVal) / (maxVal - minVal), -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.ZIndex = 45
    knob.Parent = barBg
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local value = default
    local dragging = false

    local function updateFromX(mouseX)
        local absPos = barBg.AbsolutePosition.X
        local absSize = barBg.AbsoluteSize.X
        if absSize <= 0 then return end
        local rel = math.clamp((mouseX - absPos) / absSize, 0, 1)
        value = math.floor(minVal + rel * (maxVal - minVal) + 0.5)
        local relPos = (value - minVal) / (maxVal - minVal)
        fill.Size = UDim2.new(relPos, 0, 1, 0)
        knob.Position = UDim2.new(relPos, -7, 0.5, -7)
        valueLabel.Text = tostring(value)
        if callback then
            local ok, err = pcall(callback, value)
            if not ok then warn("[Slider] " .. tostring(err)) end
        end
    end

    barBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(input.Position.X)
        end
    end)

    return function(v)
        v = math.clamp(v, minVal, maxVal)
        value = v
        local relPos = (value - minVal) / (maxVal - minVal)
        fill.Size = UDim2.new(relPos, 0, 1, 0)
        knob.Position = UDim2.new(relPos, -7, 0.5, -7)
        valueLabel.Text = tostring(value)
        if callback then
            local ok, err = pcall(callback, value)
            if not ok then warn("[Slider] " .. tostring(err)) end
        end
    end
end
