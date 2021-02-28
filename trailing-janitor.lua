-- trailing janitor, cleans trailing whitespaces on your scripts
-- while you work

local function clean(source) 
	local lines = source:split("\n")
	local n_lines = #lines
	local new_source = "" -- avoid table concat
	for i, line in ipairs (lines) do 
		local multistring_opens = line:find("%[%[") or 0
		local multistring_complete = line:find("%[%[.-%]%]") or 0
		
		-- don't trim multi line strings
		if (multistring_complete == multistring_opens) then 
			line = line:gsub("%s-$", "")
		end
		local newline = i == n_lines and "\n" or ""
		new_source = new_source..line..newline
	end
	return new_source
end

-- Clean scripts in the background

local StudioService = game:GetService("StudioService")
local active_signal = StudioService:GetPropertyChangedSignal("ActiveScript")
local active_script = StudioService.ActiveScript

local services = {
	"Workspace",
	"ReplicatedStorage",
	"ReplicatedFirst",
	"ReplicatedScriptService",
	"ServerStorage",
	"ServerScriptService",
	"Lighting",
	"StarterGui",
	"StarterPack",
	"StarterPlayer"
}

for i, service in ipairs(services) do 
	services[i] = game:GetService(service)
end

local function clean_descendants(ancestor)
	for _, d in ipairs(ancestor:GetDescendants()) do 
		if d:isA("Script") and d ~= active_script then 
			d.Source = clean(d.Source) 
		end
	end
end

active_signal:Connect(function(object)
	active_script = object
	for _, service in ipairs(services) do 
		clean_descendants(service)
	end
end)
