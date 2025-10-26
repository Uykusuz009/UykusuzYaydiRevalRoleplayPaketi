local pizzaMarker = 0
local pizzaCreatedMarkers = {}
-- false devam
-- true bekle
-- true, true bitiş
local pizzaRota = {
	{  2083.658203125, -1799.5517578125, 12.981063842773, false },
	{  2113.2373046875, -1691.076171875, 12.981255531311, false },
	{  2115.474609375, -1602.5205078125, 24.470903396606, false },
	{  2130.96875, -1447.892578125, 23.426380157471, false },
	
	{  2146.7939453125, -1419.3427734375, 25.161472320557, true },
	
	{  2130.900390625, -1396.953125, 23.426298141479, false },
	{  2151.1025390625, -1387.255859375, 23.434057235718, false },
	{  2201.42578125, -1387.6435546875, 23.425964355469, false },
	{  2209.763671875, -1398.666015625, 23.418464660645, false },
	{  2209.98046875, -1442.10546875, 23.415576934814, false },
	
	{  2197.146484375, -1455.5625, 24.942026138306, true },
	{  2196.01171875, -1469.4970703125, 25.170845031738, true },
	
	{  2209.869140625, -1484.673828125, 23.415454864502, false },
	{  2208.77734375, -1567.6611328125, 23.04220199585, false },
	{  2197.5458984375, -1628.796875, 15.162569046021, false },
	{  2182.1513671875, -1738.5517578125, 12.973320007324, false },
	{  2171.4140625, -1749.5205078125, 12.983699798584, false },
	
	{  2139.228515625, -1747.05078125, 13.150632858276, true },
	
	{  2120.912109375, -1749.7763671875, 13.004450798035, false },
	{  2086.4853515625, -1765.8349609375, 12.992916107178, false },
	
	{  2076.4345703125, -1801.1904296875, 13.145077705383, true, true },
}

function pizzabasla(cmd)		
local oyuncuArac = getPedOccupiedVehicle(getLocalPlayer())
		local oyuncuAracModel = getElementModel(oyuncuArac)
		local kacakciAracModel = 448
if getVehicleOccupant(oyuncuArac, 1) then
	outputChatBox("Reval Roleplay:#ffffff Mesleğe başlamak için motorda tek kişi olması gerekmektedir.",201,201,201,true)
 return
 end
if not getElementData(getLocalPlayer(), "pizzaSoforlugu") then
if oyuncuAracModel == kacakciAracModel then
			setElementData(getLocalPlayer(), "pizzaSoforlugu", true)
			updatepizzaRota()
			addEventHandler("onClientMarkerHit", resourceRoot, pizzaRotaMarkerHit)
		end
	else
		outputChatBox("Reval Roleplay:#ffffff Zaten mesleğe başladınız.",201,201,201,true)
	end
end
addCommandHandler("pizzabasla", pizzabasla)

function updatepizzaRota()
	pizzaMarker = pizzaMarker + 1
	for i,v in ipairs(pizzaRota) do
		if i == pizzaMarker then
			if not v[4] == true then
				local rotaMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 0, 255, 0, 255)
				table.insert(pizzaCreatedMarkers, { rotaMarker, false })
			elseif v[4] == true and v[5] == true then 
				local bitMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255)
				table.insert(pizzaCreatedMarkers, { bitMarker, true, true })	
			elseif v[4] == true then
				local malMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255)
				table.insert(pizzaCreatedMarkers, { malMarker, true, false })			
			end
		end
	end
end

function pizzaRotaMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 448 then
				for _, marker in ipairs(pizzaCreatedMarkers) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							updatepizzaRota()
						elseif marker[2] == true and marker[3] == true then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitVehicle, true)
							setElementFrozen(hitPlayer, true)
							toggleAllControls(false, true, false)
							pizzaMarker = 0
							triggerServerEvent("pizzaParaVer", hitPlayer, hitPlayer)
							outputChatBox("Reval Roleplay:#ffffff Motorunuza yeni pizzalar yükleniyor, lütfen bekleyiniz.",201,201,201,true)
							--outputChatBox("[!] #FFFFFFAracınıza yeni mallar yükleniyor, lütfen bekleyiniz. Eğer devam etmek istemiyorsanız, /copculukbitir yazınız.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("Reval Roleplay:#ffffff Motorunuza yeni pizzalar yüklenmiştir, devam edebilirsiniz.",201,201,201,true)
									--outputChatBox("[!] #FFFFFFAracınıza yeni mallar yüklenmiştir. Gidebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updatepizzaRota()
								end, 1, 1, hitPlayer, hitVehicle, source
								--end, 1, 1, hitPlayer, hitVehicle, source
							)	
						elseif marker[2] == true and marker[3] == false then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitPlayer, true)
							setElementFrozen(hitVehicle, true)
							toggleAllControls(false, true, false)
							outputChatBox("Reval Roleplay:#ffffff Motorunuzdaki pizzalar indiriliyor, lütfen bekleyiniz.",201,201,201,true)
						--	outputChatBox("[!] #FFFFFFAracınızdaki mallar indiriliyor, lütfen bekleyiniz.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("Reval Roleplay:#ffffff Motorunuzdaki pizzalar indirilmiştir, devam edebilirsiniz.",201,201,201,true)
								--	outputChatBox("[!] #FFFFFFAracınızdaki mallar indirilmiştir, geri dönebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updatepizzaRota()
								end, 5000, 1, hitPlayer, hitVehicle, source
							)						
						end
					end
				end
			end
		end
	end
end

function pizzaBitir()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	local pizzaSoforlugu = getElementData(getLocalPlayer(), "pizzaSoforlugu")
	if pedVeh then
		if pedVehModel == 448 then
			if pizzaSoforlugu then
				exports.rl_global:fadeToBlack()
				setElementData(getLocalPlayer(), "pizzaSoforlugu", false)
				for i,v in ipairs(pizzaCreatedMarkers) do
					destroyElement(v[1])
				end
				pizzaCreatedMarkers = {}
				pizzaMarker = 0
				triggerServerEvent("pizzaBitir", getLocalPlayer(), getLocalPlayer())
				removeEventHandler("onClientMarkerHit", resourceRoot, pizzaRotaMarkerHit)
				removeEventHandler("onClientVehicleStartEnter", getRootElement(), pizzaAntiYabanci)
				setTimer(function() exports.rl_global:fadeFromBlack() end, 2000, 1)
			end
		end
	end
end
addCommandHandler("pizzaBitir", pizzaBitir)

function pizzaAntiAracTerketme(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		local theVehicle = source
		if seat == 0 then
			pizzaBitir()
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), pizzaAntiAracTerketme)