local properties = {
	"Text Color",
	"Background Color",
	"Selection Color",
	"Selection Background Color",
	"Operator Color",
	"Number Color",
	"String Color",
	"Comment Color",
	"Keyword Color",
	"Warning Color",
	"Find Selection Background Color",
	"Matching Word Background Color",
	"Build-in Function Color",
	"Whitespace Color",
	"Current Line Highlight Color",
	"Debugger Current Line Color",
	"Debugger Error Line Color",
	"Local Method Color",
	"Local Property Color",
	"\"nil\" Color",
	"Bool Color",
	"\"function\" Color",
	"\"local\" Color",
	"\"self\" Color",
	"Luau Keyword Color",
	"Function Name Color",
	"TODO Color",
	"Script Ruler Color",
	"Script Bracket Color"
}

local preview = [[
function Something:Do()
	print "test"
	print (test)
	local a = {
		["test"] = "test"
	}
	self.Color = Color3.new(1,2,3)
	if a == b then 
		return true 
	end
	-- and comment
end
]]
