
modem = peripheral.find("modem", rednet.open)
monitor = peripheral.find("monitor")
rednet.CHANNEL_BROADCAST = 55859
monitor.setPaletteColor(colors.magenta,0xa848e8)
local wrap = require "cc.strings".wrap
function start()
    monitor.setCursorPos(2,1)
    monitor.setBackgroundColor(colors.purple)
    monitor.setTextColor(colors.white)
    monitor.write("TO-DO LIST:")
    return 0
end
local monitorW,monitorH = monitor.getSize()
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
function broadcastTasks()
    local serialized = textutils.serialize(tasks)
    rednet.broadcast(serialized, "todolist_sync")
end

function receiveUpdates()
    while true do
        local senderId, message, protocol = rednet.receive("todolist_sync")
        if senderId ~= os.getComputerID() then
            local data = textutils.unserialize(message)
            if data then
                tasks = data
                term.setBackgroundColor(colors.purple)
                start()
                writetasks()
            end
        end
    end
end
function writetasks()
    lineindex={}
        line=2
        for k,v in pairs(tasks) do
            table.insert(lineindex,line,k)
            monitor.setBackgroundColor(colors.magenta)
            monitor.setCursorPos(2,line)
            monitor.clearLine()
            monitor.setBackgroundColor(colors.purple)
            monitor.setCursorPos(1,line)
            monitor.write(" ")
            if v.isDone==0 then
                bg=(colors.white)
                fg=(colors.black)
            else 
                bg=(colors.lime)
                fg=(colors.white)
            end
            monitor.setTextColor(fg)
            monitor.setBackgroundColor(bg)
            monitor.write("\x88")
            monitor.setBackgroundColor(colors.magenta)
            monitor.setTextColor(bg)
            monitor.write("\x95")
            monitor.setBackgroundColor(colors.red)
            monitor.setCursorPos(monitorW,line)
            monitor.setTextColor(colors.white)
            monitor.write("X")
            monitor.setTextColor(bg)
            for i,wers in pairs(wrap(v.tasken,monitorW-4)) do
                if i>1 then
                    monitor.setBackgroundColor(colors.magenta)
                    monitor.setCursorPos(4,line)
                    monitor.write(string.rep(" ",monitorW-1))
                    monitor.setCursorPos(4,line)
                    monitor.write(wers)
                    line=line+1
                else
                    monitor.setBackgroundColor(colors.magenta)
                    monitor.setCursorPos(4,line)
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
start()
writetasks()
function main()
    while true do
        local event,side,x,y = os.pullEvent("monitor_touch")
        for p,c in pairs(lineindex) do
            if y==p and x==monitorW then
                deletetask(c)
            elseif deleting==false and y==p and x>=2 and x<=monitorW-1 then
                if tasks[c].isDone == 0 then
                    tasks[c].isDone = 1
                else 
                    tasks[c].isDone = 0
                end
                savetofile()
                broadcastTasks()
                monitor.setBackgroundColor(colors.purple)
                monitor.clear()
                start()
                writetasks()
            end
        end
        if deleting==true and x<=10 and x>=4 and y==9 then
            deleting=false
            monitor.setBackgroundColor(colors.purple)
            monitor.clear()
            start()
            writetasks()
        elseif deleting==true and x<=24 and x>=17 and y==9 then
            deleting=false
            table.remove(tasks,deletenumber)
            savetofile()
            broadcastTasks()
            monitor.setBackgroundColor(colors.purple)
            monitor.clear()
            start()
            writetasks()
        end
        os.sleep(0.1)
    end
end

parallel.waitForAny(receiveUpdates,main)
