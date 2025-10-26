local mysql = exports.rl_mysql
local kirmayeri = createColSphere(1422.69140625, -1292.216796875, 13.560044288635, 3)

addEvent("cuff.getAnim",true)
local cuffed = {}
local controls = {"fire", "next_weapon", "previous_weapon", "jump", "action", "aim_weapon", "vehicle_fire", "vehicle_secondary_fire", "vehicle_left", "vehicle_right", "steer_forward", "steer_back", "accelerate", "brake_reverse", "sprint"}
local cuffedFuncs = {}

function isElementInRange(ele, x, y, z, range)
	if isElement(ele) and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(range) == "number" then
		return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.
	end
	return false
end

addEvent("onPlayerCuff", true)
addEventHandler("onPlayerCuff", root, function(type, player)
	if type == "cuff" then
		kelepcele(source, _, getPlayerName(player))
	elseif type == "uncuff" then
		kelepceCikar(source, _, getPlayerName(player))
	end
end)

function kelepcele(thePlayer, commandName, targetPlayer)
	if isElement(thePlayer:getTeam()) then
		if thePlayer:getData("faction") == 1 then
			if targetPlayer then
				if not exports.rl_global:hasItem(thePlayer, 45) then
					outputChatBox("[!]#FFFFFF Kelepçeleme yapmak için kelepçeye ihtiyacın var.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
					return
				end
				local target = exports.rl_global:findPlayerByPartialNick(targetPlayer)
				if target then
					if isElement(target) then
						local x,y,z = getElementPosition(thePlayer)
						if isElementInRange(target, x, y, z, 5) then 
							if not cuffed[thePlayer] then
								cuffed[thePlayer] = {}
							end	
							exports.rl_global:takeItem(thePlayer, 45)
							thePlayer:setAnimation("BD_FIRE", "warl_up", 1000, false, true, false, false)
							target:setData("restrain", 1)
							target:setAnimation("sword", "sword_block", 1000, false, true, false)
							for i, v in ipairs(controls) do
								toggleControl(target, v, false)
							end
							triggerEvent("sendLocalMeAction", thePlayer, thePlayer, "ellerini teçhizat kemerine götürerek kelepçeyi alır ve şahsın ellerini ters tutarak kelepçeler.")
							outputChatBox("[!]#FFFFFF " .. target:getName() .. " isimli oyuncu kelepçelendi.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. thePlayer:getName() .. " isimli oyuncu sizi kelepçeledi.", target, 0, 0, 255, true)
							setElementData(target, "kelepceli", true)
							exports["rl_items"]:giveItem(thePlayer, 47, 1) 
							cuffedFuncs[target:getName()] = setTimer(function() end, 2000, 0)
							cuffed[thePlayer][target:getName()] = true
							cuffedFuncs[thePlayer] = setTimer(function (target)
								if not isElement(target) then return end
								setPedAnimationProgress(target,"sword_block",1.0)
								for i, v in ipairs(controls) do
									toggleControl(target, v, false)
								end
							end, 50, 0, target)
							giveWeapon(target, 1, 1, true)
						else
							outputChatBox("[!]#FFFFFF Kelepçe takmak için oyuncuya yakın olman gerekli.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					end
				else
					outputChatBox("[!]#FFFFFF Eşleşecek kimse bulunamadı.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else	
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("[!]#FFFFFF Bu işlemi yalnızca Los Santos Police Department üyeleri yapabilir.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("[!]#FFFFFF Bu işlemi yalnızca Los Santos Police Department üyeleri yapabilir.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("kelepcele", kelepcele)

function kelepceKirma(thePlayer, commandName)
	if not isElementWithinColShape(thePlayer, kirmayeri) then
		outputChatBox("[!]#FFFFFF Bu alanda kelepçe kıramazsın.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	else
		local restrain = getElementData(thePlayer, "restrain")
		
		if restrain == 0 then
			outputChatBox("[!]#FFFFFF Zaten kelepçeli değilsin.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		else
			cuffed[thePlayer] = nil
			thePlayer:setData("restrain", 0)
			for i, v in ipairs(controls) do
				toggleControl(thePlayer, v, true)
			end
			exports.rl_global:sendLocalMeAction(thePlayer, "sağ ve sol elindeki kelepçeyi çöp tenekesinin ucuna vurarak kırmayaya çalışır.", false, true)
			exports.rl_global:sendLocalDoAction(thePlayer, "Kelepçe kırılmıştır.", false, true)
			outputChatBox("[!]#FFFFFF Kelepçe başarıyla kırıldı.", thePlayer, 0, 255, 0, true)
			setElementData(thePlayer, "kelepceli", false)
			killTimer(cuffedFuncs[thePlayer:getName()])
			killTimer(cuffedFuncs[thePlayer])
			takeWeapon(target, 1)
		end
	end
end
addCommandHandler("kelepcekir", kelepceKirma, false, false)

function kelepceCikar(thePlayer, commandName, targetPlayer)
	if targetPlayer then
		local target = exports.rl_global:findPlayerByPartialNick(targetPlayer)
		if target then
			if target:getData("restrain") == 1 then
				if isElement(target) then
					local x, y, z = getElementPosition(thePlayer)
					if isElementInRange(target, x, y, z, 5) then 
						cuffed[thePlayer] = nil
						target:setData("restrain", 0)
						for i, v in ipairs(controls) do
							toggleControl(target, v, true)
						end
						outputChatBox("[!]#FFFFFF " .. target:getName() .. " isimli oyuncunun kelepçesini çıkardınız.", thePlayer, 0, 0, 255, true)
						outputChatBox("[!]#FFFFFF " .. thePlayer:getName() .. " isimli oyuncu kelepçenizi çıkardı.", target, 0, 0, 255, true)
						setElementData(target, "restrain", false)
						killTimer(cuffedFuncs[target:getName()])
						killTimer(cuffedFuncs[thePlayer])
						takeWeapon(target, 1)
					else
						outputChatBox("[!]#FFFFFF Kelepçe çıkarmak için oyuncuya yakın olman gerekli.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				end
			else
				outputChatBox("[!]#FFFFFF Bu oyuncu zaten kelepçeli değil.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("[!]#FFFFFF Eşleşecek kimse bulunamadı.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else	
		outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("kelepcecikar", kelepceCikar)