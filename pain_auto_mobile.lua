local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
_G.autoPainFarm = true

-- 🟩 GUI Toggle
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "PainAutoFarmGUI"
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 180, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 300)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
ToggleButton.Text = "🟢 Auto Pain Farm ON"
ToggleButton.TextScaled = true
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold

ToggleButton.MouseButton1Click:Connect(function()
    _G.autoPainFarm = not _G.autoPainFarm
    ToggleButton.Text = _G.autoPainFarm and "🟢 Auto Pain Farm ON" or "🔴 Auto Pain Farm OFF"
    ToggleButton.BackgroundColor3 = _G.autoPainFarm and Color3.fromRGB(40, 170, 90) or Color3.fromRGB(170, 40, 40)
    print("🔁 AutoFarm toggled via GUI:", _G.autoPainFarm)
end)

-- 🔁 Toggle key (F6)
UIS.InputBegan:Connect(function(inp, gp)
    if not gp and inp.KeyCode == Enum.KeyCode.F6 then
        _G.autoPainFarm = not _G.autoPainFarm
        ToggleButton.Text = _G.autoPainFarm and "🟢 Auto Pain Farm ON" or "🔴 Auto Pain Farm OFF"
        ToggleButton.BackgroundColor3 = _G.autoPainFarm and Color3.fromRGB(40, 170, 90) or Color3.fromRGB(170, 40, 40)
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
    while true do
        if _G.autoPainFarm then
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
        end
        wait(0.5)
    end
end)

-- 🔁 Substitution every 0.3s
task.spawn(function()
    while true do
        if _G.autoPainFarm then
            pcall(function()
                local subRem = player.PlayerGui.SubstitutionMobile.Frame.ImageButton.LocalScript.RemoteEvent
                subRem:FireServer()
            end)
        end
        wait(0.3)
    end
end)

-- 🔁 GainChi every 3s
task.spawn(function()
    while true do
        if _G.autoPainFarm then
            pcall(function()
                RS.RemoteEvents.GainChi:FireServer()
            end)
        end
        wait(3)
    end
end)

-- 🔥 Fireball Jutsu every 0.5s
task.spawn(function()
    while true do
        if _G.autoPainFarm then
            pcall(function()
                RS.SkillRemotes.Jutsu.Ninjutsu.FireStyle.FireBall.RemoteEvent:FireServer()
                print("🔥 Fireball Jutsu triggered")
            end)
        end
        wait(0.5)
    end
end)

-- 👊 M1 Combat using provided RemoteEvent
task.spawn(function()
    while true do
        if _G.autoPainFarm then
            pcall(function()
                RS.Combat.Remotes.Combat:FireServer()
            end)
        end
        wait(0.1)
    end
end)

-- 📥 Auto-claim Pain drop
task.spawn(function()
    while true do
        if _G.autoPainFarm then
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
        wait(1)
    end
end)

print("✅ Auto Pain Farm Mobile with GUI loaded!")
