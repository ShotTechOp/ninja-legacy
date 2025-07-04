local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ✅ BlueStacks-safe Anti-AFK (uses contextless input)
pcall(function()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
        print("✅ Anti-AFK triggered")
    end)
end)

-- ✅ Use _G so toggle works outside coroutine if needed
_G.autoFarm = true

-- 🔁 Remotes and settings
local combatRemote = ReplicatedStorage:WaitForChild("Combat"):WaitForChild("Remotes"):WaitForChild("Combat")
local attackDelay = 0.1

-- 📜 Accept Sasuke mission
local function acceptSasukeMission()
    pcall(function()
        local acceptRemote = ReplicatedStorage
            :WaitForChild("Missions")
            :WaitForChild("BossScrolls")
            :WaitForChild("Sasuke")
            :FindFirstChild("Accept")
        if acceptRemote then acceptRemote:FireServer() end
    end)
end

-- 🔁 Summon Sasuke
local function summonSasuke()
    pcall(function()
        local summonRemote = ReplicatedStorage
            :WaitForChild("Missions")
            :WaitForChild("BossScrolls")
            :WaitForChild("Sasuke")
            :FindFirstChild("Summon")
        local bosses = workspace:FindFirstChild("BossScrolls") and workspace.BossScrolls:FindFirstChild("Bosses")
        if summonRemote and bosses and not bosses:FindFirstChild("Sasuke Uchiha | Rouge") then
            summonRemote:FireServer()
        end
    end)
end

-- 📍 TP to boss every 0.5s
task.spawn(function()
    while true do
        if _G.autoFarm then
            pcall(function()
                local boss = workspace:FindFirstChild("BossScrolls")
                    and workspace.BossScrolls:FindFirstChild("Bosses")
                    and workspace.BossScrolls.Bosses:FindFirstChild("Sasuke Uchiha | Rouge")
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

-- 🧘 GainChi every 3s
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

-- ⏳ Wait for Sasuke to spawn
local function waitForSasuke()
    for _ = 1, 20 do
        local boss = workspace:FindFirstChild("BossScrolls")
            and workspace.BossScrolls:FindFirstChild("Bosses")
            and workspace.BossScrolls.Bosses:FindFirstChild("Sasuke Uchiha | Rouge")
        if boss and boss:FindFirstChild("HumanoidRootPart") then
            return boss.HumanoidRootPart
        end
        wait(1)
    end
    return nil
end

-- 📥 Claim scroll
local function claimScroll()
    pcall(function()
        local scroll = workspace:FindFirstChild("BossScrolls")
            and workspace.BossScrolls:FindFirstChild("SasukeBoss")
            and workspace.BossScrolls.SasukeBoss:FindFirstChild("Scroll")
        if scroll and scroll:FindFirstChild("Claim") then
            scroll.Claim:FireServer()
        end
    end)
end

-- 👊 M1 Combat loop
local function autoM1(root)
    while root and root.Parent and _G.autoFarm do
        pcall(function()
            combatRemote:FireServer({
                Skill = "M1",
                Target = root,
                Position = root.Position
            })
            claimScroll()
        end)
        wait(attackDelay)
        root = workspace:FindFirstChild("BossScrolls")
            and workspace.BossScrolls:FindFirstChild("Bosses")
            and workspace.BossScrolls.Bosses:FindFirstChild("Sasuke Uchiha | Rouge")
            and workspace.BossScrolls.Bosses["Sasuke Uchiha | Rouge"]:FindFirstChild("HumanoidRootPart")
    end
end

-- ♻️ Main farming loop
task.spawn(function()
    while true do
        if _G.autoFarm then
            pcall(function()
                acceptSasukeMission()
                wait(0.5)
                summonSasuke()
                local root = waitForSasuke()
                if root then autoM1(root) end
                for _ = 1, 5 do
                    claimScroll()
                    wait(0.5)
                end
            end)
        end
        wait(2)
    end
end)

print("✅ BlueStacks-compatible Auto Sasuke Farm running...")
