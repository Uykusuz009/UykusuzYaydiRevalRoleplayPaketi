--[[
Ne0R` hocadan sevgilerimle
çalanın anasını öldüresiye siker öldürürm elimde kalır
--]]


local tupcuMarker = 0
local tupcuCreatedMarkers = {}
-- false devam
-- true bekle
-- true, true bitiş
local tupcuRota = {
	{  2142.419921875, -1896.5419921875, 13.002395629883, false },
	{  2198.0068359375, -1896.490234375, 13.389797210693, false },
	{  2234.7744140625, -1896.5361328125, 13.020984649658, false },
	{  2299.4091796875, -1896.662109375, 13.037599563599, false },
	{  2311.044921875, -1928.900390625, 13.023875236511, false },
	{  2319.693359375, -1975.1748046875, 12.991291999817, false },
	{  2389.568359375, -1975.4853515625, 13.020700454712, false },
	{  2435.978515625, -2012.38671875, 13.03674697876, false },
	
	{  2507.322265625, -2013.564453125, 12.920613288879, true },
	
	{  2493.3720703125, -2006.5068359375, 12.918910980225, false },
	{  2464.6953125, -2006.5380859375, 12.957607269287, false },
	{  2428.9638671875, -2006.5517578125, 13.041257858276, false },
	{  2416.7197265625, -1988.9404296875, 13.00261592865, false },
	{  2427.93359375, -1934.9990234375, 13.008158683777, false },
	{  2477.1708984375, -1934.4912109375, 12.986859321594, false },
	{  2537.630859375, -1934.3349609375, 13.02062702179, false },
	{  2580.279296875, -1934.4130859375, 13.021214485168, false },
	{  2646.6123046875, -1934.529296875, 12.969294548035, false },
	{  2707.052734375, -1934.548828125, 12.957087516785, false },
	{  2711.8828125, -1997.8125, 13.038782119751, false },-- ayrı atıldı
	
	{  2696.1083984375, -2000.9697265625, 12.967687606812, true },
	
	{  2674.6318359375, -2000.982421875, 13.013110160828, false },
	{  2655.099609375, -2006.98828125, 13.019642829895, false },
	
	{  2693.49609375, -2006.8408203125, 13.028548240662, true },
	
	{  2711.2470703125, -2014.568359375, 12.953963279724, false },
	{  2711.87109375, -2039.8955078125, 12.99343585968, false },
	{  2690.9130859375, -2046.5498046875, 13.131100654602, false },
	{  2651.9248046875, -2047.04296875, 19.819961547852, false },
	{  2581.9814453125, -2046.9892578125, 24.171022415161, false },
	{  2478.65234375, -2046.529296875, 24.22020149231, false },
	{  2379.904296875, -2046.41015625, 14.488185882568, false },
	{  2310.2509765625, -2053.759765625, 13.013687133789, false },
	{  2286.09375, -2074.837890625, 13.053832054138, false },
	{  2272.0576171875, -2065.4501953125, 13.017360687256, false },
	{  2240.271484375, -2033.6015625, 12.999864578247, false },
	{  2216.205078125, -1962.4609375, 13.004435539246, false },
	{  2220.1904296875, -1911.3935546875, 12.992782592773, false },
	{  2207.68359375, -1891.2490234375, 13.200221061707, false },
	{  2166.1982421875, -1891.4716796875, 12.967629432678, false },
	{  2113.7841796875, -1891.65234375, 12.971308708191, false },
	{  2089.775390625, -1891.865234375, 13.019933700562, false },
	{  2079.3603515625, -1906.0654296875, 13.015517234802, true, true },
	
}

function tupbasla(cmd)		
local oyuncuArac = getPedOccupiedVehicle(getLocalPlayer())
		local oyuncuAracModel = getElementModel(oyuncuArac)
		local kacakciAracModel = 478
if getVehicleOccupant(oyuncuArac, 1) then
	outputChatBox("Reval Roleplay:#ffffff Mesleğe başlamak için araçta tek kişi olması gerekmektedir.",201,201,201,true)
 return
 end
if not getElementData(getLocalPlayer(), "tupSoforlugu") then
if oyuncuAracModel == kacakciAracModel then
			setElementData(getLocalPlayer(), "tupSoforlugu", true)
			updatetupcuRota()
			addEventHandler("onClientMarkerHit", resourceRoot, tupcuRotaMarkerHit)
		end
	else
		outputChatBox("Reval Roleplay:#ffffff Zaten mesleğe başladınız.",201,201,201,true)
	end
end
addCommandHandler("tupbasla", tupbasla)

function updatetupcuRota()
	tupcuMarker = tupcuMarker + 1
	for i,v in ipairs(tupcuRota) do
		if i == tupcuMarker then
			if not v[4] == true then
				local rotaMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 0, 255, 0, 255)
				table.insert(tupcuCreatedMarkers, { rotaMarker, false })
			elseif v[4] == true and v[5] == true then 
				local bitMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255)
				table.insert(tupcuCreatedMarkers, { bitMarker, true, true })	
			elseif v[4] == true then
				local malMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255)
				table.insert(tupcuCreatedMarkers, { malMarker, true, false })			
			end
		end
	end
end

function tupcuRotaMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 478 then
				for _, marker in ipairs(tupcuCreatedMarkers) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							updatetupcuRota()
						elseif marker[2] == true and marker[3] == true then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitVehicle, true)
							setElementFrozen(hitPlayer, true)
							toggleAllControls(false, true, false)
							tupcuMarker = 0
							triggerServerEvent("tupcuParaVer", hitPlayer, hitPlayer)
							outputChatBox("Reval Roleplay:#ffffff Aracınıza yeni tüpler yükleniyor, lütfen bekleyiniz.",201,201,201,true)
							--outputChatBox("[!] #FFFFFFAracınıza yeni mallar yükleniyor, lütfen bekleyiniz. Eğer devam etmek istemiyorsanız, /copculukbitir yazınız.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("Reval Roleplay:#ffffff Aracınıza yeni tüpler yüklenmiştir, devam edebilirsiniz.",201,201,201,true)
									--outputChatBox("[!] #FFFFFFAracınıza yeni mallar yüklenmiştir. Gidebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updatetupcuRota()
								end, 5000, 1, hitPlayer, hitVehicle, source
							)	
						elseif marker[2] == true and marker[3] == false then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitPlayer, true)
							setElementFrozen(hitVehicle, true)
							toggleAllControls(false, true, false)
							outputChatBox("Reval Roleplay:#ffffff Aracınızdaki tüpler indiriliyor, lütfen bekleyiniz.",201,201,201,true)
						--	outputChatBox("[!] #FFFFFFAracınızdaki mallar indiriliyor, lütfen bekleyiniz.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("Reval Roleplay:#ffffff Aracınızdaki tüpler indirilmiştir, devam edebilirsiniz.",201,201,201,true)
								--	outputChatBox("[!] #FFFFFFAracınızdaki mallar indirilmiştir, geri dönebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updatetupcuRota()
								end, 10000, 1, hitPlayer, hitVehicle, source
							)						
						end
					end
				end
			end
		end
	end
end

function tupBitir()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	local tupSoforlugu = getElementData(getLocalPlayer(), "tupSoforlugu")
	if pedVeh then
		if pedVehModel == 478 then
			if tupSoforlugu then
				exports.rl_global:fadeToBlack()
				setElementData(getLocalPlayer(), "tupSoforlugu", false)
				for i,v in ipairs(tupcuCreatedMarkers) do
					destroyElement(v[1])
				end
				tupcuCreatedMarkers = {}
				tupcuMarker = 0
				triggerServerEvent("tupBitir", getLocalPlayer(), getLocalPlayer())
				removeEventHandler("onClientMarkerHit", resourceRoot, tupcuRotaMarkerHit)
				removeEventHandler("onClientVehicleStartEnter", getRootElement(), tupcuAntiYabanci)
				setTimer(function() exports.rl_global:fadeFromBlack() end, 2000, 1)
			end
		end
	end
end
addCommandHandler("tupBitir", tupBitir)

function tupcuAntiAracTerketme(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		local theVehicle = source
		if seat == 0 then
			tupBitir()
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), tupcuAntiAracTerketme)