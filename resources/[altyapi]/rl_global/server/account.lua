function getPlayerFromCharacterID(charID)
	if charID and tonumber(charID) then
		for _, player in ipairs(getElementsByType("player")) do
			if (tonumber(getElementData(player, "dbid")) == tonumber(charID)) then
				return player
			end
		end
	end
	return false
end

function getPlayerFromSerial(serial)
	if serial then
		for _, player in ipairs(getElementsByType("player")) do
			if (getPlayerSerial(player) == serial) then
				return player
			end
		end
	end
	return false
end