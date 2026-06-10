A1 = 1

A2 = 1
LineNum = 1

completed = 0

xcor = 0

zcor = 0

ycor = 1

zd = 0

yd = 0 

xd = 0

r = 0

-- GUI --

term.clear()

term.setCursorPos(1,1)

print("Welcome to Digging programm!")

sleep(0.5)

write("X size(Forward): ")
xs = read()

xs = xs + 0
write("Z size(Right): ")

zs = read()

zs = zs + 0

write("Y size(Up/Down): ")

ys = read()

ys = ys + 0

print("Drop items in chest?")

A1 = 1
LineNum = 1

while A1 == 1 do

  if LineNum == 1 then
    term.setCursorPos(1,6)
    term.clearLine()
    print("[Yes]   No ")

  elseif LineNum == 2 then
    term.setCursorPos(1,6)
    term.clearLine()
    print(" Yes   [No]")
  end

  local name, data = os.pullEvent()

  if name == "key" then

    if data == keys.enter then
      if LineNum == 1 then
        Chest = 1
        A1 = 0
      elseif LineNum == 2 then
        Chest = 0
        A1 = 0
      end
    end

    if data == 205 or data == 200 then
      LineNum = LineNum + 1
    elseif data == 203 or data == 208 then
      LineNum = LineNum - 1
    end

  end
  
  if name == "mouse_scroll" then
    
    if data == 1 then 
      LineNum = LineNum + 1
    elseif data == -1 then
      LineNum = LineNum - 1   
    end   
  
  end
  
  if LineNum == 3 then
    LineNum = 1
  end
 
  if LineNum == 0 then  
    LineNum = 2
  end

end

LineNum = 1

while A2 == 1 do
  
  if LineNum == 1 then
    
    term.clearLine(7)
    
    term.setCursorPos(1,7)
    
    print("[Dig Up]   Dig Down ")
  
  elseif LineNum == 2 then
    
    term.clearLine(7)
    
    term.setCursorPos(1,7)
    
    print(" Dig Up   [Dig Down]")
  
  end
  
  name,data = os.pullEvent()
 
  if name == "key" then
   
    if data == 205 or data == 200 then
      
      LineNum = LineNum + 1    
    
    elseif data == 203 or data == 208 then
      
      LineNum = LineNum - 1
    
    end
    
    if data == keys.enter then
      
      if LineNum == 1 then
       
        Dir = "up"
        
        A2 = 0
      
      elseif LineNum == 2 then
        
        Dir = "down"
       
        A2 = 0
      
      end
    
    end
  
  end
  
  if name == "mouse_scroll" then
    
    if data == 1 then
      
      LineNum = LineNum + 1
    
    elseif data == -1 then
      
      LineNum = LineNum - 1
    
    end
  
  end
  
  if LineNum == 3 then
    
    LineNum = 1
  
  elseif LineNum == 0 then
    
    LineNum = 2
  
  end  

end

LineNum = 1

term.clear()

term.setCursorPos(1,1)

reqfuel = xs*zs*ys

print("Minimum fuel required: ",reqfuel)

turtle.select(1)

turtle.refuel(10)

fuel = turtle.getFuelLevel()

print("Fuel : ",fuel)

A3 = 0

if reqfuel > 100000 then
  
  print("Sorry but selected size is")
  
  print("too large :)")
  
  sleep(2,5)
  
  print("rebooting...")
  
  sleep(1.5)
  
  os.reboot()

end

if fuel < reqfuel then
 
  A3 = 1

end

while A3 == 1 do
  
  term.clearLine(2)
 
  term.setCursorPos(1,2)
  
  print("Fuel: [",fuel,"/",reqfuel,"]")
  
  print("Place fuel in slot 1")
  
  turtle.select(1)
  
  turtle.refuel(10)
  
  fuel = turtle.getFuelLevel()
 
  if fuel >= reqfuel then
    
    term.clearLine(3)
   
    term.setCursorPos(1,3)
    
    A3 = 0
  
  end

end

term.clearLine(2)

term.clearLine(3)

term.setCursorPos(1,3)

print("X size : ",xs)

print("Y size : ",ys)

print("Z size : ",zs)

write("Use chest : ")

if Chest ==  1 then
  
  print("Yes")


elseif Chest == 0  then
  print("No")

end
print("Mining direction : ",Dir)

print("To start press any botton...")

print("To reboot press Ctrl...")

name,data = os.pullEvent("key")

if name == "key" and data == 29 then
  
  os.reboot()

end

size = xs * zs * ys 

local function monitor()
  
  term.clear()
  
  term.setCursorPos(1,1)
 
  rfuel = turtle.getFuelLevel()
 
  print("Fuel : ",rfuel)
  
  print("Position : "," X: ",xcor," Y: ",ycor," Z: ",zcor)

end


-- Mining section -- 

zcor = 1

completed = 0

finish = 0

A9 = 0 

bd = 0

while finish == 0 do

  monitor()

    if Chest == 1 and turtle.getItemCount(16) > 0 then

      A9 = 1
      xlcor = xcor

      zlcor = zcor

      ylcor = ycor
      if r == 0 then
      
        while xcor > 1 do
        
          if turtle.back() then
          
            xcor = xcor - 1
        
          end
      
        end 
      
        turtle.turnLeft()
      
        while zcor > 1 do        
        
          if turtle.forward() then
          
            zcor = zcor - 1
        
          end
      
        end
      
        while ycor > 1 do
        
          if Dir == "up" then
          
            if turtle.down() then
            
              ycor = ycor - 1
          
            end
        
        elseif Dir == "down" then
          
          if turtle.up() then
            
            ycor = ycor - 1
          
          end
        
        end
      
      end
      
      turtle.turnRight()
    
    end
    if r == 1 then
      
      turtle.turnRight()
      
      while zcor > 1 do
        
        if turtle.forward() then
          
          zcor = zcor - 1
        
        end
      
      end
      
      turtle.turnLeft()
      
      while xcor > 1 do
       
        if  turtle.forward() then
          
          xcor = xcor - 1
        
        end
      
      end
      
      turtle.turnRight()
     
      turtle.turnRight()
      
        while ycor > 1 do
        
          if Dir == "up" then
          
            if turtle.down() then
            
              ycor = ycor - 1
          
            end
        
          elseif Dir == "down" then
          
            if turtle.up() then
            
              ycor = ycor - 1
          
            end
        
          end
      
        end
    
      end
    
      turtle.back()
    
      slotNum = 16
    
      turtle.select(16)
    
      turtle.dropUp()
    
      while slotNum > 1 do
      
        slotNum = slotNum - 1
     
        turtle.select(slotNum)
      
        turtle.dropUp()
    
      end
    
      turtle.forward()
    
      while xcor < xlcor do
     
        turtle.dig()
      
        if turtle.forward() then
       
          xcor = xcor + 1 
      
        end
    
      end
    
      turtle.turnRight()
    
      while zcor < zlcor do 
      
        turtle.dig()
       
        if turtle.forward() then
        
          zcor = zcor + 1
      
        end
    
      end
    
      if r == 0 then
      
        turtle.turnLeft()
    
      elseif r == 1 then
      
        turtle.turnRight()
    
      end
    
      while ycor < ylcor do
      
        if Dir == "up" then
        
          if turtle.up() then
          
            ycor = ycor + 1
        
          end
      
        elseif Dir == "down" then
        
          if turtle.down() then
          
            ycor = ycor + 1
        
          end
      
        end
    
      end
  
    end
  
    turtle.dig()
  
    if ys - yd > 1 and xcor > 0 then
    
      if  Dir == "up" then
      
        turtle.digUp()
    
      elseif Dir == "down" then
      
        turtle.digDown()
    
      end
  
    end
  
    monitor()
  
    if finish == 0 and turtle.forward() then
    
      monitor()
    
      xd = xd + 1
    
      if r == 0 then  
      
        xcor = xcor + 1
    
      elseif r == 1 then
      
        xcor = xcor - 1
    
      end
  
    end
  
    if zd + 1 == zs and xd == xs then
    
      completed = 1
  
    end
  
    if completed == 1 then 
    
      if r == 0 then
      
        turtle.turnLeft()
      
        if ys - yd > 1 then
        
          if Dir == "up" then
          
            turtle.digUp()
        
          elseif Dir == "down" then
          
            turtle.digDown()
        
          end
      
        end
      
        monitor()
      
        while zcor > 1 do
        
            turtle.dig()
        
            if turtle.forward() then
          
              zcor = zcor - 1
        
            end
      
          end
      
          turtle.turnLeft()
      
          while xcor > 1 do
        
            turtle.dig()
        
            if turtle.forward() then
          
              xcor = xcor - 1
        
            end
      
          end
      
          turtle.turnLeft()
     
          turtle.turnLeft()
    
        end     
    
        if r == 1 then
      
          r = 0
      
          if ys - yd > 1 then
        
            if  Dir == "up" then
          
              turtle.digUp()
        
            elseif Dir == "down" then
          
              turtle.digDown()
        
            end
      
          end 
     
          turtle.turnRight()
      
          while zcor > 1 do
        
            if turtle.forward() then
          
              zcor = zcor - 1
        
            end
      
          end
      
          turtle.turnRight()
    
        end       
    
        if ys - yd > 1 then
      
          yd = yd + 2
    
        elseif ys - yd == 1 then
      
          yd = yd + 1
    
        end
  
      end
  
      monitor()
  
      if completed == 1 and yd < ys then
    
        xd = 1 
    
        zd = 0
    
        zcor = 1
    
        xcor = 1
   
        completed = 0
    
        ycor = ycor + 2
    
        A8 = 1
    
        if Dir == "up" then
      
          while A8 == 1 do 
        
            turtle.digUp()
        
            if turtle.up() then
          
              A8 = 0
        
            end
      
          end
      
          A8 = 1
      
          while A8 == 1 do 
        
            turtle.digUp()
        
            if turtle.up() then
          
              A8 = 0 
        
            end
      
          end
    
        elseif Dir == "down" then
      
          while A8 == 1 do
        
            turtle.digDown()
        
            if turtle.down() then
          
              A8 = 0
        
            end
      
          end
      
          A8 = 1
      
          while A8 == 1 do
        
            turtle.digDown()
        
            if turtle.down() then
          
              A8 = 0 
        
            end
      
          end
    
        end
  
      end
  
      monitor()
  
      if completed == 1 and yd == ys then
    
        print("completed!")
    
      while ycor > 1 do
     
        if Dir == "up" then
        
          turtle.digUp()
        
          if turtle.down() then
          
            ycor = ycor - 1
        
          end
      
        elseif Dir == "down" then
        
          turtle.digDown()
       
          if turtle.up() then
          
            ycor = ycor - 1
        
          end
      
        end
    
      end
    
    finish = 1
  
  end
  
  if completed == 0 and xd == xs and r == 0 and zd<zs then
    
    if ys - yd > 1 then 
      
      if Dir == "down" then
        
        turtle.digDown()
      
      elseif Dir == "up" then
        
        turtle.digUp()
      
      end
    
    end
    
    A4 = 1
    
    xd = 1
    
    r = 1
    
    zd = zd + 1
    
    zcor = zcor + 1
    
    turtle.turnRight()
    
    while A4 == 1 do
      
       turtle.dig()
      
       if turtle.forward() then
        
         A4 = 0
      
       end
    
    end
    
    turtle.turnRight()
  
  end
  
  if completed == 0 and xd == xs and r == 1 and zd < zs then
    
    if ys - yd > 1 then  
      
      if Dir == "up" then
        
        turtle.digUp() 
      
      elseif  Dir == "down" then
        
        turtle.digDown() 
      
      end
    
    end
    
    A5 = 1
    
    xd = 1
    
    r = 0
    
    zd = zd + 1
    
    zcor = zcor + 1 
    
    turtle.turnLeft()
    
    while A5 == 1 do
      
      turtle.dig()
      
      if turtle.forward() then
        
        A5 = 0
      
      end
    
    end
    
    turtle.turnLeft()
  
  end
  
  monitor() 

end

monitor()

print("Completed!")
