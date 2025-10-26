bindKey("x", "both", function(key, state)
	if not getElementData(localPlayer, "baygin") then
		if state == "down" then
			if not getElementData(localPlayer, "apontar") then
				setElementData(localPlayer, "apontar", true)
				triggerServerEvent("onClientSyncVOZ", localPlayer)
			end
		else
			setElementData(localPlayer, "apontar", false)
			triggerServerEvent("onClientSyncVOZparar", localPlayer)
		end
	end
end)