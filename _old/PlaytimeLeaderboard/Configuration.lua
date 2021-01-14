-- Playtime Leaderboard by g_captain
-- SETTINGS --

local Configurations = {
	
	NamesOnBoard = 20			; -- How many names are displayed on the leaderboard
	AddPointWait = 60			; -- In seconds; how much time to wait for every point
	LeaderboardName = "Time"	; -- The leaderboard name as seen in the player tab
	Board = script.Parent		; -- The brick where the leaderboard will be displayed
	
	DataStoreName = tostring(game.PlaceId).."_PLAYTIME"		; -- The datastore name. Changing this will store data in a new store, and all current data will not show
}

return Configurations
