local komurBolge = createColSphere (2113.2080078125, -2009.2138671875, 13.699184417725, 40, 3, 81)
addCommandHandler("komur", function(plr, cmd,komut)

local Kazma = 361
local KomurFiyati = (550+80)*2
local IslenmisKomur = 359

local SunucuAdi = "Reval"

if not isElementWithinColShape(plr, komurBolge) then
outputChatBox("["..SunucuAdi.."]#ffffff Burada kömür kazıması yapamazsın.",plr,255,0,0,true)
return end

if not exports.rl_global:hasItem(plr,Kazma) then outputChatBox("["..SunucuAdi.."]#ffffff Bakır kazabilmek için 'Kazma' satın almalısın.",plr,255,194,14,true) return end
--if exports.rl_global:hasItem(plr,IslenmisKomur) then outputChatBox("[!]#ffffff Envanterinde işlenmiş kömür taşıyorken kömür kazamazsın.",plr,255,194,14,true) return end
if getElementData(plr, "komur:durum") then
	exports['rl_bildirim']:addNotification(plr, "Kömür kazabilmen için 5 dakika beklemen gerekiyor.", "error")
	--outputChatBox("["..SunucuAdi.."]#ffffff Kömür kazabilmen için 5 dakika beklemen gerekiyor.",plr,255,0,0,true)
return end

	if not komut then
		outputChatBox("["..SunucuAdi.."]#FFFFFF /"..cmd.." [kaz] yazarak toplayabilirsiniz.",plr,255,194,14,true)
	return end
	
if komut == "kaz" then
local randomdeger = math.random(1,1)
	exports['rl_bildirim']:addNotification(plr, "Kömür toplamaya başladın.", "info")
	--outputChatBox("["..SunucuAdi.."]#ffffff Kömür toplamaya başladın..",plr,0,255,0,true)
	setElementData(plr, "komur:durum", true)
	exports.rl_global:applyAnimation(plr, "BASEBALL", "bat_4", -1, true, false, false)	
	setTimer(function()
for i=1, randomdeger, 1 do
	exports["rl_items"]:giveItem(plr,IslenmisKomur,1)
end
		exports['rl_bildirim']:addNotification(plr, "Tebrikler, işlenmiş madeninizi artık kuyumcuda satabilirsiniz.", "info")
		--outputChatBox("["..SunucuAdi.."]#ffffff Tebrikler, işlenmiş madeninizi artık kuyumcuda satabilirsiniz.",plr,0,255,0,true)
		exports.rl_global:removeAnimation(plr)		
		setTimer(function()
		outputChatBox("["..SunucuAdi.."]#ffffff Süren doldu, yeniden kömür toplayabilirsin.",plr,0,255,0,true)
			setElementData(plr, "komur:durum", nil)
		end, 300000, 1)
	end, 10000, 1)

end

end)