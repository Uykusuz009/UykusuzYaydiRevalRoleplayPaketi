


function arac_tamir (thePlayer)
	local arac = getPedOccupiedVehicle(source)
	setElementData(arac, "tamir_oldumu", 1)
	setTimer(function(arac,oyuncu)
		arac_tamir2(arac, oyuncu)
	end,2600,1,arac,thePlayer)
	 setElementFrozen ( arac, true )
	outputChatBox("[!]#ffffff Aracınız (1-2) saniye içerisin de tamir edilecektir.", thePlayer, 100, 0, 255, true)
end
addEvent("Tamirsistemi:tamir", true)
addEventHandler("Tamirsistemi:tamir", root, arac_tamir)

function arac_tamir2(arac, oyuncu)
	local arac_cani = getElementHealth(arac)
	local hasar = 1000 - arac_cani
	hasar = math.floor(hasar)
	local para = math.floor(hasar * 5)
	local oyuncu_para = getElementData(oyuncu, "money") or 0
	if oyuncu_para < para then
	outputChatBox("[!]#ffffff Maalesef yeterli miktarda paran yok.", oyuncu, 255, 0, 0, true)
	setElementFrozen ( arac, false )
	setElementData(arac, "tamir_oldumu", 0)
	return false end
		if getElementData(arac, "dbid") <= 0 then
		 outputChatBox("[!]#ffffff Bu araç geçici bir araçtır. Tamir edilemez.", oyuncu, 255, 0, 0, true)
		return end
		
		 outputChatBox("[!]#ffffff Aracınız başarıyla tamir edilmiştir. Ücret: ₺"..para, oyuncu, 0, 194, 0, true)
		 fixVehicle(arac) --// ARACIN KAPORTASININ TAMİR EDİLMESİ KALKMIŞTIR
		 setElementData(arac, "tamir_oldumu", 0)
		 exports.rl_global:takeMoney(oyuncu, para)
		 setElementFrozen ( arac, false )
		for i = 0, 5 do
		 setVehicleDoorState(arac, i, 0)
	end
end

--////////// TAMİR OLURKEN ARAÇTAN İNME //////////-

function exitVehicle ( thePlayer, seat, jacked ) 
   if ( getElementData(source, "tamir_oldumu") == 1 ) then 
      outputChatBox ( "[!]#ffffff Araç tamir olurken inemezsiniz.", thePlayer, 255, 0, 0, true )  
      cancelEvent()
   end
end
addEventHandler ( "onVehicleStartExit", getRootElement(), exitVehicle)