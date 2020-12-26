--// Analytics
--// Send a game session's analytics to a Discord webhook

local Analytics = {}
local RS = game:GetService("RunService")
local HTTPS = game:GetService("HttpService")
local Players = game:GetService("Players")
local DS = game:GetService("DataStoreService")
local ReturnStore = DS:GetDataStore("ReturningPlayers")
local running = true

local URL = ""
local SessionData = {
	SessionLength = 0;
	PlrSessions = {};
	AvgPlrSessionLength = 0;
	LongestPlrSession = 0;
	ShortestPlrSession = math.huge;
	TotalJoins = 0;
	ReturningPlayers = 0;
	MostReturnCount = 0;
}

--// When game first loads
coroutine.wrap(function()
	if RS:IsStudio() then return end
	while running do
		wait(1)
		SessionData.SessionLength = SessionData.SessionLength+1
	end
end)()

--// Players
Players.PlayerAdded:Connect(function(player)
	if RS:IsStudio() then return end
	if player.UserId == game.CreatorId then return end	--//
	if game.CreatorType==Enum.CreatorType.Group and player:GetRankInGroup(game.CreatorId)==255 then return end
	local isPlaying = true
	local pData = {
		SessionLength = 0;
	}

	SessionData.TotalJoins = SessionData.TotalJoins+1
	SessionData.PlrSessions[player.UserId] = SessionData.PlrSessions[player.UserId] or 0

	-- if found in Returningplayers, add 1 to streak and returnplayercount
	-- else add their entry
	local s, ReturningData = pcall(function() return ReturnStore:GetAsync(player.UserId) end)
	if ReturningData then
		SessionData.ReturningPlayers = SessionData.ReturningPlayers+1
		if ReturningData>SessionData.MostReturnCount then SessionData.MostReturnCount = ReturningData end
	else
		ReturningData = 0
	end
	ReturningData = ReturningData+1

	coroutine.wrap(function()
		while isPlaying do
			wait(1)
			pData.SessionLength = pData.SessionLength+1
		end
	end)()

	Players.PlayerRemoving:Connect(function(rplayer)
		if rplayer ~= player then return end
		isPlaying = false
		SessionData.PlrSessions[player.UserId] = pData.SessionLength
		pcall(function() ReturnStore:SetAsync(player.UserId, ReturningData) end)
	end)
end)

--// When game closes
game:BindToClose(function()
	if RS:IsStudio() then return end
	running = false
	local finishedSaving = false
	coroutine.wrap(function()

		--// Player Sessions 
		local sessioncount = 0
		local totalsessionlength = 0
		for i,v in pairs (SessionData.PlrSessions) do
			sessioncount = sessioncount+1
			totalsessionlength = totalsessionlength+v
			SessionData.AvgPlrSessionLength = totalsessionlength/sessioncount
			SessionData.LongestPlrSession = v > SessionData.LongestPlrSession and v or SessionData.LongestPlrSession
			SessionData.ShortestPlrSession = v < SessionData.ShortestPlrSession and v or SessionData.ShortestPlrSession
		end
		SessionData.PlrSessions = sessioncount

		--// Send to webhook
		local finalstring = 
			"Session Length: "..tostring(SessionData.SessionLength).."s \n"..
			"Total Joins: "..tostring(SessionData.TotalJoins).."\n"..
			"Player Sessions: "..tostring(SessionData.PlrSessions).."\n"..
			"Average Player Session: "..tostring(SessionData.AvgPlrSessionLength).."\n"..
			"Longest Player Session: "..tostring(SessionData.LongestPlrSession).."\n"..
			"Shortest Player Session: "..tostring(SessionData.ShortestPlrSession).."\n"..
			"ReturningPlayers: "..tostring(SessionData.ReturningPlayers).."\n"..
			"MostReturnCount: "..tostring(SessionData.MostReturnCount)
		
		print(finalstring)
		
		local s,v = pcall(function() 
			HTTPS:PostAsync(URL,HTTPS:JSONEncode({
				["embeds"] = {{
					["title"] = "Session Analytics "..os.date("%c",os.time());
					["description"] = finalstring;
					["color"] = 5814783
				}}
			}))
			RS.Heartbeat:Wait()
		end)
		print(s,v)

		finishedSaving = true
	end)()

	repeat RS.Heartbeat:Wait() until finishedSaving
end)
