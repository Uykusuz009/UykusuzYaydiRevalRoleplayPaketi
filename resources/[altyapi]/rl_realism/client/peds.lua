addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "player" then
		setPedVoice(source, "PED_TYPE_DISABLED")
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	for _, player in ipairs(getElementsByType("player")) do
		if getElementDimension(player) < 65000 then
			setPedVoice(player, "PED_TYPE_DISABLED")
		end
	end
end)