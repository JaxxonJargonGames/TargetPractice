local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TopScoresEvent = ReplicatedStorage:WaitForChild("TopScoresEvent")

local function getTextLabel(text)
	local textLabel = Instance.new("TextLabel")
	textLabel.BackgroundTransparency = 1
	textLabel.Font = Enum.Font.SourceSans
	textLabel.Size = UDim2.new(0, 400, 0, 30)
	textLabel.SizeConstraint = Enum.SizeConstraint.RelativeXY
	textLabel.Text = text
	textLabel.TextColor3 = Color3.new(255, 255, 255)
	textLabel.TextSize = 20
	textLabel.Visible = true
	return textLabel
end

TopScoresEvent.OnClientEvent:Connect(function(topScores)
	local textLabel = getTextLabel("Top Scores of All Time")
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextColor3 = Color3.new(255, 200, 100)
	textLabel.TextSize = 24
	textLabel.Parent = script.Parent
	for rank, data in ipairs(topScores) do
		local userId = data.key
		local name = Players:GetNameFromUserIdAsync(userId)
		local points = data.value
		local text = name .. " is ranked #" .. rank .. " with " .. points .. " points"
		local textLabel = getTextLabel(text)
		textLabel.Parent = script.Parent
	end
end)
