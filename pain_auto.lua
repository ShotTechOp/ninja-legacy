local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
_G.autoPainFarm = true

-- 🔁 Toggle key (F6)
UIS.InputBegan:Connect(function(inp, gp)
    if not gp and inp.KeyCode == Enum.KeyCode.F6 then
        _G.autoPainFarm = not _G.autoPainFarm
        print("🔁 AutoFarm toggled:", _G.autoPainFarm)
    end
end)

-- 🛡️ Anti-AFK
pcall(function()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
        print("✅ Anti-AFK triggered")
    end)
end)

-- 👁️ Transform once (Sasuke MS Stage 3)
pcall(function()
    RS.Jutsu.Modes.Sharingan.MS.SasukeMS.Stage3.Transform:FireServer()
    print("🧠 Transform (SasukeMS Stage3) triggered")
end)

-- 🔁 TP to Pain every 0.5s
task.spawn(function()
    while _G.autoPainFarm do
        pcall(function()
            local boss = workspace:FindFirstChild("Pain | Akatsuki")
            if boss then
                local hrp = boss:FindFirstChild("HumanoidRootPart")
                local plrHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp and plrHRP then
                    plrHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, 8)
                end
            end
        end)
        wait(0.5)
    end
end)

-- 🔁 Substitution every 0.3s
task.spawn(function()
    while _G.autoPainFarm do
        pcall(function()
            local subRem = player.PlayerGui.SubstitutionMobile.Frame.ImageButton.LocalScript.RemoteEvent
            subRem:FireServer()
        end)
        wait(0.3)
    end
end)

-- 🔁 GainChi every 1s
task.spawn(function()
    while _G.autoPainFarm do
        pcall(function()
            RS.RemoteEvents.GainChi:FireServer()
        end)
        wait(1)
    end
end)

-- 🔥 Fireball Jutsu every 0.5s
task.spawn(function()
    while _G.autoPainFarm do
        pcall(function()
            RS.SkillRemotes.Jutsu.Ninjutsu.FireStyle.FireBall.RemoteEvent:FireServer()
            print("🔥 Fireball Jutsu triggered")
        end)
        wait(0.5)
    end
end)

-- 👊 M1 Combat using provided RemoteEvent
task.spawn(function()
    while _G.autoPainFarm do
        pcall(function()
            RS.Combat.Remotes.Combat:FireServer()
        end)
        wait(0.1)
    end
end)

-- 📥 Auto-claim Pain drop
task.spawn(function()
    while _G.autoPainFarm do
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
        wait(1)
    end
end)

print("✅ Auto Pain Farm Mobile now loaded!")
