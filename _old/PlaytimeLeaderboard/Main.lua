local Players = game:GetService("Players")
local DS = game:GetService("DataStoreService")
local DSS = require(script.Parent.DSS)
local Config = require(script.Parent)
local Store = DS:GetOrderedDataStore(Config.DataStoreName)
local s, n = tostring, tonumber

local SurfaceGUI = script.Parent.SurfaceGui
local Board = Config.Board

local function Setup(Gui)
	local ScrollingFrame = Gui.ScrollingFrame
	local Template = ScrollingFrame.Template
	local sortedStore = Store:GetSortedAsync(false, Config.NamesOnBoard):GetCurrentPage()

	for i, entry in ipairs(sortedStore) do
		local CT = Template:Clone()
		CT.Rank.Text = s(i)
		CT.Player.Text = Players:GetNameFromUserIdAsync(n(entry.key))
		CT.Amount.Text = s(entry.value)

		CT.Parent = ScrollingFrame
		CT.Visible = true
	end
	Template.Visible = false
	Gui.Adornee = Board
end

local update = coroutine.wrap(function(playerGUI) 
	while true do
		local ClonedGUI = SurfaceGUI:Clone()
		Setup(ClonedGUI)
		ClonedGUI.Parent = playerGUI
		wait(10)
		ClonedGUI:Destroy()
	end 
end)


Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		wait(.5)
		update(player.PlayerGui)
	end)

	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"
	local lbPoints = Instance.new("IntValue", leaderstats)
	lbPoints.Name = Config.LeaderboardName
	local GetS, GetV = DSS.Get(Store, s(player.UserId))
	lbPoints.Value = GetV

	local sessionPoints = Instance.new("IntValue")
	sessionPoints.Parent = player
	sessionPoints.Name = player.UserId.."_SessionPoints"

	while player and sessionPoints do
		wait(Config.AddPointWait) 
		sessionPoints.Value = sessionPoints.Value + 1
		lbPoints.Value = lbPoints.Value + 1
	end
	
end)

Players.PlayerRemoving:Connect(function(rPlayer)
	local sessionPoints = rPlayer:FindFirstChild(rPlayer.UserId.."_SessionPoints")
	if not sessionPoints then return end
	local success, v = DSS.Increment(Store, s(rPlayer.UserId), sessionPoints.Value)
	if success then print("Data successfully saved! Player "..s(rPlayer.UserId).." Amount "..v)
	else error("ERROR. Player "..s(rPlayer.UserId).." Amount "..v)end
end)
