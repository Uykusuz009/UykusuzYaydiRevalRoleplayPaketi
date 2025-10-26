local hostname = "localhost"
local username = "root"
local password = "revalmta31."
local database = "reval"
local port = 3306

local connection = nil

addEventHandler("onResourceStart", resourceRoot, function()
    connection = dbConnect("mysql", "dbname=" .. database .. ";host=" .. hostname, username, password, "autoreconnect=1")
    if connection then
        outputDebugString("[MySQL] Successfully connected to database.")
    else
        outputDebugString("[MySQL] Failed to connect to database.")
    end
end)

function getConnection()
    return connection
end