id=0  
gpio_pin= {4,3,0,1,2}


function find_dev(i2c_id, dev_addr)
     i2c.start(i2c_id)
     c=i2c.address(i2c_id, dev_addr ,i2c.TRANSMITTER)
     i2c.stop(i2c_id)
     return c
end

print("Scanning all pins for I2C Bus device")
for scl=1,7 do
     for sda=1,7 do
          tmr.wdclr() 
          if sda~=scl then
               i2c.setup(id,sda,scl,i2c.SLOW)
               for i=0,127 do 
                    if find_dev(id, i)==true then
                    print("Device is wired: SDA to GPIO - IO index "..sda)
                    print("Device is wired: SCL to GPIO - IO index "..scl)
                    print("Device found at address 0x"..string.format("%02X",i))
                    end
               end
          end
     end
end
