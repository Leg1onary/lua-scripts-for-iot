local M
do
require("ds3231")
local sdaRTC = 3
local sclRTC = 4

ds3231.init(sdaRTC, sclRTC)
  
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

M={
SetTime=SetTime,
PrintTime=PrintTime
}
end
return M