--[[

    Powerups
    by g-captain-t
    For non-plot buyable power-ups, for example, a walk speed boost
    
    Powerups.Powerups = {
        ["ExamplePowerup"]={isSaved=true, requires={}, price=0, callback=function(player)  end}
    }
    
    Powerups.Bought (inst player, string powerupName)
    
    function Powerups.BoughtCallback(player,powerupName)
    
    function Powerups.Buy(powerupName, player)
    function Powerups.PlayerOwnsPowerup(powerupName,player)
    function Powerups.Apply(powerupName, player)
    function Powerups.ApplyAll(player)
    
]]

local G = require(game.ReplicatedStorage.G)
local storename = "MainStore"
local DataCache, Lstats, tabl = G.GetLibrary("DataCache","Leaderstats","tabl")
local Powerups = {}

Powerups.Powerups = {
	["ExamplePowerup"]={isSaved=true, requires={}, price=0, callback=function(player) print(player)  end}
}

Powerups.Bought = Instance.new("BindableEvent") -- returns player instance and powerup name

--// What happens every time a powerup is bought.
--// Powerup-unique callbacks go in Powerup.callback. This is more of a universal function
function Powerups.BoughtCallback(player,powerupName)

end

function Powerups.Buy(powerupName, player)
	local powerup = Powerups.Powerups[powerupName]
	assert(powerup, "Powerup "..powerupName.." not found!")
	local pdata = DataCache.Get(player.UserId,storename)
	local lstats = Lstats.Get(player)
	
	--// Check if already owned
	if powerup.isSaved and tabl.find(pdata.BoughtPowerups,powerupName) then 
		warn(powerupName.." already owned!")
		return
	end
	
	--// Check requirements
	for _,required in pairs (powerup.requires) do
		if not tabl.find(pdata.BoughtPowerups,required)then
			warn(player.Name.." does not own "..required) 
			return
		end
	end

	--// Check money
	assert(pdata.Money >= powerup.price, player.Name.." can't afford "..powerupName)

	--// Update player data
	pdata.Money = pdata.Money-powerup.price
	lstats.Money.Value = pdata.Money
	if powerup.isSaved then
		table.insert(pdata.BoughtPowerups, powerupName)
	end
	DataCache.Save(player.UserId,storename, pdata)

	--// Send feedback
	Powerups.Bought:Fire(player, powerupName)
	print(player.Name.." sucessfully bought "..powerupName.."!")

	--// Run the callback
	powerup.callback(player)
	Powerups.BoughtCallback(player,powerupName)
end

function Powerups.PlayerOwnsPowerup(powerupName,player)
	local pdata = DataCache.Get(player.UserId,storename)
	return tabl.find(pdata.BoughtPowerups,powerupName)~=nil
end

--// Runs the callback
function Powerups.Apply(powerupName,player)
	local powerup = Powerups.Powerups(powerupName)
	if not Powerups.PlayerOwnsPowerup(powerupName,player)then 
		warn(player.Name.." does not own power-up"..powerupName)
		return 
	end
	powerup.callback(player)
end

function Powerups.ApplyAll(player)
	local pdata = DataCache.Get(player.UserId,storename)
	for _,powerupName in pairs (pdata.BoughtPowerups) do
		Powerups.Powerups[powerupName].callback(player)
	end
end

return Powerups