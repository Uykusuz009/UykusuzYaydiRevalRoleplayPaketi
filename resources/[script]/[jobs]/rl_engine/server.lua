local datas = {
    ["database"] = "reval",
    ["host"] = "localhost",
    ["name"] = "root",
    ["password"] = "revalmta31.",
}

local connection

local firstConnection = true

function connectToMySQL()
    connection = dbConnect("mysql", "dbname="..datas["database"]..";host="..datas["host"].."", datas["name"], datas["password"], "log=1")
    if connection then
        outputDebugString("SQL Bağlantısı Başarılı")
        if not firstConnection then
            restartResource(getThisResource())
            firstConnection = true
        end
    else
        outputDebugString("SQL Bağlantısı Başarısız (10 Saniye içinde tekrar denecek)", 2)    
        setTimer(connectToMySQL, 10000, 1)
        firstConnection = false
    end
end
addEventHandler("onResourceStart", resourceRoot, connectToMySQL)

function getConn(res)
    if res then
        local resName = getResourceName(res)
        if resName then
            outputDebugString(""..resName.." Csatlakozott a mysqlhez!")
            return connection
        end
    end
end



local ids = {}
local connection = getConn(getThisResource())
local devSerials = {}
local devNames = {}
local syntax = getServerSyntax("Admin")
local syntax2 = getServerSyntax("Használat")
local slot = getMaxPlayers()

addEventHandler('onResourceStart', resourceRoot,
    function()
	    aclReload()
        
        
	    setMapName(serverData['city'])
		setGameType(serverData['mod'] .. " " .. serverData['version'])
		setRuleValue('modversion', serverData['version'])
		setRuleValue('developer', serverData['developer'])
		
       
	end
)



-- addEvent("core >> setElementData", true)
-- addEventHandler("core >> setElementData", root,
--     function(element, dataName, value)
--         setElementData(element, dataName, value)
--     end
-- )

-- addEvent("core >> removeElementData", true)
-- addEventHandler("core >> removeElementData", root,
--     function(element, dataName, value)
--         removeElementData(element, dataName)
--     end
-- )



local _addCommandHandler = addCommandHandler
function addCommandHandler(source, cmd, ...)
	if type(cmd) == "table" then
		for k, v in ipairs(cmd) do
			_addCommandHandler(source, v, ...)
		end
	else
		_addCommandHandler(source, cmd, ...)
	end
end

function outputChatBoxSpecial(element, text)
    if getElementData(element, "admin >> alogDisabled") then
        outputConsole(string.gsub(text, "#%x%x%x%x%x%x", ""), element)
    else
        outputChatBox(text, element, 255,255,255,true)
    end
end
addEvent("outputChatBox", true)
addEventHandler("outputChatBox", root, outputChatBoxSpecial)

function sendMessageToAdmin(element, text, neededLevel)
    local pair = {}
    for k,v in pairs(getElementsByType("player")) do
        local adminlevel = getElementData(v, "admin_level") or 0
        if adminlevel >= neededLevel then
            pair[v] = true
        end
    end
    
    for k,v in pairs(pair) do
        outputChatBoxSpecial(k, text)
    end
end

--// MoneyGlobal

function hasMoney(element, money, bankMoney)
    if bankMoney then
        local oldMoney = getElementData(element, "money") or 0
        if oldMoney - money > 0 then
            return true
        else
            return false
        end
    else
        local oldMoney = getElementData(element, "bankmoney") or 0
        if oldMoney - money > 0 then
            return true
        else
            return false
        end
    end
end

function takeMoney(element, money, bankMoney)
    if bankMoney then
        if hasMoney(element, money, false) then
            local oldMoney = getElementData(element, "money") or 0
            setElementData(element, "money", oldMoney - money)
            return true
        else
            return false
        end
    else
        if hasMoney(element, money, true) then
            local oldMoney = getElementData(element, "bankmoney") or 0
            setElementData(element, "bankmoney", oldMoney - money)
            return true
        else
            return false
        end
    end
end

function giveMoney(element, money, bankMoney)
    if bankMoney then
        local oldMoney = getElementData(element, "money") or 0
        setElementData(element, "money", oldMoney + money)
        return true
    else
        local oldMoney = getElementData(element, "bankmoney") or 0
        setElementData(element, "bankmoney", oldMoney + money)
        return true
    end
end


