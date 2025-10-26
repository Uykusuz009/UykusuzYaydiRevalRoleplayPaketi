local mysql = exports.rl_mysql
local tax = 15
local incometax = 10

function getTaxAmount()
	return tax / 100
end

function setTaxAmount(new)
	tax = math.max(0, math.min(30, math.ceil(new)))
end

function getIncomeTaxAmount()
	return incometax / 100
end

function setIncomeTaxAmount(new)
	incometax = math.max(0, math.min(25, math.ceil(new)))
end

function giveMoney(thePlayer, amount)
	amount = tonumber(amount) or 0
	if amount == 0 then
		return true
	elseif thePlayer and isElement(thePlayer) and amount > 0 then
		amount = math.floor(amount)
		if getElementType(thePlayer) == "player" then
			if not dbExec(mysql:getConnection(), "UPDATE characters SET money = money + " .. amount .. " WHERE id = '" ..  getElementData(thePlayer, "dbid")  .. "'") then
				return false
			end
			
			if not setElementData(thePlayer, "money", getMoney(thePlayer) + amount) then
				return false
			end
			
			triggerClientEvent(thePlayer, "moneyUpdateFX", thePlayer, true, amount)
			return true
		elseif getElementType(thePlayer) == "team" then
			return dbExec(mysql:getConnection(), "UPDATE factions SET bankbalance = bankbalance + " .. amount .. " WHERE id = " .. getElementData(thePlayer, "id")) and setElementData(thePlayer, "money", getMoney(thePlayer) + amount) 
		end
	end
	return false
end

function takeMoney(thePlayer, amount, rest)
	amount = tonumber(amount) or 0
	if amount == 0 then
		return true, 0
	elseif thePlayer and isElement(thePlayer) and amount > 0 then
		amount = math.ceil(amount)
		
		local money = getMoney(thePlayer)
		if rest and amount > money then
			amount = money
		end
		
		if amount == 0 then
			return true, 0
		elseif hasMoney(thePlayer, amount) then
			if getElementType(thePlayer) == "player" then
				if not dbExec(mysql:getConnection(), "UPDATE characters SET money = money - " .. amount .. " WHERE id = '" ..  getElementData(thePlayer, "dbid")  .. "'") then
					return false
				end

				if not setElementData(thePlayer, "money", money - amount) then
					return false
				end
				
				triggerClientEvent(thePlayer, "moneyUpdateFX", thePlayer, false, amount)
				return true, amount
			elseif getElementType(thePlayer) == "team" then
				return dbExec(mysql:getConnection(), "UPDATE factions SET bankbalance = bankbalance - " .. amount .. " WHERE id = " .. getElementData(thePlayer, "id")) and setElementData(thePlayer, "money", money - amount)	
			end
			return false, 0
		end
	end
	return false, 0
end

function setMoney(thePlayer, amount, onSpawn)
	amount = tonumber(amount) or 0
	if thePlayer and isElement(thePlayer) and (amount >= 0 or onSpawn) then
		amount = math.floor(amount)
		if getElementType(thePlayer) == "player" then
			if not onSpawn then
				if not dbExec(mysql:getConnection(), "UPDATE characters SET money = " .. amount .. " WHERE id = " .. getElementData(thePlayer, "dbid")) then
					return false
				end
			end

			local currentMoney = getElementData(thePlayer, "money")

			if not setElementData(thePlayer, "money", amount) then
				return false
			end
			
			if not onSpawn then
				if amount > currentMoney then
					triggerClientEvent(thePlayer, "moneyUpdateFX", thePlayer, true, amount-currentMoney)
				elseif amount < currentMoney then
					triggerClientEvent(thePlayer, "moneyUpdateFX", thePlayer, false, currentMoney-amount)
				end
			end

			return true
		elseif getElementType(thePlayer) == "team" then
			return dbExec(mysql:getConnection(), "UPDATE factions SET bankbalance = " .. amount .. " WHERE id = " .. getElementData(thePlayer, "id")) and setElementData(thePlayer, "money", amount)
		end
	end
end

function hasMoney(thePlayer, amount)
	amount = tonumber(amount) or 0
	if thePlayer and isElement(thePlayer) and amount >= 0 then
		amount = math.floor(amount)
		
		return getMoney(thePlayer) >= amount
	end
	return false
end

function getMoney(thePlayer)
	return getElementData(thePlayer, "money") or 0
end

function formatMoney(amount)
	if not amount or not tonumber(amount) or amount == 0 then
		return 0
	end
	local left, num, right = string.match(tostring(amount), "^([^%d]*%d)(%d*)(.-)$")
	return left .. (num:reverse():gsub("(%d%d%d)", "%1,"):reverse()) .. right
end

local moneyLimitTimers = {}
local bankMoneyLimitTimers = {}

addEventHandler("onElementDataChange", root, function(theKey, oldValue, newValue)
	if theKey == "money" then
		local money = (tonumber(newValue)) or 0
		
		if money > 500000000 then
			moneyLimitTimers[source] = setTimer(function(source)
				setMoney(source, 500000000)
				outputChatBox("[!]#FFFFFF Para miktarınız $500,000,000 sınırını aştığı için $500,000,000'a düşürüldü.", source, 255, 0, 0, true)
				playSoundFrontEnd(source, 4)
			end, 1000, 1, source)
		end
	
		setPlayerMoney(source, money, true)
	elseif theKey == "bank_money" then
		local bankMoney = (tonumber(newValue)) or 0
		
		if bankMoney > 500000000 then
			bankMoneyLimitTimers[source] = setTimer(function(source)
				setElementData(source, "bank_money", 500000000)
				dbExec(mysql:getConnection(), "UPDATE characters SET bank_money = ? WHERE id = ?", 500000000, getElementData(source, "dbid"))
				outputChatBox("[!]#FFFFFF Banka para miktarınız $500,000,000 sınırını aştığı için $500,000,000'a düşürüldü.", source, 255, 0, 0, true)
				playSoundFrontEnd(source, 4)
			end, 1000, 1, source)
		end
	end
end)