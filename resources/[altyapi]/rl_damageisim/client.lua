local damage_label2 = guiCreateLabel(0.6, 0.802, 0.3, 0.05, "", true)

guiLabelSetColor(damage_label2, 0, 0, 0)
guiLabelSetHorizontalAlign(damage_label2, "center")
guiSetFont(damage_label2, "default-bold-small" )
guiSetVisible(damage_label2, false)

local damage_label = guiCreateLabel(0.6, 0.8, 0.3, 0.05, "", true)
guiLabelSetHorizontalAlign(damage_label, "center")
guiSetFont(damage_label, "default-bold-small" )
guiSetVisible(damage_label, false)

local timer = nil

addEvent("damage:info", true)
addEventHandler("damage:info", root, function(heal, attacker, weapon, bodypart, loss, state, who)

	if isTimer(timer) then killTimer(timer) end

	guiSetVisible(damage_label, true)
	guiSetVisible(damage_label2, true)

	timer = setTimer(function()
		guiSetVisible(damage_label, false)
		guiSetVisible(damage_label2, false)
	end, 3000, 1)

	if who == "attacker" then
		if state == "armor" then
			guiSetText(damage_label, getPlayerName(attacker).." / "..getWeaponNameFromID(weapon).." / +"..loss)
			guiSetText(damage_label2, getPlayerName(attacker).." / "..getWeaponNameFromID(weapon).." / +"..loss)
	        guiLabelSetColor(damage_label, 0, 255, 0)
		else
			guiSetText(damage_label, getPlayerName(attacker).." / "..getWeaponNameFromID(weapon).." / +"..loss)
			guiSetText(damage_label2, getPlayerName(attacker).." / "..getWeaponNameFromID(weapon).." / +"..loss)
	        guiLabelSetColor(damage_label, 0, 255, 0)
		end

	elseif who == "damaged" then
		if state == "armor" then
			guiSetText(damage_label, getPlayerName(attacker).." / "..getWeaponNameFromID(weapon).." / -"..loss)
			guiSetText(damage_label2, getPlayerName(attacker).." / "..getWeaponNameFromID(weapon).." / -"..loss)
	        guiLabelSetColor(damage_label, 255, 0, 0)
		else
			guiSetText(damage_label, getPlayerName(attacker).." / "..getWeaponNameFromID(weapon).." / -"..loss)
			guiSetText(damage_label2, getPlayerName(attacker).." / "..getWeaponNameFromID(weapon).." / -"..loss)
	        guiLabelSetColor(damage_label, 255, 0, 0)
		end
	end

end)
