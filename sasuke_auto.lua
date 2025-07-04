local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Toggle state
_G.autoFarm = true

-- 🔁 Toggle on F6 with console output
UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F6 then
        _G.autoFarm = not _G.autoFarm
        print("🔁 AutoFarm toggled " .. (_G.autoFarm and "ON ✅" or "OFF ❌"))
    end
end)

-- 🛡️ Anti-AFK (BlueStacks safe)
pcall(function()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
        print("✅ Anti-AFK triggered")
    end)
end)

local combatRemote = ReplicatedStorage:WaitForChild("Combat"):WaitForChild("Remotes"):WaitForChild("Combat")
local attackDelay = 0.1

local function acceptSasukeMission()
    pcall(function()
        local r = ReplicatedStorage:WaitForChild("Missions"):WaitForChild("BossScrolls"):WaitForChild("Sasuke"):FindFirstChild("Accept")
        if r then r:FireServer() end
    end)
end

local function summonSasuke()
    pcall(function()
        local r = ReplicatedStorage:WaitForChild("Missions"):WaitForChild("BossScrolls"):WaitForChild("Sasuke"):FindFirstChild("Summon")
        local bosses = workspace:FindFirstChild("BossScrolls") and workspace.BossScrolls:FindFirstChild("Bosses")
        if r and bosses and not bosses:FindFirstChild("Sasuke Uchiha | Rouge") then
            r:FireServer()
        end
    end)
end

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

task.spawn(function()
    while true do
        if _G.autoFarm then
            pcall(function()
                local sub = player:FindFirstChild("PlayerGui")
                if sub then
                    sub = sub:FindFirstChild("SubstitutionMobile")
                    and sub.SubstitutionMobile:FindFirstChild("Frame")
                    and sub.SubstitutionMobile.Frame:FindFirstChild("ImageButton")
                    and sub.SubstitutionMobile.Frame.ImageButton:FindFirstChild("LocalScript")
                    and sub.SubstitutionMobile.Frame.ImageButton.LocalScript:FindFirstChild("RemoteEvent")
                    if sub then sub:FireServer() end
                end
            end)
        end
        wait(0.3)
    end
end)

task.spawn(function()
    while true do
        if _G.autoFarm then
            pcall(function()
                local chi = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("GainChi")
                chi:FireServer()
            end)
        end
        wait(3)
    end
end)

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

print("✅ BlueStacks Auto Sasuke Farm script with F6 toggle loaded.")
