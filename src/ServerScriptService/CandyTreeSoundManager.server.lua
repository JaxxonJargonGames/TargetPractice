for _, tree in ipairs(workspace.CandyTrees:GetChildren()) do
	local treePart = tree:FindFirstChildWhichIsA("BasePart", true)
	if treePart then
		local sound = Instance.new("Sound")
		sound.Looped = true
		sound.RollOffMaxDistance = 50
		sound.SoundId = "rbxassetid://169736440" -- ForestAmbienceVar2
		sound.Volume = 1
		sound.Parent = treePart
		sound:Play()
	end
end
