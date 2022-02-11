local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TopScoresEvent = ReplicatedStorage:WaitForChild("TopScoresEvent")
local ZombieKilledEvent = ReplicatedStorage:WaitForChild("ZombieKilledEvent")

local GlobalPoints = DataStoreService:GetOrderedDataStore("GlobalPoints")
local PlayerPoints = DataStoreService:GetDataStore("PlayerPoints")

local STARTING_POINTS = 0
local ZOMBIE_KILLED_POINTS = 1

game.Players.CharacterAutoLoads = false

ZombieKilledEvent.Event:Connect(function(player)
	player.leaderstats.Points.Value += ZOMBIE_KILLED_POINTS
end)

local function setupLeaderboard(player)
	local folder = Instance.new("Folder")
	local points = Instance.new("IntValue")
	folder.Name = "leaderstats"
	folder.Parent = player
	points.Name = "Points"
	points.Value = STARTING_POINTS
	points.Parent = folder
	local success, savedPlayerPoints = pcall(function()
		return PlayerPoints:GetAsync(player.UserId)
	end)
	if success then
		if savedPlayerPoints then
			points.Value = savedPlayerPoints
		else
			points.Value = STARTING_POINTS
		end
	end
end

local function setupTopScores(player)
	local isAscending = false
	local pageSize = 20
	local pages = GlobalPoints:GetSortedAsync(isAscending, pageSize)
	local topScores = pages:GetCurrentPage()
	TopScoresEvent:FireClient(player, topScores)
end

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.Died:Connect(function()
			player:LoadCharacter()
		end)
	end)
	player:LoadCharacter()
	setupLeaderboard(player)
	setupTopScores(player)
end)

local function saveGlobal(player)
	local success, errorMessage = pcall(function()
		GlobalPoints:SetAsync(player.UserId, player.leaderstats.Points.Value)
	end)
	if not success then
		warn(errorMessage)
	end
end

local function saveLeaderboard(player)
	local success, errorMessage = pcall(function()
		PlayerPoints:SetAsync(player.UserId, player.leaderstats.Points.Value)
	end)
	if not success then
		warn(errorMessage)
	end
end

game.Players.PlayerRemoving:Connect(function(player)
	saveGlobal(player)
	saveLeaderboard(player)
end)
