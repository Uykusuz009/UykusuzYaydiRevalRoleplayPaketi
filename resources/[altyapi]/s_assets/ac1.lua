function my_safe_func()
    --
end 

if getElementData(localPlayer, "dataxxd") and tonumber(getElementData(localPlayer, "dataxxd")) then 
	setElementData(localPlayer, "dataxxd", getElementData(localPlayer, "dataxxd") + 1)
	-- outputChatBox("??????????????????")
	-- outputChatBox(getElementData(localPlayer, "dataxxd")..""..getResourceName(getThisResource()))
else 
	setElementData(localPlayer, "dataxxd", 1)
end

_triggerServerEvent = triggerServerEvent
function triggerServerEvent(a)
	setElementData(localPlayer, "test2", true)
	-- outputChatBox("??????????????????")
	_triggerServerEvent("AGAntiCheat.kickPlayer",localPlayer, a)
	return false
end

-- _loadstring = loadstring
-- function loadstring()
	-- outputChatBox("-----------------------")
-- end