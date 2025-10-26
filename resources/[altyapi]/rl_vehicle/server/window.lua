local spamTimersSeatbeltWindow = {}

function toggleWindow(thePlayer)
	if not thePlayer then
		thePlayer = source
	end
	
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	if theVehicle then
		if hasVehicleWindows(theVehicle) then
			if isTimer(spamTimersSeatbeltWindow[thePlayer]) then return end
			if not (isVehicleWindowUp(theVehicle)) then
				triggerClientEvent(root, "playVehicleSound", root, "public/sounds/window.mp3", theVehicle)
				setElementData(theVehicle, "vehicle:windowstat", 0, true)
				exports.rl_global:sendLocalMeAction(thePlayer, "elini konsoldaki düğmeye götürerek camları kapatır.")
				for i = 0, getVehicleMaxPassengers(theVehicle) do
					local player = getVehicleOccupant(theVehicle, i)
					if (player) then
						triggerClientEvent(player, "updateWindow", theVehicle)
						triggerEvent("setTintName", player)
					end
				end
			else
				triggerClientEvent(root, "playVehicleSound", root, "public/sounds/window.mp3", theVehicle)
				setElementData(theVehicle, "vehicle:windowstat", 1, true)
				exports.rl_global:sendLocalMeAction(thePlayer, "elini konsoldaki düğmeye götürerek camları açar.")
				for i = 0, getVehicleMaxPassengers(theVehicle) do
					local player = getVehicleOccupant(theVehicle, i)
					if (player) then
						triggerClientEvent(player, "updateWindow", theVehicle)
						triggerEvent("resetTintName", theVehicle, player)
					end
				end
			end
			spamTimersSeatbeltWindow[thePlayer] = setTimer(function() end, 1000, 1)
		end
	end
end
addEvent("vehicle:togWindow", true)
addEventHandler("vehicle:togWindow", root, toggleWindow)
addCommandHandler("togwindow", toggleWindow)