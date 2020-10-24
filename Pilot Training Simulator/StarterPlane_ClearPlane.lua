local plane = script.Parent.Parent
local mainSeat = script.Parent.MainSeat

for i=1, 30 do wait(1)
	if i == 30 and mainSeat.Occupant == nil then 
		plane:Destroy() 
		print("Plane has no occupant. Destroying...")	
	end
end
