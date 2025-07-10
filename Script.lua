local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid, Root

-- Utility to update Character references
local function refreshChar()
    Character = Player.Character or Player.CharacterAdded:Wait()
    Humanoid = Character:FindFirstChildOfClass("Humanoid")
    Root = Character:FindFirstChild("HumanoidRootPart")
end

refreshChar()
Player.CharacterAdded:Connect(refreshChar)

local CurrentSpeed = 0
local MoonEnabled = false
local GravityConn
local TeleportUp = true
local ESPEnabled = false
local ESPInstances = {}

local Window = Rayfield:CreateWindow({
    Name = "Souls hub",
    LoadingTitle = "Loading...",
    ConfigFolder = "Souls",
})

local MainTab = Window:CreateTab("Main")
local ServerTab = Window:CreateTab("Server")
local DiscordTab = Window:CreateTab("Discord")

-- Moon Gravity
MainTab:CreateToggle({
    Name = "Gravity",
    CurrentValue = false,
    Flag = "moon_toggle",
    Callback = function(value)
        MoonEnabled = value
        if GravityConn then GravityConn:Disconnect() end
        if MoonEnabled and Humanoid and Root then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = 96
            GravityConn = RunService.Stepped:Connect(function()
                if Root.Velocity.Y < 0 then
                    Root.Velocity = Root.Velocity * Vector3.new(1, 0.9, 1)
                end
            end)
        elseif Humanoid then
            Humanoid.JumpPower = 50
        end
    end
})

-- Teleport Up/Down Button
MainTab:CreateButton({
    Name = "Teleport Up/Down",
    Callback = function()
        if Root then
            if TeleportUp then
                Root.CFrame = Root.CFrame + Vector3.new(0, 150, 0)
            else
                Root.CFrame = Root.CFrame - Vector3.new(0, 150, 0)
            end
            TeleportUp = not TeleportUp
        end
    end
})

-- Speed Slider
MainTab:CreateSlider({
    Name = "Speed Boost",
    Range = {0, 6},
    Increment = 0.1,
    CurrentValue = 0,
    Flag = "speed_slider",
    Callback = function(val)
        CurrentSpeed = val
    end
})

-- Speed execution
RunService.Heartbeat:Connect(function(dt)
    if Humanoid and Root and CurrentSpeed > 0 then
        local dir = Humanoid.MoveDirection
        if dir.Magnitude > 0 then
            Root.CFrame = Root.CFrame + dir * CurrentSpeed * dt * 10
        end
    end
end)

-- Invisibility Cloak Support
MainTab:CreateButton({
    Name = "Use Invisibility Cloak",
    Callback = function()
        if Root then
            local cloak = Character:FindFirstChild("Invisibility Cloak")
            if cloak and cloak:GetAttribute("SpeedModifier") == 2 then
                cloak.Parent = workspace
                Rayfield:Notify({Title="HOKALAZA",Content="Cloak dropped for invisibility.",Duration=2})
            else
                Rayfield:Notify({Title="Error",Content="You need to wear an Invisibility Cloak first!",Duration=2})
            end
        end
    end
})

-- ESP Toggle
MainTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "esp_toggle",
    Callback = function(enabled)
        ESPEnabled = enabled
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= Player then
                if enabled then
                    local root = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                    if root and not ESPInstances[p] then
                        local bb = Instance.new("BillboardGui", root)
                        bb.Name = "HOKALAZA_ESP"
                        bb.Size = UDim2.new(0,100,0,25)
                        bb.AlwaysOnTop = true
                        bb.Adornee = root
                        local lbl = Instance.new("TextLabel", bb)
                        lbl.Size = UDim2.new(1,0,1,0)
                        lbl.BackgroundTransparency = 1
                        lbl.Text = p.DisplayName
                        lbl.TextColor3 = Color3.new(1,1,0)
                        lbl.TextScaled = true
                        ESPInstances[p] = bb
                    end
                else
                    if ESPInstances[p] then
                        ESPInstances[p]:Destroy()
                        ESPInstances[p] = nil
                    end
                end
            end
        end
    end
})

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        if ESPEnabled then
            task.wait(0.5)
            MainTab.Flags["esp_toggle"] = true
            MainTab_:Callback(true)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(p)
    if ESPInstances[p] then ESPInstances[p]:Destroy(); ESPInstances[p]=nil end
end)

-- Server Controls
ServerTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
    end
})

ServerTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local data = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _, s in ipairs(data.data) do
            if s.playing < s.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, Player)
                return
            end
        end
        Rayfield:Notify({Title="Souls hub",Content="No servers found or all servers are full.",Duration=2})
    end
})

DiscordTab:CreateButton({
    Name = "Copy Discord Invite",
    Callback = function()
        setclipboard("https://discord.gg/ede3wHEH9m")
        Rayfield:Notify({
            Title = "Souls Hub",
            Content = "Discord invite copied to clipboard!",
            Duration = 2
        })
    end
})

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        MainTab:TouchFlag("Teleport Up/Down")
    elseif input.KeyCode == Enum.KeyCode.F then
        local shopGui = Player:WaitForChild("PlayerGui"):FindFirstChild("Main")
        if shopGui and shopGui:FindFirstChild("CoinsShop") then
            shopGui.CoinsShop.Visible = not shopGui.CoinsShop.Visible
        end
    end
end)
