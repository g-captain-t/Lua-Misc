local Remote = script.Parent.Remote.Value

local frame = script.Parent.Frame
local scrollFrame = script.Parent.Frame.ScrollingFrame
local messageTemplate = script.Parent.Frame.ScrollingFrame.Message
local maxMessages = script.Parent.MaxMessages.Value

messageTemplate.Visible = false
messageTemplate.Parent = script
scrollFrame.CanvasSize = UDim2.new(0,0,0,
	messageTemplate.Size.Y.Offset*(maxMessages-1))
scrollFrame.CanvasPosition = Vector2.new(0,scrollFrame.CanvasSize.Y.Offset)

Remote.OnClientEvent:Connect(function(action, message)
	if action == "NEWMESSAGE" then
		local cMessage = messageTemplate:Clone()
		cMessage.Text = message
		if #scrollFrame:GetChildren() > maxMessages+1 then
			scrollFrame:GetChildren()[2]:Destroy() end
		cMessage.Visible = true
		cMessage.Parent = scrollFrame
		scrollFrame.CanvasPosition = Vector2.new(0,scrollFrame.CanvasSize.Y.Offset)
	end
end)

local ChatInput = frame.Input
game:GetService("UserInputService").InputBegan:Connect(function(key, gameProcessedEvent)
	if not gameProcessedEvent then 
		if key.KeyCode == Enum.KeyCode.Return then
			Remote:FireServer("MESSAGE", ChatInput.Text)
			ChatInput.Text = ""

		elseif key.KeyCode == Enum.KeyCode.Semicolon then
			ChatInput:CaptureFocus()
		end
	end
end)

frame.Toggle.MouseButton1Click:Connect(function()
	Remote:FireServer("CHATENABLE")
end)

if script.Parent.ChatEnabled.Value then frame.Toggle.ImageColor3 = frame.Toggle.On.Value
else frame.Toggle.ImageColor3 = frame.Toggle.Off.Value end
script.Parent.ChatEnabled:GetPropertyChangedSignal("Value"):Connect(function()
	if script.Parent.ChatEnabled.Value then frame.Toggle.ImageColor3 = frame.Toggle.On.Value
	else frame.Toggle.ImageColor3 = frame.Toggle.Off.Value end
end)

local visible = true
local defaultPos = frame.Position

frame.Hide.MouseButton1Click:Connect(function()
	if not visible then return end
	frame.Position = UDim2.new(0,-frame.Size.X.Offset, 
		frame.Position.Y.Scale, frame.Position.Y.Offset)
	visible = false
end)

frame.Show.MouseButton1Click:Connect(function()
	if visible then return end
	frame.Position = defaultPos
	visible = true
end)
