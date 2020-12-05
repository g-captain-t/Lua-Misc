local Settings = {
	
	UseHTTP = true	;
	URL = "https://raw.githubusercontent.com/g-captain-t/Lua-Misc/master/ImportClothing/ServerScriptService/Test/Test.json";
	-- Link to the JSON file
	
	UseModule = false ;
	Module = script.Parent.Test.TestModule; 
	-- Or simply change to the roblox library ID if the module is outside the game
	
}

return Settings
