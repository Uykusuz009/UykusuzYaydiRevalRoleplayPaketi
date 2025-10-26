-- _triggerServerEvent = triggerServerEvent 
addEventHandler("onClientResourceStart",resourceRoot,function()
    if not my_safe_func then
        outputChatBox("hile tespt edildi")
		setElementData(localPlayer, "test2", true)
        triggerServerEvent("AGAntiCheat.kickPlayer",localPlayer, "func")
		iprint("hile tespt edildi",getResourceName(getThisResource()))
    end    
end)

