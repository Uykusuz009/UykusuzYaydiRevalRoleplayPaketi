local elmasBolge = createColSphere (-110.828125, 1982.8037109375, -12.703633308411, 40, 3, 81)
addCommandHandler("elmas", function(plr, cmd,komut)

local Kazma = 361
local ElmasFiyati = (1420+80)*2
local IslenmisElmas = 360

local SunucuAdi = "Reval"

if not isElementWithinColShape(plr, elmasBolge) then
outputChatBox("["..SunucuAdi.."]#ffffff Burada elmas kazıması yapamazsın.",plr,255,0,0,true)
return end

if not exports.rl_global:hasItem(plr,Kazma) then outputChatBox("["..SunucuAdi.."]#ffffff Bakır kazabilmek için 'Kazma' satın almalısın.",plr,255,194,14,true) return end
--if exports.rl_global:hasItem(plr,IslenmisElmas) then outputChatBox("[!]#ffffff Envanterinde işlenmiş elmas Elmasıyorken elmas kazamazsın.",plr,255,194,14,true) return end
if getElementData(plr, "elmas:durum") then
	exports['rl_bildirim']:addNotification(plr, "Elmas kazabilmen için 5 dakika beklemen gerekiyor.", "error")
	--outputChatBox("["..SunucuAdi.."]#ffffff Elmas toplayabilmen için 5 dakika beklemen gerekiyor.",plr,255,0,0,true)
return end

	if not komut then
		outputChatBox("["..SunucuAdi.."]#FFFFFF /"..cmd.." [kaz] yazarak kazabilirsiniz.",plr,255,194,14,true)
	return end
	
if komut == "kaz" then
local randomdeger = math.random(1,1)
	exports['rl_bildirim']:addNotification(plr, "Elmas kazmaya başladın.", "info")
	--outputChatBox("["..SunucuAdi.."]#ffffff Elmas kazmaya başladın..",plr,0,255,0,true)
	setElementData(plr, "elmas:durum", true)
	exports.rl_global:applyAnimation(plr, "BASEBALL", "bat_4", -1, true, false, false)	
	setTimer(function()
for i=1, randomdeger, 1 do
	exports["rl_items"]:giveItem(plr,IslenmisElmas,1)
end
		exports['rl_bildirim']:addNotification(plr, "Tebrikler, işlenmiş madeninizi artık kuyumcuda satabilirsiniz.", "info")
		--outputChatBox("["..SunucuAdi.."]#ffffff Tebrikler, işlenmiş madeninizi artık kuyumcuda satabilirsiniz.",plr,0,255,0,true)
		exports.rl_global:removeAnimation(plr)			
		setTimer(function()
		outputChatBox("["..SunucuAdi.."]#ffffff Süren doldu, yeniden Elmas toplayabilirsin.",plr,0,255,0,true)
			setElementData(plr, "elmas:durum", nil)
		end, 300000, 1)
	end, 10000, 1)

end

end)