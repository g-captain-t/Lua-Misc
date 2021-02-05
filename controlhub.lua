--[[

controlhub.lua
Starts controllers with respect to priority. Call controlhub() and pass the
folder with controllers with a single server/client script.

	require(controlhub)(game.ServerScriptService)
	require(controlhub)(script.Parent)

A controller looks like this:

	local controller = {}
	controller.meta = {
		IsAsync = true;
		Priority = 0;		-- Smallest first
	}
	controller.controller = function()
		-- Do something
	end

	return controller

]]

local controlhub = function (container)
	local queue = {}
	local smallestpriority = math.huge
	local largestpriority = -math.huge
	for _, child in pairs (container:GetChildren()) do
		if child:IsA("ModuleScript") then
			local s, controller = pcall(function()return require(child) end)
			if s then
				controller.Name = child.Name
				largestpriority = controller.Priority > largestpriority and controller.Priority or largestpriority
				smallestpriority = controller.Priority < smallestpriority and controller.Priority or smallestpriority
				table.insert(queue, controller)
			else
				warn("controlhub: Error loading controller"..child.Name..". "..controller)
			end
		end
	end

	local nqueue = #queue
	local running = {}
	for priority=0, largestpriority do 
		if #running == nqueue or largestpriority == -math.huge then
			break
		end
		-- Asynchronous first
		for _, controller in ipairs(queue) do 
			if controller.Priority == priority and controller.isAsync then
				local s, err = pcall(function() coroutine.wrap(controller.controller)() end)
				if s then
					table.insert(running, controller)
				else
					warn("controlhub: Error running controller"..controller.Name..": "..err)
				end
			end
		end
		-- Then the synchronous ones
		for _, controller in ipairs(queue) do 
			if controller.Priority == priority and not controller.isAsync then
				local t = tick()
				coroutine.wrap(function()
					wait(3)
					if t ~=nil then 
						warn("ControlHub: synchronous controller "..controller.Name.." is taking too long -- check for an infinite yield!") 
					end
				end)()
				local s, err = pcall(controller.controller)
				t = nil
				if s then
					table.insert(running, controller)
				else
					warn("controlhub: Error running controller"..controller.Name..": "..err)
				end
			end
		end
	end
	-- Done
end

return controlhub
