-- drone program used in building. written by jonathan ortiz
slot=1
choice=3
isFull=false
builder=true
gatherer=false
patternString="Line"
pattern=1
sideLength=0
sideHeight=0
sideWidth=0
builderString="Building"
drawinglength=false
drawingheight=false
drawingwidth=false
running=false
--checks if the turtle has material in any of the first 14 slots (last two slots are for fuel) will place a block below the turtle.--
--It is possible to script a pattern of 14 different stages by placing specific quantities into the turtle in from top left across then down.--
drawWorking=function()
term.setCursorPos(2,3)
term.write(" Currently:")term.write(builderString)term.write(" a ")term.write(patternString)
end
boarder=function()
term.clear()
term.setCursorPos(1,1)
print("===========Turtle Builder==============")
print("|                                                                         |")
print("|                                                                         |")
print("|                                                                         |")
print("|                                                                         |")
print("|                                                                         |")
print("|                                                                         |")
print("|                                                                         |")
print("|                                                                         |")
print("|                                                                         |")
print("|                                                                         |")
print("===========Turtle Builder==============")
end
mainhud=function()
term.setCursorPos(2,3)
term.write(" 1  Build/Break:")
term.setCursorPos(2,4)
term.write(" 2  Gather:")
term.setCursorPos(2,5)
term.write(" 3  Pattern:")
term.setCursorPos(2,6)
term.write(" 4  Run!")
term.setCursorPos(2,7)
term.write(" 5  Exit!")
if pattern>1 then
term.setCursorPos(1,8)
term.write("< 7  > Side Length: ")term.write(tostring(sideLength))
drawinglength=true
else
drawinglength=false
end
if pattern==4 or pattern==2 or pattern==3 then
term.setCursorPos(1,9)
term.write("< 8  > Side Height: ")term.write(tostring(sideHeight))
drawingheight=true
else
drawingheight=false
end
if pattern==1 and not builder then
term.setCursorPos(1,8)
term.write("< 7  > Side Length: ")term.write(tostring(sideLength))
end
if pattern==3 then
term.setCursorPos(1,10)
term.write("< 9  > Side Width: ")term.write(tostring(sideWidth))
drawingwidth=true
else
drawingwidth=false
end
end
drawStatus=function(builder,gatherer,patternString)
term.setCursorPos(18,3)
if builder then
builderString="Building"
else
builderString="Breaking"
end
term.write(builderString)
term.setCursorPos(13,4)
term.write(gatherer)
term.setCursorPos(14,5)
if pattern==1 then patternString="Line"
elseif pattern==2 then patternString="Square"
elseif pattern==3 then patternString="Floor"
elseif pattern==4 then patternString="Wall"
end
term.write(patternString)
end
drawChoice=function(choiceNum)
term.setCursorPos(2,choiceNum)
term.write("[")
term.setCursorPos(4,choiceNum)
term.write("]")
end
place=function()
counted=turtle.getItemCount(slot)
turtle.select(slot)
if counted<1 then
  empty=true
end

while empty do
  slot=slot+1
  if slot>14 then
   error("out of blocks")
  end

turtle.select(slot)
counted=turtle.getItemCount(slot)

  if counted>0 then
   empty=false
  end

  term.write("still empty")

end

turtle.placeDown()
end
--IMPORTANT! when a turtle is being used to collect blocks with this program the first slot must remain open as a buffer for new items coming in--
sort=function()
for i=2,14,1 do
  turtle.select(1)
  sames=turtle.compareTo(i)
  if sames then
   turtle.select(1)
   turtle.transferTo(i)
  end
end
  if turtle.getItemCount(1)>0 then
   for j=2,14,1 do
        empty=turtle.getItemCount(j)
        if empty==0 and turtle.getItemCount(1)>0 then
         turtle.select(1)
         turtle.transferTo(j)
        end
   end
   if turtle.getItemCount(1)>0 then
        isFull=true
        return
   end
  end
end
--takes up blocks around the turtle making use of the sort function to store them--
gather=function()
turtle.drop()
end
--Breaks the block below the turtle and gathers it optionaly. depends on boolean 'shouldGather'--
dig=function()
turtle.digDown()
if not gatherer==true then
gather()
end
end
digFront=function()
turtle.dig()
if gatherer==true then
--gather()
end
end
--breaks the block in front of the turtle and gathers it optionally. depends on the boolean 'shouldGather'--
--will check for fuel and the need for it then take the appropriate action.--
fuel=function()
fuelSlot=15
hasFuel=turtle.getFuelLevel()
if hasFuel<2 then
  turtle.select(fuelSlot)
  counted=turtle.getItemCount(fuelSlot)
  if counted>0 then
   turtle.refuel(1)
  else
   fuelSlot=fuelSlot+1
   turtle.select(fuelSlot)
   counted=turtle.getItemCount(fuelSlot)
   if counted>0 then
        turtle.refuel(1)
   end
  end
  hasFuel=turtle.getFuelLevel()
  if hasFuel<2 then
   error("Out of Fuel")
  end
  term.write("fuel complete")
end
end
-- will place blocks in a line untill the turtle discovers an obstruction.--
-- It is possible to controll the length of the line without an obstruction by limiting the building materials located in the first 14 slots of the turtle.--
bLine=function()
runsline=true
term.clear()
boarder()
term.setCursorPos(2,3)
term.write("Starting")

while runsline do
  if turtle.getFuelLevel()<2 then
   fuel()
   end

  isBlocked=turtle.detect()
  hasPlaced=turtle.detectDown()

   if hasPlaced and isBlocked then
        term.write("Operation Stopped due to obstruction")
        runsline=false
   elseif isBlocked and not hasPlaced then
        place()
        runsline=false
   elseif not isBlocked and not hasPlaced then
        place()
   end
   turtle.forward()
end
term.write("Finshed")
end
brLine=function(sideLength)
term.clear()
boarder()
term.setCursorPos(2,3)
term.write("Starting")
   for i=0,sideLength,1 do
   if turtle.getFuelLevel()<2 then
   fuel()
   end
   turtle.dig()
   if gatherer==true then
   term.write("stupid gatherer")
   --gather()
   end
   turtle.forward()
   end
end
bSquare=function(sideLength,sideHeight)
term.clear()
boarder()
term.setCursorPos(2,3)
term.write("Starting")
building=true
while building do
  place()
  for i=1,sideHeight do
   for j=2,sideLength do
        if turtle.getFuelLevel()<2 then
        fuel()
        end
        place()
        isBlocked=turtle.detect()
        if isBlocked then
         error("path blocked")
        else
         turtle.forward()
        end
   end
   turtle.turnRight()
   for j=2,sideLength do
        if turtle.getFuelLevel()<2 then
        fuel()
        end
        place()
        isBlocked=turtle.detect()
        if isBlocked then
         error("path blocked")
        else
         turtle.forward()
        end
   end
   turtle.turnRight()
   for j=2,sideLength do
        if turtle.getFuelLevel()<2 then
        fuel()
        end
        place()
        isBlocked=turtle.detect()
        if isBlocked then
         error("path blocked")
        else
         turtle.forward()
        end
   end
   turtle.turnRight()
   for j=3,sideLength do
        if turtle.getFuelLevel()<2 then
        fuel()
        end
        place()
        isBlocked=turtle.detect()
        if isBlocked then
         error("path blocked")
        else
         turtle.forward()
        end
   end
   place()
   turtle.up()
   isBlocked=turtle.detect()
        if isBlocked then
         error("path blocked")
        else
         turtle.forward()
        end
        place()
        turtle.turnRight()
   end
end
running=false
end
brSquare=function(sideLength,sideHeight)
term.clear()
boarder()
term.setCursorPos(2,3)
term.write("Starting")
building=true
while building do
  dig()
  for i=1,sideHeight do
   for j=2,sideLength do
        if turtle.getFuelLevel()<2 then
        fuel()
        end
        dig()
        isBlocked=turtle.detect()
        if isBlocked then
         error("path blocked")
        else
         turtle.forward()
        end
   end
   turtle.turnRight()
   for j=2,sideLength do
        if turtle.getFuelLevel()<2 then
        fuel()
        end
        dig()
        isBlocked=turtle.detect()
        if isBlocked then
         error("path blocked")
        else
         turtle.forward()
        end
   end
   turtle.turnRight()
   for j=2,sideLength do
        if turtle.getFuelLevel()<2 then
        fuel()
        end
        dig()
        isBlocked=turtle.detect()
        if isBlocked then
         error("path blocked")
        else
         turtle.forward()
        end
   end
   turtle.turnRight()
   for j=3,sideLength do
        if turtle.getFuelLevel()<2 then
        fuel()
        end
        dig()
        isBlocked=turtle.detect()
        if isBlocked then
         error("path blocked")
        else
         turtle.forward()
        end
   end
   dig()
   turtle.down()
   isBlocked=turtle.detect()
        if isBlocked then
         error("path blocked")
        else
         turtle.forward()
        end
        dig()
        turtle.turnRight()
   end
   building=false
end
running=false
end
bFloor=function(sideLength,sideWidth,sideHeight)
term.clear()
boarder()
term.setCursorPos(2,3)
term.write("Starting")
building=true
turnRight=true
while building do
for i=1,sideHeight,1 do
  for i=1,sideWidth,1 do
   for i=2,sideLength,1 do
   --walking forward placing blocks
   if turtle.getFuelLevel()<2 then
   fuel()
   end
   place()
   isBlocked=turtle.detect()
        if isBlocked then
         error("path blocked")
        else
         turtle.forward()
        end
                        place()  
   end
   --decides to zig or zag then does it placing it facing back the opposite way over an empty space
   if turnRight then
   turtle.turnRight()
   isBlocked=turtle.detect()
         if isBlocked then
          error("path blocked")
         else
          turtle.forward()
          end
   turtle.turnRight()
   end
   if not turnRight then
        turtle.turnLeft()
        isBlocked=turtle.detect()
         if isBlocked then
          error("path blocked")
         else
          turtle.forward()
         end
          turtle.turnLeft()
         end
        turnRight= not turnRight
   end
   --moves turtle up then checks to see if it just went left or right
   turtle.up()
   if not turnRight then
   --if the turtle just went right then it should
        turtle.turnRight()
        isBlocked=turtle.detect()
         if isBlocked then
          error("path blocked")
         else
          turtle.forward()
          end
          turtle.turnLeft()
          end
   if turnRight then
         turtle.turnLeft()
         isBlocked=turtle.detect()
         if isBlocked then
          error("path blocked")
         else
          turtle.forward()
          end
          turtle.turnRight()
          end
          turnRight=not turnRight
  end
  building=false
end
end
brFloor=function()
term.clear()
boarder()
term.setCursorPos(2,3)
term.write("Starting")
building=true
turnRight=true
while building do
for i=1,sideHeight,1 do
  for j=1,sideWidth,1 do
   for i=2,sideLength,1 do
   --walking forward placing blocks
   if turtle.getFuelLevel()<2 then
   fuel()
   end
   dig()
   isBlocked=turtle.detect()
        if isBlocked and i<sideLength then
         digFront()
          turtle.forward()
        else
         turtle.forward()
        end
                        dig()
   end
   --decides to zig or zag then does it placing it facing back the opposite way over an empty space
   if turnRight and j<sideWidth then
   turtle.turnRight()
   isBlocked=turtle.detect()
         if isBlocked then
          dig()
          turtle.forward()
         else
          turtle.forward()
          end
   turtle.turnRight()
   end
   if not turnRight and j<sideWidth then
        turtle.turnLeft()
        isBlocked=turtle.detect()
         if isBlocked then
          dig()
          turtle.forward()
         else
          turtle.forward()
         end
          turtle.turnLeft()
         end
        turnRight= not turnRight
   end
  --after completing a whole floor turtle turns about and descends and contunues on.
  turtle.turnRight()
  turtle.turnRight()
  turtle.down()
  turnRight=not turnRight
   end
  building=false
end
end
bWall=function(sideLength,sideHeight)
term.clear()
boarder()
term.setCursorPos(2,3)
term.write("Starting")
for i=1,sideHeight,1 do
  for j=2,sideLength,1 do
  if turtle.getFuelLevel()<2 then
   fuel()
   end
   place()
   isBlocked=turtle.detect()
        if isBlocked and i<sideLength then
         digFront()
          turtle.forward()
        else
         turtle.forward()
        end
                        place()
  end
  turtle.turnRight()
  turtle.turnRight()
  turtle.up()
end
end
brWall=function()
term.clear()
boarder()
term.setCursorPos(2,3)
term.write("Starting")
for i=1,sideHeight,1 do
  for j=2,sideLength,1 do
  if turtle.getFuelLevel()<2 then
   fuel()
   end
   dig()
   isBlocked=turtle.detect()
        if isBlocked and i<sideLength then
         digFront()
          turtle.forward()
        else
         turtle.forward()
        end
                        dig()
  end
  turtle.turnRight()
  turtle.turnRight()
  turtle.down()
end
end
while true do
boarder()
mainhud()
drawStatus(builder,gatherer,patternString)
drawChoice(choice)
event,param1=os.pullEvent("key")
if event== "key" and param1==200 then
choice = choice-1
  if choice<3 and drawingwidth then
   choice=10
  end
  if choice<3 and drawingheight and not drawingwidth then
  choice=9
  end
  if choice<3 and drawinglength and not drawingheight then
  choice=8
  end
  if choice<3 and not drawinglength then
  choice=7
  end
        end
if event== "key" and param1==208 then
choice=choice+1
  if choice>10 then
   choice=3
   end
   if choice>7 and not drawinglength and not drawingwidth then
   choice=3
   end
   if choice>8 and not drawingheight then
   choice=3
   end
   if choice>9 and not drawingwidth then
   choice=3
   end
   end
if event== "key" and param1==28 then
  if choice==3 then
   builder=not builder
   end
  if choice==4 then
  gatherer= not gatherer
  end
  if choice==5 then
  pattern=pattern+1
   if pattern>4 then
   pattern=1
   end
  end
  if choice==6 and param1==28 then
  running=true
  --primary loop when all choices have been made--
   while running do
   --line order--
        if pattern==1 then
         if builder and running then
         bLine()
         elseif not builder then
         brLine(sideLength)
         end
   --square order--
        elseif pattern==2 then
        if builder then
        bSquare(sideLength,sideHeight)
        end
        if not builder then
        brSquare(sideLength,sideHeight)
        end
   --floor order--
        elseif pattern==3 then
        if builder then
        bFloor(sideLength,sideWidth,sideHeight)
        end
        if not builder then
        brFloor(sideLength,sideWidth,sideHeight)
        end
   --wall order--
        elseif pattern==4 then
        if builder then
        bWall(sideLength,sideHeight)
        end
        if not builder then
        brWall(sideLength,sideHeight)
        end
        end
        term.setCursorPos(2,6)
        term.write("Operation Finished")
        os.sleep(1)
        running=false  
   end
  --end of the main loop area--
  end
  if choice==7 then
  term.clear()
   error("thank you for using Turtle Builder!")
  end

  end
if event== "key" and param1==205 and choice==8 then
  sideLength=sideLength+1
  end
if event== "key" and param1==203 and choice==8 then
  sideLength=sideLength-1
  if sideLength<=0 then
  sideLength=0
  end
end
if event== "key" and param1==205 and choice==9 then
  sideHeight=sideHeight+1
  end
if event== "key" and param1==203 and choice==9 then
  sideHeight=sideHeight-1
  if sideHeight<=0 then
  sideHeight=0
  end
  end
if event== "key" and param1==205 and choice==10 then
  sideWidth=sideWidth+1
  end
if event== "key" and param1==203 and choice==10 then
  sideWidth=sideWidth-1
  if sideWidth<=0 then
  sideWidth=0
  end
end
end
