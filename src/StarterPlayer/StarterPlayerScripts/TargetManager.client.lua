local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local TargetsModule = require(ReplicatedStorage.Targets)

local GemTargetHitEvent = ReplicatedStorage:WaitForChild("GemTargetHitEvent")
local GlassTargetHitEvent = ReplicatedStorage:WaitForChild("GlassTargetHitEvent")
local TargetMissedEvent = ReplicatedStorage:WaitForChild("TargetMissedEvent")

local applauseSound = Instance.new("Sound")
applauseSound.SoundId = "rbxassetid://1869741275" -- Applause.
applauseSound.Volume = 5

local glassSound = Instance.new("Sound")
glassSound.SoundId = "rbxassetid://5961220911" -- Glass shatter.
glassSound.Volume = 5

local function getExplosion()
	local explosion = Instance.new("ParticleEmitter")
	explosion.Enabled = false
	explosion.Texture = "rbxassetid://6101261905"
	explosion.Drag = 10
	explosion.Lifetime = NumberRange.new(0.2, 0.6)
	explosion.Speed = NumberRange.new(20, 40)
	explosion.SpreadAngle = Vector2.new(180, 180)
	return explosion
end

local function getVisibleTargets(folder)
	local targets = {}
	for _, child in ipairs(folder:GetChildren()) do
		if child.Name == "GlassTarget" and child.Transparency == 0 then
			table.insert(targets, child)
		end
	end
	return targets
end

GemTargetHitEvent.OnClientEvent:Connect(function(player, target)
	TargetsModule.targetsHit += 1
	glassSound.Parent = target
	glassSound:Play()
	glassSound.Parent = SoundService
	task.wait(0.5)
	local explosion = getExplosion()
	explosion.Parent = target
	target.CanCollide = false
	target.Transparency = 1
	explosion:Emit(600)
	task.wait(0.5)
	GemTargetHitEvent:FireServer(target)
	target:Destroy() -- Removes the target blip from the minimap.

	-- Disable glass targets for the forseeable future.
	--local glassModel = target.Parent:FindFirstChild("GlassModel")
	--if glassModel then
	--	for _, child in ipairs(glassModel:GetChildren()) do
	--		if child.Name == "GlassTarget" then
	--			child.CanCollide = true
	--			child.Transparency = 0
	--		end
	--	end
	--end
end)

GlassTargetHitEvent.OnClientEvent:Connect(function(player, target)
	GlassTargetHitEvent:FireServer(player, target)
	TargetsModule.targetsHit += 1
	glassSound.Parent = target
	glassSound:Play()
	glassSound.Parent = SoundService
	task.wait(0.5)
	target.CanCollide = false
	target.Transparency = 1
	if #getVisibleTargets(target.Parent) == 0 then -- This is the last visible child in this folder.
		local newTargetsFolder = target.Parent:FindFirstChild("GlassTargets")
		if newTargetsFolder then
			for _, newTarget in ipairs(newTargetsFolder:GetChildren()) do
				if newTarget.Name == "GlassTarget" then
					newTarget.CanCollide = true
					newTarget.Transparency = 0
				end
			end
		end
	end
end)

TargetMissedEvent.OnClientEvent:Connect(function()
	TargetsModule.targetsMissed += 1
end)
