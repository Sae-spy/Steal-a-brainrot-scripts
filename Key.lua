local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local StarterGui = Player:WaitForChild("PlayerGui")

-- Create ScreenGui
local gui = Instance.new("ScreenGui", StarterGui)
gui.Name = "SoulsKeyGui"
gui.ResetOnSpawn = false

-- Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

-- UICorner
local corner = Instance.new("UICorner", frame)

-- Title Label
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Souls Hub Key System"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1, 1, 1)

-- TextBox
local keyBox = Instance.new("TextBox", frame)
keyBox.Size = UDim2.new(0.8, 0, 0, 30)
keyBox.Position = UDim2.new(0.1, 0, 0.3, 0)
keyBox.PlaceholderText = "Enter Key Here"
keyBox.Text = ""
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 16
keyBox.TextColor3 = Color3.new(0, 0, 0)
keyBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", keyBox)

-- Message Label
local msgLabel = Instance.new("TextLabel", frame)
msgLabel.Size = UDim2.new(1, 0, 0, 25)
msgLabel.Position = UDim2.new(0, 0, 0.55, 0)
msgLabel.Text = ""
msgLabel.Font = Enum.Font.Gotham
msgLabel.TextSize = 14
msgLabel.TextColor3 = Color3.new(1, 1, 1)
msgLabel.BackgroundTransparency = 1

-- Redeem Button
local redeemBtn = Instance.new("TextButton", frame)
redeemBtn.Size = UDim2.new(0.35, 0, 0, 30)
redeemBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
redeemBtn.Text = "Redeem"
redeemBtn.Font = Enum.Font.GothamBold
redeemBtn.TextSize = 16
redeemBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
redeemBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", redeemBtn)

-- Get Key Button
local getKeyBtn = Instance.new("TextButton", frame)
getKeyBtn.Size = UDim2.new(0.35, 0, 0, 30)
getKeyBtn.Position = UDim2.new(0.55, 0, 0.7, 0)
getKeyBtn.Text = "Get Key"
getKeyBtn.Font = Enum.Font.GothamBold
getKeyBtn.TextSize = 16
getKeyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
getKeyBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", getKeyBtn)

-- Logic
local CORRECT_KEY = "Souls1"
redeemBtn.MouseButton1Click:Connect(function()
	local input = keyBox.Text
	if input == CORRECT_KEY then
		msgLabel.Text = "Key accepted! Loading hub..."
		msgLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
		wait(1)
		gui:Destroy()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Sae-spy/Steal-a-brainrot-scripts/refs/heads/main/Script.lua"))()
	else
		msgLabel.Text = "Invalid key!"
		msgLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
	end
end)

getKeyBtn.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/ede3wHEH9m")
	msgLabel.Text = "Discord link copied!"
	msgLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
end)
