termx,termy = term.getSize()
term.clear()
wrap = require "cc.strings".wrap
if fs.exists("config.txt") then
  port=""
else
  fs.open("config.txt","w")
  port = ""
end
configScreen = 0
function portWriting()
  term.setCursorBlink(true)
  local e1, p1, x, y = os.pullEvent()
    if e1 == "key" then
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
        elseif p1 == keys.space then
          CurX,CurY = term.getCursorPos()
          port=string.sub(port,1,CurX-2).." "..string.sub(port,CurX-1)
          term.setCursorPos(CurX+1,CurY)
          drawPort()
        end
    elseif e1 == "char" then
      if p1:match("%d") then
        CurX,CurY = term.getCursorPos()
        port=string.sub(port,1,CurX-2)..p1..string.sub(port,CurX-1)
        term.setCursorPos(CurX+1,CurY)
        drawPort()
      end
    elseif e1=="mouse_click" then
        if x>=termx-8 and x<=termx-1 and y==termy-1 then
          writingMode = false
          term.setCursorBlink(false)
          configScreen=1
        elseif x>=2 and x<=8 and y==inputY then

        else
            writingMode = false
            term.setCursorBlink(false)
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
  term.write("Port Selection")
  term.setBackgroundColor(colors.lightGray)
  term.setCursorPos(2,2)
  term.setTextColor(colors.gray)
  for l,t in pairs(wrap("Enter the port number here. It will be used to connect to the other computer, so make sure you use the same number on both.\nThe number must be between 0 and 65535.",termx-1)) do
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
  term.setBackgroundColor(colors.lime)
  term.setCursorPos(termx-8,termy-1)
  term.write("Confirm")

end


if configScreen==0 then
  portConfig()
elseif configScreen==1 then
  term.clear()
  term.write("Config Screen 1")
end
while true do
  local event,mouseButton,mouseX,mouseY = os.pullEvent("mouse_click")
  if mouseX>=2 and mouseX<=8 and mouseY==inputY then
    writingMode=true
    term.setTextColor(colors.black)
    term.setBackgroundColor(colors.white)
    term.setCursorPos(2,inputY)
  end
  while writingMode==true and configScreen==0 do
    portWriting()
  end
  if configScreen==1 then
    term.clear()
    term.write("Config Screen 1")
  end
end
