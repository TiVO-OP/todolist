termx,termy=term.getSize()
deviceSet=0
tasks = fs.open("tasks.txt","w")
tasks.close()


function mainScreen()
  term.setBackgroundColor(colors.lightGray)
  term.clear()
  term.setCursorPos(math.floor(termx/2)-9,1)
  term.setTextColor(colors.white)
  term.setBackgroundColor(colors.gray)
  term.clearLine()
  term.write("To-Do List Installer")
  term.setBackgroundColor(colors.lightGray)
  term.setCursorPos(math.floor(termx/2)-8,3)
  term.setTextColor(colors.black)
  term.write("Select the device:")
  term.setCursorPos(2,6)
  term.setTextColor(colors.lightGray)
  term.setBackgroundColor(colors.black)
  term.write("\x88")
  term.setBackgroundColor(colors.lightGray)
  term.setTextColor(colors.black)
  term.write("\x95")
  term.setBackgroundColor(colors.lightGray)
  term.setTextColor(colors.white)
  term.write("Pocket computer")
  term.setCursorPos(2,9)
  term.setTextColor(colors.lightGray)
  term.setBackgroundColor(colors.black)
  term.write("\x88")
  term.setBackgroundColor(colors.lightGray)
  term.setTextColor(colors.black)
  term.write("\x95")
  term.setBackgroundColor(colors.lightGray)
  term.setTextColor(colors.white)
  term.write("Computer with monitors")
  term.setCursorPos(math.floor(termx/2)-7,12)
  term.setBackgroundColor(colors.lime)
  term.setTextColor(colors.black)
  CurX,CurY=term.getCursorPos()
  for i=1,3,1 do
    term.setCursorPos(CurX,CurY)
    term.write(string.rep(" ",15))
    CurY=CurY+1
  end
  term.setCursorPos(math.floor(termx/2)-3,13)
  term.write("Install")
end

function install()
  term.blit("[INSTALL] configurator","0555555500000000000000","ffffffffffffffffffffff")
  shell.run("wget https://raw.githubusercontent.com/TiVO-OP/todolist/refs/heads/main/configure.lua")
  term.setCursorPos(1,2)
  if deviceSet==1 then
     term.blit("[INSTALL] pocketpc","055555550000000000","ffffffffffffffffff")
    shell.run("wget https://raw.githubusercontent.com/TiVO-OP/todolist/refs/heads/main/pocketpc.lua")
  elseif deviceSet==2 then
    term.blit("[INSTALL] monitor","05555555000000000","fffffffffffffffff")
    shell.run("wget https://raw.githubusercontent.com/TiVO-OP/todolist/refs/heads/main/monitor.lua")
  end
  term.setCursorPos(1,3)
  term.blit("[INSTALL] startup","05555555000000000","fffffffffffffffff")
  os.sleep(1)
end

mainScreen()
while true do
  local event,mouseButton,mouseX,mouseY=os.pullEvent("mouse_click")
  term.setCursorPos(1,1)
  if mouseX>=2 and mouseX<=17 and mouseY==6 then
    deviceSet=1
  elseif mouseX>=2 and mouseX<=17 and mouseY==9 then
    deviceSet=2
  elseif mouseX>=math.floor(termx/2)-7 and mouseX<=math.floor(termx/2)+8 and mouseY>=12 and mouseY<=14 then
    if deviceSet==1 or deviceSet==2 then
      term.setCursorPos(1,1)
      term.setBackgroundColor(colors.black)
      term.setTextColor(colors.white)
      term.clear()
      install()
      shell.run("configure.lua")
      break
    else
      term.setBackgroundColor(colors.lightGray)
      term.setCursorPos(1,4)
      term.setTextColor(colors.red)
      term.write("Error: No device selected!")
    end
  end

  if deviceSet==1 then
    term.setCursorPos(2,6)
    term.setTextColor(colors.black)
    term.setBackgroundColor(colors.white)
    term.write("\x88")
    term.setBackgroundColor(colors.lightGray)
    term.setTextColor(colors.white)
    term.write("\x95")
    term.setCursorPos(2,9)
    term.setTextColor(colors.lightGray)
    term.setBackgroundColor(colors.black)
    term.write("\x88")
    term.setBackgroundColor(colors.lightGray)
    term.setTextColor(colors.black)
    term.write("\x95")
  elseif deviceSet==2 then
    term.setCursorPos(2,9)
    term.setTextColor(colors.black)
    term.setBackgroundColor(colors.white)
    term.write("\x88")
    term.setBackgroundColor(colors.lightGray)
    term.setTextColor(colors.white)
    term.write("\x95")
    term.setCursorPos(2,6)
    term.setTextColor(colors.lightGray)
    term.setBackgroundColor(colors.black)
    term.write("\x88")
    term.setBackgroundColor(colors.lightGray)
    term.setTextColor(colors.black)
    term.write("\x95")
  end
end
