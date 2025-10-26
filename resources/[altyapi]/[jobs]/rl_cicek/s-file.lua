mysql = exports.rl_mysql

-- Toplama markerı alanı büyütüldü (3), satış markerı biraz büyütüldü (2.5)
toplamamarker = createMarker(1872.6982421875, -1236.8017578125, 12.745145797729, "cylinder", 12, 10, 177, 255, 20)
satmarker = createMarker(1884.107421875, -1268.2333984375, 12.546875, "cylinder", 3.5, 10, 177, 255, 20)

function cicekbindsoygun()
	local players = exports.rl_pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		if not(isKeyBound(arrayPlayer, "e", "down", cicek_gir)) then
			bindKey(arrayPlayer, "e", "down", cicek_gir)
		end
	end
end

function ciceksoygunbind()
	bindKey(source, "e", "down", cicek_gir)
end
addEventHandler("onResourceStart", getResourceRootElement(), cicekbindsoygun)
addEventHandler("onPlayerJoin", getRootElement(), ciceksoygunbind)

function cicek_gir(thePlayer)
	x,y,z = getElementPosition(thePlayer)
	if getElementData(thePlayer, "bind:engel") then return end
	if isPedInVehicle(thePlayer) then return end

	if isElementWithinMarker(thePlayer, toplamamarker) then
		if getElementData(thePlayer, "dead") == 1 then exports.rl_infobox:addBox(thePlayer, "error", "Baygın olduğun için cicek toplayamazsın.") return end
		if z > 20.3 then exports.rl_infobox:addBox(thePlayer, "error", "Önce bir yere in akıllı.") return end	
		setElementFrozen(thePlayer, true)	
		exports.rl_global:applyAnimation(thePlayer,"bomber", "bom_plant_loop", -1, true, false, false)
		triggerClientEvent(thePlayer, "cicek:toplama", thePlayer)
		setElementData(thePlayer, "cicek:top", true)
		setElementData(thePlayer, "bind:engel", true)
	elseif isElementWithinMarker(thePlayer, satmarker) then
		if exports.rl_global:hasItem(thePlayer, 102) then
			-- Satış işlemi: Süre sonunda direkt satış
			setElementFrozen(thePlayer, true)
			exports.rl_global:applyAnimation(thePlayer,"ped", "IDLE_CHAT", -1, true, false, false)
			setTimer(function()
				exports.rl_global:removeAnimation(thePlayer)
				setElementFrozen(thePlayer, false)
				triggerEvent("cicek:ver", thePlayer, thePlayer)
				setElementData(thePlayer, "cicek:top", false)
				setElementData(thePlayer, "bind:engel", false)
			end, 2000, 1)
		else
			exports.rl_infobox:addBox(thePlayer, "error", "Çicek olmadan satma işlemi yapamazsın.")
		end
	end
end

function cicek_ver(thePlayer)
	if getElementData(thePlayer, "cicek:tur") == "toplama" then
		-- Hile kontrolü: Toplama event süresi kontrolü
		local now = getTickCount()
		local lastCollect = getElementData(thePlayer, "cicek:lastCollect") or 0
		if now - lastCollect < 3200 then
			kickPlayer(thePlayer, "hahahaha")
			setElementFrozen(thePlayer, false)
			exports.rl_global:removeAnimation(thePlayer)
			setElementData(thePlayer, "cicek:top", false)
			setElementData(thePlayer, "bind:engel", false)
			return
		end
		setElementData(thePlayer, "cicek:lastCollect", now)

		setElementFrozen(thePlayer, false)
		exports.rl_global:removeAnimation(thePlayer)
		exports.rl_infobox:addBox(thePlayer, "success", "Bir adet çicek topladın.")
		exports["rl_items"]:giveItem(thePlayer, 102, 1)	
	elseif getElementData(thePlayer, "cicek:tur") == "satma" then
		exports.rl_global:removeAnimation(thePlayer)
		local cicekler = exports["rl_items"]:countItems(thePlayer, 102, 1)
		toplamPara = (cicekler * 300)
		exports.rl_global:giveMoney(thePlayer, toplamPara)
		for i = 0, cicekler do
			exports["rl_items"]:takeItem(thePlayer, 102, 1)
		end
	end	
end
addEvent("cicek:ver", true)
addEventHandler("cicek:ver", root, cicek_ver)

function cicek_e_gostre(player)
setElementData(player, "cicek:e", true)
setElementData(player, "cicek:tur", "toplama")
end
addEventHandler("onMarkerHit", toplamamarker, cicek_e_gostre)
function cicek_e_gizle(player)
setElementData(player, "cicek:e", false)
setElementData(player, "cicek:tur", false)
end
addEventHandler("onMarkerLeave", toplamamarker, cicek_e_gizle)
addEventHandler("onMarkerLeave", satmarker, cicek_e_gizle)
function cicek_e_gostre3(player)
setElementData(player, "cicek:e", true)
setElementData(player, "cicek:tur", "satma")
end
addEventHandler("onMarkerHit", satmarker, cicek_e_gostre3)