local demirBolge = createColSphere (-725.4189453125, 1545.4638671875, 39.087566375732, 40, 3, 81)
addCommandHandler("demir", function(plr, cmd,komut)

local Kazma = 361
local DemirFiyati = (920+80)*2
local IslenmisDemir = 357

local SunucuAdi = "Reval"

if not isElementWithinColShape(plr, demirBolge) then
outputChatBox("["..SunucuAdi.."]#ffffff Burada demir kazıması yapamazsın.",plr,255,0,0,true)
return end

if not exports.rl_global:hasItem(plr,Kazma) then outputChatBox("["..SunucuAdi.."]#ffffff Bakır kazabilmek için 'Kazma' satın almalısın.",plr,255,194,14,true) return end
--if exports.rl_global:hasItem(plr,IslenmisDemir) then outputChatBox("[!]#ffffff Envanterinde işlenmiş demir taşıyorken demir kazamazsın.",plr,255,194,14,true) return end
if getElementData(plr, "demir:durum") then
	exports['rl_bildirim']:addNotification(plr, "Demir kazabilmen için 5 dakika beklemen gerekiyor.", "error")
	--outputChatBox("["..SunucuAdi.."]#ffffff Demir kazabilmen için 5 dakika beklemen gerekiyor.",plr,255,0,0,true)
return end

	if not komut then
		outputChatBox("["..SunucuAdi.."]#FFFFFF /"..cmd.." [kaz] yazarak toplayabilirsiniz.",plr,255,194,14,true)
	return end
	
if komut == "kaz" then
local randomdeger = math.random(1,1)
	exports['rl_bildirim']:addNotification(plr, "Demir kazmaya başladın.", "info")
	--outputChatBox("["..SunucuAdi.."]#ffffff Demir toplamaya başladın..",plr,0,255,0,true)
	setElementData(plr, "demir:durum", true)
	exports.rl_global:applyAnimation(plr, "BASEBALL", "bat_4", -1, true, false, false)
	setTimer(function()
for i=1, randomdeger, 1 do
	exports["rl_items"]:giveItem(plr,IslenmisDemir,1)
end
		exports['rl_bildirim']:addNotification(plr, "Tebrikler, işlenmiş madeninizi artık kuyumcuda satabilirsiniz.", "info")
		--outputChatBox("["..SunucuAdi.."]#ffffff Tebrikler, işlenmiş madeninizi artık kuyumcuda satabilirsiniz.",plr,0,255,0,true)
		exports.rl_global:removeAnimation(plr)	
		setTimer(function()
		outputChatBox("["..SunucuAdi.."]#ffffff Süren doldu, yeniden demir toplayabilirsin.",plr,0,255,0,true)
			setElementData(plr, "demir:durum", nil)
		end, 300000, 1)
	end, 10000, 1)

end

end)