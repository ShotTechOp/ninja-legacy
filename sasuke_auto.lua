local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Toggle farming
_G.autoFarm = true

-- 🛡️ Anti-AFK (safe for BlueStacks)
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

-- 🔁 TP to Sasuke every 0.5s
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

-- 🔁 Substitution every 0.3s
task.spawn(function()
    while true do
        if _G.autoFarm then
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
        if _G.autoFarm then
            pcall(function()
                local chiRemote = ReplicatedStorage
                    :WaitForChild("RemoteEvents")
                    :WaitForChild("GainChi")
                chiRemote:FireServer()
            end)
        end
        wait(3)
    end
end)

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

-- 👊 M1 loop
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

-- 🔁 Main loop
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

print("✅ Auto Sasuke (BlueStacks) started — toggle with _G.autoFarm = true/false")
