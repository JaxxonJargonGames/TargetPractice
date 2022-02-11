local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")

PhysicsService:CreateCollisionGroup("Players")
PhysicsService:CreateCollisionGroup("ZombieWalls")

for _, wall in ipairs(workspace.ZombieWalls:GetChildren()) do
	wall.Transparency = 1
	PhysicsService:SetPartCollisionGroup(wall, "ZombieWalls")
end

local function setCollisionGroup(character, groupName)
	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("BasePart") then
			PhysicsService:SetPartCollisionGroup(child, groupName)
		end
	end
	character.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("BasePart") then
			PhysicsService:SetPartCollisionGroup(descendant, groupName)
		end
	end)
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		setCollisionGroup(character, "Players")
	end)
end)

PhysicsService:CollisionGroupSetCollidable("Players", "ZombieWalls", false)
