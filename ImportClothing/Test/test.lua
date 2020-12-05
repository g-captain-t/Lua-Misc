-- Lua version of the JSON table
-- Allows for comments and no comma policing

local clothing = {
	["FormalWear"] = {
		{["Shirt"]="5375354423", ["Pants"]="5375357586/Graviclad-Womens-All-Black-Blazer"},
		{["Shirt"]="5266601665", ["Pants"]="5266604097/Graviclad-Chestnut-Checkered-Blazer-Pants"},
		{["Shirt"]="5266607450", ["Pants"]="5266624369/Graviclad-Charcoal-Checkered-Blazer-Pants"},
	},
	["CasualWear"] = {
		{["Shirt"]="5283900969", ["Pants"]="5283906027/Graviclad-Beige-Overalls"},
		{["Shirt"]="5283914026", ["Pants"]="5283915405/Graviclad-Light-Denim-Overalls"},
		{["Shirt"]="5283882627", ["Pants"]="5283884111/Graviclad-Black-White-Overalls"},
	},
	["Featured"] = {
		["Left"] = {["Shirt"]="5266601665", ["Pants"]="5266604097/Graviclad-Chestnut-Checkered-Blazer-Pants"},
		["Right"] = {["Shirt"]="5266607450", ["Pants"]="5266624369/Graviclad-Charcoal-Checkered-Blazer-Pants"},
	},
	["TestCategory"] = {
		{["Shirt"]="", ["Pants"]=""},
		{["Shirt"]="", ["Pants"]=""},
	},
}
return clothing
