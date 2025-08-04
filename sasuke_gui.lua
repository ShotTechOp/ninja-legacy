local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 🔧 Configs
local attackDelay = 0.1
local fireballCooldown = 3
local sharinganUsed = false
local guiToggle = true

-- 🛡️ Anti-AFK
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        print("✅ Anti-AFK triggered")
    end)
end)

-- 🌐 Remotes
local combatRemote = ReplicatedStorage.Combat.Remotes.Combat
local chiRemote = ReplicatedStorage.RemoteEvents.GainChi
local fireballRemote = ReplicatedStorage.SkillRemotes.Jutsu.ClanJutsu.Uchiha.RagingFlames.RemoteEvent
local transformRemote = ReplicatedStorage.RemoteEvents.TransformEvent
local subRemote = player.PlayerGui.SubstitutionMobile.Frame.ImageButton.LocalScript.RemoteEvent

-- 🧱 Mission Remotes
local missionFolder = ReplicatedStorage.Missions.BossScrolls.Sasuke
local acceptRemote = missionFolder:FindFirstChild("Accept")
local summonRemote = missionFolder:FindFirstChild("Summon")

-- 📦 GUI Toggle
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "SasukeToggleUI"
local button = Instance.new("TextButton", screenGui)

button.Size = UDim2.new(0, 180, 0, 50)
button.Position = UDim2.new(0, 10, 0, 200)
button.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
button.Text = "🟢 Auto-Farm: ON"
button.TextScaled = true
button.TextColor3 = Color3.new(1, 1, 1)

button.MouseButton1Click:Connect(function()
    guiToggle = not guiToggle
    button.Text = guiToggle and "🟢 Auto-Farm: ON" or "🔴 Auto-Farm: OFF"
    button.BackgroundColor3 = guiToggle and Color3.new(0.2, 0.6, 0.2) or Color3.new(0.6, 0.2, 0.2)
    print(guiToggle and "✅ Auto-Farm ENABLED" or "❌ Auto-Farm DISABLED")
end)

-- 🔁 TP to Sasuke
task.spawn(function()
    while true do
        if guiToggle then
            pcall(function()
                local boss = workspace.BossScrolls.Bosses:FindFirstChild("Sasuke Uchiha | Rouge")
                if boss and boss:FindFirstChild("HumanoidRootPart") then
                    local myChar = player.Character or player.CharacterAdded:Wait()
                    local hrp = myChar:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, 8)
                    end
                end
            end)
        end
        wait(0.5)
    end
end)

-- 🔁 Substitution
task.spawn(function()
    while true do
        if guiToggle then
            pcall(function()
                subRemote:FireServer()
            end)
        end
        wait(0.3)
    end
end)

-- 🔋 Chi Recharge
task.spawn(function()
    while true do
        if guiToggle then
            pcall(function()
                chiRemote:FireServer()
            end)
        end
        wait(2)
    end
end)

-- 🔥 Fireball Jutsu
task.spawn(function()
    while true do
        if guiToggle then
            pcall(function()
                fireballRemote:FireServer()
            end)
        end
        wait(fireballCooldown)
    end
end)

-- 👁️ Transform (once)
task.spawn(function()
    while not sharinganUsed and guiToggle do
        pcall(function()
            transformRemote:FireServer()
            sharinganUsed = true
        end)
        wait(1)
    end
end)

-- 🌀 M1 Combat
local function autoM1(root)
    while root and root.Parent and guiToggle do
        pcall(function()
            combatRemote:FireServer({
                Skill = "M1",
                Target = root,
                Position = root.Position
            })
        end)
        wait(attackDelay)
        root = workspace.BossScrolls.Bosses:FindFirstChild("Sasuke Uchiha | Rouge")
        and workspace.BossScrolls.Bosses["Sasuke Uchiha | Rouge"]:FindFirstChild("HumanoidRootPart")
    end
end

-- 🧾 Claim scroll
local function claimScroll()
    pcall(function()
        local scroll = workspace.BossScrolls:FindFirstChild("SasukeBoss")
        if scroll and scroll:FindFirstChild("Scroll") and scroll.Scroll:FindFirstChild("Claim") then
            scroll.Scroll.Claim:FireServer()
        end
    end)
end

-- 📜 Mission Start
task.spawn(function()
    while true do
        if guiToggle then
            pcall(function()
                if acceptRemote then acceptRemote:FireServer() end
                wait(0.5)
                local bosses = workspace.BossScrolls:FindFirstChild("Bosses")
                if summonRemote and bosses and not bosses:FindFirstChild("Sasuke Uchiha | Rouge") then
                    summonRemote:FireServer()
                    print("✅ Sasuke Summon Fired")
                end
                wait(1)
                local boss = bosses and bosses:FindFirstChild("Sasuke Uchiha | Rouge")
                local root = boss and boss:FindFirstChild("HumanoidRootPart")
                if root then autoM1(root) end
                for _ = 1, 5 do claimScroll() wait(0.5) end
            end)
        end
        wait(2)
    end
end)

print("✅ Sasuke Auto-Farm with GUI Toggle started.")
