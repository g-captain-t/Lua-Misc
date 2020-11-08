local u = string.upper
local scrollFrame = script.Parent
local searchBar = script.Parent.Search

-- Make table of entry keywords. Children's names will be a keyword as well as the item name
-- -- item = {kw1, kw2, kw3, item.Name}
local entries = {}

for i, d in pairs (scrollFrame:GetChildren()) do
	local keywords = {}
	table.insert (keywords, d.Name)
	for i2, kw in pairs () do table.insert(keywords,kw.Name) end
	table.insert(entries, d, keywords)
end

function Search()
  if searchBar.Text == "" then return end -- blank

  -- Scan entries for entries, in each entry loop through the keywords. Eatch match will be one point
  -- Insert the item to the graded table with their grand total points
  -- -- item = 3

  local gradedEntries = {}

  for item, keywords in pairs (entries) do
  	local score = 0
  	for i, kw in pairs (keywords) do
	  	if string.find(u(kw),searchinput)~=nil or u(kw)==u(searchinput) then score = score +1 end
	  end
  	table.insert(gradedEntries, item, score)
  end

  -- Sort table. Then loop through the table twice, first to take out the entries, then re-insert them sorted in LayoutOrder.

  table.sort(gradedEntries, function(a,b) return a>b end)
  for i, v in pairs (gradedEntries) do v.Parent = nil end
  for i, v in pairs (gradedEntries) do v.Parent = end
end

searchBar:GetPropertyChangedSignal("Text"):Connect(Search)
