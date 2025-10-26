function updateNametagColor(thePlayer)
	if source then thePlayer = source end
	
	for _, value in pairs(exports.rl_items:getBadges()) do
		local badge = getElementData(thePlayer, "badge")
		if badge and badge == value[1] then
			setPlayerNametagColor(thePlayer, unpack(value[4]))
			return
		end
	end
	
	if not getElementData(thePlayer, "logged") then
		setPlayerNametagColor(thePlayer, 127, 127, 127)
	elseif exports.rl_integration:isPlayerTrialAdmin(thePlayer) and getElementData(thePlayer, "duty_admin") and not getElementData(thePlayer, "hidden_admin") then
		setPlayerNametagColor(thePlayer, 255, 0, 0)
	else
		setPlayerNametagColor(thePlayer, 255, 255, 255)
	end
end
addEvent("updateNametagColor", true)
addEventHandler("updateNametagColor", root, updateNametagColor)

for _, player in ipairs(getElementsByType("player")) do
	updateNametagColor(player)
end