--[[
Ne0R` hocadan sevgilerimle
çalanın anasını öldüresiye siker öldürürm elimde kalır
--]]


local sosisliciMarker = 0
local sosisliciCreatedMarkers = {}
-- false devam
-- true bekle
-- true, true bitiş
local sosisliciRota = {
	{ 1001.208984375, -1336.4306640625, 13.163815498352, false },
	{ 978.36328125, -1319.8583984375, 13.151776313782, false },
	{ 881.521484375, -1319.7080078125, 13.299654006958, false },
	{ 810.98046875, -1319.228515625, 13.257660865784, false },
	{ 737.837890625, -1317.3193359375, 13.170581817627, false },
	{ 654.7333984375, -1317.4365234375, 13.162952423096, false },
	{ 554.451171875, -1327.6708984375, 13.185203552246, false },
	{ 498.025390625, -1344.07421875, 15.740793228149, false },
	{ 427.142578125, -1381.16015625, 28.672662734985, false },
	{ 374.0556640625, -1421.3388671875, 33.94242477417, false },
	{ 274.080078125, -1509.11328125, 32.13228225708, false },
	{ 234.849609375, -1596.453125, 32.844913482666, false },
	{ 270.646484375, -1637.177734375, 32.928073883057, false },
	{ 356.1064453125, -1648.6005859375, 32.602787017822, false },
	{ 424.8310546875, -1658.4892578125, 25.806131362915, false },
	{ 469.4873046875, -1660.9755859375, 24.402976989746, false },
	{ 544.138671875, -1670.4140625, 18.310955047607, false },
	{ 617.1982421875, -1679.3369140625, 15.78982925415, false },
	{ 650.9140625, -1674.666015625, 14.319261550903, false },
	{ 754.1923828125, -1676.7216796875, 11.295429229736, false },
	{ 796.8779296875, -1677.54296875, 13.139003753662, false },
	
	{ 801.173828125, -1629.7998046875, 13.162099838257, true },
	
	{ 788.4482421875, -1623.390625, 13.16500377655, false },
	{ 789.99609375, -1598.4677734375, 13.162261009216, false },
	{ 774.0244140625, -1575.41796875, 13.163542747498, false },
	{ 791.3974609375, -1499.9970703125, 13.163368225098, false },
	{ 799.8447265625, -1419.46875, 13.174029350281, false },
	{ 799.9033203125, -1379.857421875, 13.184706687927, false },
	{ 799.4013671875, -1351.0712890625, 13.162611961365, false },
	{ 811.7470703125, -1328.29296875, 13.252287864685, false },
	{ 897.3388671875, -1327.41015625, 13.292542457581, false },
	{ 976.357421875, -1328.068359375, 13.148027420044, false },
	
	{ 1017.625, -1332.74609375, 13.240846633911, true, true },
}

function sosisliciBasla(cmd)		
local oyuncuArac = getPedOccupiedVehicle(getLocalPlayer())
		local oyuncuAracModel = getElementModel(oyuncuArac)
		local kacakciAracModel = 588
if getVehicleOccupant(oyuncuArac, 1) then
	outputChatBox("Reval Roleplay:#ffffff Mesleğe başlamak için araçta tek kişi olması gerekmektedir.",201,201,201,true)
 return
 end
if not getElementData(getLocalPlayer(), "sosisliciSoforlugu") then
if oyuncuAracModel == kacakciAracModel then
			setElementData(getLocalPlayer(), "sosisliciSoforlugu", true)
			updatesosisliciRota()
			addEventHandler("onClientMarkerHit", resourceRoot, sosisliciRotaMarkerHit)
		end
	else
		outputChatBox("Reval Roleplay:#ffffff Zaten mesleğe başladınız.",201,201,201,true)
	end
end
addCommandHandler("sosislibasla", sosisliciBasla)

function updatesosisliciRota()
	sosisliciMarker = sosisliciMarker + 1
	for i,v in ipairs(sosisliciRota) do
		if i == sosisliciMarker then
			if not v[4] == true then
				local rotaMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 0, 255, 0, 255)
				table.insert(sosisliciCreatedMarkers, { rotaMarker, false })
			elseif v[4] == true and v[5] == true then 
				local bitMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255)
				table.insert(sosisliciCreatedMarkers, { bitMarker, true, true })	
			elseif v[4] == true then
				local malMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255)
				table.insert(sosisliciCreatedMarkers, { malMarker, true, false })			
			end
		end
	end
end

function sosisliciRotaMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 588 then
				for _, marker in ipairs(sosisliciCreatedMarkers) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							updatesosisliciRota()
						elseif marker[2] == true and marker[3] == true then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitVehicle, true)
							setElementFrozen(hitPlayer, true)
							toggleAllControls(false, true, false)
							sosisliciMarker = 0
							triggerServerEvent("sosisliciParaVer", hitPlayer, hitPlayer)
							outputChatBox("Reval Roleplay:#ffffff Aracınıza yeni sosisliler yükleniyor, lütfen bekleyiniz.",201,201,201,true)
							--outputChatBox("[!] #FFFFFFAracınıza yeni mallar yükleniyor, lütfen bekleyiniz. Eğer devam etmek istemiyorsanız, /copculukbitir yazınız.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("Reval Roleplay:#ffffff Aracınıza yeni sosisliler yüklenmiştir, devam edebilirsiniz.",201,201,201,true)
									--outputChatBox("[!] #FFFFFFAracınıza yeni mallar yüklenmiştir. Gidebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updatesosisliciRota()
								end, 5000, 1, hitPlayer, hitVehicle, source
							)	
						elseif marker[2] == true and marker[3] == false then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitPlayer, true)
							setElementFrozen(hitVehicle, true)
							toggleAllControls(false, true, false)
							outputChatBox("Reval Roleplay:#ffffff Aracınızdaki sosisliler indiriliyor, lütfen bekleyiniz.",201,201,201,true)
						--	outputChatBox("[!] #FFFFFFAracınızdaki mallar indiriliyor, lütfen bekleyiniz.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("Reval Roleplay:#ffffff Aracınızdaki sosisliler indirilmiştir, devam edebilirsiniz.",201,201,201,true)
								--	outputChatBox("[!] #FFFFFFAracınızdaki mallar indirilmiştir, geri dönebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updatesosisliciRota()
								end, 10000, 1, hitPlayer, hitVehicle, source
							)						
						end
					end
				end
			end
		end
	end
end

function sosisliciBitir()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	local sosisliciSoforlugu = getElementData(getLocalPlayer(), "sosisliciSoforlugu")
	if pedVeh then
		if pedVehModel == 588 then
			if sosisliciSoforlugu then
				exports.rl_global:fadeToBlack()
				setElementData(getLocalPlayer(), "sosisliciSoforlugu", false)
				for i,v in ipairs(sosisliciCreatedMarkers) do
					destroyElement(v[1])
				end
				sosisliciCreatedMarkers = {}
				sosisliciMarker = 0
				triggerServerEvent("sosisliciBitir", getLocalPlayer(), getLocalPlayer())
				removeEventHandler("onClientMarkerHit", resourceRoot, sosisliciRotaMarkerHit)
				removeEventHandler("onClientVehicleStartEnter", getRootElement(), sosisliciAntiYabanci)
				setTimer(function() exports.rl_global:fadeFromBlack() end, 2000, 1)
			end
		end
	end
end
addCommandHandler("sosislibitir", sosisliciBitir)

function sosisliciAntiAracTerketme(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		local theVehicle = source
		if seat == 0 then
			sosisliciBitir()
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), sosisliciAntiAracTerketme)