local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("AdminPanelGui") then
	playerGui.AdminPanelGui:Destroy()
end

-- Текущие настройки темы
local currentTheme = {
	MainBg = Color3.fromRGB(25, 25, 30),
	HeaderBg = Color3.fromRGB(32, 32, 38),
	BtnBg = Color3.fromRGB(45, 45, 55),
	Accent = Color3.fromRGB(70, 130, 220)
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminPanelGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Островок для открытия
local openFrame = Instance.new("Frame")
openFrame.Name = "OpenButtonFrame"
openFrame.Size = UDim2.new(0, 100, 0, 40)
openFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
openFrame.BackgroundColor3 = currentTheme.MainBg
openFrame.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 10)
openCorner.Parent = openFrame

local openBtn = Instance.new("TextButton")
openBtn.Name = "OpenButton"
openBtn.Size = UDim2.new(1, 0, 1, 0)
openBtn.BackgroundTransparency = 1
openBtn.Text = "Admin"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 16
openBtn.Parent = openFrame

-- Главное окно меню
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 260, 0, 310)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -155)
mainFrame.BackgroundColor3 = currentTheme.MainBg
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Верхняя панель (заголовок и перетаскивание)
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = currentTheme.HeaderBg
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
titleLabel.Position = UDim2.new(0.05, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Admin Panel"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 15
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Кнопка закрытия (крестик)
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Панель переключения вкладок
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(0.9, 0, 0, 32)
tabBar.Position = UDim2.new(0.05, 0, 0, 48)
tabBar.BackgroundTransparency = 1
tabBar.Parent = mainFrame

local playerTabBtn = Instance.new("TextButton")
playerTabBtn.Size = UDim2.new(0.48, 0, 1, 0)
playerTabBtn.Position = UDim2.new(0, 0, 0, 0)
playerTabBtn.BackgroundColor3 = currentTheme.Accent
playerTabBtn.Text = "Игрок"
playerTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
playerTabBtn.Font = Enum.Font.GothamBold
playerTabBtn.TextSize = 14
playerTabBtn.Parent = tabBar

local tabCorner1 = Instance.new("UICorner")
tabCorner1.CornerRadius = UDim.new(0, 8)
tabCorner1.Parent = playerTabBtn

local settingsTabBtn = Instance.new("TextButton")
settingsTabBtn.Size = UDim2.new(0.48, 0, 1, 0)
settingsTabBtn.Position = UDim2.new(0.52, 0, 0, 0)
settingsTabBtn.BackgroundColor3 = currentTheme.BtnBg
settingsTabBtn.Text = "Настройки"
settingsTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsTabBtn.Font = Enum.Font.GothamBold
settingsTabBtn.TextSize = 14
settingsTabBtn.Parent = tabBar

local tabCorner2 = Instance.new("UICorner")
tabCorner2.CornerRadius = UDim.new(0, 8)
tabCorner2.Parent = settingsTabBtn

-- Контейнеры для вкладок
local playerPage = Instance.new("Frame")
playerPage.Name = "PlayerPage"
playerPage.Size = UDim2.new(0.9, 0, 1, -95)
playerPage.Position = UDim2.new(0.05, 0, 0, 88)
playerPage.BackgroundTransparency = 1
playerPage.Visible = true
playerPage.Parent = mainFrame

local settingsPage = Instance.new("Frame")
settingsPage.Name = "SettingsPage"
settingsPage.Size = UDim2.new(0.9, 0, 1, -95)
settingsPage.Position = UDim2.new(0.05, 0, 0, 88)
settingsPage.BackgroundTransparency = 1
settingsPage.Visible = false
settingsPage.Parent = mainFrame

local themedButtons = {}

local function createActionButton(parent, text, posY, heightScale)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, heightScale or 0.21, 0)
	btn.Position = UDim2.new(0, 0, posY, 0)
	btn.BackgroundColor3 = currentTheme.BtnBg
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 14
	btn.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn

	table.insert(themedButtons, btn)
	return btn
end

-- Кнопки в разделе "Игрок"
local flyBtn = createActionButton(playerPage, "Fly: ВЫКЛ", 0.02, 0.21)
local noclipBtn = createActionButton(playerPage, "No-Clip: ВЫКЛ", 0.27, 0.21)
local interactBtn = createActionButton(playerPage, "Fast Interact: ВЫКЛ", 0.52, 0.21)
local espBtn = createActionButton(playerPage, "Player ESP: ВЫКЛ", 0.77, 0.21)

-- Элементы в разделе "Настройки"
local colorLabel = Instance.new("TextLabel")
colorLabel.Size = UDim2.new(1, 0, 0.14, 0)
colorLabel.Position = UDim2.new(0, 0, 0, 0)
colorLabel.BackgroundTransparency = 1
colorLabel.Text = "Цвет темы меню:"
colorLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
colorLabel.Font = Enum.Font.GothamSemibold
colorLabel.TextSize = 13
colorLabel.TextXAlignment = Enum.TextXAlignment.Left
colorLabel.Parent = settingsPage

local colorContainer = Instance.new("Frame")
colorContainer.Size = UDim2.new(1, 0, 0.22, 0)
colorContainer.Position = UDim2.new(0, 0, 0.15, 0)
colorContainer.BackgroundTransparency = 1
colorContainer.Parent = settingsPage

local themes = {
	{Name = "Темная", Main = Color3.fromRGB(25, 25, 30), Header = Color3.fromRGB(32, 32, 38), Btn = Color3.fromRGB(45, 45, 55), Accent = Color3.fromRGB(70, 130, 220)},
	{Name = "Синяя", Main = Color3.fromRGB(18, 28, 46), Header = Color3.fromRGB(24, 38, 62), Btn = Color3.fromRGB(34, 52, 84), Accent = Color3.fromRGB(56, 152, 236)},
	{Name = "Фиол.", Main = Color3.fromRGB(32, 20, 44), Header = Color3.fromRGB(44, 28, 60), Btn = Color3.fromRGB(60, 38, 82), Accent = Color3.fromRGB(155, 89, 182)},
	{Name = "Изумр.", Main = Color3.fromRGB(18, 36, 30), Header = Color3.fromRGB(24, 48, 40), Btn = Color3.fromRGB(34, 66, 56), Accent = Color3.fromRGB(46, 204, 113)}
}

local activeTab = "Player"

local function applyTheme(theme)
	currentTheme.MainBg = theme.Main
	currentTheme.HeaderBg = theme.Header
	currentTheme.BtnBg = theme.Btn
	currentTheme.Accent = theme.Accent

	mainFrame.BackgroundColor3 = theme.Main
	openFrame.BackgroundColor3 = theme.Main
	topBar.BackgroundColor3 = theme.Header

	for _, btn in ipairs(themedButtons) do
		btn.BackgroundColor3 = theme.Btn
	end

	if activeTab == "Player" then
		playerTabBtn.BackgroundColor3 = theme.Accent
		settingsTabBtn.BackgroundColor3 = theme.Btn
	else
		settingsTabBtn.BackgroundColor3 = theme.Accent
		playerTabBtn.BackgroundColor3 = theme.Btn
	end
end

for i, theme in ipairs(themes) do
	local cBtn = Instance.new("TextButton")
	cBtn.Size = UDim2.new(0.23, 0, 1, 0)
	cBtn.Position = UDim2.new((i - 1) * 0.256, 0, 0, 0)
	cBtn.BackgroundColor3 = theme.Accent
	cBtn.Text = theme.Name
	cBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	cBtn.Font = Enum.Font.GothamBold
	cBtn.TextSize = 11
	cBtn.Parent = colorContainer

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = cBtn

	cBtn.MouseButton1Click:Connect(function()
		applyTheme(theme)
	end)
end

local sizeLabel = Instance.new("TextLabel")
sizeLabel.Size = UDim2.new(1, 0, 0.14, 0)
sizeLabel.Position = UDim2.new(0, 0, 0.44, 0)
sizeLabel.BackgroundTransparency = 1
sizeLabel.Text = "Размер окна:"
sizeLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
sizeLabel.Font = Enum.Font.GothamSemibold
sizeLabel.TextSize = 13
sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
sizeLabel.Parent = settingsPage

local sizeContainer = Instance.new("Frame")
sizeContainer.Size = UDim2.new(1, 0, 0.22, 0)
sizeContainer.Position = UDim2.new(0, 0, 0.59, 0)
sizeContainer.BackgroundTransparency = 1
sizeContainer.Parent = settingsPage

local sizes = {
	{Name = "Малый", W = 220, H = 260},
	{Name = "Средний", W = 260, H = 310},
	{Name = "Большой", W = 310, H = 360}
}

for i, sz in ipairs(sizes) do
	local sBtn = Instance.new("TextButton")
	sBtn.Size = UDim2.new(0.31, 0, 1, 0)
	sBtn.Position = UDim2.new((i - 1) * 0.345, 0, 0, 0)
	sBtn.BackgroundColor3 = currentTheme.BtnBg
	sBtn.Text = sz.Name
	sBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	sBtn.Font = Enum.Font.GothamSemibold
	sBtn.TextSize = 12
	sBtn.Parent = sizeContainer

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = sBtn

	table.insert(themedButtons, sBtn)

	sBtn.MouseButton1Click:Connect(function()
		mainFrame.Size = UDim2.new(0, sz.W, 0, sz.H)
	end)
end

-- Переключение вкладок
playerTabBtn.MouseButton1Click:Connect(function()
	activeTab = "Player"
	playerPage.Visible = true
	settingsPage.Visible = false
	playerTabBtn.BackgroundColor3 = currentTheme.Accent
	settingsTabBtn.BackgroundColor3 = currentTheme.BtnBg
end)

settingsTabBtn.MouseButton1Click:Connect(function()
