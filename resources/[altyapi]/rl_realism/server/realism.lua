function onStealthKill(targetPlayer)
    cancelEvent(true)
end
addEventHandler("onPlayerStealthKill", root, onStealthKill)

local checked = false
function checkDimension(thePlayer, newdim, newint)
	if not (type(firearmstable[thePlayer]) == "table") then return end

	for k,v in pairs(firearmstable[thePlayer]) do
		if isElement(v) then
			if (checked == false) then
				if not (isElement(v)) then
					outputDebugString("WearableCheckDimension: This is not a element: " .. tostring(v[thePlayer]) .. " - Owner: " .. getPlayerName(thePlayer))
					checked = true
				end
			end
			local dim = getElementDimension (v)
			local int = getElementInterior (v)
				
			if (dim ~= newdim) then
				setElementDimension (v, newdim)
			end
			if (int ~= newint) then
				setElementInterior(v, newint)
			end
		end
	end
end

addEventHandler("onVehicleStartEnter", root, function(thePlayer, seat, jacked)
	if jacked and seat == 0 then
		cancelEvent(true)
		outputChatBox("[!]#FFFFFF Binmeye çalıştığınız arabanın sürücü koltuğunda birisi var.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
	
	if getElementData(thePlayer, "dead") then
		cancelEvent(true)
		outputChatBox("[!]#FFFFFF Baygın iken araca binemezsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end)