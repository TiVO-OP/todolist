termx,termy = term.getSize()
term.clear()
wrap = require "cc.strings".wrap
if fs.exists("config.json") then
  configFile = fs.open("config.json","r")
  contentOfFile = configFile.readAll()
  configFile.close()
  configFromFile = textutils.unserializeJSON(contentOfFile)
  port = configFromFile["port"]
else
  configFile = fs.open("config.json","w")
  configFile.close()
  port = ""
end
configScreenDesc = {Network=0,Port=1,Color=2,Overview=3}
currentConfigScreen = configScreenDesc.Network
isPortChecked,isNetworked,writingMode=false,false,false

function nextBackButtons()
  term.setBackgroundColor(colors.white)
  term.setTextColor(colors.black)
  term.setCursorPos(termx-6,termy-1)
  term.write("Next \x1A")
  term.setCursorPos(2,termy-1)
  term.write("\x1B Back")
end

function portWriting()
  term.setCursorBlink(true)
  while writingMode==true do
    local e1, p1, x, y = os.pullEvent()
    if e1 == "char" then
      if p1:match("%d") then
        CurX,CurY = term.getCursorPos()
        if #port<=4 then
          port=string.sub(port,1,CurX-2)..p1..string.sub(port,CurX-1)
        end
        term.setCursorPos(CurX+1,CurY)
        drawPort()
      end
    elseif e1 == "key" then
      if p1 == keys.backspace then
        CurX,CurY=term.getCursorPos()
        local CharPosInput = CurX-2
        if CharPosInput>0 then
          port = port:sub(1, CharPosInput - 1) .. port:sub(CharPosInput + 1)
          term.setCursorPos(CurX-1,CurY)
        end
        drawPort()
      elseif p1 == keys.left then
        CurX,CurY = term.getCursorPos()
        if CurX>2 then
          term.setCursorPos(CurX-1,inputY)
        end
      elseif p1 == keys.right then
        CurX,CurY = term.getCursorPos()
        if CurX<2+#port then
          term.setCursorPos(CurX+1,inputY)
        end
      end
    elseif e1=="mouse_click" then
      if x>=2 and x<=8 and y==inputY then
        drawPort()
      else
        writingMode = false
        term.setCursorBlink(false)
      end
    end
  end
end

function drawPort()
    CurX,CurY=term.getCursorPos()
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.black)
    term.setCursorPos(2,inputY)
    term.write(string.rep(" ",7))
    term.setCursorPos(2,inputY)
    term.write(port)
    maxCursorX = math.min(2+#port,8)
    CursorX = math.max(2, math.min(CurX,maxCursorX))
    term.setCursorPos(CursorX,inputY)
end

function portConfig()
  inputY=2
  term.setBackgroundColor(colors.lightGray)
  term.clear()
  term.setCursorPos(math.floor(termx/2)-7,1)
  term.setBackgroundColor(colors.gray)
  term.clearLine()
  term.setTextColor(colors.white)
  term.write("Port Selection")
  term.setBackgroundColor(colors.lightGray)
  term.setCursorPos(2,2)
  term.setTextColor(colors.gray)
  for l,t in pairs(wrap("Enter the port number here. It will be used to connect to the other computer, so make sure you use the same number on both.\nThe number must be between 0 and 65535.",termx-2)) do
    inputY=inputY+1
    CurX,CurY=term.getCursorPos()
    term.setCursorPos(2,CurY+1)
    term.write(t)
  end
  inputY=inputY+2
  CurX,CurY=term.getCursorPos()
  term.setCursorPos(2,inputY)
  term.setBackgroundColor(colors.white)
  term.write(string.rep(" ",7))
  nextBackButtons()
end

function networkingConfig()
  term.setBackgroundColor(colors.lightGray)
  term.clear()
  term.setCursorPos(1,1)
  term.setBackgroundColor(colors.gray)
  term.clearLine()
  term.setTextColor(colors.white)
  term.setCursorPos(math.floor(termx/2)-7,1)
  term.write("Network Config")
  term.setBackgroundColor(colors.lightGray)
  term.setTextColor(colors.gray)
  term.setCursorPos(2,2)
  for l,t in pairs(wrap("Is the device networked? Keep the box unchecked if you are going to use this as a standalone device.",termx-2)) do
    CurX,CurY=term.getCursorPos()
    term.setCursorPos(2,CurY+1)
    term.write(t)
  end
  CurX,CurY=term.getCursorPos()
  nextBackButtons()
  term.setCursorPos(2,termy-1)
  term.setBackgroundColor(colors.lightGray)
  term.write(string.rep(" ",8))
end

while true do
  if currentConfigScreen==configScreenDesc.Network then
    networkingConfig()
    if isNetworked==false then
      term.setCursorPos(2,CurY+3)
      term.setTextColor(colors.lightGray)
      term.setBackgroundColor(colors.black)
      term.write("\x88")
      term.setBackgroundColor(colors.lightGray)
      term.setTextColor(colors.black)
      term.write("\x95")
      term.setTextColor(colors.black)
      term.write("Networked")
    else
      term.setCursorPos(2,CurY+3)
      term.setTextColor(colors.black)
      term.setBackgroundColor(colors.lime)
      term.write("\x88")
      term.setBackgroundColor(colors.lightGray)
      term.setTextColor(colors.lime)
      term.write("\x95")
      term.setTextColor(colors.black)
      term.write("Networked")
    end
  end
  local event,mouseButton,mouseX,mouseY = os.pullEvent("mouse_click")
  if mouseX>=termx-6 and mouseX<=termx-1 and mouseY==termy-1 then
    currentConfigScreen=currentConfigScreen+1
    isPortChecked=false
  elseif mouseX>=2 and mouseX<=8 and mouseY==termy-1 then
    currentConfigScreen=currentConfigScreen-1
    isPortChecked=false
  end
  if currentConfigScreen==configScreenDesc.Network and mouseX>=2 and mouseX<=3 and mouseY==CurY+3 then
    isNetworked=not isNetworked
  end
  if currentConfigScreen==configScreenDesc.Color then
    term.setBackgroundColor(colors.lightGray)
    term.setTextColor(colors.gray)
    term.setCursorPos(1,6)
    term.clear()
    term.write("TEMP")
  end

  if currentConfigScreen==configScreenDesc.Port then
    portConfig()
  end

  if currentConfigScreen==configScreenDesc.Port and isPortChecked==false then
    drawPort()
    term.setCursorPos(#port+2,inputY)
    isPortChecked=true
  end

  if currentConfigScreen==configScreenDesc.Port and mouseX>=2 and mouseX<=8 and mouseY==inputY then
    drawPort()
    writingMode=true
    term.setTextColor(colors.black)
    term.setBackgroundColor(colors.white)
    term.setCursorPos(#port+2,inputY)
  elseif currentConfigScreen==configScreenDesc.Port and (mouseButton==1 or mouseButton==2 or mouseButton==3) then
    drawPort()
  end
  
  while writingMode==true and currentConfigScreen==configScreenDesc.Port do
    portWriting()
    os.sleep(0.00001)
  end
  
  os.sleep(0.00001)
end
