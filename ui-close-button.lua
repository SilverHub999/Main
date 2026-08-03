local UserInputService = game:GetService("UserInputService")
local args = {...}

task.spawn(function()
	local TweenService = game:GetService("TweenService")
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local Mouse = LocalPlayer:GetMouse()

	local function MakeDraggable(topbarobject, object)
		local Dragging = nil
		local DragInput = nil
		local DragStart = nil
		local StartPosition = nil

		local function Update(input)
			local Delta = input.Position - DragStart
			local pos = UDim2.new(
				StartPosition.X.Scale,
				StartPosition.X.Offset + Delta.X,
				StartPosition.Y.Scale,
				StartPosition.Y.Offset + Delta.Y
			)

			TweenService:Create(object, TweenInfo.new(0.2), {
				Position = pos
			}):Play()
		end

		topbarobject.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then

				Dragging = true
				DragStart = input.Position
				StartPosition = object.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)

		topbarobject.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch then
				DragInput = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input == DragInput and Dragging then
				Update(input)
			end
		end)
	end

	local function GetMainUI()
		for _, v in ipairs(game:GetService("CoreGui"):GetChildren()) do
			if v:IsA("ScreenGui") and v.Name ~= "CloseUI" then
				return v
			end
		end

		for _, v in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
			if v:IsA("ScreenGui") then
				return v
			end
		end
	end

	if game:GetService("CoreGui"):FindFirstChild("CloseUI") then
		game:GetService("CoreGui").CloseUI:Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")
	local Frame = Instance.new("Frame")
	Frame.ZIndex = 99999

	local UICorner = Instance.new("UICorner")
	local TextLabel = Instance.new("TextLabel")
	local TextButton = Instance.new("TextButton")

	MakeDraggable(TextButton, Frame)

	ScreenGui.Name = "CloseUI"
	ScreenGui.Parent = game:GetService("CoreGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.DisplayOrder = 1000

	Frame.Parent = ScreenGui
	Frame.Active = true
	Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(0.081166774, 0, 0.0841463208, 0)
	Frame.Size = UDim2.new(0, 47, 0, 47)

	UICorner.Parent = Frame

	TextLabel.Parent = Frame
	TextLabel.Active = true
	TextLabel.BackgroundTransparency = 1
	TextLabel.Position = UDim2.new(0, 0, 0.0212765951, 0)
	TextLabel.Size = UDim2.new(0, 47, 0, 47)
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.Text = ""
	TextLabel.TextColor3 = Color3.new(1, 1, 1)
	TextLabel.TextSize = 14

	TextButton.Parent = Frame
	TextButton.BackgroundTransparency = 1
	TextButton.Size = UDim2.new(0, 47, 0, 47)
	TextButton.Text = ""

	local focus = false

	TextButton.MouseButton1Down:Connect(function()
		local RoyXUi = GetMainUI()
		if not RoyXUi then
			warn("No UI Found")
			return
		end
		local VirtualInputManager = game:GetService("VirtualInputManager")
		TextButton.MouseButton1Down:Connect(function()
			VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
			task.wait()
			VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
		end)
		focus = not focus
	end)
end)
