--[[
	@Coder by: Ne0R`
	@job-system/şarap mesleği
]]

local sarapMarker = 0
local sarapCreatedMarkers = {}
-- false devam
-- true bekle
-- true, true bitiş
local sarapRota = {
	{  2560.2138671875, -2386.1240234375, 13.46875, false },
	{  2519.4609375, -2377.4697265625, 13.453125, false },
	{  2449.15234375, -2446.0107421875, 13.477083206177, false },
	{  2320.53125, -2313.92578125, 13.546875, true },
	{  2285.6142578125, -2292.6484375, 13.375, false },
	{  2399.1572265625, -2188.25, 13.382091522217, false },
	{  2558.53515625, -2172.6396484375, 13.101440429688, false },
	{  2716.66015625, -2147.59375, 10.971279144287, false },
	{  2704.3466796875, -2047.1279296875, 13.379482269287, false },
	{  2499.3974609375, -2047.2900390625, 24.933979034424, false },
	{  2278.5615234375, -2072.6884765625, 13.3828125, false },
	{  2247.1904296875, -2019.169921875, 13.546875, true },
	{  2221.990234375, -2014.83984375, 13.355214118958, false },
	{  2223.560546875, -1974.896484375, 13.39376449585, false },
	{  2324.7978515625, -1974.3759765625, 13.564730644226, false },
	{  2347.7890625, -1995.1572265625, 13.376598358154, true },
	{  2339.6796875, -2014.6171875, 13.545785903931, false },
	{  2248.8076171875, -2019.7265625, 13.546875, false },
	{  2270.4697265625, -2070.4169921875, 13.3828125, false },
	{  2377.48046875, -2177.15625, 22.868391036987, false },
	{  2527.5185546875, -2326.921875, 22.964691162109, false },
	{  2568.34765625, -2416.94921875, 13.634776115417, true, true },
}

function sarapbasla(cmd)		
local oyuncuArac = getPedOccupiedVehicle(getLocalPlayer())
		local oyuncuAracModel = getElementModel(oyuncuArac)
		local kacakciAracModel = 456
if getVehicleOccupant(oyuncuArac, 1) then
	outputChatBox("Reval Roleplay:#ffffff Mesleğe başlamak için araçta tek kişi olması gerekmektedir.",201,201,201,true)
 return
 end
if not getElementData(getLocalPlayer(), "sarapSoforlugu") then
if oyuncuAracModel == kacakciAracModel then
			setElementData(getLocalPlayer(), "sarapSoforlugu", true)
			updatesarapRota()
			addEventHandler("onClientMarkerHit", resourceRoot, sarapRotaMarkerHit)
		end
	else
		outputChatBox("Reval Roleplay:#ffffff Zaten mesleğe başladınız.",201,201,201,true)
	end
end
addCommandHandler("sarapbasla", sarapbasla)

function updatesarapRota()
	sarapMarker = sarapMarker + 1
	for i,v in ipairs(sarapRota) do
		if i == sarapMarker then
			if not v[4] == true then
				local rotaMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 0, 255, 0, 255)
				table.insert(sarapCreatedMarkers, { rotaMarker, false })
			elseif v[4] == true and v[5] == true then 
				local bitMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255)
				table.insert(sarapCreatedMarkers, { bitMarker, true, true })	
			elseif v[4] == true then
				local malMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255)
				table.insert(sarapCreatedMarkers, { malMarker, true, false })			
			end
		end
	end
end

function sarapRotaMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 456 then
				for _, marker in ipairs(sarapCreatedMarkers) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							updatesarapRota()
						elseif marker[2] == true and marker[3] == true then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitVehicle, true)
							setElementFrozen(hitPlayer, true)
							toggleAllControls(false, true, false)
							sarapMarker = 0
							triggerServerEvent("sarapParaVer", hitPlayer, hitPlayer)
							outputChatBox("Reval Roleplay:#ffffff Kamyonunuza yeni şaraplar yükleniyor, lütfen bekleyiniz.",201,201,201,true)
							--outputChatBox("[!] #FFFFFFAracınıza yeni mallar yükleniyor, lütfen bekleyiniz. Eğer devam etmek istemiyorsanız, /copculukbitir yazınız.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("Reval Roleplay:#ffffff Kamyonunuza yeni şaraplar yüklenmiştir, devam edebilirsiniz.",201,201,201,true)
									--outputChatBox("[!] #FFFFFFAracınıza yeni mallar yüklenmiştir. Gidebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updatesarapRota()
								end, 5000, 1, hitPlayer, hitVehicle, source
							)	
						elseif marker[2] == true and marker[3] == false then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitPlayer, true)
							setElementFrozen(hitVehicle, true)
							toggleAllControls(false, true, false)
							outputChatBox("Reval Roleplay:#ffffff Kamyonunuzdaki şaraplar indiriliyor, lütfen bekleyiniz.",201,201,201,true)
						--	outputChatBox("[!] #FFFFFFAracınızdaki mallar indiriliyor, lütfen bekleyiniz.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("Reval Roleplay:#ffffff Kamyonunuzdaki şaraplar indirilmiştir, devam edebilirsiniz.",201,201,201,true)
								--	outputChatBox("[!] #FFFFFFAracınızdaki mallar indirilmiştir, geri dönebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updatesarapRota()
								end, 5000, 1, hitPlayer, hitVehicle, source
							)						
						end
					end
				end
			end
		end
	end
end

function sarapBitir()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	local sarapSoforlugu = getElementData(getLocalPlayer(), "sarapSoforlugu")
	if pedVeh then
		if pedVehModel == 456 then
			if sarapSoforlugu then
				exports.rl_global:fadeToBlack()
				setElementData(getLocalPlayer(), "sarapSoforlugu", false)
				for i,v in ipairs(sarapCreatedMarkers) do
					destroyElement(v[1])
				end
				sarapCreatedMarkers = {}
				sarapMarker = 0
				triggerServerEvent("sarapBitir", getLocalPlayer(), getLocalPlayer())
				removeEventHandler("onClientMarkerHit", resourceRoot, sarapRotaMarkerHit)
				removeEventHandler("onClientVehicleStartEnter", getRootElement(), sarapAntiYabanci)
				setTimer(function() exports.rl_global:fadeFromBlack() end, 2000, 1)
			end
		end
	end
end
addCommandHandler("sarapBitir", sarapBitir)

function sarapAntiAracTerketme(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		local theVehicle = source
		if seat == 0 then
			sarapBitir()
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), sarapAntiAracTerketme)