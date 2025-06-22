-- Basic Aimbot for Roblox RIVALS
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AimbotEnabled = false
local AimKey = Enum.KeyCode.E -- ganti sesuai keinginan

local FOVRadius = 100 -- radius lingkaran aimbot di layar

-- Function untuk cari musuh terdekat dalam FOV
local function GetClosestEnemy()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local headPos, onScreen = Camera:WorldToScreenPoint(player.Character.Head.Position)
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local dist = (Vector2.new(headPos.X, headPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).magnitude
                if dist < FOVRadius and dist < shortestDistance then
                    closestPlayer = player
                    shortestDistance = dist
                end
            end
        end
    end

    return closestPlayer
end

-- Function untuk mengarahkan camera ke musuh
local function AimAt(target)
    if target and target.Character and target.Character:FindFirstChild("Head") then
        local headPos = target.Character.Head.Position
        local camPos = Camera.CFrame.Position
        local direction = (headPos - camPos).unit
        local newCFrame = CFrame.new(camPos, camPos + direction)
        Camera.CFrame = newCFrame
    end
end

-- Toggle aimbot dengan tombol
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == AimKey then
        AimbotEnabled = not AimbotEnabled
        print("Aimbot: " .. (AimbotEnabled and "ON" or "OFF"))
    end
end)

-- Loop aimbot setiap frame saat aktif
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = GetClosestEnemy()
        if target then
            AimAt(target)
        end
    end
end)
