local command = ":handto"
local Group = 0
local MinRank = 0

local Players = game:GetService("Players")
local u = string.upper

local function Whitelist (player)
	--if player:GetRankInGroup(Group) >= MinRank then return true end
	--if player.UserId == 0 then return true end
	return true
end

Players.PlayerAdded:Connect(function (player)
	if not Whitelist(player) then return end
	
	player.Chatted:Connect(function(message)
		if not string.match(u(message), u(command)) then return end
		local target = string.sub(message, string.len(command.." ")+1)
		local targetPlayer = Players:FindFirstChild(target)
		if not targetPlayer then return end
		
		local tool = player.Character:FindFirstChildWhichIsA("Tool")
		if not tool then return end
		
		tool.Parent = targetPlayer.Backpack
	end)
end)
