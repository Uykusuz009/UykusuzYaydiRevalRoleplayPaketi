--
function ustAramas(thePlayer, cmdName, targetPlayer)
	local logged = getElementData(thePlayer, "logged")
	
	if (logged==1) then
		if getElementData(thePlayer, "ustArama") then
			outputChatBox("[!]#FFFFFF Aynı anda birden fazla kişinin üstünü arayamazsınız!", thePlayer, 255, 0, 0, true)
			return false
		end

		if not (targetPlayer) then
			outputChatBox("[!]#FFFFFF KULLANIM: /" .. cmdName .. " [Kişi Adı / ID]", thePlayer, 255, 194, 14, true)
		else
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer == thePlayer then
				outputChatBox("[!]#FFFFFF Kendi üzerinizi arayamazsınız.", thePlayer, 255, 0, 0, true)
				return
			end
			
			if targetPlayer then
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
			
				local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
				
				if (distance<=5) then
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli şahsa üst arama isteği gönderilmiştir.", thePlayer, 0, 255, 0, true)
					triggerClientEvent(targetPlayer, "pd:ustAramaOnayGUI", thePlayer, thePlayer, targetPlayer)
				else
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli şahısdan uzaksınız.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("ustaraxx", ustAramas)

function aramaKabul(thePlayer, targetPlayer)
	if thePlayer and targetPlayer then
		local para = exports.rl_global:getMoney(targetPlayer)
		local pistol, deagle, uzi, tec9, mp5, shotgun, ak47, m4, sniper = false
		
		local silahlar = getPedWeapons(targetPlayer)
		local deagle, uzi, tec9, mp5, shotgun, ak47, m4, sniper = false
		for i, v in ipairs(silahlar) do
			if v == 28 then
				uzi = true
			elseif v == 24 then
				deagle = true
			elseif v == 32 then
				tec9 = true
			elseif v == 29 then
				mp5 = true
			elseif v == 25 then
				shotgun = true
			elseif v == 30 then
				ak47 = true
			elseif v == 31 then
				m4 = true
			elseif v == 34 then
				sniper = true
			end
		end
		
		local marijuana = exports["rl_items"]:countItem(targetPlayer, 38)
		local kokain = exports["rl_items"]:countItem(targetPlayer, 34)
		local mantar = false
		local eroin = exports["rl_items"]:countItem(targetPlayer, 37)
		local ekstazi = exports["rl_items"]:countItem(targetPlayer, 36)
		local meth = exports["rl_items"]:countItem(targetPlayer, 39)
		
		local telefon = exports["rl_items"]:hasItem(targetPlayer, 2)
		local telsiz = exports["rl_items"]:hasItem(targetPlayer, 6)
	
		outputChatBox("[!]#FFFFFF Para: $" .. exports.rl_global:formatMoney(para), thePlayer, 0, 0, 255, true)
		outputChatBox("[!]#FFFFFF Telefon: " .. (telefon and "[#ff0000VAR#FFFFFF]" or "[#ff0000YOK#FFFFFF]") .. " - Telsiz:" .. (telsiz and "[#ff0000VAR#FFFFFF]" or "[#ff0000YOK#FFFFFF]"), thePlayer, 0, 0, 255, true)
		outputChatBox("[!]#FFFFFF Pistol: " .. (pistol and "[#ff0000VAR#FFFFFF]" or "[#ff0000YOK#FFFFFF]") .. " - Deagle:" .. (deagle and "[#ff0000VAR#FFFFFF]" or "[#ff0000YOK#FFFFFF]") .. " UZI:" .. (uzi and "[#ff0000VAR#FFFFFF]" or "[#ff0000YOK#FFFFFF]"), thePlayer, 0, 0, 255, true)
		outputChatBox("[!]#FFFFFF TEC9: " .. (tec9 and "[#ff0000VAR#FFFFFF]" or "[#ff0000YOK#FFFFFF]") .. " - MP5:" .. (mp5 and "[#ff0000VAR#FFFFFF]" or "[#ff0000YOK#FFFFFF]") .. " Pompalı:" .. (shotgun and "[#ff0000VAR#FFFFFF]" or "[#ff0000YOK#FFFFFF]"), thePlayer, 0, 0, 255, true)
		outputChatBox("[!]#FFFFFF AK47: " .. (ak47 and "[#ff0000VAR#FFFFFF]" or "[#ff0000YOK#FFFFFF]") .. " - M4:" .. (m4 and "[#ff0000VAR#FFFFFF]" or "[#ff0000YOK#FFFFFF]") .. " Tüfek:" .. (sniper and "[#ff0000VAR#FFFFFF]" or "[#ff0000YOK#FFFFFF]"), thePlayer, 0, 0, 255, true)
		outputChatBox("[!]#FFFFFF Marijuana: " .. "[" .. marijuana .. "]" .. " - Kokain:" ..  "[" .. kokain .. "]" ..  " Mantar:[0]", thePlayer, 0, 0, 255, true)
		outputChatBox("[!]#FFFFFF Eroin: [" .. eroin .. "] - Ekstazi: [" .. ekstazi .. "] - Methamorphine: [" .. meth .. "]", thePlayer, 0, 0, 255, true)
	end
end
addEvent("pd:aramaKabuls", true)
addEventHandler("pd:aramaKabuls", getRootElement(), aramaKabul)

function aramaRed(thePlayer, targetPlayer)
	if thePlayer and targetPlayer then
		outputChatBox("[!]#FFFFFF Üst arama isteğini başarıyla reddettiniz.", targetPlayer, 0, 255, 0, true)
		outputChatBox("[!]#FFFFFF Üst arama isteğiniz reddedilmiştir.", thePlayer, 255, 0, 0, true)
	end
end
addEvent("pd:aramaReds", true)
addEventHandler("pd:aramaReds", getRootElement(), aramaRed)

function getPedWeapons(ped)
	local playerWeapons = {}
	if ped and isElement(ped) and getElementType(ped) == "ped" or getElementType(ped) == "player" then
		for i=2,9 do
			local wep = getPedWeapon(ped,i)
			if wep and wep ~= 0 then
				table.insert(playerWeapons,wep)
			end
		end
	else
		return false
	end
	return playerWeapons
end