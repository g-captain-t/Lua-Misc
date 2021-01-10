local G = require(game.ReplicatedStorage.G)
local DataCache, Lstats, Evhub = G.GetLibrary("DataCache","Leaderstats","Evhub")
local Players, Plots, Powerups = G.GetService("Players", "Plots", "Powerups")

--// Player join/leave and data

local storename = "MainStore"
local defaultdata = {
	DataId=0, 
	Money=0,
	Income=10,
	Multiplier=1,
	Interval=3,
	BoughtItems={},
	BoughtPowerups={},
}
local defaultlstats = {Money=0}

Players.PlayerAdded:Connect(function(player)
	--// Retrieve data
	local pdata = DataCache.Get(player.UserId,storename,defaultdata)
	local leaderstats = Lstats.Init(player,defaultlstats)
	leaderstats.Money.Value = pdata.Money

	--// Assign a plot, update based on boughtitems
	local emptyplot = Plots.GetEmpty()
	Plots.Setup(emptyplot, player)

	--// On character added
	player.CharacterAdded:Connect(function(character)

	end)

	--// Apply powerups
	Powerups.ApplyAll(player)
	
	--// Income
	while player do
		wait(pdata.Interval)
		pdata = DataCache.Get(player.UserId, storename)
		Lstats.Update(player,"Money",leaderstats.Money.Value + pdata.Income*pdata.Multiplier)
		pdata.Money = leaderstats.Money.Value
		DataCache.Save(player.UserId, storename, pdata)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	--// Retrieve & save data to store
	local pdata = DataCache.Get(player.UserId,storename,defaultdata)
	local leaderstats = Lstats.Get(player)
	local s,v = DataCache.SaveStore(player.UserId,storename,pdata)
	print(player.UserId,storename,pdata)

	--// Cleanup their plot
	local abandonedplot = Plots.GetPlayerPlot(player)
	Plots.Cleanup(abandonedplot)
end)