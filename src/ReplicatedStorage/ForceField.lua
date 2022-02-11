local Debris = game:GetService("Debris")

local module = {}

function module.setupForceField(item, duration)
	local forceField = Instance.new("ForceField")
	forceField.Visible = true
	forceField.Parent = item
	if duration then
		Debris:AddItem(forceField, duration)
	end
end

return module
