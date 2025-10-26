function moneyUpdateFX(state, amount, toEachother)
	if exports.rl_settings:getPlayerSetting(localPlayer, "finance_update_visible") then
		if amount and tonumber(amount) and tonumber(amount) > 0  then
			local info = {{"finans güncellemesi"}, {""}}
			local money = localPlayer:getData("money") or 0
			local bankMoney = localPlayer:getData("bank_money") or 0
			
			if state then
				setSoundVolume(playSound("public/sounds/collect_money.ogg"), 0.3)

				table.insert(info, {"Cüzdan: $" .. exports.rl_global:formatMoney(money) .. " (+$" .. exports.rl_global:formatMoney(amount) .. ")"})
				if toEachother then
					table.insert(info, {"Banka: $" .. exports.rl_global:formatMoney(bankMoney - amount)})
				else
					table.insert(info, {"Banka: $" .. exports.rl_global:formatMoney(bankMoney)})
				end
			else
				setSoundVolume(playSound("public/sounds/pay_money.mp3"), 0.3)

				table.insert(info, {"Cüzdan: $" .. exports.rl_global:formatMoney(money) .. " (-$" .. exports.rl_global:formatMoney(amount) .. ")"})
				if toEachother then
					table.insert(info, {"Banka: $" .. exports.rl_global:formatMoney(bankMoney + amount)})
				else
					table.insert(info, {"Banka: $" .. exports.rl_global:formatMoney(bankMoney)})
				end
			end
			
			table.insert(info, {""})
			triggerEvent("hud.drawOverlayTopRight", localPlayer, info)
		end
	end
end
addEvent("moneyUpdateFX", true)
addEventHandler("moneyUpdateFX", root, moneyUpdateFX)