local StateVal = script.Parent.State
local States = {}

local function ChangeState(StringState, t)
	print(StringState)
	StateVal.Value = StringState
	States[StringState](t)
end

function States.Work(t)
	for i=1,t do 
		wait(1)
		if game.Lighting.ClockTime == 7 then 
			ChangeState("Eat",10)
		end
	end
	ChangeState("GoHome")
end

function States.Eat(t)
	for i=1,t do
		wait(1)
		if game.Lighting.ClockTime < 7 then 
			ChangeState("GoHome")
		else
			ChangeState("Work",120)
		end
	end
end

function States.GoHome()
	wait(240)
	ChangeState("Work", 120)
end

--// INITIATE
ChangeState("Work",120)
