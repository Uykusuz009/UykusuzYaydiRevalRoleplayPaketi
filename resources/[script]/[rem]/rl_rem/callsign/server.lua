
addCommandHandler("callsign",function(plr,cmd,...)
	if plr:getData("faction") == 1 then
		if not plr:getOccupiedVehicle() then
			outputChatBox("#575757Reval:#ffffff Bu komutu yalnızca aracın içerisinde kullanabilirsiniz.",plr,255,0,0,true)
		return end
			if not ... then 
			exports["rl_notification"]:create(plr, "Kullanım: /"..cmd.." [Birim Kodu]", "info")
			plr:getOccupiedVehicle():setData("callsign", nil)
			return end
			local kod = table.concat({...}, " ")
			plr:getOccupiedVehicle():setData("callsign", kod)
	end
end)