termx,termy = term.getSize()
term.clear()
wrap = require "cc.strings".wrap
if fs.exists("config.txt") then

else
  fs.open("config.txt","r+")
end
configScreen = 0
function portWriting()
    local e1, p1, x, y = os.pullEvent()
      if e1 == "key" then
          if p1 == keys.backspace then
              CurX,CurY=term.getCursorPos()
              local CharPosInput = CurX-1
              if CharPosInput>0 then
                  del_pressed = 1
                  port = port:sub(1, CharPosInput - 1) .. port:sub(CharPosInput + 1)
                  CurX = CurX-1
              end
              draw()
          elseif p1 == keys.left then
              CurX,CurY = term.getCursorPos()
              if CurX>=5 then
                  term.setCursorPos(CurX-1,CurY)
              end
          elseif p1 == keys.right then
              CurX,CurY = term.getCursorPos()
              if CurX<4+#port then
                  term.setCursorPos(CurX+1,CurY)
              end
          end
      elseif e1 == "char" then
          CurX,CurY = term.getCursorPos()
          port=string.sub(port,1,CurX-4)..p1..string.sub(port,CurX-3)
          draw()
      elseif e1=="mouse_click" then
          if x>=termx-8 and x<=termx-1 and y==termy-1 then
            configScreen=1
          else
              writingMode = false
          end
      end
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
  CurX,CurY=term.getCursorPos()
  term.setCursorPos(2,CurY+2)
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
  if writingMode==true then
    portWriting()
  end
end
