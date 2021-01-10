--[[

    Plots
    by g-captain-t
    Handles plot assign/abandonment as well as item boughts

    Plots.Plots = {
        {plotId=1, plotGroup=workspace:WaitForChild("Plot1"), owner=nil}
    Plots.Items {
        ["ExampleItem"]={requires={}, price=0, callback=function(player,plotGroup) end}
    }

    Plots.ItemBought (inst player, string itemname)

    function Plots.AbandonCallback(table plot)
    function Plots.AssignCallback(plot,player)
    function Plots.BoughtItemCallback(plot,player,item)

    function Plots.GetEmpty()
    function Plots.GetPlayerPlot(player)
    function Plots.BuyItem(itemName, player)
    function Plots.PlayerOwnsItem(itemName,player)
    function Plots.Setup(plot, player)
    function Plots.Cleanup(plot)
    
]]

local G = require(game.ReplicatedStorage.G)
local storename = "MainStore"
local DataCache, Lstats, tabl = G.GetLibrary("DataCache","Leaderstats","tabl")
local Plots = {}

--// Properties


Plots.Plots = {
	{plotId=1, plotGroup=workspace:WaitForChild("Plot1"), owner=nil}
}
--// The buyable items and the callbacks. For example
Plots.Items = {
	["ExampleItem"]={requires={}, price=0, callback=function(player,plotGroup) end},
	["ExampleItem2"]={requires={"ExampleItem"}, price=50, callback=function(player,plotGroup) end}
}

--// Events
--// Plots.ItemBought.Event (inst player, string itemname)
Plots.ItemBought = Instance.new("BindableEvent")


--// What happens when a plot is abandoned, for example, reset the plot group instance
function Plots.AbandonCallback(plot)

end
--// What happens when a plot is assigned, for example, teleport the character there
function Plots.AssignCallback(plot,player)

end
--// What happens when an item is bought, for example, Check the available buy plates and make them visible
--// Item-unique callbacks go in item.callback. This is more of a universal function
function Plots.BoughtItemCallback(plot,player,item)

end

--// Functions

function Plots.GetEmpty()
	for _,plot in pairs (Plots.Plots) do
		if not plot.owner then return plot end
	end
end

function Plots.GetPlayerPlot(player)
	for _, plot in pairs (Plots.Plots) do
		if plot.owner==player then return plot end
	end
end

function Plots.BuyItem(itemName, player)
	local item = Plots.Items[itemName]
	local pdata = DataCache.Get(player.UserId,storename)
	local lstats = Lstats.Get(player)
	local plot = Plots.GetPlayerPlot(player)
	local plotGroup = plot.plotGroup
	
	--// Check if already owned
	if tabl.find(pdata.BoughtItems,itemName) then 
		warn(itemName.." already owned!") return 
	end

	--// Check requirements
	for _,required in pairs (item.requires) do
		if not tabl.find(pdata.BoughtItems,required) then 
			warn(player.Name.." does not own "..required) 
			return 
		end
	end
	
	--// Check money
	if not (pdata.Money >= item.price) then warn(player.Name.." can't afford "..itemName) return end

	--// Save player data
	pdata.Money = pdata.Money-item.price
	lstats.Money.Value = pdata.Money
	table.insert(pdata.BoughtItems, itemName)
	DataCache.Save(player.UserId,storename, pdata)

	--// Send feedback
	Plots.ItemBought:Fire(player, itemName)
	print(player.Name.." sucessfully bought "..itemName.."!")

	--// Run the callback
	item.callback(player, plotGroup)
	Plots.BoughtItemCallback(plot,player,itemName)
end

function Plots.PlayerOwnsItem(itemName,player)
	local pdata = DataCache.Get(player.UserId,storename)
	return tabl.find(pdata.BoughtItems,itemName)~=nil
end

function Plots.Setup(plot, player)
	local pdata = DataCache.Get(player.UserId,storename)

	--// Do the assigncallback
	plot.owner = player
	Plots.AssignCallback(plot,player)

	--// Do the callbacks
	for _,item in pairs (pdata.BoughtItems) do
		Plots.Items[item].callback()
	end

	--// Finish up
	print("Finished setup for Plot"..plot.plotId.." and "..player.Name)
end

function Plots.Cleanup(plot)
	Plots.AbandonCallback(plot)
	plot.owner=nil
	print("Finished cleanup for Plot"..plot.plotId)
end

return Plots