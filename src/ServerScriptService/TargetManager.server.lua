local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local ForceField = require(ReplicatedStorage:WaitForChild("ForceField"))

local GemTargetHitEvent = ReplicatedStorage:WaitForChild("GemTargetHitEvent")
local GlassTargetHitEvent = ReplicatedStorage:WaitForChild("GlassTargetHitEvent")

local gemTargets = workspace:WaitForChild("GemTargets")
local glassTargets = workspace:WaitForChild("GlassTargets")

local GEM_TARGET_POINTS = 1
local GLASS_TARGET_POINTS = 5

GemTargetHitEvent.OnServerEvent:Connect(function(player, target)
	player.leaderstats.Points.Value += GEM_TARGET_POINTS
end)

GlassTargetHitEvent.OnServerEvent:Connect(function(player, target)
	player.leaderstats.Points.Value += GLASS_TARGET_POINTS
end)

GemTargetHitEvent.OnServerEvent:Connect(function(player, target)
	local butterfly = ServerStorage:WaitForChild("Butterfly"):Clone()
	butterfly.GEO_Butterfly_01.Position = target.Position
	butterfly.Parent = workspace.Butterflies
	for count = 1, math.random(3, 12) do
		local zombie = ServerStorage:WaitForChild("Zombie"):Clone()
		zombie:SetAttribute("PlayerUserId", player.UserId)
		zombie.Configuration.AttackDamage.Value = 35
		zombie.Configuration.AttackRadius.Value = math.random(100, 200)
		zombie.Configuration.PatrolRadius.Value = math.random(20, 200)
		zombie.HumanoidRootPart.Position = target.Position
		CollectionService:AddTag(zombie.HumanoidRootPart, "Zombie") -- Tagged for the minimap.
		ForceField.setupForceField(zombie, 10)
		zombie.Parent = workspace.Zombies
		task.wait(0.2)
	end
end)

local function setupChild(child)
	if child.Name == "GlassTarget" then
		child.CanCollide = false
		child.Transparency = 1
	elseif child.Name == "GlassTargets" then
		for _, newChild in ipairs(child:GetChildren()) do
			setupChild(newChild)
		end
	else
		return
	end
end

for _, model in ipairs(glassTargets:GetChildren()) do
	for _, child in ipairs(model:GetChildren()) do
		if child.Name == "GlassTargets" then
			setupChild(child)
		end
	end
end

for _, targetModel in ipairs(gemTargets:GetChildren()) do
	local gemTarget = targetModel:WaitForChild("GemTarget")
	CollectionService:AddTag(gemTarget, "GemTarget") -- Tagged for the minimap.
end


--for _, model in ipairs(gemTargets:GetChildren()) do
--	local glassModel = model:FindFirstChild("GlassModel")
--	if glassModel then
--		for _, child in ipairs(glassModel:GetChildren()) do
--			if child.Name == "GlassTarget" then
--				child.CanCollide = false
--				child.Transparency = 1
--			elseif child.Name == "GlassTargets" then
--				setupChild(child)
--			end
--		end
--	end
--end

--local function getTarget()
--	local target = Instance.new("Part")
--	target.Anchored = true
--	target.Material = Enum.Material.Neon
--	target.Name = "GlassTarget"
--	target.Size = Vector3.new(1, 1, 1)
--	target.CanCollide = false
--	target.Transparency = 1
--	return target
--end

--for _, targetModel in ipairs(gemTargets:GetChildren()) do
--	if #targetModel:GetChildren() > 1 then
--		-- This model already has manually created targets.
--		continue
--	end
--	local gemTarget = targetModel:WaitForChild("GemTarget")
	
--	local glassModel = Instance.new("Model")
--	glassModel.Name = "GlassModel"
--	glassModel.Parent = targetModel
	
--	local target = getTarget()
--	target.BrickColor = BrickColor.new("Really red")
--	target.Position = gemTarget.Position + Vector3.new(0, 2, 0)
--	target.Parent = glassModel

--	local glassTargetsFolder1 = Instance.new("Folder")
--	glassTargetsFolder1.Name = "GlassTargets"
--	glassTargetsFolder1.Parent = glassModel
	
--	local target = getTarget()
--	target.BrickColor = BrickColor.new("New Yeller")
--	target.Position = gemTarget.Position + Vector3.new(0, 1, 0)
--	target.Parent = glassTargetsFolder1
	
--	local glassTargetsFolder2 = Instance.new("Folder")
--	glassTargetsFolder2.Name = "GlassTargets"
--	glassTargetsFolder2.Parent = glassTargetsFolder1

--	local target = getTarget()
--	target.BrickColor = BrickColor.new("Lime green")
--	target.Position = gemTarget.Position + Vector3.new(0, 0, 0)
--	target.Parent = glassTargetsFolder2
--end
