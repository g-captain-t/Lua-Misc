local Players = game:GetService("Players")
local Config = require(script.Parent)
local Remote = script.Parent.ChatEvent
local GUI = script.Parent.RadioGUI

Remote.Parent = game:GetService("ReplicatedStorage")

local function getFilteredMessage(textObject, toPlayerId)							-- Filter message
	local filteredMessage
	local success, errorMessage = pcall(function()
		filteredMessage = textObject:GetNonChatStringForUserAsync(toPlayerId)
	end)
	return filteredMessage
end

local function CloneGui(player)											-- Clone UI
	local PlayerGui = player:WaitForChild("PlayerGui")
	local cGui = GUI:Clone()
	cGui.Remote.Value = Remote
	cGui.MaxMessages.Value = Config.maxMessages
	cGui.Parent = PlayerGui
	cGui.LocalScript.Disabled = false
	return cGui
end

Players.PlayerAdded:Connect(function(player)
	if not Config.CheckChatter(player) then return end
	local playerName = Players:GetNameFromUserIdAsync(player.UserId)
	local cGui = CloneGui(player)
	
	player.CharacterAdded:Connect(function() 								--ReplicateUI
		local PlayerGui = player:WaitForChild("PlayerGui")
		if not cGui then cGui = CloneGui(player) end
	end)
	
	Remote.OnServerEvent:Connect(function(chatter, action, content)
		if action == "MESSAGE" then 									-- Send Message
			if not Config.CheckChatter(chatter) then return end
			if content == "" then return end
			local chattername = Players:GetNameFromUserIdAsync(chatter.UserId)
			local filteredContent = getFilteredMessage(content, player.UserId)
			local msgString = "["..chattername.."] "..filteredContent
			Remote:FireClient(player, "NEWMESSAGE", msgString)
		elseif action == "CHATENABLE" then 								-- Update ChatEnabled
			if not cGui then return end
			if chatter ~= player then return end
			cGui.ChatEnabled.Value = not cGui.ChatEnabled.Value
		end
	end)
	
	player.Chatted:Connect(function(message)								-- On Chat
		if not cGui then return end
		if not cGui.ChatEnabled.Value then return end
		local msgString = "["..player.Name.."] "..message
		Remote:FireAllClients("NEWMESSAGE", msgString)
	end)
end)
