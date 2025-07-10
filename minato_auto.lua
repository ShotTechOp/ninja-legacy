local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- 🔧 Settings
local attackDelay = 0.1
local fireballCooldown = 3
local sharinganUsed = false
local autoFarm = true
local toggleState = true
local keyPressed = false

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

-- 🔁 F6 Toggle with Status Message
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.F6 and not keyPressed then
        toggleState = not toggleState
        autoFarm = toggleState
        keyPressed = true
        print(toggleState and "🟢 AutoFarm Toggled ON" or "🔴 AutoFarm Toggled OFF")
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F6 then
        keyPressed = false
    end
end)

-- 🔁 Remote References
local combatRemote = ReplicatedStorage:WaitForChild("Combat"):WaitForChild("Remotes"):WaitForChild("Combat")
local chiRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("GainChi")
local fireballRemote = ReplicatedStorage:WaitForChild("SkillRemotes")
    :WaitForChild("Jutsu"):WaitForChild("ClanJutsu"):WaitForChild("Uchiha")
    :WaitForChild("RagingFlames"):WaitForChild("RemoteEvent")
local transformRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("TransformEvent")
local subRemote = player:WaitForChild("PlayerGui")
    :WaitForChild("SubstitutionMobile"):WaitForChild("Frame")
    :WaitForChild("ImageButton"):WaitForChild("LocalScript")
    :WaitForChild("RemoteEvent")

-- 🔁 TP to Minato
task.spawn(function()
    while true do
        if autoFarm then
            pcall(function()
                local boss = workspace:FindFirstChild("BossScrolls")
                    and workspace.BossScrolls:FindFirstChild("Bosses")
                    and workspace.BossScrolls.Bosses:FindFirstChild("Minato Namikaze | Jonin")
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

-- 🌀 Substitution every 0.3s
task.spawn(function()
    while true do
        if autoFarm then
            pcall(function()
                subRemote:FireServer()
            end)
        end
        wait(0.3)
    end
end)

-- 🔋 GainChi every 3s
task.spawn(function()
    while true do
        if autoFarm then
            pcall(function()
                chiRemote:FireServer()
            end)
        end
        wait(3)
    end
end)

-- 🔥 Fireball every 3s
task.spawn(function()
    while true do
        if autoFarm then
            pcall(function()
                fireballRemote:FireServer()
            end)
        end
        wait(fireballCooldown)
    end
end)

-- 👁️ Transform once
task.spawn(function()
    if not sharinganUsed then
        pcall(function()
            transformRemote:FireServer()
            sharinganUsed = true
        end)
    end
end)

-- 📜 Accept + Summon Minato
local function summonMinato()
    pcall(function()
        local summon = ReplicatedStorage:WaitForChild("Missions")
            :WaitForChild("BossScrolls"):WaitForChild("Minato")
            :FindFirstChild("Summon")
        if summon then
            summon:FireServer()
            print("✅ Minato Summon Fired")
        end
    end)
end

-- ⏳ Wait for Minato
local function waitForMinato()
    for _ = 1, 20 do
        local boss = workspace:FindFirstChild("BossScrolls")
            and workspace.BossScrolls:FindFirstChild("Bosses")
            and workspace.BossScrolls.Bosses:FindFirstChild("Minato Namikaze | Jonin")
        if boss and boss:FindFirstChild("HumanoidRootPart") then
            return boss.HumanoidRootPart
        end
        wait(1)
    end
    return nil
end

-- 👊 M1 loop
local function autoM1(root)
    while root and root.Parent and autoFarm do
        pcall(function()
            combatRemote:FireServer({
                Skill = "M1",
                Target = root,
                Position = root.Position
            })
        end)
        wait(attackDelay)
        root = workspace:FindFirstChild("BossScrolls")
            and workspace.BossScrolls:FindFirstChild("Bosses")
            and workspace.BossScrolls.Bosses:FindFirstChild("Minato Namikaze | Jonin")
            and workspace.BossScrolls.Bosses["Minato Namikaze | Jonin"]:FindFirstChild("HumanoidRootPart")
    end
end

-- 🔁 Main loop
task.spawn(function()
    while true do
        if autoFarm then
            pcall(function()
                summonMinato()
                wait(1)
                local root = waitForMinato()
                if root then autoM1(root) end
            end)
        end
        wait(2)
    end
end)

print("✅ Auto Minato Farm (with F6 toggle + Fireball + Transform + Substitution) started.")
