modem = peripheral.find("modem", rednet.open)
rednet.CHANNEL_BROADCAST = 55859
term.setPaletteColor(colors.magenta,0xa848e8)
local wrap = require "cc.strings".wrap
local inputting = ""
function start(x,y)
    term.setCursorPos(x,y)
    term.setBackgroundColor(colors.purple)
    term.setTextColor(colors.white)
    term.write("TO-DO LIST:")
    return 0
end
local del_pressed=0
local deletenumber=0
local writingtask = false
local line=2
local deleting=false
local adding=false
local lineindex={}
local tasks = {}
for line in io.lines("tasks.txt") do
    if line:sub(1,1)=="1" then
        table.insert(tasks, {isDone=1, tasken=line:sub(3,#line)})
    else
        table.insert(tasks, {isDone=0, tasken=line:sub(3,#line)})
    end
end
function savetofile()
    io.open("tasks.txt","w+")
    io.output("tasks.txt")
    for i,t in pairs(tasks) do
        io.write(tostring(t.isDone).." ".. t.tasken.."\n")
    end
    io.close(tasks.txt)
    return 0
end

function writetasks()
    lineindex={}
    rednet.broadcast(tasks)
        adding=false
        line=2
        for k,v in pairs(tasks) do
            table.insert(lineindex,line,k)
            term.setBackgroundColor(colors.magenta)
            term.setCursorPos(1,line)
            term.clearLine()
            if v.isDone==0 then
                term.setBackgroundColor(colors.white)
            else 
                term.setBackgroundColor(colors.lime)
            end
            term.write(" ")
            term.setBackgroundColor(colors.red)
            term.setCursorPos(26,line)
            term.write("X")
            for i,wers in pairs(wrap(v.tasken,22)) do
                if i>1 then
                    term.setBackgroundColor(colors.magenta)
                    term.setCursorPos(2,line)
                    term.write(string.rep(" ",25))
                    term.setCursorPos(3,line)
                    term.write(wers)
                    line=line+1
                else
                    term.setBackgroundColor(colors.magenta)
                    term.setCursorPos(3,line)
                    term.write(wers)
                    line=line+1
                end
            end
        end
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.black)
    term.setCursorPos(2,line+2)
    term.write(" add ")
    return 0
end

function addtask()
    adding=true
    term.setCursorPos(3,5)
    for i=1,5,1 do
        term.setBackgroundColor(colors.lightGray)
        term.write(string.rep(" ",22))
        term.setCursorPos(3,i+5)
    end
    term.setCursorPos(4,5)
    term.setTextColor(colors.black)
    term.write("Input task name:")
    term.setCursorPos(4,7)
    term.setBackgroundColor(colors.white)
    term.write(string.rep(" ", 20))
    term.setCursorPos(4,9)
    term.setBackgroundColor(colors.red)
    term.write("Cancel")
    term.setCursorPos(17,9)
    term.setBackgroundColor(colors.lime)
    term.write("Confirm")
    return 0
end
function deletetask(tasknumber)
    deleting=true
    deletenumber=tasknumber
    term.setCursorPos(3,5)
    for i=1,5,1 do
        term.setBackgroundColor(colors.lightGray)
        term.write(string.rep(" ",22))
        term.setCursorPos(3,i+5)
    end
    term.setCursorPos(6,6)
    term.setTextColor(colors.black)
    term.write("Delete task #"..tasknumber.."?")
    term.setCursorPos(4,9)
    term.setBackgroundColor(colors.red)
    term.write("Cancel")
    term.setCursorPos(17,9)
    term.setBackgroundColor(colors.lime)
    term.write("Confirm")
    return 0
end
function draw()
    cursorx,cursory=term.getCursorPos()
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.black)
    term.setCursorPos(4,7)
    term.write(string.rep(" ",20))
    term.setCursorPos(4,7)
    term.write(inputting)
    if cursorx~=4+#inputting and del_pressed == 0 then
        term.setCursorPos(cursorx+1,7)
    elseif cursorx~=4+#inputting and del_pressed == 1 then
        term.setCursorPos(cursorx-1,7)
        del_pressed=0
    end
    return 0
end
term.setBackgroundColor(colors.purple)
term.clear()
start(1,1)
writetasks()
while true do
    rednet.broadcast(tasks)
    local event,button,x,y = os.pullEvent("mouse_click")
    for p,c in pairs(lineindex) do
        if adding==false and button==1 and y==p and x==26 then
            deletetask(c)
        end
        if adding==false and deleting==false and button==1 and y==p and x==1 then
            if tasks[c].isDone == 0 then
                tasks[c].isDone = 1
            else 
                tasks[c].isDone = 0
            end
            savetofile()
            term.setBackgroundColor(colors.purple)
            term.clear()
            start(1,1)
            writetasks()
        end
    end
    if deleting==false and adding==false and button==1 and x>= 2 and x<=7 and y == line+2 then
        addtask()
        term.setCursorPos(4+#inputting,7)
        term.setCursorBlink(true)
        writing=true
    end
    if button==1 and adding==false and deleting==true and x<=10 and x>=4 and y==9 then
        deleting=false
        term.setBackgroundColor(colors.purple)
        term.clear()
        start(1,1)
        writetasks()
    end
    if button==1 and adding==false and deleting==true and x<=24 and x>=17 and y==9 then
        deleting=false
        table.remove(tasks,deletenumber)
        savetofile()
        term.setBackgroundColor(colors.purple)
        term.clear()
        start(1,1)
        writetasks()
    end
    if button==1 and deleting==false and adding==true and x<=10 and x>=4 and y==9 then
        term.setBackgroundColor(colors.purple)
        term.clear()
        start(1,1)
        writetasks()
        term.setCursorBlink(false)
        inputting=""
        adding=false
        writing=false
    end
    if button==1 and deleting==false and adding==true and x>=17 and x<=24 and y==9 then
        table.insert(tasks, {isDone=0, tasken=inputting})
        savetofile()
        rednet.broadcast(tasks)
        inputting=""
        term.setBackgroundColor(colors.purple)
        term.clear()
        start(1,1)
        writetasks()
        adding=false
        writing=false
    end
    if button==1 and deleting==false and adding==true and x>=4 and x<=24 and y==7 then
        term.setCursorPos(4+#inputting,7)
        term.setCursorBlink(true)
        writing=true
    end
    while writing==true do
        local e1, p1, x, y = os.pullEvent()
        if e1 == "key" then
            if p1 == keys.backspace then
                cursorx,cursory=term.getCursorPos()
                local CharPosInput = cursorx-4
                if CharPosInput>0 then
                    del_pressed = 1
                    inputting = inputting:sub(1, CharPosInput - 1) .. inputting:sub(CharPosInput + 1)
                    cursorx = cursorx-1
                end
                draw()
            end
            if p1 == keys.left then
                cursorx,cursory = term.getCursorPos()
                if cursorx>=5 then
                    term.setCursorPos(cursorx-1,cursory)
                end
            end
            if p1 == keys.right then
                cursorx,cursory = term.getCursorPos()
                if cursorx<4+#inputting then
                    term.setCursorPos(cursorx+1,cursory)
                end
            end
        elseif e1 == "char" then
            cursorx,cursory = term.getCursorPos()
            inputting=string.sub(inputting,1,cursorx-4)..p1..string.sub(inputting,cursorx-3)
            draw()
        elseif e1=="mouse_click" then
            if x>=5 and x<=24 and y==7 then

            elseif x>=4 and x<=10 and y==9 then
                term.setBackgroundColor(colors.purple)
                term.clear()
                start(1,1)
                writetasks()
                term.setCursorBlink(false)
                inputting=""
                adding=false
                writing=false
            elseif x>=17 and x<=24 and y==9 then
                term.setCursorBlink(false)
                table.insert(tasks, {isDone=0,tasken=inputting})
                savetofile()
                rednet.broadcast(tasks)
                inputting=""
                term.setBackgroundColor(colors.purple)
                term.clear()
                start(1,1)
                writetasks()
                adding=false
                writing=false
            else
                writing=false
                term.setCursorBlink(false)
            end
        end
    end
    os.sleep(0.5)
end
