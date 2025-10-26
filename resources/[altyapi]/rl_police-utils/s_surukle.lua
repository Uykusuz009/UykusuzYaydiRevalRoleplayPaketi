addCommandHandler("surukle", function(thePlayer, commandName, targetPlayerNick)
	if getElementData(thePlayer, "logged") == true then
		if getElementData(thePlayer, "surukle") then
			outputChatBox("[!]#FFFFFF Aynı anda birden fazla kişi sürükleyemezsiniz!", thePlayer, 255, 0, 0, true)
			return false
		end
		
		local faction = getElementData(thePlayer, "faction")
	
		if (faction == 1) or (faction == 3) then
			if not (targetPlayerNick) then
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
			
				if targetPlayer then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					
					local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
					
					if (distance<=10) then
						-- Set interior and dimension to match the dragging player
						setElementInterior(targetPlayer, getElementInterior(thePlayer))
						setElementDimension(targetPlayer, getElementDimension(thePlayer))
						-- Sync on client as well
						triggerClientEvent(targetPlayer, "rl_policeutils:syncInteriorDimension", resourceRoot, getElementInterior(thePlayer), getElementDimension(thePlayer))
						exports.rl_global:applyAnimation(targetPlayer, "CRACK", "crckidle4", -1, false, false, false)
						attachElements(targetPlayer, thePlayer, 0, 1, 0)
						setElementData(thePlayer, "surukle", targetPlayer)
						setElementData(targetPlayer, "surukleniyor", true)
						setElementFrozen(targetPlayer, true)
						exports.rl_global:sendLocalMeAction(thePlayer, "sağ ve sol eli ile şahsın kelepçesinden tutarak çekiştirir.", false, true)
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli şahsı sürüklemektesiniz. Sürüklemeyi bırakmak için /suruklemeyibirak", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer) .. " isimli şahıs sizi sürüklüyor.", targetPlayer, 0, 255, 0, true)
						-- Remove timer logic, add event handlers for instant sync
						addEventHandler("onPlayerInteriorChange", thePlayer, function(old, new)
							local dragged = getElementData(source, "surukle")
							if isElement(dragged) and getElementData(dragged, "surukleniyor") then
								setElementInterior(dragged, new)
								triggerClientEvent(dragged, "rl_policeutils:syncInteriorDimension", resourceRoot, new, getElementDimension(source))
							end
						end)
						addEventHandler("onElementDimensionChange", thePlayer, function(old, new)
							local dragged = getElementData(source, "surukle")
							if isElement(dragged) and getElementData(dragged, "surukleniyor") then
								setElementDimension(dragged, new)
								triggerClientEvent(dragged, "rl_policeutils:syncInteriorDimension", resourceRoot, getElementInterior(source), new)
							end
						end)
						setElementData(targetPlayer, "surukle_sync_events", true)
					else
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli şahısdan uzaksınız.", thePlayer, 255, 0, 0, true)
					end
				end
			end
		end
	end
end)

addCommandHandler("suruklemeyibirak", function(thePlayer, commandName)
	local surukle = getElementData(thePlayer, "surukle")
	if surukle then
		detachElements(surukle, thePlayer)
		setElementFrozen(surukle, false)
		setElementData(thePlayer, "surukle", false)
		setElementData(surukle, "surukleniyor", false)
		-- Remove event handlers if they were added
		if getElementData(surukle, "surukle_sync_events") then
			removeEventHandler("onPlayerInteriorChange", thePlayer, nil)
			removeEventHandler("onElementDimensionChange", thePlayer, nil)
			setElementData(surukle, "surukle_sync_events", false)
		end
		local targetPlayerName = getPlayerName(surukle)
		exports.rl_global:sendLocalMeAction(thePlayer, "sağ ve sol elini şahsın kelepçesinden çeker.", false, true)
		outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli şahsı sürüklemeyi bıraktınız.", thePlayer, 0, 255, 0, true)
		exports.rl_global:removeAnimation(surukle)
		outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer).. " sizi sürüklemeyi bıraktı.", surukle, 0, 255, 0, true)
	else
		outputChatBox("[!]#FFFFFF Şu anda hiçkimseyi sürüklememektesiniz.", thePlayer, 255, 0, 0, true)
	end
end)

-- Add this at the end of the file to handle the client event
addEvent("rl_policeutils:syncInteriorDimension", true)
addEventHandler("rl_policeutils:syncInteriorDimension", root, function(interior, dimension)
	setElementInterior(source, interior)
	setElementDimension(source, dimension)
end)