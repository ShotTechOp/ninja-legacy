
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

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

-- Settings
local attackDelay = 0.1
local fireballCooldown = 1.5
local sharinganUsed = false
_G.autoFarm = true

-- Remotes
local combatRemote = ReplicatedStorage:WaitForChild("Combat"):WaitForChild("Remotes"):WaitForChild("Combat")
local chiRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("GainChi")
local subRemote = player:WaitForChild("PlayerGui"):WaitForChild("SubstitutionMobile")
    :WaitForChild("Frame"):WaitForChild("ImageButton"):WaitForChild("LocalScript"):WaitForChild("RemoteEvent")
local fireballRemote = ReplicatedStorage:WaitForChild("SkillRemotes")
    :WaitForChild("Jutsu"):WaitForChild("FireStyle"):WaitForChild("FireBall"):WaitForChild("RemoteEvent")
local transformRemote = ReplicatedStorage:WaitForChild("Jutsu"):WaitForChild("Modes")
    :WaitForChild("Sharingan"):WaitForChild("MS"):WaitForChild("ShisuiMS")
    :WaitForChild("Stage3"):WaitForChild("Transform")

-- 🔁 TP to Pain every 0.5s
task.spawn(function()
    while _G.autoFarm do
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
        wait(0.5)
    end
end)

-- 🔁 Substitution every 0.3s
task.spawn(function()
    while _G.autoFarm do
        pcall(function()
            subRemote:FireServer()
        end)
        wait(0.3)
    end
end)

-- 🔁 GainChi every 2s
task.spawn(function()
    while _G.autoFarm do
        pcall(function()
            chiRemote:FireServer()
        end)
        wait(2)
    end
end)

-- 🔥 Fireball Jutsu every 1.5s
task.spawn(function()
    while _G.autoFarm do
        pcall(function()
            fireballRemote:FireServer()
            print("🔥 Fireball Jutsu triggered")
        end)
        wait(fireballCooldown)
    end
end)

-- 🧠 Sharingan MS Transform (once)
task.spawn(function()
    while not sharinganUsed do
        pcall(function()
            transformRemote:FireServer()
            sharinganUsed = true
            print("🧠 Shisui MS Stage 3 Transform triggered")
        end)
        wait(1)
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
    while _G.autoFarm do
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
        wait(attackDelay)
    end
end)

print("✅ [Pain Auto-Farm Script Started ✅] (Fireball + ShisuiMS Transform enabled)")
