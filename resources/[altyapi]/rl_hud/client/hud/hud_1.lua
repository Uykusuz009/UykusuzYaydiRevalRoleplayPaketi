local huds = {"ammo", "armour", "breath", "clock", "health", "money", "weapon"}

addEventHandler("onClientElementDataChange", localPlayer, function(theKey, oldValue, newValue)
	if theKey == "hud_settings" then
		if getElementData(localPlayer, "hud_settings").hud == 1 then
			for _, component in ipairs(huds) do
				setPlayerHudComponentVisible(component, true)
			end
		else
			for _, component in ipairs(huds) do
				setPlayerHudComponentVisible(component, false)
			end
		end
	end
end)