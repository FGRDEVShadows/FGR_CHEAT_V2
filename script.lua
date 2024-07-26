local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local coreGui = game:GetService("CoreGui")  -- Используем CoreGui вместо PlayerGui

local function createCoreGUI()
    -- Проверяем, существует ли уже GUI, и удаляем его, если это так
    local existingGui = coreGui:FindFirstChild("CoreGUI")
    if existingGui then
        existingGui:Destroy()
    end

    local coreGuiInstance = Instance.new("ScreenGui")
    coreGuiInstance.Name = "CoreGUI"
    coreGuiInstance.Parent = coreGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 500)  -- Размер 500x500 пикселей
    mainFrame.Position = UDim2.new(1, 500, 0.5, -250)  -- Начальная позиция за пределами экрана
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)  -- Темный серый фон
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = coreGuiInstance

    -- Добавляем градиент для неоновости
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),  -- Темный серый
        ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 70, 70))   -- Светлый серый
    })
    gradient.Parent = mainFrame

    -- Оранжевый Label вверху
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0.1, 0)  -- Размер в верхней части
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.Text = "FGR CHEAT V2"
    titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)  -- Черный цвет текста
    titleLabel.BackgroundColor3 = Color3.fromRGB(255, 105, 0)  -- Неоновый оранжевый фон для Label
    titleLabel.BorderSizePixel = 0
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextScaled = true
    titleLabel.TextStrokeTransparency = 0.7
    titleLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)  -- Белый контур для выделения
    titleLabel.Parent = mainFrame

    -- Кнопка закрытия
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0.05, 0, 0.05, 0)  -- Размер кнопки
    closeButton.Position = UDim2.new(0.94, 0, 0.025, 0)  -- Позиция кнопки
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Белый цвет текста
    closeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Черный фон
    closeButton.BorderSizePixel = 0
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextScaled = true
    closeButton.TextStrokeTransparency = 0.7
    closeButton.TextStrokeColor3 = Color3.fromRGB(200, 200, 200)  -- Светло-серый контур

    -- Добавляем закругленные углы для кнопки закрытия
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)  -- Полностью круглая кнопка
    corner.Parent = closeButton

    -- Эффект нажатия
    closeButton.MouseEnter:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- Темно-серый при наведении
    end)

    closeButton.MouseLeave:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Черный при уходе
    end)

    closeButton.MouseButton1Click:Connect(function()
        local closeTweenGoal = {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(-1, 0, 0.5, -250)  -- Уезжает в левую сторону
        }

        local closeTween = tweenService:Create(mainFrame, tweenInfo, closeTweenGoal)
        closeTween:Play()
        closeTween.Completed:Connect(function()
            coreGuiInstance:Destroy()
        end)
    end)
    closeButton.Parent = mainFrame

    -- Анимация появления
    local appearanceTweenGoal = {
        Size = UDim2.new(0, 500, 0, 500),
        Position = UDim2.new(0.5, -250, 0.5, -250)  -- Центр экрана
    }

    local appearanceTween = tweenService:Create(mainFrame, tweenInfo, appearanceTweenGoal)
    appearanceTween:Play()

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
end

createCoreGUI()
