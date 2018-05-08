local moduleName = ...
local N = {}
_G[moduleName] = N

local id = 0
--local sda = 5      -- GPIO0
--local scl = 6      -- GPIO2
local dev = 0x27   -- I2C Address 0x27
local reg = 0x00   -- write
local pin_Green = 1 
local pin_Red = 2
local bl = 0x08      -- 0x08 = back light on

local function send(data)
   local value = {}
   for i = 1, #data do
      table.insert(value, data[i] + bl + 0x04 + rs)
      table.insert(value, data[i] + bl +  rs)      -- fall edge to write
   end  
   i2c.start(id)
   i2c.address(id, dev ,i2c.TRANSMITTER)
   i2c.write(id, reg, value)
   i2c.stop(id)
end
 
if (rs == nil) then
-- init
 rs = 0
 send({0x30})
 tmr.delay(4100)
 send({0x30})
 tmr.delay(100)
 send({0x30})
 send({0x20, 0x20, 0x80})      -- 4 bit, 2 line
 send({0x00, 0x10})            -- display clear
 send({0x00, 0xc0})            -- display on
end

local function cursor(op)
 local oldrs=rs
 rs=0
 if (op == 1) then 
   send({0x00, 0xe0})            -- cursor on
  else 
   send({0x00, 0xc0})            -- cursor off
 end
 rs=oldrs
end

local function cls()
 local oldrs=rs
 rs=0
 send({0x00, 0x10})
 rs=oldrs
end

local function home()
 local oldrs=rs
 rs =0
 send({0x00, 0x20})
 rs=oldrs
end

local function lcdprint (str,line,col)
if (type(str) =="number") then
 str = tostring(str)
end
rs = 0
--move cursor
if (line == 2) then
 send({0xc0,bit.lshift(col,4)})
elseif (line==1) then 
 send({0x80,bit.lshift(col,4)})
end

rs = 1
for i = 1, #str do
 local char = string.byte(string.sub(str, i, i))
 send ({ bit.clear(char,0,1,2,3),bit.lshift(bit.clear(char,4,5,6,7),4)})
end

end

function N.busytime(time_start,time_end)
cls()
gpio.write(pin_Green,gpio.LOW)
gpio.write(pin_Red,gpio.HIGH)
str = tostring("**Room is BUSY**")
rs = 0
--move cursor
 send({0x80,bit.lshift(0,4)})

rs = 1
for i = 1, #str do
 local char = string.byte(string.sub(str, i, i))
 send ({ bit.clear(char,0,1,2,3),bit.lshift(bit.clear(char,4,5,6,7),4)})
end

str = tostring(time_start.." - "..time_end)

rs = 0
--move cursor
if (#time_start==4) then
 send({0xc0,bit.lshift(2,4)})
elseif (#time_start==5) then 
 send({0xc0,bit.lshift(1,4)})
end

rs = 1 
for i = 1, #str do
 local char = string.byte(string.sub(str, i, i))
 send ({ bit.clear(char,0,1,2,3),bit.lshift(bit.clear(char,4,5,6,7),4)})
end

cursor(0)
end

function N.freetime(time_start,time_end)
cls()
gpio.write(pin_Red,gpio.LOW)
gpio.write(pin_Green,gpio.HIGH)
str = tostring("**Room is FREE**")
rs = 0
--move cursor
 send({0x80,bit.lshift(0,4)})

rs = 1
for i = 1, #str do
 local char = string.byte(string.sub(str, i, i))
 send ({ bit.clear(char,0,1,2,3),bit.lshift(bit.clear(char,4,5,6,7),4)})
end

str = tostring(time_start.." - "..time_end)

rs = 0
--move cursor
if (#time_start==4) then
 send({0xc0,bit.lshift(2,4)})
elseif (#time_start==5) then 
 send({0xc0,bit.lshift(1,4)})
end

rs = 1 
for i = 1, #str do
 local char = string.byte(string.sub(str, i, i))
 send ({ bit.clear(char,0,1,2,3),bit.lshift(bit.clear(char,4,5,6,7),4)})
end

cursor(0)
end

function N.resetdiod()
gpio.write(pin_Green,gpio.LOW)
gpio.write(pin_Red,gpio.LOW)
end

function N.init(d, l)
  if (d ~= nil) and (l ~= nil) and (d >= 0) and (d <= 11) and (l >= 0) and ( l <= 11) and (d ~= l) then
    sda = d
    scl = l
  else
	return nil
  end
    i2c.setup(id, sda, scl, i2c.SLOW)
end

function N.test()
gpio.mode(pin_Green,gpio.OUTPUT)
gpio.mode(pin_Red,gpio.OUTPUT)
--init diod
gpio.write(pin_Green,gpio.HIGH)
tmr.delay(300000)
gpio.write(pin_Green,gpio.LOW)
tmr.delay(50000)
gpio.write(pin_Red,gpio.HIGH)
tmr.delay(300000)
gpio.write(pin_Red,gpio.LOW)
tmr.delay(50000)
--init display
for i=1,3 do
home()
lcdprint("||||||||||||||||",1,0)
lcdprint("||||||||||||||||",2,0)
tmr.delay(100000)
lcdprint("////////////////",1,0)
lcdprint("////////////////",2,0)
tmr.delay(100000)
lcdprint("----------------",1,0)
lcdprint("----------------",2,0)
tmr.delay(100000)
end
cls()
lcdprint("initialization",1,1)
lcdprint("complete :)",2,4)
tmr.delay(4000000)
cls()
end

return N