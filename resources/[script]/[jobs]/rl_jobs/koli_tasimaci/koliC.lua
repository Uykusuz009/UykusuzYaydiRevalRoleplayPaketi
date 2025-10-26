--[[
Ne0R` hocadan sevgilerimle
çalanın anasını öldüresiye siker öldürürm elimde kalır
--]]


local koliMarker = 0
local koliCreatedMarkers = {}
-- false devam
-- true bekle
-- true, true bitiş
local koliRota = {
	{  2303.7568359375, -2378.1015625, 13.684377670288, false },
	{  2271.6435546875, -2410.6884765625, 13.684464454651, false },
	
	{  2262.17578125, -2442.80078125, 13.684005737305, true },
	
	{  2247.2294921875, -2429.95703125, 13.684163093567, false },
	{  2260.4375, -2404.4404296875, 13.546663284302, false },
	{  2315.9384765625, -2349.20703125, 13.519082069397, false },
	{  2333.619140625, -2353.0234375, 13.520245552063, false },
	{  2422.3359375, -2442.3203125, 13.567459106445, false },
	{  2464.2353515625, -2440.259765625, 13.590608596802, false },
	{  2523.580078125, -2380.951171875, 13.590624809265, false },
	
	{  2561.90234375, -2404.73828125, 13.775693893433, true },
	
	{  2578.462890625, -2403.0107421875, 13.606240272522, false },
	{  2545.845703125, -2373.2509765625, 13.59558391571, false },
	{  2506.9931640625, -2388.861328125, 13.590635299683, false },
	{  2452.791015625, -2442.853515625, 13.591765403748, false },
	{  2418.29296875, -2430.0390625, 13.512265205383, false },
	{  2332.625, -2345.0771484375, 13.520268440247, false },
	{  2315.869140625, -2366.37890625, 13.684253692627, true, true },
	
}

function kolibasla(cmd)		
local oyuncuArac = getPedOccupiedVehicle(getLocalPlayer())
		local oyuncuAracModel = getElementModel(oyuncuArac)
		local kacakciAracModel = 414
if getVehicleOccupant(oyuncuArac, 1) then
	outputChatBox("Reval Roleplay:#ffffff Mesleğe başlamak için araçta tek kişi olması gerekmektedir.",201,201,201,true)
 return
 end
if not getElementData(getLocalPlayer(), "koliSoforlugu") then
if oyuncuAracModel == kacakciAracModel then
			setElementData(getLocalPlayer(), "koliSoforlugu", true)
			updatekoliRota()
			addEventHandler("onClientMarkerHit", resourceRoot, koliRotaMarkerHit)
		end
	else
		outputChatBox("Reval Roleplay:#ffffff Zaten mesleğe başladınız.",201,201,201,true)
	end
end
addCommandHandler("kolibasla", kolibasla)

function updatekoliRota()
	koliMarker = koliMarker + 1
	for i,v in ipairs(koliRota) do
		if i == koliMarker then
			if not v[4] == true then
				local rotaMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 0, 255, 0, 255)
				table.insert(koliCreatedMarkers, { rotaMarker, false })
			elseif v[4] == true and v[5] == true then 
				local bitMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255)
				table.insert(koliCreatedMarkers, { bitMarker, true, true })	
			elseif v[4] == true then
				local malMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255)
				table.insert(koliCreatedMarkers, { malMarker, true, false })			
			end
		end
	end
end

function koliRotaMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 414 then
				for _, marker in ipairs(koliCreatedMarkers) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							updatekoliRota()
						elseif marker[2] == true and marker[3] == true then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitVehicle, true)
							setElementFrozen(hitPlayer, true)
							toggleAllControls(false, true, false)
							koliMarker = 0
							triggerServerEvent("koliParaVer", hitPlayer, hitPlayer)
							outputChatBox("Reval Roleplay:#ffffff Aracınıza koliler yükleniyor, lütfen bekleyiniz.",201,201,201,true)
							--outputChatBox("[!] #FFFFFFAracınıza yeni mallar yükleniyor, lütfen bekleyiniz. Eğer devam etmek istemiyorsanız, /copculukbitir yazınız.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("Reval Roleplay:#ffffff Aracınıza koliler yüklenmiştir, devam edebilirsiniz.",201,201,201,true)
									--outputChatBox("[!] #FFFFFFAracınıza yeni mallar yüklenmiştir. Gidebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updatekoliRota()
								--end, 5000, 1, hitPlayer, hitVehicle, source
								end, 5000, 1, hitPlayer, hitVehicle, source
							)	
						elseif marker[2] == true and marker[3] == false then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitPlayer, true)
							setElementFrozen(hitVehicle, true)
							toggleAllControls(false, true, false)
							outputChatBox("Reval Roleplay:#ffffff Aracınızdaki koliler indiriliyor, lütfen bekleyiniz.",201,201,201,true)
						--	outputChatBox("[!] #FFFFFFAracınızdaki mallar indiriliyor, lütfen bekleyiniz.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("Reval Roleplay:#ffffff Aracınızdaki koliler indirilmiştir, devam edebilirsiniz.",201,201,201,true)
								--	outputChatBox("[!] #FFFFFFAracınızdaki mallar indirilmiştir, geri dönebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updatekoliRota()
								end, 5000, 1, hitPlayer, hitVehicle, source
							)						
						end
					end
				end
			end
		end
	end
end

function koliBitir()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	local koliSoforlugu = getElementData(getLocalPlayer(), "koliSoforlugu")
	if pedVeh then
		if pedVehModel == 414 then
			if koliSoforlugu then
				exports.rl_global:fadeToBlack()
				setElementData(getLocalPlayer(), "koliSoforlugu", false)
				for i,v in ipairs(koliCreatedMarkers) do
					destroyElement(v[1])
				end
				koliCreatedMarkers = {}
				koliMarker = 0
				triggerServerEvent("koliBitir", getLocalPlayer(), getLocalPlayer())
				removeEventHandler("onClientMarkerHit", resourceRoot, koliRotaMarkerHit)
				removeEventHandler("onClientVehicleStartEnter", getRootElement(), koliAntiYabanci)
				setTimer(function() exports.rl_global:fadeFromBlack() end, 2000, 1)
			end
		end
	end
end
addCommandHandler("kolibitir", koliBitir)

function koliAntiAracTerketme(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		local theVehicle = source
		if seat == 0 then
			koliBitir()
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), koliAntiAracTerketme)