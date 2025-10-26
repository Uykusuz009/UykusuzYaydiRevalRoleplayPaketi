function quitPlayer (  )
    x, y, z = getElementPosition(source)
for i, v in ipairs(getElementsByType("player")) do
	triggerClientEvent(v, "quit:add", v, x, y, z, getPlayerName(source), getElementData(source, "dbid"), getElementInterior(source), getElementDimension(source))
end
end
addEventHandler ( "onPlayerQuit", root, quitPlayer )