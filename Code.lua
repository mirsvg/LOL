--[[
    Универсальное меню для Roblox (Solara-совместимое)
    Разделы: Игрок / Настройка меню
    Функции: Fly, Noclip, FastInteract, Player ESP, Godmode, Speed Slider, Jump Slider
    Колесо мыши: слайдеры + скролл контента
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
Content.ScrollBarThickness = 6
Content.ScrollBarImageColor3 = COL_SUB
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.ScrollingDirection = Enum.ScrollingDirection.Y
Content.ScrollingEnabled = true
Content.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
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
    local hovered = false

    local function setValue(v, fireCallback)
        v = math.clamp(math.floor(v + 0.5), minVal, maxVal)
        if v == value and not fireCallback then return end
        value = v
        local relPos = (value - minVal) / (maxVal - minVal)
        fill.Size = UDim2.new(relPos, 0, 1, 0)
        knob.Position = UDim2.new(relPos, -7, 0.5, -7)
        valueLabel.Text = tostring(value)
        if fireCallback and callback then
            local ok, err = pcall(callback, value)
            if not ok then warn("[Slider] " .. tostring(err)) end
        end
    end

    local function updateFromX(mouseX)
        local absPos = barBg.AbsolutePosition.X
        local absSize = barBg.AbsoluteSize.X
        if absSize <= 0 then return end
        local rel = math.clamp((mouseX - absPos) / absSize, 0, 1)
        setValue(minVal + rel * (maxVal - minVal), true)
    end

    barBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX(input.Position.X)
        end
    end)

    row.MouseEnter:Connect(function()
        hovered = true
    end)
    row.MouseLeave:Connect(function()
        hovered = false
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

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseWheel and hovered then
            local step = 1
            if input.Position.Z > 0 then
                setValue(value + step, true)
            else
                setValue(value - step, true)
            end
        end
    end)

    return function(v)
        setValue(v, true)
    end
end

local Pages = {}
local TabButtons = {}

local function createPage(name, order)
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ZIndex = 42
    page.Parent = Content
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page
    Pages[name] = page

    local tb = makeTabButton(name, order)
    TabButtons[name] = tb
    tb.MouseButton1Click:Connect(function()
        for n, p in pairs(Pages) do
            p.Visible = (n == name)
            TabButtons[n].TextColor3 = (n == name) and COL_ACCENT or COL_SUB
            TabButtons[n].BackgroundColor3 = (n == name) and COL_BG or COL_PANEL
        end
    end)
    return page
end

local PagePlayer = createPage("Игрок", 1)
local PageSettings = createPage("Настройка меню", 2)

-- ============ FLY ============
local flyConnection = nil
local flyBodyVelocity = nil
local flyAlignOrientation = nil
local flyAttachment = nil
local FLY_SPEED = 60
local FLY_VERTICAL = 40
_G.__FlySpeed = 16

local function stopFly()
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    if flyAlignOrientation then flyAlignOrientation:Destroy() flyAlignOrientation = nil end
    if flyAttachment then flyAttachment:Destroy() flyAttachment = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
            hum.AutoRotate = true
        end
    end
end

local function startFly()
    stopFly()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    hum.PlatformStand = true
    hum.AutoRotate = false

    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyVelocity.Velocity = Vector3.zero
    flyBodyVelocity.P = 10000
    flyBodyVelocity.Parent = hrp

    flyAttachment = Instance.new("Attachment")
    flyAttachment.Parent = hrp

    flyAlignOrientation = Instance.new("AlignOrientation")
    flyAlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    flyAlignOrientation.Attachment0 = flyAttachment
    flyAlignOrientation.MaxTorque = math.huge
    flyAlignOrientation.Responsiveness = 200
    flyAlignOrientation.RigidityEnabled = true
    flyAlignOrientation.Parent = hrp

    flyConnection = RunService.RenderStepped:Connect(function()
        local c = LocalPlayer.Character
        if not c then stopFly() return end
        local root = c:FindFirstChild("HumanoidRootPart")
        if not root or not flyBodyVelocity or not flyAlignOrientation then return end

        local camCF = Camera.CFrame
        local look = camCF.LookVector
        local right = camCF.RightVector
        local flatRight = Vector3.new(right.X, 0, right.Z)
        if flatRight.Magnitude > 0.001 then flatRight = flatRight.Unit end

        flyAlignOrientation.CFrame = CFrame.new(root.Position, root.Position + look)

        local move = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + look end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - look end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + flatRight end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - flatRight end

        local vertical = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vertical = vertical + 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
        or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then vertical = vertical - 1 end

        local velocity = Vector3.zero
        if move.Magnitude > 0 then
            local fs = _G.__FlySpeed or FLY_SPEED
            if fs <= 0 then fs = FLY_SPEED end
            velocity = move.Unit * fs
        end
        velocity = velocity + Vector3.new(0, vertical * FLY_VERTICAL, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
        or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
            velocity = velocity * 2
        end

        flyBodyVelocity.Velocity = velocity
    end)
end

-- ============ NOCLIP ============
local noclipConnection = nil
local function setNoclip(on)
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    if not on then return end
    noclipConnection = RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
end

-- ============ GODMODE ============
local godmodeConnection = nil
local function setGodmode(on)
    if godmodeConnection then godmodeConnection:Disconnect() godmodeConnection = nil end
    if not on then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = hum.MaxHealth end
        end
        return
    end
    godmodeConnection = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end
    end)
end

-- ============ FAST INTERACT ============
local fastInteractConnection = nil
local function setFastInteract(on)
    if fastInteractConnection then fastInteractConnection:Disconnect() fastInteractConnection = nil end
    if not on then return end
    fastInteractConnection = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Enabled then
                local part = obj.Parent
                if part and part:IsA("BasePart") then
                    if (part.Position - hrp.Position).Magnitude < 12 then
                        pcall(function() obj:InputHoldBegin() obj:InputHoldEnd() end)
                    end
                end
            end
        end
    end)
end

-- ============ ESP ============
local espFolder = Instance.new("Folder")
espFolder.Name = "PlayerESP"
espFolder.Parent = ScreenGui

local espObjects = {}

local function createESP(player)
    if player == LocalPlayer then return end
    if espObjects[player] then return end
    local box = Instance.new("Frame")
    box.Name = "ESP_" .. player.Name
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.ZIndex = 30
    box.Parent = espFolder

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 60, 60)
    stroke.Thickness = 1.5
    stroke.Parent = box

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 14)
    nameLabel.Position = UDim2.new(0, 0, 0, -16)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0.4
    nameLabel.ZIndex = 31
    nameLabel.Parent = box

    espObjects[player] = { box = box, name = nameLabel, stroke = stroke }
end

local espEnabled = false
local espRenderConn = nil

local function updateESP()
    for player, data in pairs(espObjects) do
        if not espEnabled or player == LocalPlayer then
            data.box.Visible = false
        else
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and head and humanoid and humanoid.Health > 0 then
                local headPos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
                local rootPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                if onScreen then
                    local height = math.abs(headPos.Y - rootPos.Y)
                    local width = height * 0.55
                    data.box.Visible = true
                    data.box.Size = UDim2.new(0, width, 0, height)
                    data.box.Position = UDim2.new(0, rootPos.X - width / 2, 0, headPos.Y)
                else
                    data.box.Visible = false
                end
            else
                data.box.Visible = false
            end
        end
    end
end

local function setESP(on)
    espEnabled = on
    if on then
        for _, p in ipairs(Players:GetPlayers()) do
            createESP(p)
        end
        if not espRenderConn then
            espRenderConn = RunService.RenderStepped:Connect(updateESP)
        end
    else
        if espRenderConn then espRenderConn:Disconnect() espRenderConn = nil end
        for _, data in pairs(espObjects) do
            data.box.Visible = false
        end
    end
end

Players.PlayerAdded:Connect(function(p) createESP(p) end)
Players.PlayerRemoving:Connect(function(p)
    if espObjects[p] then
        espObjects[p].box:Destroy()
        espObjects[p] = nil
    end
end)

-- ============ ВКЛАДКА "ИГРОК" ============
local flySet = makeToggle(PagePlayer, "Полёт (Fly)", 1, false, function(v)
    if v then startFly() else stopFly() end
end)

makeToggle(PagePlayer, "Ноуклип (Noclip)", 2, false, function(v)
    setNoclip(v)
end)

makeToggle(PagePlayer, "Быстрое взаимодействие", 3, false, function(v)
    setFastInteract(v)
end)

makeToggle(PagePlayer, "ESP игроков", 4, false, function(v)
    setESP(v)
end)

makeToggle(PagePlayer, "Бессмертие (Godmode)", 5, false, function(v)
    setGodmode(v)
end)

local speedSet = makeSlider(PagePlayer, "Скорость игрока", 6, 0, 150, 16, function(v)
    _G.__FlySpeed = v
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end
end)

local jumpSet = makeSlider(PagePlayer, "Сила прыжка", 7, 0, 300, 50, function(v)
    _G.__JumpPower = v
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if hum.UseJumpPower then
                hum.JumpPower = v
            else
                hum.JumpHeight = v * 0.2
            end
        end
    end
end)

makeButton(PagePlayer, "Сбросить персонажа", 8, function()
    local char = LocalPlayer.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then h.Health = 0 end
    end
end)

-- ============ ВКЛАДКА "НАСТРОЙКА МЕНЮ" ============
makeToggle(PageSettings, "Показывать островок", 1, true, function(v)
    Island.Visible = v
end)

makeButton(PageSettings, "Сбросить позицию окна", 2, function()
    Main.Position = UDim2.new(0.5, -260, 0.5, -170)
end)

makeButton(PageSettings, "Сбросить размер окна", 3, function()
    Main.Size = UDim2.new(0, 520, 0, 340)
end)

makeButton(PageSettings, "Сбросить позицию островка", 4, function()
    Island.Position = UDim2.new(0, 20, 0.5, -27)
end)

makeButton(PageSettings, "Закрыть меню", 5, function()
    Main.Visible = false
end)

-- ============ ПЕРЕТАСКИВАНИЕ ============
local function makeDraggable(frame, handle)
    local dragging = false
    local dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(Main, TitleBar)

-- ============ ОСТРОВОК ============
local islandDragging = false
local islandMoved = false
local islandDragStart, islandStartPos

Island.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        islandDragging = true
        islandMoved = false
        islandDragStart = input.Position
        islandStartPos = Island.Position
    end
end)

Island.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        islandDragging = false
        if not islandMoved then
            Main.Visible = true
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if islandDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - islandDragStart
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
            islandMoved = true
        end
        if islandMoved then
            Island.Position = UDim2.new(
                islandStartPos.X.Scale, islandStartPos.X.Offset + delta.X,
                islandStartPos.Y.Scale, islandStartPos.Y.Offset + delta.Y
            )
        end
    end
end)

-- ============ РЕСАЙЗ ============
local resizing = false
local resizeStart = nil
local resizeStartSize = nil
local MIN_W, MIN_H = 380, 240
local MAX_W, MAX_H = 1000, 700

ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeStart = input.Position
        resizeStartSize = Main.AbsoluteSize
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - resizeStart
        local newW = math.clamp(resizeStartSize.X + delta.X, MIN_W, MAX_W)
        local newH = math.clamp(resizeStartSize.Y + delta.Y, MIN_H, MAX_H)
        Main.Size = UDim2.new(0, newW, 0, newH)
    end
end)

-- ============ СКРОЛЛ КОЛЁСИКОМ (контент) ============
local scrollSpeed = 40
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        local mousePos = UserInputService:GetMouseLocation()
        local cPos = Content.AbsolutePosition
        local cSize = Content.AbsoluteSize
        if mousePos.X >= cPos.X and mousePos.X <= cPos.X + cSize.X
        and mousePos.Y >= cPos.Y and mousePos.Y <= cPos.Y + cSize.Y then
            local currentY = Content.CanvasPosition.Y
            local maxY = math.max(0, Content.AbsoluteCanvasSize.Y - Content.AbsoluteSize.Y)
            local delta = input.Position.Z > 0 and -scrollSpeed or scrollSpeed
            local newY = math.clamp(currentY + delta, 0, maxY)
            Content.CanvasPosition = Vector2.new(0, newY)
        end
    end
end)

Pages["Игрок"].Visible = true
TabButtons["Игрок"].TextColor3 = COL_ACCENT
TabButtons["Игрок"].BackgroundColor3 = COL_BG

LocalPlayer.CharacterAdded:Connect(function(char)
    stopFly()
    if flySet then flySet(false) end
    if godmodeConnection then
        godmodeConnection:Disconnect()
        godmodeConnection = nil
    end
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        if _G.__FlySpeed then
            hum.WalkSpeed = _G.__FlySpeed
        end
        if _G.__JumpPower then
            if hum.UseJumpPower then
                hum.JumpPower = _G.__JumpPower
            else
                hum.JumpHeight = _G.__JumpPower * 0.2
            end
        end
    end
end)
