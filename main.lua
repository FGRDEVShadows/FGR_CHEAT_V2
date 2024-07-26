local function createCoreGUI()
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    -- Проверяем, существует ли уже GUI, и удаляем его, если это так
    local existingGui = playerGui:FindFirstChild("CoreGUI")
    if existingGui then
        existingGui:Destroy()
    end

    local coreGui = Instance.new("ScreenGui")
    coreGui.Name = "CoreGUI"
    coreGui.Parent = playerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 200, 0, 100)  -- Размер 200x100 пикселей
    mainFrame.Position = UDim2.new(1, -210, 0.5, -50)  -- Начальная позиция справа от экрана
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Черный фон
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = coreGui
    mainFrame.Visible = true  -- Сначала видимо

    -- Добавляем градиент для неоновости
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),  -- Темный цвет
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))   -- Более светлый оттенок
    })
    gradient.Parent = mainFrame

    -- Заголовок
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.8, 0, 0.25, 0)  -- Уменьшенный размер заголовка
    titleLabel.Position = UDim2.new(0.1, 0, 0, 0)  -- Позиция заголовка
    titleLabel.Text = "Loader FGR"  -- Название
    titleLabel.TextColor3 = Color3.fromRGB(255, 105, 0)  -- Неоново-оранжевый текст
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextStrokeTransparency = 0.7
    titleLabel.TextStrokeColor3 = Color3.fromRGB(255, 165, 0)  -- Неоновый оранжевый контур
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = mainFrame

    -- Центральная кнопка
    local actionButton = Instance.new("TextButton")
    actionButton.Size = UDim2.new(0.8, 0, 0.3, 0)
    actionButton.Position = UDim2.new(0.1, 0, 0.35, 0)  -- Позиция кнопки под заголовком
    actionButton.Text = "Launch"
    actionButton.TextColor3 = Color3.fromRGB(0, 0, 0)  -- Черный текст
    actionButton.BackgroundColor3 = Color3.fromRGB(255, 105, 0)  -- Неоново-оранжевый фон
    actionButton.BorderSizePixel = 0
    actionButton.Font = Enum.Font.GothamBold
    actionButton.TextScaled = true
    actionButton.TextStrokeTransparency = 0.7
    actionButton.TextStrokeColor3 = Color3.fromRGB(255, 165, 0)  -- Неоновый оранжевый контур
    actionButton.Parent = mainFrame

    -- Кнопка закрытия
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0.15, 0, 0.3, 0)  -- Уменьшенный размер кнопки
    closeButton.Position = UDim2.new(0.85, 0, 0, 0)  -- Позиция кнопки
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)  -- Светло-серый текст
    closeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Черный фон
    closeButton.BorderSizePixel = 0
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextScaled = true
    closeButton.TextStrokeTransparency = 0.7
    closeButton.TextStrokeColor3 = Color3.fromRGB(150, 150, 150)  -- Серый контур
    closeButton.Parent = mainFrame

    -- Добавляем закругленные углы
    local function applyCornerRound(instance)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)  -- Радиус закругления углов
        corner.Parent = instance
    end

    applyCornerRound(mainFrame)
    applyCornerRound(actionButton)
    applyCornerRound(closeButton)

    -- Добавляем анимацию появления
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)  -- Длительность и стиль анимации

    local appearanceTweenGoal = {
        Size = UDim2.new(0, 200, 0, 100),
        Position = UDim2.new(0.5, -100, 0.5, -50)  -- Позиция по центру экрана
    }

    local appearanceTween = tweenService:Create(mainFrame, tweenInfo, appearanceTweenGoal)
    appearanceTween:Play()

    -- Добавляем анимацию исчезновения
    local function onActionButtonClick()
        local scriptURL = "https://raw.githubusercontent.com/FGRDEVShadows/FGR_CHEAT_V2/main/script.lua"  -- URL скрипта
        local success, result = pcall(function()
            local scriptContent = game:HttpGet(scriptURL)
            loadstring(scriptContent)()
        end)
        if not success then
            warn("Failed to load and execute script: " .. result)
        end

        local disappearanceTweenGoal = {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(-0.5, -200, 0.5, -50)  -- Уезжает в левую сторону
        }

        local disappearanceTween = tweenService:Create(mainFrame, tweenInfo, disappearanceTweenGoal)
        disappearanceTween:Play()
        disappearanceTween.Completed:Connect(function()
            coreGui:Destroy()
        end)
    end

    actionButton.MouseButton1Click:Connect(onActionButtonClick)

    -- Функция для перетаскивания
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging then
            update(input)
        end
    end)

    -- Функция для закрытия текущего CoreGUI
    closeButton.MouseButton1Click:Connect(function()
        local closeTweenGoal = {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(-0.5, -200, 0.5, -50)  -- Уезжает в левую сторону
        }

        local closeTween = tweenService:Create(mainFrame, tweenInfo, closeTweenGoal)
        closeTween:Play()
        closeTween.Completed:Connect(function()
            coreGui:Destroy()
        end)
    end)
end

createCoreGUI()
