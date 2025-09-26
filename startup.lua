if fs.exists("config.json") then
    local configFile = fs.open("config.json", "r")
    local configFromFile = configFile.readAll()
    configFile.close()

    if contentOfFile~="" then
        if fs.exists("monitor.lua") then
            shell.run("monitor.lua")
        else 
            shell.run("pocketpc.lua")
        end
    end
else
    shell.run("configure.lua")
end
