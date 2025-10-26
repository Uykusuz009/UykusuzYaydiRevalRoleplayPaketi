local price = 200 -- meth başına verilecek para

local pots = {}
local delays = {}
local regions = {
	[1] = createColSphere(2161.724609375, -102.51953125, 2.75, 75),
	[2] = createColSphere(2443.9306640625, -1976.9951171875, 13.546875, 1.5)
}
local pickup = createPickup(2443.9306640625, -1976.9951171875, 13.546875, 3, 1239)
setElementData(pickup, "informationicon:information", "#D1AB51/meth Sat#ffffff\nmeth Satma Noktası")

addCommandHandler("meth", function(player, command, type)
	if type then
		if (type == "yap") then
			if isElementWithinColShape(player, regions[1]) then
				local x, y, z = getElementPosition(player)
				if pots[player] then
					outputChatBox("[!]#ffffff Zaten ekili bir methiniz var önce onu toplayın.", player, 255, 0, 0, true)
					return
				end
				pots[player] = {}
				pots[player][1] = createObject(2203, x, y, z-0.8, 0, 0, 140)
				pots[player][3] = 20
				outputChatBox("[!]#ffffff meth yaptınız, toplamak için /meth topla.", player, 0, 255, 0, true)
			else
				outputChatBox("[!]#ffffff meth yapma yerinde değilsiniz.", player, 255, 0, 0, true)
			end
		elseif (type == "kaldır") then
			if pots[player] then
				destroyElement(pots[player][1])
				destroyElement(pots[player][2])
				pots[player][3] = nil
				pots[player] = nil
				collectgarbage("collect")
				outputChatBox("[!]#ffffff Hazırladığınız methi kaldırdınız.", player, 0, 255, 0, true)
			else
				outputChatBox("[!]#ffffff Hazır olan bir methiniz yok.", player, 255, 0, 0, true)
			end
		elseif (type == "topla") then
			if pots[player] then
				local x, y, z = getElementPosition(player)
				local vx, vy, vz = getElementPosition(pots[player][1])
				if getDistanceBetweenPoints3D(x, y, z, vx, vy, vz) <= 2 then
					if not delays[player] then
						delays[player] = setTimer(function(thePlayer)
							if thePlayer then
								delays[thePlayer] = nil
								collectgarbage("collect")
							end
						end, 3500, 1, player)
						setPedAnimation(player, "bomber", "bom_plant", -1, false, false, false, false)
						local current = tonumber(getElementData(player, "methmiktar")) or 0
						if current < 20 then
							setElementData(player, "methmiktar", current + 1)
							local new = tonumber(getElementData(player, "methmiktar")) or 0
							outputChatBox("[!]#ffffff Üzerinizdeki meth miktarı: "..new.." adet.", player, 0, 255, 0, true)
							pots[player][3] = tonumber(pots[player][3] - 1) or 0
							if tonumber(pots[player][3]) <= 0 then
								destroyElement(pots[player][1])
								destroyElement(pots[player][2])
								pots[player][3] = nil
								pots[player] = nil
								collectgarbage("collect")
							end
						else
							outputChatBox("[!]#ffffff Üzerinizde çok fazla meth var, önce onu satmalısınız.", player, 255, 0, 0, true)
						end
					end
				else
					outputChatBox("[!]#ffffff Yaptığınız methden çok uzaksınız.", player, 255, 0, 0, true)
				end
			else
				outputChatBox("[!]#ffffff Yaptığın bir methiniz yok.", player, 255, 0, 0, true)
			end
		elseif (type == "sat") then
			if isElementWithinColShape(player, regions[2]) then
				local current = tonumber(getElementData(player, "methmiktar")) or 0
				if current > 0 then
					local amount = tonumber(current * price)
					exports.rl_global:giveMoney(player, amount)
					outputChatBox("[!]#ffffff "..current.." adet meth sattınız ve "..exports.rl_global:formatMoney(amount).."TL kazandınız!", player, 255, 0, 0, true)
					setElementData(player, "methmiktar", 0)
				else
					outputChatBox("[!]#ffffff Üzerinizde hiç meth yok.", player, 255, 0, 0, true)
				end
			end
		end
	else
		outputChatBox("[!]#ffffff /meth [yap - kaldır - topla - sat]", player, 0, 255, 0, true)
	end
end, false, false)