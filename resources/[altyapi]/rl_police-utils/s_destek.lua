

myBlip = {}
addCommandHandler('destek', function(plr)
	if plr:getData('logged') == true and plr:getData('faction') == 3 then 
		 dbid = tonumber(plr:getData('dbid'))
		if not plr:getData('destek:talep') then 
			plr:outputChat('[!]#FFFFFF Bir destek talebinde bulundunuz.', 50, 50, 255, true)
			local x, y, z = getElementPosition(plr)
			plr:setData('destek:talep', true)
			for k,v in ipairs(getElementsByType('player')) do 
				if v:getData('faction') == 1 or v:getData('faction') == 3 then
					--outputChatBox('[Destek]#FFFFFF  "' .. plr.team:getData('ranks')[plr:getData('factionrank')] .. ' ' .. plr.name .. '" destek talebi açtı!',v ,50, 50, 255, true)
				end 
			end
		else 
			plr:outputChat('[!]#FFFFFF Destek talebinizi kapattınız.', 50, 255, 50, true)
			plr:setData('destek:talep', nil)
			for k,v in ipairs(getElementsByType('player')) do 
				if v:getData('faction') == 1  or v:getData('faction') == 3 then
					--outputChatBox('[Destek]#FFFFFF  "' .. plr.team:getData('ranks')[plr:getData('factionrank')] .. ' ' .. plr.name .. '"  destek talebini kaldırdı, devriyesine devam ediyor.',v, 50, 255, 50, true)
					for i, blip in ipairs(getElementsByType("blip")) do
						if blip:getData('destek') then
							if blip:getData('owner') == plr then 
								blip:destroy()
							end 
						end
					end
				end 
			end
		end
	end 
end)