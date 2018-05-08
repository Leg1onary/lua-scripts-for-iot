local N
do
require("display")
local sdaDisp = 5
local sclDisp = 6

display.init(sdaDisp, sclDisp)

local function freetime(time_start,time_end)
 display.freetime(time_start,time_end)
 display = nil
 package.loaded["display"]=nil
end

local function busytime(time_start,time_end)
 display.busytime(time_start,time_end)
 display = nil
 package.loaded["display"]=nil
end

local function resetdiod()
 display.resetdiod()
 display = nil
 package.loaded["display"]=nil
end

local function test()
 display.test()
 display = nil
 package.loaded["display"]=nil 
end

N={
busytime=busytime,
freetime=freetime,
resetdiod=resetdiod,
test=test
}
end
return N