local gazeteMarker = 0
local gazeteCreatedMarkers = {}
-- false devam
-- true bekle
-- true, true bitiş
local gazeteCreatedMarkers = {
	{  1824.193359375, -1876.72265625, 13.327858924866, false },
	{  1824.2392578125, -1825.2236328125, 13.4140625, false },
	{  1832.130859375, -1754.9033203125, 13.3828125, false },

	{  1928.2236328125, -1757.939453125, 13.546875, true },

	{  1959.232421875, -1769.3076171875, 13.3828125, false },
	{  1973.9072265625, -1814.8095703125, 13.3828125, false },
	{  2068.9736328125, -1814.7421875, 13.3828125, false },

	{  2091.462890625, -1773.208984375, 13.3828125, true },

	{  2114.919921875, -1679.2978515625, 13.376791954041, false },
	{  2097.986328125, -1459.8671875, 23.828125, false },
	{  1908.552734375, -1459.0625, 13.3828125, false },

	{  1811.890625, -1453.5791015625, 13.540172576904, true },

	{  1682.7001953125, -1438.6455078125, 13.3828125, false },
	{  1444.9951171875, -1438.6201171875, 13.3828125, false },
	{  1409.99609375, -1393.080078125, 13.3828125, false },

	{  1301.3515625, -1391.03515625, 13.2791223526, true },
	
	{  1261.5654296875, -1356.72265625, 13.175433158875, false },
	{  1237.5185546875, -1278.3076171875, 13.3828125, false },
	{  1195.8046875, -1300.197265625, 13.386378288269, false },
	
	{  1190.52734375, -1358.2412109375, 13.399528503418, true },

	{  1210.029296875, -1408.072265625, 13.237730026245, false },
	{  1339.921875, -1417.8056640625, 13.3828125, false },
	{  1295.3603515625, -1560.7978515625, 13.390605926514, false },
	{  1300.3232421875, -1693.1337890625, 13.637601852417, false },
	{  1335.6767578125, -1734.3203125, 13.603428840637, false },
	
	{  1493.1796875, -1738.1474609375, 13.546875, true },
	
	{  1590.544921875, -1734.33203125, 13.3828125, false },
	{  1774.4560546875, -1734.603515625, 13.3828125, false },
	{  1818.98828125, -1761.2197265625, 13.3828125, false },
	{  1812.166015625, -1889.3359375, 13.4140625, false },

	{  1781.208984375, -1889.0966796875, 13.390201568604, true, true },
}

function gazetebasla(cmd)		
local oyuncuArac = getPedOccupiedVehicle(getLocalPlayer())
		local oyuncuAracModel = getElementModel(oyuncuArac)
		local kacakciAracModel = 483
if getVehicleOccupant(oyuncuArac, 1) then
	outputChatBox("Reval Roleplay:#ffffff Mesleğe başlamak için motorda tek kişi olması gerekmektedir.",201,201,201,true)
 return
 end
if not getElementData(getLocalPlayer(), "gazeteSoforlugu") then
if oyuncuAracModel == kacakciAracModel then
			setElementData(getLocalPlayer(), "gazeteSoforlugu", true)
			updategazeteCreatedMarkers()
			addEventHandler("onClientMarkerHit", resourceRoot, gazeteCreatedMarkersMarkerHit)
		end
	else
		outputChatBox("Reval Roleplay:#ffffff Zaten mesleğe başladınız.",201,201,201,true)
	end
end
addCommandHandler("dolmusbasla", gazetebasla)

function updategazeteCreatedMarkers()
	gazeteMarker = gazeteMarker + 1
	for i,v in ipairs(gazeteCreatedMarkers) do
		if i == gazeteMarker then
			if not v[4] == true then
				local rotaMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 0, 255, 0, 255)
				table.insert(gazeteCreatedMarkers, { rotaMarker, false })
			elseif v[4] == true and v[5] == true then 
				local bitMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255)
				table.insert(gazeteCreatedMarkers, { bitMarker, true, true })	
			elseif v[4] == true then
				local malMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255)
				table.insert(gazeteCreatedMarkers, { malMarker, true, false })			
			end
		end
	end
end

function gazeteCreatedMarkersMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 483 then
				for _, marker in ipairs(gazeteCreatedMarkers) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							updategazeteCreatedMarkers()
						elseif marker[2] == true and marker[3] == true then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitVehicle, true)
							setElementFrozen(hitPlayer, true)
							toggleAllControls(false, true, false)
							gazeteMarker = 0
							triggerServerEvent("gazeteParaVer", hitPlayer, hitPlayer)
							outputChatBox("Reval Roleplay:#ffffff Yolcular biniyor, lütfen bekleyiniz.",201,201,201,true)
							--outputChatBox("[!] #FFFFFFAracınıza yeni mallar yükleniyor, lütfen bekleyiniz. Eğer devam etmek istemiyorsanız, /copculukbitir yazınız.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("Reval Roleplay:#ffffff Yolcuların ücretleri alındı, devam edebilirsiniz.",201,201,201,true)
									--outputChatBox("[!] #FFFFFFAracınıza yeni mallar yüklenmiştir. Gidebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updategazeteCreatedMarkers()
								end, 5000, 1, hitPlayer, hitVehicle, source
								--end, 1, 1, hitPlayer, hitVehicle, source
							)	
						elseif marker[2] == true and marker[3] == false then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitPlayer, true)
							setElementFrozen(hitVehicle, true)
							toggleAllControls(false, true, false)
							outputChatBox("Reval Roleplay:#ffffff Yolcular iniyor, lütfen bekleyiniz.",201,201,201,true)
						--	outputChatBox("[!] #FFFFFFAracınızdaki mallar indiriliyor, lütfen bekleyiniz.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("Reval Roleplay:#ffffff Yolcular dolmuştan indi, devam edebilirsiniz.",201,201,201,true)
								--	outputChatBox("[!] #FFFFFFAracınızdaki mallar indirilmiştir, geri dönebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updategazeteCreatedMarkers()
								end, 5000, 1, hitPlayer, hitVehicle, source
							)						
						end
					end
				end
			end
		end
	end
end

function gazeteBitir()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	local gazeteSoforlugu = getElementData(getLocalPlayer(), "gazeteSoforlugu")
	if pedVeh then
		if pedVehModel == 483 then
			if gazeteSoforlugu then
				exports.rl_global:fadeToBlack()
				setElementData(getLocalPlayer(), "gazeteSoforlugu", false)
				for i,v in ipairs(gazeteCreatedMarkers) do
					destroyElement(v[1])
				end
				gazeteCreatedMarkers = {}
				gazeteMarker = 0
				triggerServerEvent("gazeteBitir", getLocalPlayer(), getLocalPlayer())
				removeEventHandler("onClientMarkerHit", resourceRoot, gazeteCreatedMarkersMarkerHit)
				removeEventHandler("onClientVehicleStartEnter", getRootElement(), gazeteAntiYabanci)
				setTimer(function() exports.rl_global:fadeFromBlack() end, 2000, 1)
			end
		end
	end
end
addCommandHandler("dolmusbitir", gazeteBitir)

function gazeteAntiAracTerketme(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		local theVehicle = source
		if seat == 0 then
			gazeteBitir()
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), gazeteAntiAracTerketme)