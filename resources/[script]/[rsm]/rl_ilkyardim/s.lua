function ilkyardim(thePlayer , commandName , target)
	local username = getPlayerName(thePlayer)
	local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, target)
	local health = tonumber(getElementHealth(targetPlayer))
	local px, py, pz = getElementPosition(thePlayer)
	local tx, ty, tz = getElementPosition(targetPlayer)
	if not (exports.rl_global:hasItem(thePlayer, 4999))then
		exports["rl_bildirim"]:create(thePlayer, "Gerekli eşyaya sahip değilsiniz.", "error")
		return
	end
	if not (target) then outputChatBox("Kullanım: /" .. commandName .. " [ID / İsim]", thePlayer, 255, 255, 0) return end
	if (thePlayer == targetPlayer) then exports["rl_bildirim"]:create(thePlayer, "İlk yardımı kendinize uygulayamazsınız.", "error") return end
	if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) < 5 then 
		if health >= 70 then exports["rl_bildirim"]:create(thePlayer, "İlk yardım kitini şuan uygulayamazsınız.", "error") return end
			if not (thePlayer == targetPlayer) then
			exports["rl_bildirim"]:create(thePlayer, "" .. targetPlayerName .." adlı oyuncuya ilk yardım uyguluyorsunuz. Yaklaşık 15 saniye sonra işlem sona erecek.", "info")
			exports["rl_bildirim"]:create(targetPlayer, "" .. username .." adlı oyuncu size ilk yardım uyguluyor. Yaklaşık 15 saniye sonra işlem sona erecek.", "info")
			end
			exports.rl_global:applyAnimation(thePlayer, "BOMBER", "BOM_plant", 1, false, false, false, false)
			exports.rl_global:applyAnimation(targetPlayer, "CRACK", "crckidle1", 1, false, false, false, false)
            exports.rl_global:sendLocalMeAction(thePlayer, "sağ/sol elini cebine/çantasına atar ve ilk yardım çantasını çıkarır.", false, true)
			exports.rl_global:sendLocalMeAction(thePlayer, "sağ/sol eli ile çantayı aralayarak yaralı kişiye ilk yardım uygular.", false, true)
			exports.rl_global:takeItem(thePlayer, 4999 , 1)
            setElementFrozen(thePlayer, true)
            setElementFrozen(targetPlayer, true)
			toggleAllControls(thePlayer, false)
			toggleAllControls(targetPlayer, false)

			setTimer(function()
				setElementFrozen(thePlayer, false)
				setElementFrozen(targetPlayer, false)
				toggleAllControls(thePlayer, true)
				toggleAllControls(targetPlayer, true)
				setElementHealth(targetPlayer, tonumber(health+21))	
				exports["rl_bildirim"]:create(targetPlayer, "İlk yardım sona erdi. [+20HP]", "success")
			end, 15000, 1)
	else
		exports["rl_bildirim"]:create(thePlayer, "" .. targetPlayerName .." adlı oyuncuya İlk Yardım Kiti'ni uygulayabilmen için daha yakın olman gerekiyor.", "error")
	end
end
addCommandHandler("ilkyardim" , ilkyardim)