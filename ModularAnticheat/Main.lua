-- Modular Anticheat by g_captain
-- g-captain-t/Lua-Misc/blob/master/ModularAnticheat/

local Whitelist = require(script.Whitelist)
local Modules = script.Modules
local Players = game:GetService("Players")

script.Parent = game:GetService("ServerScriptService")

Players.PlayerAdded:Connect(function(player)
	if Whitelist.Check(player) then return end
	
	player.CharacterAdded:Connect(function(character)
		pcall(function() require(Modules.AntiTeleport).BindCheck(character, player) end)
	end)
end)
