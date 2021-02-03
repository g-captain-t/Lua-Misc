--[[

OOP TicTacToe
For my own practice with OOP, and trying to see how sane I can stay keeping track of 
everything. Which is why I'm not using metatables and prefer to see an indent telling 
me what object this spagetthi belongs  to. If you find a way to use this, feel free 
to use this for your own project.

Objects:
- Round
- Player
- Board

]]

-- Player object

local Player = {}
function Player.new(n)
	local self = {
		mark = n,
		name = ""
	}
	
	function self.Award(self)
		print("Player "..self.n.." won!")
	end
	
	function self.Destroy(self)
		self = nil
	end
	
	return self
end

local function tcompare(t0,t1)
	local issimillar = true
	for i, v in pairs (t0) do 
		local Type0 = type(v)
		local Type1 = type(t1[i])
		if Type0 ~= Type1 then 
			issimillar = false
			break
		end
		if Type0 == "table" then 
			local isvsimillar = tcompare(v, t1[i])
			if not isvsimillar then issimillar = false break end 
		elseif v ~= t1[i] then
			issimillar = false 
			break
		end
	end
	return issimillar
end

-- Board object

local Board = {}

local winningpositions = {
	{{1,1,1},{0,0,0},{0,0,0}},
	{{0,0,0},{1,1,1},{0,0,0}},
	{{0,0,0},{0,0,0},{1,1,1}},
	{{1,0,0},{1,0,0},{1,0,0}},
	{{0,1,0},{0,1,0},{0,1,0}},
	{{0,0,1},{0,0,1},{0,0,1}},
	{{1,0,0},{0,1,0},{0,0,1}},
	{{0,0,1},{0,1,0},{1,0,0}},
}

function Board.new()
	local self = {}
	self.grid = {}
	
	for y = 1,3 do 
		local row = {}
		for x = 1,3 do 
			row[x] = 0
		end
		self.grid[y] = row
	end
	
	function self.ScanForWin(self,player)
		local mark = player.mark 
		-- Create a grid of the player's placements
		local playerplacements = {}
		for y=1,3 do 
			local row = {}
			for x=1,3 do 
				if self.grid[y][x] == mark then
					self.grid[y][x] = 1
				else 
					self.grid[y][x] = 0
				end
			end
			playerplacements[y]=row
		end
		-- Compare the players and winning positions
		for _, winningpos in ipairs (winningpositions) do 
			if tcompare(winningpis, playerplacements) then 
				return true
			end
		end
	end
	
	function self.PlaceMark(self, x,y, player)
		local valid = false
		if self.grid[y][x] == 0 then 
			self.grid[y][x] = player.mark
		end
	end
	
	function self:Destroy()
		for i,v in pairs (self.grid) do 
			self.grid[i] = nil
		end
		self.grid = nil
		self = nil
	end
	
	return self
end

-- Round object

local Round = {}

function Round.new(player1,player2)
	local self = {
		current_turn = player1
		player1 = Player.new(1),
		player2 = Player.new(2),
		board = Board.new(),
		winner = nil;
	}
	
	function self.Move(self,x,y,player)
		if current_turn ~= player then
			return 
		end 
		
		self.board:PlaceMark(x,y,player)
		if self.board:ScanForWin(player) then 
			self.winner = player
			self:End()
		else 
			current_turn = player==self. player1 and self.player2 or self.player1
		end
	end
	
	function self.End(self)
		self.winner:Award()
		self.Board:Destroy()
		self.Player1:Destroy()
		self.Player2:Destroy()
		self = nil
	end
	
	return self
end

-- Packed in a module

local TTT = {
	Round = Round,
	Board = Board,
	Player = Player
}

return TTT
