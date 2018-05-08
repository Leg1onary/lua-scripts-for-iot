local K
do
require("display")
require("ds3231")
local sdaRTC = 3
local sclRTC = 4
local sdaDisp = 5
local sclDisp = 6

ds3231.init(sdaRTC, sclRTC)
display.init(sdaDisp, sclDisp)

local function SetTime(hour, minute, second, day, month, year)
-- Set current time
  ds3231.setTime(second, minute, hour, day, date, month, year);
  -- print current time
  print(string.format("Time & Date: %s:%s:%s %s/%s/%s", hour, minute, second, date, month, year))
  ds3231 = nil
  package.loaded["ds3231"]=nil
end

local function PrintTime()
-- Get current time
second, minute, hour, day, date, month, year = ds3231.getTime();
print(string.format("Time & Date: %s:%s:%s %s/%s/%s", hour, minute, second, date, month, year))
ds3231 = nil
package.loaded["ds3231"]=nil
end

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

K={
busytime=busytime,
freetime=freetime,
resetdiod=resetdiod,
test=test,
SetTime=SetTime,
PrintTime=PrintTime
}
end
return K