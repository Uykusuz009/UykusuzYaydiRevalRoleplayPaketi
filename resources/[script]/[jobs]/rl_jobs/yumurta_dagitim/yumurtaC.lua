local yumurtaciMarker = 0
local yumurtaciCreatedMarkers = {}
-- false devam
-- true bekle
-- true, true bitiş
local yumurtaciRota = {
	{ 2292.7607421875, -2067.908203125, 13.087770462036, true },
	{ 2277.3984375, -2071.0302734375, 13.087552070618, false },
	{ 2226.46484375, -2019.8212890625, 13.04967212677, false },
	{ 2216.216796875, -1986.7958984375, 13.042593955994, false },
	{ 2220.412109375, -1909.6259765625, 13.065905570984, false },
	{ 2219.642578125, -1821.9013671875, 12.899732589722, false },
	{ 2218.150390625, -1765.564453125, 13.058847427368, false },
	{ 2218.970703125, -1720.2431640625, 13.082504272461, false },
	{ 2227.9248046875, -1667.041015625, 14.7317237854, false },
	{ 2241.505859375, -1657.5322265625, 14.994267463684, false },
	{ 2288.9462890625, -1661.2451171875, 14.56595993042, false },
	{ 2326.4697265625, -1661.5234375, 13.378819465637, false },
	{ 2339.9833984375, -1672.1474609375, 13.067346572876, false },
	{ 2339.896484375, -1716.08203125, 13.063822746277, false },
	{ 2351.7607421875, -1734.796875, 13.088109016418, false },
	{ 2398.361328125, -1734.853515625, 13.087259292603, false },
	{ 2503.845703125, -1734.53125, 13.087653160095, false },
	{ 2524.923828125, -1742.1513671875, 13.089303016663, false },
	{ 2525.0341796875, -1779.271484375, 13.08722782135, false },
	{ 2514.296875, -1828.236328125, 13.071462631226, false },
	{ 2514.3837890625, -1911.0869140625, 13.044406890869, false },
	{ 2506.70703125, -1929.8984375, 13.068942070007, false },
	{ 2427.2236328125, -1930.0400390625, 13.075975418091, false },
	{ 2416.255859375, -1921.75390625, 13.087936401367, false },
	{ 2404.7109375, -1892.271484375, 13.088064193726, false },
	{ 2384.056640625, -1892.173828125, 13.090064048767, false },
	
	{ 2375.34375, -1906.396484375, 13.371857643127, true },
	
	{ 2386.3544921875, -1920.5400390625, 13.088199615479, false },
	{ 2402.443359375, -1920.7470703125, 13.088173866272, false },
	{ 2411.34375, -1928.322265625, 13.088210105896, false },
	{ 2411.1962890625, -1957.6630859375, 13.088210105896, false },
	{ 2403.1201171875, -1969.796875, 13.098663330078, false },
	{ 2328.923828125, -1970.125, 13.065855026245, false },
	{ 2253.5087890625, -1970.2802734375, 13.048357963562, false },
	{ 2228.619140625, -1970.4296875, 13.077686309814, false },
	{ 2211.35546875, -1980.9033203125, 13.035303115845, false },
	{ 2221.5029296875, -2022.013671875, 13.054537773132, false },
	{ 2271.6669921875, -2072.1865234375, 13.087731361389, false },
	
	{ 2294.26171875, -2077.1640625, 13.167574882507, true, true }
	
}

function yumurtaciBasla(cmd)		
local oyuncuArac = getPedOccupiedVehicle(getLocalPlayer())
		local oyuncuAracModel = getElementModel(oyuncuArac)
		local kacakciAracModel = 478
if getVehicleOccupant(oyuncuArac, 1) then
	outputChatBox("Reval Roleplay:#ffffff Mesleğe başlamak için araçta tek kişi olması gerekmektedir.",201,201,201,true)
 return
 end
if not getElementData(getLocalPlayer(), "yumurtaSoforlugu") then
if oyuncuAracModel == kacakciAracModel then
			setElementData(getLocalPlayer(), "yumurtaSoforlugu", true)
			updateyumurtaciRota()
			addEventHandler("onClientMarkerHit", resourceRoot, yumurtaciRotaMarkerHit)
		end
	else
		outputChatBox("Reval Roleplay:#ffffff Zaten mesleğe başladınız.",201,201,201,true)
	end
end
addCommandHandler("yumurtabasla", yumurtaciBasla)

function updateyumurtaciRota()
	yumurtaciMarker = yumurtaciMarker + 1
	for i,v in ipairs(yumurtaciRota) do
		if i == yumurtaciMarker then
			if not v[4] == true then
				local rotaMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 0, 255, 0, 255)
				table.insert(yumurtaciCreatedMarkers, { rotaMarker, false })
			elseif v[4] == true and v[5] == true then 
				local bitMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255)
				table.insert(yumurtaciCreatedMarkers, { bitMarker, true, true })	
			elseif v[4] == true then
				local malMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255)
				table.insert(yumurtaciCreatedMarkers, { malMarker, true, false })			
			end
		end
	end
end

function yumurtaciRotaMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 478 then
				for _, marker in ipairs(yumurtaciCreatedMarkers) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							updateyumurtaciRota()
						elseif marker[2] == true and marker[3] == true then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitVehicle, true)
							setElementFrozen(hitPlayer, true)
							toggleAllControls(false, true, false)
							yumurtaciMarker = 0
							triggerServerEvent("yumurtaciParaVer", hitPlayer, hitPlayer)
							outputChatBox("Reval Roleplay:#ffffff Aracınıza yeni yumurta kolileri yükleniyor, lütfen bekleyiniz.",201,201,201,true)
							--outputChatBox("[!] #FFFFFFAracınıza yeni mallar yükleniyor, lütfen bekleyiniz. Eğer devam etmek istemiyorsanız, /copculukbitir yazınız.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("Reval Roleplay:#ffffff Aracınıza yeni yumurta kolileri yüklenmiştir, devam edebilirsiniz.",201,201,201,true)
									--outputChatBox("[!] #FFFFFFAracınıza yeni mallar yüklenmiştir. Gidebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updateyumurtaciRota()
								end, 1, 1, hitPlayer, hitVehicle, source
							)	
						elseif marker[2] == true and marker[3] == false then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitPlayer, true)
							setElementFrozen(hitVehicle, true)
							toggleAllControls(false, true, false)
							outputChatBox("Reval Roleplay:#ffffff Aracınızdaki yumurta kolileri indiriliyor, lütfen bekleyiniz.",201,201,201,true)
						--	outputChatBox("[!] #FFFFFFAracınızdaki mallar indiriliyor, lütfen bekleyiniz.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("Reval Roleplay:#ffffff Aracınızdaki yumurta kolileri indirilmiştir, devam edebilirsiniz.",201,201,201,true)
								--	outputChatBox("[!] #FFFFFFAracınızdaki mallar indirilmiştir, geri dönebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updateyumurtaciRota()
								end, 10000, 1, hitPlayer, hitVehicle, source
							)						
						end
					end
				end
			end
		end
	end
end

function yumurtaciBitir()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	local yumurtaSoforlugu = getElementData(getLocalPlayer(), "yumurtaSoforlugu")
	if pedVeh then
		if pedVehModel == 478 then
			if yumurtaSoforlugu then
				exports.rl_global:fadeToBlack()
				setElementData(getLocalPlayer(), "yumurtaSoforlugu", false)
				for i,v in ipairs(yumurtaciCreatedMarkers) do
					destroyElement(v[1])
				end
				yumurtaciCreatedMarkers = {}
				yumurtaciMarker = 0
				triggerServerEvent("yumurtaciBitir", getLocalPlayer(), getLocalPlayer())
				removeEventHandler("onClientMarkerHit", resourceRoot, yumurtaciRotaMarkerHit)
				removeEventHandler("onClientVehicleStartEnter", getRootElement(), yumurtaciAntiYabanci)
				setTimer(function() exports.rl_global:fadeFromBlack() end, 2000, 1)
			end
		end
	end
end
addCommandHandler("yumurtabitir", yumurtaciBitir)

function yumurtaciAntiAracTerketme(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		local theVehicle = source
		if seat == 0 then
			yumurtaciBitir()
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), yumurtaciAntiAracTerketme)