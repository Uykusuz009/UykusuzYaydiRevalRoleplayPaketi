mysql = exports.rl_mysql

function kefaletode(plr,yontem,ucret)
	if (yontem == "uzerinden") then
		if not exports.rl_global:hasMoney(plr,ucret) then
			outputChatBox("[!] #FFFFFFMaalesef bunu karşılayamıyorsun.",plr,255,0,0,true)
		return end
			exports.rl_global:takeMoney(plr,ucret)

			plr:setData('hapis_sure', tonumber(0))
			plr:setPosition(1803.0341796875, -1576.34375, 13.409018516541)
			plr:setInterior(0)
			plr:setDimension(0)
			dbExec(mysql:getConnection(), "UPDATE characters SET hapis_sure = '-1', hapis_sebep = '0'  WHERE id = " .. (plr:getData('dbid')))

			outputChatBox("[!] #FFFFFF"..exports.rl_global:formatMoney(ucret).."₺ kefalet ödeyerek hapsini sonlandırdın.",plr,0,255,0,true)

	end	
if (yontem == "bankadan") then
		if not exports.rl_global:hasMoney(plr,ucret) then
			outputChatBox("[!] #FFFFFFMaalesef bunu karşılayamıyorsun.",plr,255,0,0,true)
		return end
        if getElementData(plr, "bank_money") >= ucret then
		   setElementData(plr, "bank_money", tonumber(getElementData(plr, "bank_money")) - ucret)

		   plr:setData('hapis_sure', tonumber(0))
		   plr:setPosition(1803.0341796875, -1576.34375, 13.409018516541)
		   plr:setInterior(0)
		   plr:setDimension(0)
		   dbExec(mysql:getConnection(), "UPDATE characters SET hapis_sure = '-1', hapis_sebep = '0'  WHERE id = " .. (plr:getData('dbid')))

		   outputChatBox("[!] #FFFFFF"..exports.rl_global:formatMoney(ucret).."₺ kefalet ödeyerek hapsini sonlandırdın.",plr,0,255,0,true)
		end
	end
end
addEvent("kefalet",true)
addEventHandler("kefalet",root,kefaletode)

setTimer(function()
	for i,v in ipairs(getElementsByType("player")) do
		local jailTime = v:getData("hapis_sure")
		local loggedin = v:getData("logged")
		if loggedin then
			if jailTime and (tonumber(jailTime) and tonumber(jailTime) > 0) or jailTime == "permanently" then
				if v.dimension ~= 5 then
					v.dimension = 5
				end
			end
		end
	end
end,1000,0)