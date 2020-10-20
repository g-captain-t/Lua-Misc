local module = {minuteReqCount = 0}
local config = {
    
    Limit = 500; -- Request limit per minute
    RetryTime = 5; -- Wait time before checking the request limit again
    RetryLimit = 3; -- Max retries
    
}

module.gameRegularCheck = coroutine.wrap(function()
    while true do wait(60)
    module.minuteReqCount = 0 end
end) 

function module.LimitHTTP()
    if module.minuteReqCount == config.Limit then
        local retrycount = config.RetryTime
        repeat wait(5) 
            retrycount = retrycount + 1
            if retrycount == config.RetryLimit then return false end
        until module.minuteReqCount < config.Limit
    end
    module.minuteReqCount = module.minuteReqCount + 1
    return true
end

return module

--[[ 
- Run module.gameRegularCheck() once in-game
- Call module.LimitHTTP() before a HTTP action
- module.LimitHTTP() also returns success status
]]
