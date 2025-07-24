_G.autoMandaFarm = true

-- [🔥 Start]
local rs, plr, char = game:GetService("ReplicatedStorage"), game.Players.LocalPlayer, game.Players.LocalPlayer.Character
local function getChar() return plr.Character or workspace:WaitForChild(plr.Name) end
local function waitForManda() while not workspace.BossScrolls.Bosses:FindFirstChild("Manda") and _G.autoMandaFarm do task.wait(0.1) end end

-- [📍 TP to Manda]
local function tpToManda()
    local boss = workspace.BossScrolls.Bosses:FindFirstChild("Manda")
    if boss and boss:FindFirstChild("HumanoidRootPart") then
        getChar():WaitForChild("HumanoidRootPart").CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end

-- [⚔️ Remote Combat]
local function attack()
    pcall(function()
        rs:WaitForChild("Combat"):WaitForChild("Remotes"):WaitForChild("Combat"):FireServer()
    end)
end

-- [🔥 Fireball every 1.5s]
task.spawn(function()
    while _G.autoMandaFarm do
        pcall(function()
            rs:WaitForChild("SkillRemotes"):WaitForChild("Jutsu"):WaitForChild("Ninjutsu"):WaitForChild("FireStyle"):WaitForChild("FireBall"):WaitForChild("RemoteEvent"):FireServer()
        end)
        task.wait(1.5)
    end
end)

-- [🔁 Gain Chakra every 3s]
task.spawn(function()
    while _G.autoMandaFarm do
        pcall(function()
            rs:WaitForChild("Remotes"):WaitForChild("GainChi"):FireServer()
        end)
        task.wait(3)
    end
end)

-- [💨 Auto Substitution every 0.3s]
task.spawn(function()
    while _G.autoMandaFarm do
        pcall(function()
            rs:WaitForChild("Remotes"):WaitForChild("Sub"):FireServer()
        end)
        task.wait(0.3)
    end
end)

-- [🧠 Mode Transform (MS Stage 3)]
task.spawn(function()
    while _G.autoMandaFarm do
        pcall(function()
            rs:WaitForChild("Jutsu"):WaitForChild("Modes"):WaitForChild("Sharingan"):WaitForChild("MS"):WaitForChild("SasukeMS"):WaitForChild("Stage3"):WaitForChild("Transform"):FireServer()
        end)
        task.wait(5)
    end
end)

-- [🌀 Summon Manda]
local function summonManda()
    pcall(function()
        rs:WaitForChild("Missions"):WaitForChild("BossScrolls"):WaitForChild("Manda"):WaitForChild("Summon"):FireServer()
    end)
end

-- [🔁 Main Loop]
task.spawn(function()
    while _G.autoMandaFarm do
        summonManda()
        waitForManda()
        while workspace.BossScrolls.Bosses:FindFirstChild("Manda") and _G.autoMandaFarm do
            tpToManda()
            attack()
            task.wait(0.1)
        end
        task.wait(1)
    end
end)

print("✅ Auto Manda Farm with Remote Fireball, Combat, Transform started.")