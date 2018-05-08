local M
do
require("ds3231")
local gpio0 = 3
local gpio2 = 4

ds3231.init(gpio0, gpio2)
  
local function SetTime(hour, minute, second, day, month, year)
-- GPIO Mapping
  ds3231.setTime(second, minute, hour, day, date, month, year);
  -- Get current time
  print(string.format("Time & Date: %s:%s:%s %s/%s/%s", hour, minute, second, date, month, year))
  -- Don't forget to release it after use
  ds3231 = nil
  package.loaded["ds3231"]=nil
end

local function PrintTime()
second, minute, hour, day, date, month, year = ds3231.getTime();
-- Get current time
print(string.format("Time & Date: %s:%s:%s %s/%s/%s", hour, minute, second, date, month, year))
-- Don't forget to release it after use
ds3231 = nil
package.loaded["ds3231"]=nil
end

M={
SetTime=SetTime,
PrintTime=PrintTime
}
end
return M