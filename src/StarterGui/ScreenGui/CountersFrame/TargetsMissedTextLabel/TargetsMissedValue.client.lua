local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TargetsModule = require(ReplicatedStorage.Targets)

local textLabel = script.Parent

local function update()
	local targetsMissed = TargetsModule.targetsMissed
	textLabel.Text = "Targets Missed: " .. tostring(targetsMissed)
end

while true do
	update()
	task.wait(0.25)
end
