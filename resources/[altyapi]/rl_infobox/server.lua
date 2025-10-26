function addBox(element, type, message)
    if client and client ~= source then
		return false
	end
	triggerClientEvent(element, "infobox.addBox", element, type, message, 10000)
end