local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- GUI Creation
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local toggleButton = Instance.new("TextButton", screenGui)

screenGui.Name = "AutoFarmGUI"
toggleButton.Size = UDim2.new(0, 140, 0, 40)
toggleButton.Position = UDim2.new(0.5, -70, 0.9, 0)
toggleButton.Text = "🔴 Start AutoFarm"
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20

-- Variables
local attackDelay = 0.1
local fireballCooldown = 3
local autoFarm = false
local sharinganUsed = false

-- Remotes
local combatRemote = ReplicatedStorage:WaitForChild("Combat").Remotes.Combat
local chiRemote = ReplicatedStorage.RemoteEvents.GainChi
local fireballRemote = ReplicatedStorage.SkillRemotes.Jutsu.ClanJutsu.Uchiha.RagingFlames.RemoteEvent
local transformRemote = ReplicatedStorage.RemoteEvents.TransformEvent
local subRemote = player.PlayerGui.SubstitutionMobile.Frame.ImageButton.LocalScript.RemoteEvent
local summonRemote = ReplicatedStorage.Missions.BossScrolls.Hashirama.Summon

-- 🛡️ Anti-AFK
task.spawn(function()
	local vu = game:GetService("VirtualUser")
	player.Idled:Connect(function()
		vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
		wait(1)
		vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	end)
end)

-- 👁️ Transform Once
task.spawn(function()
	if not sharinganUsed then
		pcall(function()
			transformRemote:FireServer()
			sharinganUsed = true
		end)
	end
end)

-- Toggle Button Logic
toggleButton.MouseButton1Click:Connect(function()
	autoFarm = not autoFarm
	if autoFarm then
		toggleButton.Text = "🟢 Stop AutoFarm"
		toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	else
		toggleButton.Text = "🔴 Start AutoFarm"
		toggleButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
	end
end)

-- TP to Hashirama every 0.5s
task.spawn(function()
	while true do
		if autoFarm then
			pcall(function()
				local boss = workspace:FindFirstChild("BossScrolls")
					and workspace.BossScrolls:FindFirstChild("Bosses")
					and workspace.BossScrolls.Bosses:FindFirstChild("Hashirama Senju | Shinobi")
				if boss then
					local bossRoot = boss:FindFirstChild("HumanoidRootPart")
					local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
					if bossRoot and myHRP then
						myHRP.CFrame = bossRoot.CFrame * CFrame.new(0, 0, 8)
					end
				end
			end)
		end
		wait(0.5)
	end
end)

-- Substitution
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

-- GainChi
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

-- Fireball
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

-- M1 Combat
local function autoM1Loop(root)
	while root and root.Parent and autoFarm do
		pcall(function()
			combatRemote:FireServer({
				Skill = "M1",
				Target = root,
				Position = root.Position
			})
		end)
		wait(attackDelay)
		root = workspace.BossScrolls.Bosses:FindFirstChild("Hashirama Senju | Shinobi")
			and workspace.BossScrolls.Bosses["Hashirama Senju | Shinobi"]:FindFirstChild("HumanoidRootPart")
	end
end

-- Summon + M1
task.spawn(function()
	while true do
		if autoFarm then
			pcall(function()
				summonRemote:FireServer()
				wait(1)
				for _ = 1, 20 do
					local boss = workspace.BossScrolls.Bosses:FindFirstChild("Hashirama Senju | Shinobi")
					if boss and boss:FindFirstChild("HumanoidRootPart") then
						autoM1Loop(boss.HumanoidRootPart)
						break
					end
					wait(1)
				end
			end)
		end
		wait(2)
	end
end)

print("✅ Auto Hashirama Farm (GUI toggle) script loaded.")
