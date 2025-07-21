local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- 📱 GUI Toggle
local autoFarm = false

-- Create Toggle GUI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "PainAutoFarmGUI"
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0.85, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Toggle Farm"
toggleButton.Parent = ScreenGui

toggleButton.MouseButton1Click:Connect(function()
    autoFarm = not autoFarm
    toggleButton.Text = autoFarm and "Farming: ON" or "Farming: OFF"
    print("⚙️ AutoFarm toggled:", autoFarm)
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

local combatRemote = ReplicatedStorage:WaitForChild("Combat"):WaitForChild("Remotes"):WaitForChild("Combat")
local attackDelay = 0.1

-- 🔁 TP to Pain every 0.5s
task.spawn(function()
    while true do
        if autoFarm then
            pcall(function()
                local boss = workspace:FindFirstChild("Pain | Akatsuki")
                if boss then
                    local bossRoot = boss:FindFirstChild("HumanoidRootPart")
                    local myChar = player.Character or player.CharacterAdded:Wait()
                    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                    if bossRoot and myHRP then
                        myHRP.CFrame = bossRoot.CFrame * CFrame.new(0, 0, 8)
                    end
                end
            end)
        end
        wait(0.5)
    end
end)

-- 🔁 Substitution every 0.3s
task.spawn(function()
    while true do
        if autoFarm then
            pcall(function()
                local subRemote = player:WaitForChild("PlayerGui")
                    :WaitForChild("SubstitutionMobile")
                    :WaitForChild("Frame")
                    :WaitForChild("ImageButton")
                    :WaitForChild("LocalScript")
                    :WaitForChild("RemoteEvent")
                subRemote:FireServer()
            end)
        end
        wait(0.3)
    end
end)

-- 🔁 GainChi every 3s
task.spawn(function()
    while true do
        if autoFarm then
            pcall(function()
                local chiRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("GainChi")
                chiRemote:FireServer()
            end)
        end
        wait(3)
    end
end)

-- 🔥 Fireball Jutsu every 2.5s (Minato style)
task.spawn(function()
    while true do
        if autoFarm then
            pcall(function()
                local fireballRemote = ReplicatedStorage:FindFirstChild("RemoteEvents")
                if fireballRemote then
                    local ninjutsu = fireballRemote:FindFirstChild("Ninjutsu")
                    if ninjutsu then
                        local fireball = ninjutsu:FindFirstChild("Fireball")
                        if fireball then
                            print("🔥 Firing Fireball Jutsu")
                            fireball:FireServer()
                        else
                            warn("⚠️ Fireball Remote not found!")
                        end
                    else
                        warn("⚠️ Ninjutsu folder not found!")
                    end
                else
                    warn("⚠️ RemoteEvents not found!")
                end
            end)
        end
        wait(2.5)
    end
end)

-- 📥 Auto-claim Pain drop
local function claimPainDrop()
    pcall(function()
        local drop = workspace:FindFirstChild("Pain | Akatsuki")
        if drop and drop:FindFirstChild("BossDrop") then
            local claim = drop.BossDrop:FindFirstChild("Claim")
            if claim then
                claim:FireServer()
                print("✅ Pain drop claimed")
            end
        end
    end)
end

-- 👊 M1 Combat loop
task.spawn(function()
    while true do
        if autoFarm then
            pcall(function()
                local boss = workspace:FindFirstChild("Pain | Akatsuki")
                if boss and boss:FindFirstChild("HumanoidRootPart") then
                    combatRemote:FireServer({
                        Skill = "M1",
                        Target = boss.HumanoidRootPart,
                        Position = boss.HumanoidRootPart.Position
                    })
                    claimPainDrop()
                end
            end)
        end
        wait(attackDelay)
    end
end)

print("✅ Auto Pain Boss Farm (Mobile GUI Toggle) Loaded")
