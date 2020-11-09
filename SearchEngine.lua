local scrollFrame = script.Parent.ScrollingFrame
local searchBar = script.Parent.Search
local UIModifier = scrollFrame.UIListLayout

local u = string.upper

function Search()
	-- Make table of entry keywords. Children's names will be a keyword as well as the item name
	-- Example: item = {kw1, kw2, kw3, itemname}
	local entries = {}

	for i, d in pairs (scrollFrame:GetChildren()) do
		if d==UIModifier then continue end
		
		local keywords = {}
		table.insert (keywords, d.Name) -- Insert the name as a keyword
		for i2, kw in pairs (d:GetChildren()) do table.insert(keywords,kw.Name) end	-- Children's names are also keywords. This way you can add related keyword instances 
		entries[d] = keywords -- Example: item = {kw1, kw2, kw3, itemname}
	end

	-- Scan entries for entries, in each entry loop through the keywords. Eatch match will be one point
	-- Insert the item to the graded table with their grand total points
	-- Example: {item, 3}
	local searchinput = searchBar.Text
	if searchinput == "" then return end -- blank
	print("------SEARCH: "..searchBar.Text.."-------")
	
	local gradedEntries = {}

	for item, keywords in pairs (entries) do
		local score = 0	--Score will be in amount of letters
		
		for i, kw in pairs (keywords) do
			local matched,letters = string.find(u(kw),u(searchinput))	-- nil or an integer, amount of letters
			if matched ~= nil then score = score + letters end	-- "ap" and "apogee" returns 2
			if u(kw)==u(searchinput) then score = score + string.len(kw) + 1 end	-- Exact matches. +1 to put it on top if there are other matches with extra letters
		end
		
		table.insert(gradedEntries, {item,score}) -- Example: {item, 3}
		print(item.Name..":",score)
	end

	-- Get entries sorted in LayoutOrder.
	table.sort(gradedEntries, function(a,b) return a[2]>b[2] end)
	for _, i in pairs (gradedEntries) do i[1].LayoutOrder =  -i[2] end
	UIModifier:ApplyLayout()
	
end

searchBar:GetPropertyChangedSignal("Text"):Connect(Search)
