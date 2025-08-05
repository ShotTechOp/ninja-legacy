local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- GUI Toggle
_G.autoFarm = true

-- GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "WarFarmToggleGui"

local toggleButton = Instance.new("TextButton")
toggleButton.Parent = screenGui
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0, 100)
toggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "🟢 AutoFarm ON"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20
toggleButton.Draggable = true
toggleButton.Active = true

toggleButton.MouseButton1Click:Connect(function()
    _G.autoFarm = not _G.autoFarm
    toggleButton.Text = _G.autoFarm and "🟢 AutoFarm ON" or "🔴 AutoFarm OFF"
end)

-- 🛡️ Anti-AFK
pcall(function()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        print("✅ Anti-AFK triggered")
    end)
end)

-- Remotes
local combatRemote = ReplicatedStorage:WaitForChild("Combat"):WaitForChild("Remotes"):WaitForChild("Combat")
local skillRemote = ReplicatedStorage:WaitForChild("SkillRemotes"):WaitForChild("Jutsu"):WaitForChild("ClanJutsu"):WaitForChild("Uchiha"):WaitForChild("RagingFlames"):WaitForChild("RemoteEvent")
local transformRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("TransformEvent")
local attackDelay = 0.1
local transformed = false

-- Enemy list
local enemyNames = {
    "White Zetsu", "Ten Tails",
    "Madara Uchiha | Shinobi",
    "Kisame Hoshigaki | Akatsuki",
    "Chinoike | Rouge Ninja",
    "Hoshi Kazesuna | Jonin",
    "Sasuke Uchiha | Rouge",
    "Itachi Uchiha | Akatsuki",
    "Hagoromo",
    "Obito Uchiha | Akatsuki",
    "Uchiha | Rouge Ninja",
    "Jinpachi Munachi | Seven Ninja Swordsmen",
    "Senju | Rouge Ninja",
    "Minato Namikaze | Jonin",
    "Shisui Uchiha | Jonin"
}

-- TP to enemy
task.spawn(function()
    while true do
        if _G.autoFarm then
            pcall(function()
                for _, name in pairs(enemyNames) do
                    local enemy = workspace:FindFirstChild(name)
                    if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                        local myChar = player.Character or player.CharacterAdded:Wait()
                        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                        if myHRP then
                            myHRP.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                        end
                        break
                    end
                end
            end)
        end
        wait(0.5)
    end
end)

-- M1 Combat
task.spawn(function()
    while true do
        if _G.autoFarm then
            pcall(function()
                for _, name in pairs(enemyNames) do
                    local enemy = workspace:FindFirstChild(name)
                    if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                        combatRemote:FireServer({
                            Skill = "M1",
                            Target = enemy.HumanoidRootPart,
                            Position = enemy.HumanoidRootPart.Position
                        })
                        break
                    end
                end
            end)
        end
        wait(attackDelay)
    end
end)

-- Substitution
task.spawn(function()
    while true do
        if _G.autoFarm then
            pcall(function()
                local subRemote = player:FindFirstChild("PlayerGui")
                if subRemote then
                    subRemote = subRemote:FindFirstChild("SubstitutionMobile")
                    and subRemote.SubstitutionMobile:FindFirstChild("Frame")
                    and subRemote.SubstitutionMobile.Frame:FindFirstChild("ImageButton")
                    and subRemote.SubstitutionMobile.Frame.ImageButton:FindFirstChild("LocalScript")
                    and subRemote.SubstitutionMobile.Frame.ImageButton.LocalScript:FindFirstChild("RemoteEvent")
                    if subRemote then
                        subRemote:FireServer()
                    end
                end
            end)
        end
        wait(0.3)
    end
end)

-- GainChi
task.spawn(function()
    while true do
        if _G.autoFarm then
            pcall(function()
                local chiRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("GainChi")
                chiRemote:FireServer()
            end)
        end
        wait(3)
    end
end)

-- Raging Flames skill
task.spawn(function()
    while true do
        if _G.autoFarm then
            pcall(function()
                skillRemote:FireServer()
            end)
        end
        wait(3)
    end
end)

-- One-time Transform
task.spawn(function()
    if not transformed then
        pcall(function()
            transformRemote:FireServer()
            transformed = true
        end)
    end
end)

print("✅ War Mode Auto-Farm (Mobile + GUI Toggle) loaded.")
