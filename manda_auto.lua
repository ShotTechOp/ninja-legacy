local enabled = false
local UIS = game:GetService("UserInputService")
local rs = game:GetService("ReplicatedStorage")
local lp = game:GetService("Players").LocalPlayer

-- :radio_button: F6 Toggle
UIS.InputBegan:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.F6 then
		enabled = not enabled
		print(":repeat: Auto Manda Farm " .. (enabled and ":white_check_mark: Enabled" or ":x: Disabled"))
	end
end)

-- :shield: Anti-AFK
lp.Idled:Connect(function()
	game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	wait(1)
	game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- :stopwatch: Cooldown tracking table
local cooldowns = {
	transform = 1000,
	gainChi = 0.5,
	spec = 10,
	kirin = 60,
	ragingFlames = 2,
	fireBall = 2,
	flamingDragon = 2,
	phoenixFlames = 2,
	greatFireBall = 2,
	mandaSummon = 30
}
local lastUsed = {}

-- :hourglass_flowing_sand: Init all to 0
for k in pairs(cooldowns) do
	lastUsed[k] = 0
end

-- :repeat: Loop
task.spawn(function()
	while task.wait(0.1) do
		if enabled then
			local t = tick()

			-- :snake: Summon Manda
			if t - lastUsed.mandaSummon >= cooldowns.mandaSummon then
				pcall(function()
					rs.Missions.BossScrolls.Manda.Summon:FireServer()
				end)
				lastUsed.mandaSummon = t
			end

			-- :diamond_shape_with_a_dot_inside: Transform
			if t - lastUsed.transform >= cooldowns.transform then
				pcall(function()
					rs.RemoteEvents.TransformEvent:FireServer()
				end)
				lastUsed.transform = t
			end

			-- :battery: Gain Chi
			if t - lastUsed.gainChi >= cooldowns.gainChi then
				pcall(function()
					rs.RemoteEvents.GainChi:FireServer()
				end)
				lastUsed.gainChi = t
			end

			-- :zap: Sharingan Spec
			if t - lastUsed.spec >= cooldowns.spec then
				pcall(function()
					rs.Jutsu.Modes.Sharingan.MS.SasukeMS.Stage3.Spec:FireServer()
				end)
				lastUsed.spec = t
			end

			-- :zap: Kirin
			if t - lastUsed.kirin >= cooldowns.kirin then
				pcall(function()
					rs.SkillRemotes.Jutsu.Ninjutsu.LightningStyle.Kirin.RemoteEvent:FireServer()
				end)
				lastUsed.kirin = t
			end

			-- :fire: Fire Style: Raging Flames
			if t - lastUsed.ragingFlames >= cooldowns.ragingFlames then
				pcall(function()
					rs.SkillRemotes.Jutsu.ClanJutsu.Uchiha.RagingFlames.RemoteEvent:FireServer()
				end)
				lastUsed.ragingFlames = t
			end

			-- :fire: Fire Style: Fireball
			if t - lastUsed.fireBall >= cooldowns.fireBall then
				pcall(function()
					rs.SkillRemotes.Jutsu.Ninjutsu.FireStyle.FireBall.RemoteEvent:FireServer()
				end)
				lastUsed.fireBall = t
			end

			-- :fire: Fire Style: Flaming Dragon
			if t - lastUsed.flamingDragon >= cooldowns.flamingDragon then
				pcall(function()
					rs.SkillRemotes.Jutsu.Ninjutsu.FireStyle["Flaming Dragon"].RemoteEvent:FireServer()
				end)
				lastUsed.flamingDragon = t
			end

			-- :fire: Fire Style: Phoenix Flames
			if t - lastUsed.phoenixFlames >= cooldowns.phoenixFlames then
				pcall(function()
					rs.SkillRemotes.Jutsu.Ninjutsu.FireStyle.PhoenixFlames.RemoteEvent:FireServer()
				end)
				lastUsed.phoenixFlames = t
			end

			-- :fire: Fire Style: Great Fireball
			if t - lastUsed.greatFireBall >= cooldowns.greatFireBall then
				pcall(function()
					rs.SkillRemotes.Jutsu.Ninjutsu.FireStyle.GreatFireBall.RemoteEvent:FireServer()
				end)
				lastUsed.greatFireBall = t
			end
		end
	end
end)

print(":white_check_mark: Auto Manda Script Loaded (Cooldowns Active). Press F6 to toggle.")
