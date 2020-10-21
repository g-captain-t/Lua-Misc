--[[ Call require(5855143031) to use this 
Made this in my spare time out of boredom, here are my shortcuts for os.time():

tm.t() 		-- 906000490

tm.weekday()	-- Wednesday
tm.day()	-- 16
tm.month()   	-- September
tm.dmonth()   	-- 09
tm.year()  	-- 1998

tm.mmddyy()  	-- 09/16/98
tm.ddmmyy()  	-- 19/09/98
tm.dmy()   	-- 19/09/1998
tm.daydate()  	-- Wednesday, September 16 1998
tm.datetime()  	-- 09/16/98 23:48:10

tm.timezone() 	-- Eastern Daylight Time
tm.clock24() 	-- 23:48:10
tm.clock12() 	-- 11:48:10 pm
tm.hour() 	-- 23
tm.hour12()	-- 11
tm.minute()	-- 48
tm.second() 	-- 10

]]

local tm = {}
function tm.t()  return os.time() 	end

function tm.weekday()  return os.date("%A", os.time()) 	end	-- Wednesday
function tm.day()  return os.date("%d",os.time()) 	end	-- 16
function tm.month()  return os.date("%B",os.time()) 	end	-- September
function tm.dmonth()  return os.date("%m",os.time())	end	-- 09
function tm.year()  return os.date("%Y",os.time()) 	end	-- 1998

function tm.mmddyy() return os.date("%x", os.time())	end		-- 09/16/98
function tm.ddmmyy()  return os.date("%d/%m/%Y", os.time()) 	end	-- 19/09/98
function tm.dmy()  return os.date("%d/%m/%Y", os.time())	end	-- 19/09/1998
function tm.daydate() return os.date("%A, %B %d %Y", os.time())	end	-- Wednesday, September 16 1998
function tm.datetime()  return os.date("%c",os.time()) 	end		-- 09/16/98 23:48:10

function tm.timezone() return os.date("%Z", os.time())	end		-- Eastern Daylight Time
function tm.clock24() return os.date("%X", os.time())	end 		-- 23:48:10
function tm.clock12() return os.date("%I:%M:%S %p", os.time())	end	-- 11:48:10 pm
function tm.hour() return os.date("%H", os.time())	end 		-- 23
function tm.hour12() return os.date("%I", os.time())	end 		-- 11
function tm.minute() return os.date("%M", os.time())	end 		-- 48
function tm.second() return os.date("%S", os.time())	end 		-- 10

return tm
