
addCommandHandler("callsign",function(plr,cmd,...)
	if plr:getData("faction") == 1 or plr:getData("faction") == 3 then
		if not plr:getOccupiedVehicle() then
			outputChatBox("[!]#FFFFFF Bu komutu yalnızca aracın içerisinde kullanabilirsiniz.",plr,255,0,0,true)
		return end
			if not ... then 
			exports["rl_infobox"]:addBox(plr, "info", "Kullanım: /" .. cmd .. " [Birim Kodu]")
			plr:getOccupiedVehicle():setData("callsign", nil)
			return end
			local kod = table.concat({...}, " ")
			plr:getOccupiedVehicle():setData("callsign", kod)
	end
end)