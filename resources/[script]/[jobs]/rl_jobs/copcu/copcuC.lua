local tabutMarker = 0
local tabutCreatedMarkers = {}
-- false devam
-- true bekle
-- true, true bitiş
local tabutCreatedMarkers = {
	{  2216.2822265625, -1960.087890625, 13.952147483826, false },
	{  2220.9560546875, -1882.892578125, 14.002486228943, false },
	{  2228.5595703125, -1750.9912109375, 13.992634773254, false },
	
	{  2340.87890625, -1754.9775390625, 14.070839881897, true },
	
	{  2345.8779296875, -1719.8720703125, 13.958456993103, false },
	{  2361.4140625, -1662.396484375, 14.002738952637, false },
	
	{  2431.876953125, -1664.09375, 14.059186935425, true },
	
	{  2473.697265625, -1675.28125, 13.958450317383, false },
	{  2506.4921875, -1673.1005859375, 13.981747627258, false },
	{  2466.5771484375, -1656.3525390625, 13.93309211731, false },
	{  2345.20703125, -1645.837890625, 14.739401817322, false },
	{  2345.083984375, -1538.9267578125, 24.440208435059, false },
	{  2309.203125, -1481.1748046875, 23.988489151001, false },
	{  2215.357421875, -1470.859375, 24.444021224976, false },
	{  2199.529296875, -1381.7890625, 24.44048500061, false },
	
	{  2172.2646484375, -1336.2734375, 24.510869979858, true },
	
	{  2152.3291015625, -1298.3779296875, 24.439788818359, false },
	{  2066.064453125, -1309.3623046875, 24.431880950928, false },
	{  2067.2001953125, -1380.212890625, 24.418857574463, false },
	{  2109.7607421875, -1398.3984375, 24.443481445312, false },
	{  2110.7255859375, -1591.369140625, 26.353170394897, false },
	
	{  2095.4814453125, -1723.3720703125, 14.076855659485, true },
	
	{  2083.384765625, -1775.146484375, 14.010239601135, false },
	{  2094.5693359375, -1896.9541015625, 13.994347572327, false },
	
	{  2256.7099609375, -1899.9404296875, 14.075844764709, true },
	
	{  2310.6962890625, -1901.4267578125, 14.020299911499, false },
	{  2305.6826171875, -1969.64453125, 14.023211479187, false },
	{  2204.861328125, -1976.8642578125, 14.160569190979, false },
	
	{  2159.8642578125, -1979.57421875, 14.166457176208, true, true },
	
}

function tabutbasla(cmd)		
local oyuncuArac = getPedOccupiedVehicle(getLocalPlayer())
		local oyuncuAracModel = getElementModel(oyuncuArac)
		local kacakciAracModel = 408
if getVehicleOccupant(oyuncuArac, 1) then
	outputChatBox("Reval Roleplay:#ffffff Mesleğe başlamak için araçta tek kişi olması gerekmektedir.",201,201,201,true)
 return
 end
if not getElementData(getLocalPlayer(), "tabutSoforlugu") then
if oyuncuAracModel == kacakciAracModel then
			setElementData(getLocalPlayer(), "tabutSoforlugu", true)
			updatetabutCreatedMarkers()
			addEventHandler("onClientMarkerHit", resourceRoot, tabutCreatedMarkersMarkerHit)
		end
	else
		outputChatBox("Reval Roleplay:#ffffff Zaten mesleğe başladınız.",201,201,201,true)
	end
end
addCommandHandler("copcubasla", tabutbasla)

function updatetabutCreatedMarkers()
	tabutMarker = tabutMarker + 1
	for i,v in ipairs(tabutCreatedMarkers) do
		if i == tabutMarker then
			if not v[4] == true then
				local rotaMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 0, 255, 0, 255)
				table.insert(tabutCreatedMarkers, { rotaMarker, false })
			elseif v[4] == true and v[5] == true then 
				local bitMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255)
				table.insert(tabutCreatedMarkers, { bitMarker, true, true })	
			elseif v[4] == true then
				local malMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255)
				table.insert(tabutCreatedMarkers, { malMarker, true, false })			
			end
		end
	end
end

function tabutCreatedMarkersMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 408 then
				for _, marker in ipairs(tabutCreatedMarkers) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							updatetabutCreatedMarkers()
						elseif marker[2] == true and marker[3] == true then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitVehicle, true)
							setElementFrozen(hitPlayer, true)
							toggleAllControls(false, true, false)
							tabutMarker = 0
							triggerServerEvent("tabutParaVer", hitPlayer, hitPlayer)
							outputChatBox("Reval Roleplay:#ffffff Aracınızdaki çöpler boşaltılıyor, lütfen bekleyiniz.",201,201,201,true)
							--outputChatBox("[!] #FFFFFFAracınıza yeni mallar yükleniyor, lütfen bekleyiniz. Eğer devam etmek istemiyorsanız, /copculukbitir yazınız.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("Reval Roleplay:#ffffff Aracınızadaki çöpler boşaltıldı, devam edebilirsiniz.",201,201,201,true)
									--outputChatBox("[!] #FFFFFFAracınıza yeni mallar yüklenmiştir. Gidebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updatetabutCreatedMarkers()
								end, 5000, 1, hitPlayer, hitVehicle, source
								--end, 1, 1, hitPlayer, hitVehicle, source
							)	
						elseif marker[2] == true and marker[3] == false then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitPlayer, true)
							setElementFrozen(hitVehicle, true)
							toggleAllControls(false, true, false)
							outputChatBox("Reval Roleplay:#ffffff Aracınıza çöpler boşaltılıyor, lütfen bekleyiniz.",201,201,201,true)
						--	outputChatBox("[!] #FFFFFFAracınızdaki mallar indiriliyor, lütfen bekleyiniz.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("Reval Roleplay:#ffffff Aracınıza çöpler boşaltıldı, devam edebilirsiniz.",201,201,201,true)
								--	outputChatBox("[!] #FFFFFFAracınızdaki mallar indirilmiştir, geri dönebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updatetabutCreatedMarkers()
								end, 10000, 1, hitPlayer, hitVehicle, source
							)						
						end
					end
				end
			end
		end
	end
end

function tabutBitir()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	local tabutSoforlugu = getElementData(getLocalPlayer(), "tabutSoforlugu")
	if pedVeh then
		if pedVehModel == 408 then
			if tabutSoforlugu then
				exports.rl_global:fadeToBlack()
				setElementData(getLocalPlayer(), "tabutSoforlugu", false)
				for i,v in ipairs(tabutCreatedMarkers) do
					destroyElement(v[1])
				end
				tabutCreatedMarkers = {}
				tabutMarker = 0
				triggerServerEvent("tabutBitir", getLocalPlayer(), getLocalPlayer())
				removeEventHandler("onClientMarkerHit", resourceRoot, tabutCreatedMarkersMarkerHit)
				removeEventHandler("onClientVehicleStartEnter", getRootElement(), tabutAntiYabanci)
				setTimer(function() exports.rl_global:fadeFromBlack() end, 2000, 1)
			end
		end
	end
end
addCommandHandler("tabutBitir", tabutBitir)

function tabutAntiAracTerketme(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		local theVehicle = source
		if seat == 0 then
			tabutBitir()
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), tabutAntiAracTerketme)