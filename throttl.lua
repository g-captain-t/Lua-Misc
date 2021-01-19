--// Maybe this can help

local throttl = {
	_queue = {}
	_currentminute = os.time()
	_minuterequests = 0	
}

local HTTP = game:GetService("HTTPService")
local RS = game:GetService("RunService")

function throttl.queue(f)
	--// wraps a function to consider the queue
	local queueid = HTTP:GenerateGUID()
	table.insert(queue, queueid)
	while true do
		--// Reset the minute quota
		if os.time()-throttl._currentminute > 60 then
			throttl._currentminute = os.time()
			throttl._minuterequests = 0
		end
		local checks = {
			(throttl._minuterequests <= 490);
			(throttl._queue[1] == queueid);
		}
		local canProceed = true
		for _,check in ipairs (checks) do
			if not check then 
				canProceed = false
				break 
			end
		end 
		--// Finally
		if canProceed then
			throttl._minuterequests += 1
			table.remove(throttl._queue,1)
			local s,v = pcall(f)
			return v
		end
		RS.Heartbeat:Wait()
	end
end

function throttl.wait()
	--// Just the yield, not sure which one i should use
	local queueid = HTTP:GenerateGUID()
	table.insert(queue, queueid)
	while true do
		--// Reset the minute quota
		if os.time()-throttl._currentminute > 60 then
			throttl._currentminute = os.time()
			throttl._minuterequests = 0
		end
		local checks = {
			(throttl._minuterequests <= 490);
			(throttl._queue[1] == queueid);
		}
		local canProceed = true
		for _,check in ipairs (checks) do
			if not check then 
				canProceed = false
				break 
			end
		end 
		--// Finally
		if canProceed then
			throttl._minuterequests += 1
			table.remove(throttl._queue,1)
			return
		end
		RS.Heartbeat:Wait()
	end
end

return throttl
