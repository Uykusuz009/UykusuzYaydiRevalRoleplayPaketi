addEvent("weaponDistrict:doDistrict", true)

function weaponDistrict_doDistrict(name) 
		for k , v in ipairs(getElementsByType("player")) do  -- game
			if getElementData(v , "faction") == 1 then
			local x, y, z = getElementPosition(source)
			local loc = getZoneName ( x, y, z )
			local city = getZoneName ( x, y, z, true )
				outputChatBox("[ShotFire]#0390FF "..city.."'un #FFFF00["..loc.."]#0390FF bölgesinde silah sesleri duyulmaktadır. Ekipler derhal bölgeye!",v,0,153,255,true)
			end
		end
end
addEventHandler("weaponDistrict:doDistrict", root, weaponDistrict_doDistrict)