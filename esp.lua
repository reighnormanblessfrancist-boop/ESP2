-- ScreenGui ESP Script
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESPEnabled = false
local RGBEnabled = false
local ESPObjects = {}

-- Create simple GUI for toggles
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SupanESPGui"
ScreenGui.Parent = game:GetService("CoreGui")

-- Enable Button
local EnableBtn = Instance.new("TextButton")
EnableBtn.Size = UDim2.new(0,120,0,40)
EnableBtn.Position = UDim2.new(0,10,0,10)
EnableBtn.Text = "Enable ESP"
EnableBtn.Parent = ScreenGui
EnableBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
EnableBtn.TextScaled = true
EnableBtn.MouseButton1Click:Connect(function()
    ESPEnabled = true
end)

-- Disable Button
local DisableBtn = Instance.new("TextButton")
DisableBtn.Size = UDim2.new(0,120,0,40)
DisableBtn.Position = UDim2.new(0,10,0,60)
DisableBtn.Text = "Disable ESP"
DisableBtn.Parent = ScreenGui
DisableBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
DisableBtn.TextScaled = true
DisableBtn.MouseButton1Click:Connect(function()
    ESPEnabled = false
    -- Remove all ESP objects
    for _, obj in pairs(ESPObjects) do
        obj.Box:Destroy()
        obj.NameLabel:Destroy()
    end
    ESPObjects = {}
end)

-- RGB Toggle
local RGBBtn = Instance.new("TextButton")
RGBBtn.Size = UDim2.new(0,120,0,40)
RGBBtn.Position = UDim2.new(0,10,0,110)
RGBBtn.Text = "Toggle RGB"
RGBBtn.Parent = ScreenGui
RGBBtn.BackgroundColor3 = Color3.fromRGB(0,0,255)
RGBBtn.TextScaled = true
RGBBtn.MouseButton1Click:Connect(function()
    RGBEnabled = not RGBEnabled
end)

-- Function to create ESP for a player
local function createESP(player)
    if ESPObjects[player] then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    box.AlwaysOnTop = true
    box.Size = Vector3.new(2,5,1)
    box.ZIndex = 10
    box.Parent = workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,100,0,30)
    billboard.Adornee = player.Character and player.Character:FindFirstChild("Head")
    billboard.AlwaysOnTop = true
    billboard.Parent = workspace

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,1,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextScaled = true
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255,0,0)
    nameLabel.Parent = billboard

    ESPObjects[player] = {Box=box, NameLabel=nameLabel}
end

-- Function to remove ESP
local function removeESP(player)
    if ESPObjects[player] then
        ESPObjects[player].Box:Destroy()
        ESPObjects[player].NameLabel.Parent:Destroy()
        ESPObjects[player] = nil
    end
end

-- Update ESP colors (for RGB)
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if not ESPObjects[player] then
                    createESP(player)
                end
                if RGBEnabled then
                    local color = Color3.fromHSV(tick()%5/5,1,1)
                    ESPObjects[player].Box.Color = color
                    ESPObjects[player].NameLabel.TextColor3 = color
                else
                    ESPObjects[player].Box.Color = Color3.fromRGB(255,0,0)
                    ESPObjects[player].NameLabel.TextColor3 = Color3.fromRGB(255,0,0)
                end
            end
        end
    end
end)

-- Auto handle new players
Players.PlayerAdded:Connect(function(player)
    if ESPEnabled then
        createESP(player)
    end
end)

-- Remove ESP when player leaves
Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)
