
modem = peripheral.find("modem", rednet.open)
monitor = peripheral.find("monitor")
rednet.CHANNEL_BROADCAST = 55859
monitor.setPaletteColor(colors.magenta,0xa848e8)
local wrap = require "cc.strings".wrap
function start(x,y)
    monitor.setCursorPos(x,y)
    monitor.setBackgroundColor(colors.purple)
    monitor.setTextColor(colors.white)
    monitor.write("TO-DO LIST:")
    return 0
end
local deletenumber=0
local line=2
local deleting=false
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
    id,tasks = rednet.receive()
        line=2
        for k,v in pairs(tasks) do
            table.insert(lineindex,line,k)
            monitor.setBackgroundColor(colors.magenta)
            monitor.setCursorPos(1,line)
            monitor.clearLine()
            if v.isDone==0 then
                monitor.setBackgroundColor(colors.white)
            else 
                monitor.setBackgroundColor(colors.lime)
            end
            monitor.write("\x88")
            monitor.setBackgroundColor(colors.red)
            monitor.setCursorPos(26,line)
            monitor.write("X")
            for i,wers in pairs(wrap(v.tasken,22)) do
                if i>1 then
                    monitor.setBackgroundColor(colors.magenta)
                    monitor.setCursorPos(2,line)
                    monitor.write(string.rep(" ",25))
                    monitor.setCursorPos(3,line)
                    monitor.write(wers)
                    line=line+1
                else
                    monitor.setBackgroundColor(colors.magenta)
                    monitor.setCursorPos(3,line)
                    monitor.write(wers)
                    line=line+1
                end
            end
        end
    return 0
end

function deletetask(tasknumber)
    deleting=true
    deletenumber=tasknumber
    monitor.setCursorPos(3,5)
    for i=1,5,1 do
        monitor.setBackgroundColor(colors.lightGray)
        monitor.write(string.rep(" ",22))
        monitor.setCursorPos(3,i+5)
    end
    monitor.setCursorPos(6,6)
    monitor.setTextColor(colors.black)
    monitor.write("Delete task #"..tasknumber.."?")
    monitor.setCursorPos(4,9)
    monitor.setBackgroundColor(colors.red)
    monitor.write("Cancel")
    monitor.setCursorPos(17,9)
    monitor.setBackgroundColor(colors.lime)
    monitor.write("Confirm")
    return 0
end

monitor.setBackgroundColor(colors.purple)
monitor.clear()
start(1,1)
writetasks()
while true do
    id,tasks = rednet.receive()
    rednet.broadcast(tasks)
    local event,button,x,y = os.pullEvent("mouse_click")
    for p,c in pairs(lineindex) do
        if button==1 and y==p and x==26 then
            deletetask(c)
        end
        if deleting==false and button==1 and y==p and x==1 then
            if tasks[c].isDone == 0 then
                tasks[c].isDone = 1
            else 
                tasks[c].isDone = 0
            end
            savetofile()
            monitor.setBackgroundColor(colors.purple)
            monitor.clear()
            start(1,1)
            writetasks()
            rednet.broadcast(tasks)
        end
    end
    if button==1 and deleting==true and x<=10 and x>=4 and y==9 then
        deleting=false
        monitor.setBackgroundColor(colors.purple)
        monitor.clear()
        start(1,1)
        writetasks()
    end
    if button==1 and deleting==true and x<=24 and x>=17 and y==9 then
        deleting=false
        table.remove(tasks,deletenumber)
        savetofile()
        monitor.setBackgroundColor(colors.purple)
        monitor.clear()
        start(1,1)
        writetasks()
    end
    os.sleep(0.5)
end
