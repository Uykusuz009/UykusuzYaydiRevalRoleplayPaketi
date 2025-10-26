--
function bantla(thePlayer, cmdName, targetPlayer)
	local logged = getElementData(thePlayer, "logged")

	if (logged==1) then
		if not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. cmdName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if getElementData(thePlayer, "bantli") then outputChatBox("[!]#FFFFFF Bantlı durumdayken birini bantlayamazsınız.", thePlayer, 255, 0, 0, true) return end
			if getElementData(thePlayer, "gidenIstek") then outputChatBox("[!]#FFFFFF Zaten bir istek göndermişsiniz.", thePlayer, 255, 0, 0, true) return end
			if targetPlayer == thePlayer then
				outputChatBox("[!]#FFFFFF Kendinizi bantlayamazsınız.", thePlayer, 255, 0, 0, true)
				return
			end
			if exports.rl_global:hasItem(thePlayer, 588) then 
				if targetPlayer then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					local targetPlayerName = getPlayerName(targetPlayer)
					local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
					
					if (distance<=2) then
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli şahısa bantlama isteği gönderilmiştir.", thePlayer, 0, 255, 0, true)
						exports.rl_global:sendLocalMeAction(thePlayer, "yavaşça " .. targetPlayerName.. " isimli şahısın ağzını bantlamaya çalışır.")
						setElementData(thePlayer, "gidenIstek", true)
						triggerClientEvent(targetPlayer, "bant:bantbantlamaOnayGUI", thePlayer, thePlayer, targetPlayer)
					else
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli kişiden çok uzaksınız.", thePlayer, 255, 0, 0, true)
					end
				end
			else
				outputChatBox("[!]#FFFFFF Yeterli bantınız yok.", thePlayer, 255, 0, 0, true) 
			end
		end
	end
end
addCommandHandler("bantla", bantla)

function bantlamaKabul(thePlayer, targetPlayer)
	if thePlayer and targetPlayer then
		if exports.rl_global:takeItem(thePlayer, 588) then
			setElementData(targetPlayer, "bantli", true)
			local bantlayan = getPlayerName(thePlayer)
			local bantlanan = getPlayerName(targetPlayer)
			outputChatBox("[!]#FFFFFF " .. bantlayan .. " isimli kişi ağzınızı bantladı.", targetPlayer, 0, 0, 255, true)
			outputChatBox("[!]#FFFFFF " .. bantlanan .. " isimli kişinin ağzını bantladınız.", thePlayer, 0, 255, 0, true)
			outputChatBox("[!]#FFFFFF Bantı çıkartmak için /bantcikar yazınız veya sağ tıklayıp 'Bantı Çıkar' butonuna basınız.", thePlayer, 0, 0, 255, true)
			exports.rl_global:takeItem(thePlayer, 588, 1)
			setElementData(thePlayer, "gidenIstek", nil)
		else
			outputChatBox("[!]#FFFFFF Üzerinizde bant yok.", thePlayer, 255, 0, 0, true)
		end
	end
end
addEvent("bant:bantlamaKabul", true)
addEventHandler("bant:bantlamaKabul", getRootElement(), bantlamaKabul)

function bantlamaRed(thePlayer, targetPlayer)
	if thePlayer and targetPlayer then
		    
		local dotCounter = 0
		local doubleDot = ":"
		if dotCounter < 10000 then
			dotCounter = dotCounter + 200
		elseif dotCounter == 10000 then
			dotCounter = 0
		end
		if dotCounter <= 5000 then
			doubleDot = ":"
		else
			doubleDot = " "
		end
		
		local hour, minute = getRealTime()
		time = getRealTime()
		if time.hour >= 0 and time.hour < 10 then
			time.hour = "0" .. time.hour
		end

		if time.minute >= 0 and time.minute < 10 then
			time.minute = "0" .. time.minute
		end
			
		local realTime = time.hour..doubleDot..time.minute..doubleDot..time.second

		setElementData(thePlayer, "gidenIstek", nil)

		outputChatBox("[!]#FFFFFF Bantlanma isteğini reddettiniz.", targetPlayer, 0, 255, 0, true)
		outputChatBox("[!]#FFFFFF Bantlama isteğiniz reddedilmiştir.", thePlayer, 255, 0, 0, true)
		exports.rl_global:sendLocalMeAction(targetPlayer, "yavaşça kendini geri çeker.")
		exports.rl_global:sendLocalText(targetPlayer, " [" .. realTime .. "] " .. getPlayerName(targetPlayer) .. ": Senin amacın ne?", 230,230,230,5,nil,true)
	end
end
addEvent("bant:bantlamaRed", true)
addEventHandler("bant:bantlamaRed", getRootElement(), bantlamaRed)

function bantCikart(thePlayer, cmdName, targetPlayer)
	local logged = getElementData(thePlayer, "logged")
	
	if (logged==1) then
		if not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. cmdName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14, true)
		else
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if not getElementData(targetPlayer, "bantli") then outputChatBox("[!]#FFFFFF Şahıs zaten bantlı değil.", thePlayer, 255, 0, 0, true) return end
			if targetPlayer == thePlayer then
				outputChatBox("[!]#FFFFFF Kendinizin bantını çıkartamazsınız.", thePlayer, 255, 0, 0, true)
				return
			end
			
			if targetPlayer then
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
				local targetPlayerName = getPlayerName(targetPlayer)
				local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
				
				if (distance<=5) then
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli şahısın ağzındaki bantı çıkarttınız.", thePlayer, 0, 255, 0, true)
					exports.rl_global:sendLocalMeAction(thePlayer, "yavaşça " .. targetPlayerName.. " isimli şahısın ağzındaki bandı çıkartır.")
					setElementData(targetPlayer, "bantli", nil)
					outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer) .. " isimli şahıs ağzınızdaki bandı çıkarttı.", targetPlayer, 255, 0, 255, true)
					exports.rl_global:giveItem(thePlayer, 588, 1)
				else
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli kişiden çok uzaksınız.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("bantcikar", bantCikart)