
addEventHandler("onClientVehicVanescartEnter", root, function(player,seat,door)
	if (player == localPlayer ) then
		if getElementData(player, "dead") == 1 then 
		outputChatBox("Yaralıyken araca binemezsin!",180,0,0,true)
		cancelEvent()
		
		end
	end
end)