function spawnItem (thePlayer, targetid, itemID, itemValue)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	executeCommandHandler("giveitem", thePlayer, targetid .. " " .. itemID .. " " .. itemValue)
end
addEvent("itemCreator:spawnItem", true)
addEventHandler("itemCreator:spawnItem", root, spawnItem)