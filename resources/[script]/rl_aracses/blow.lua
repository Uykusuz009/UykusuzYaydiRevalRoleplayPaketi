-- SparroW MTA : https://sparrow-mta.blogspot.com
-- Facebook : https://www.facebook.com/sparrowgta/
-- İyi oyunlar...

local komutlar = {"-turboo", "-egzozz"} -- komut
addEventHandler("onPlayerCommand", root, function(komut)
	if komut == komutlar[1] or komut == komutlar[2] then
		local veh = getPedOccupiedVehicle(source)
		if veh then
			local seat = getPedOccupiedVehicleSeat(source)
			if seat == 0 then
				local data = getElementData(veh, "vehicle:upgrades") or {}
				if komut == komutlar[1] then
					setElementData(veh, "vehicle:upgrades", {turbo = not data.turbo, als = data.als})
					if data.turbo then
						outputChatBox("Aracınızın turbosu kaldırılmıştır.", source, 255, 0, 0, true)
					else
						outputChatBox("Aracınıza turbo takılmıştır.", source, 0, 255, 0, true)
					end
				else
					setElementData(veh, "vehicle:upgrades", {turbo = data.turbo, als = not data.als})
					if data.als then
						outputChatBox("Aracınızın egzoz patlatma özelliği kaldırılmıştır.", source, 255, 0, 0, true)
					else
						outputChatBox("Aracınıza egzoz patlatma özelliği takılmıştır.", source, 0, 255, 0, true)
					end
				end
			else
				outputChatBox("Öncelikle şöför koltuğuna geçiniz.", 255, 0, 0, true)
			end
		end
	end
end)