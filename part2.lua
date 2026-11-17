-- ============ ВОССТАНОВЛЕНИЕ ИЗ _G ============
local Players = _G.Players
local RunService = _G.RunService
local UserInputService = _G.UserInputService
local TweenService = _G.TweenService
local LocalPlayer = _G.LocalPlayer
local Camera = _G.Camera
local COL_BG = _G.COL_BG
local COL_PANEL = _G.COL_PANEL
local COL_ACCENT = _G.COL_ACCENT
local COL_TEXT = _G.COL_TEXT
local COL_SUB = _G.COL_SUB
local COL_OFF = _G.COL_OFF
local COL_ON = _G.COL_ON
local ScreenGui = _G.ScreenGui
local Island = _G.Island
local Main = _G.Main
local ResizeHandle = _G.ResizeHandle
local TitleBar = _G.TitleBar
local Content = _G.Content
local makeTabButton = _G.makeTabButton
local makeToggle = _G.makeToggle
local makeButton = _G.makeButton
local makeSlider = _G.makeSlider

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
