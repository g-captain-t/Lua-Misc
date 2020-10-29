local config = {
	
	maxMessages = 20					  ;	-- Amount of messages in radio
	
	allowedTeams = {}					  ;	-- Teams that can use radio 	("Staff"; "Security")
	allowedPlayers = {}					;	-- Players that can use radio 	("APlayerName"; 717178816;)
	allowedGroup = nil					;	-- Allowed group ID 			(881604)
	allowedGroupRank = 0				;	-- Minimum rank to use radio 	(255)
	
	
}

local Players = game:GetService("Players")
function config.CheckChatter(player)	--
	for i, t in pairs (config.allowedTeams) do
		if player.Team == t then return true end
	end
	local playerName = Players:GetNameFromUserIdAsync(player.UserId)
	for i, p in pairs (config.allowedPlayers) do
		if playerName == p then return true
		elseif player.UserId == p then return true
		end
	end
	if  config.allowedGroup ~= nil and
		player:GetRankInGroup(config.allowedGroup) >= config.allowedGroupRank then
		return true
	end
	return false
end

return config
