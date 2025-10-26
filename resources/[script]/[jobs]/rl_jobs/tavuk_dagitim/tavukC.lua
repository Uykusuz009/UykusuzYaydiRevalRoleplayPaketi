local tavukcuMarker = 0
local tavukcuCreatedMarkers = {}
-- false devam
-- true bekle
-- true, true bitiş
local tavukcuRota = {
	{ -83.3984375, -1126.3037109375, 0.71552735567093, false },
	{ -83.4677734375, -1103.41796875, 2.9537708759308, false },
	{ -78.3271484375, -1062.478515625, 16.134107589722, false },
	{ -87.2001953125, -1033.9423828125, 23.626529693604, false },
	{ -109.404296875, -999.3427734375, 24.102283477783, false },
	{ -116.65625, -978.87890625, 24.966856002808, false },
	{ -90.0966796875, -928.6982421875, 18.92138671875, false },
	{ -55.2021484375, -856.7373046875, 13.294565200806, false },
	{ -9.5087890625, -761.9580078125, 7.96426820755, false },
	{ 29.673828125, -666.8720703125, 3.336287021637, false },
	{ 50.71484375, -595.900390625, 4.4676737785339, false },
	{ 49.3828125, -543.1611328125, 9.8505544662476, false },
	{ 34.7783203125, -513.181640625, 9.6234445571899, false },
	{ 1.2197265625, -477.580078125, 3.921804189682, false },
	{ -67.966796875, -432.6640625, 0.71681034564972, false },
	{ -116.294921875, -399.4619140625, 0.71594732999802, false },
	{ -198.3662109375, -322.197265625, 0.71616363525391, false },
	{ -200.787109375, -301.333984375, 1.0692321062088, false },
	
	{ -162.6416015625, -291.6962890625, 3.5094933509827, true },
	
	{ -169.3955078125, -282.0244140625, 2.1508824825287, false },
	{ -191.0439453125, -278.4326171875, 1.0683815479279, false },
	{ -223.533203125, -279.4443359375, 1.0677543878555, false },
	{ -233.0400390625, -291.904296875, 0.71619319915771, false },
	{ -157.5869140625, -371.8916015625, 0.71618676185608, false },
	{ -67.2548828125, -439.4775390625, 0.71658366918564, false },
	{ 24.734375, -509.0625, 9.4608907699585, false },
	{ 44.72265625, -546.412109375, 9.8574314117432, false },
	{ 47.23828125, -579.9892578125, 6.6344261169434, false },
	{ 26.896484375, -655.2763671875, 2.9883580207825, false },
	{ -28.5634765625, -788.662109375, 9.5493621826172, false },
	{ -91.6435546875, -919.48046875, 18.240337371826, false },
	{ -119.2451171875, -972.806640625, 24.884086608887, false },
	{ -119.984375, -994.505859375, 24.978452682495, false },
	{ -94.8837890625, -1030.712890625, 23.780363082886, false },
	{ -82.7861328125, -1069.7060546875, 14.099724769592, false },
	
	{ -65.9150390625, -1120.634765625, 0.7165624499321, true, true },
}

function tavukcubasla(cmd)		
local oyuncuArac = getPedOccupiedVehicle(getLocalPlayer())
		local oyuncuAracModel = getElementModel(oyuncuArac)
		local kacakciAracModel = 456
if getVehicleOccupant(oyuncuArac, 1) then
	outputChatBox("Reval Roleplay:#ffffff Mesleğe başlamak için araçta tek kişi olması gerekmektedir.",201,201,201,true)
 return
 end
if not getElementData(getLocalPlayer(), "tavukcuSoforlugu") then
if oyuncuAracModel == kacakciAracModel then
			setElementData(getLocalPlayer(), "tavukcuSoforlugu", true)
			updatetavukcuRota()
			addEventHandler("onClientMarkerHit", resourceRoot, tavukcuRotaMarkerHit)
		end
	else
		outputChatBox("Reval Roleplay:#ffffff Zaten mesleğe başladınız.",201,201,201,true)
	end
end
addCommandHandler("tavukbasla", tavukcubasla)

function updatetavukcuRota()
	tavukcuMarker = tavukcuMarker + 1
	for i,v in ipairs(tavukcuRota) do
		if i == tavukcuMarker then
			if not v[4] == true then
				local rotaMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 0, 255, 0, 255)
				table.insert(tavukcuCreatedMarkers, { rotaMarker, false })
			elseif v[4] == true and v[5] == true then 
				local bitMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255)
				table.insert(tavukcuCreatedMarkers, { bitMarker, true, true })	
			elseif v[4] == true then
				local malMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255)
				table.insert(tavukcuCreatedMarkers, { malMarker, true, false })			
			end
		end
	end
end

function tavukcuRotaMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 456 then
				for _, marker in ipairs(tavukcuCreatedMarkers) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							updatetavukcuRota()
						elseif marker[2] == true and marker[3] == true then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitVehicle, true)
							setElementFrozen(hitPlayer, true)
							toggleAllControls(false, true, false)
							tavukcuMarker = 0
							triggerServerEvent("tavukcuParaVer", hitPlayer, hitPlayer)
							outputChatBox("Reval Roleplay:#ffffff Kamyonunuza yeni tavuk paketleri yükleniyor, lütfen bekleyiniz.",201,201,201,true)
							--outputChatBox("[!] #FFFFFFAracınıza yeni mallar yükleniyor, lütfen bekleyiniz. Eğer devam etmek istemiyorsanız, /copculukbitir yazınız.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("Reval Roleplay:#ffffff Kamyonunuza yeni tavuk paketleri yüklenmiştir, devam edebilirsiniz.",201,201,201,true)
									--outputChatBox("[!] #FFFFFFAracınıza yeni mallar yüklenmiştir. Gidebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updatetavukcuRota()
								end, 5000, 1, hitPlayer, hitVehicle, source
							)	
						elseif marker[2] == true and marker[3] == false then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitPlayer, true)
							setElementFrozen(hitVehicle, true)
							toggleAllControls(false, true, false)
							outputChatBox("Reval Roleplay:#ffffff Kamyonunuzdaki tavuk paketleri indiriliyor, lütfen bekleyiniz.",201,201,201,true)
						--	outputChatBox("[!] #FFFFFFAracınızdaki mallar indiriliyor, lütfen bekleyiniz.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("Reval Roleplay:#ffffff Kamyonunuzdaki tavuk paketleri indirilmiştir, devam edebilirsiniz.",201,201,201,true)
								--	outputChatBox("[!] #FFFFFFAracınızdaki mallar indirilmiştir, geri dönebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updatetavukcuRota()
								end, 5000, 1, hitPlayer, hitVehicle, source
							)						
						end
					end
				end
			end
		end
	end
end

function tavukcuBitir()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	local tavukcuSoforlugu = getElementData(getLocalPlayer(), "tavukcuSoforlugu")
	if pedVeh then
		if pedVehModel == 456 then
			if tavukcuSoforlugu then
				exports.rl_global:fadeToBlack()
				setElementData(getLocalPlayer(), "tavukcuSoforlugu", false)
				for i,v in ipairs(tavukcuCreatedMarkers) do
					destroyElement(v[1])
				end
				tavukcuCreatedMarkers = {}
				tavukcuMarker = 0
				triggerServerEvent("tavukcuBitir", getLocalPlayer(), getLocalPlayer())
				removeEventHandler("onClientMarkerHit", resourceRoot, tavukcuRotaMarkerHit)
				removeEventHandler("onClientVehicleStartEnter", getRootElement(), tavukcuAntiYabanci)
				setTimer(function() exports.rl_global:fadeFromBlack() end, 2000, 1)
			end
		end
	end
end
addCommandHandler("tavukbitir", tavukcuBitir)

function tavukcuAntiAracTerketme(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		local theVehicle = source
		if seat == 0 then
			tavukcuBitir()
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), tavukcuAntiAracTerketme)