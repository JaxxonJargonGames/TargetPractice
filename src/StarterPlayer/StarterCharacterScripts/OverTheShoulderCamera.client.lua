--Local script in StarterPlayerCharacter
--Variables:
local plr = game:GetService("Players").LocalPlayer
local mouse = plr:GetMouse()
local char = script.Parent
local hum = char:WaitForChild("Humanoid")
local rotation = Instance.new("BodyGyro") --Create a new body gyro.
rotation.P = 1000000 --Increase the power
rotation.Parent = hum.RootPart --Parent it to the HumanoidRootPart
local conn -- connection variable
--Toggle Function:
function shiftLock(active) --Toggle shift.lock function
	if active then
		hum.CameraOffset = Vector3.new(1, 0.5, 0) -- I assume this is about the right camera offset.
		rotation.MaxTorque = Vector3.new(0, math.huge, 0) --Max the power on the Y axis
		conn = game:GetService("RunService").RenderStepped:Connect(function()
			rotation.CFrame = mouse.Origin
			game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.LockCenter
		end) --Set the mouse to center every frame.
	else
		hum.CameraOffset = Vector3.new(0,0,0) --Move the camera back to normal.
		rotation.MaxTorque = Vector3.new(0, 0, 0) --Clear the torque on the HumanoidRootPart
		if conn then conn:Disconnect() end -- Allow mouse to move freely.
	end
end
--Disable and Enable:
--shiftLock(true) -- Toggle shift lock
--print("Shift lock turned on!")
--[[
shiftLock(false) --Toggle off shift Lock
]]


--[[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local connection
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local mouse = player:GetMouse()
local bodyGyro = Instance.new("BodyGyro")

bodyGyro.P = 1000000 
bodyGyro.Parent = humanoid.RootPart

local function lock(active)
	if active then
		humanoid.CameraOffset = Vector3.new(2, 1, -0.5) 
		bodyGyro.MaxTorque = Vector3.new(0, math.huge, 0) 
		connection = RunService.RenderStepped:Connect(function()
			bodyGyro.CFrame = workspace.CurrentCamera.CFrame
			UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		end)
	else
		humanoid.CameraOffset = Vector3.new(0, 0, 0) 
		bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
		if connection then 
			connection:Disconnect()
		end 
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end
end

--lock(true)
--]]
