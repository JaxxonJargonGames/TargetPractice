local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TargetsModule = require(ReplicatedStorage.Targets)

local textLabel = script.Parent

local function update()
	local targetsHit = TargetsModule.targetsHit
	textLabel.Text = "Targets Hit: " .. tostring(targetsHit)
end

while true do
	update()
	task.wait(0.25)
end
