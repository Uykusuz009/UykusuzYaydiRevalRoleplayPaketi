function takeArmor(thePlayer, commandName, interest)
	if getElementData(thePlayer, "logged") == true then
		if getElementData(thePlayer, "faction") == 1 or getElementData(thePlayer, "faction") == 2 or getElementData(thePlayer, "faction") == 3 then
			interest = tonumber(interest)
			if interest then
				if interest >= 1 and interest <= 100 then
					local theVehicle = getPedOccupiedVehicle(thePlayer)
					if theVehicle then
						if getElementData(theVehicle, "faction") == 1 or getElementData(theVehicle, "faction") == 2 or getElementData(theVehicle, "faction") == 3 then
							setPedArmor(thePlayer, interest)
							outputChatBox("[!]#FFFFFF Başarıyla görev aracından ["..interest.."%] zırh aldınız.", thePlayer, 0, 255, 0, true)
							exports.rl_global:sendLocalMeAction(thePlayer, "sağ/sol elleriyle aracın arka tarafından zırhı kavrar ve giyer.")
						else
							outputChatBox("[!]#FFFFFF Bu araçtan zırh alamazsınız.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					else
						outputChatBox("[!]#FFFFFF Bu işlemi kullanmak için araçta olmalısınız.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("KULLANIM: /"..commandName.." [Zırh]", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("KULLANIM: /"..commandName.." [Zırh]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("[!]#FFFFFF Bu işlemi yalnızca legal birlik üyeleri yapabilir.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	end
end
addCommandHandler("armor", takeArmor, false, false)