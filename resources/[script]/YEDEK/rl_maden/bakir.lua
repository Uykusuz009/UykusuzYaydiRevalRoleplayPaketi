local bakirBolge = createColSphere (-782.119140625, -1859.0498046875, 11.620872497559, 40, 3, 81)
addCommandHandler("bakir", function(plr, cmd,komut)

local Kazma = 361
local BakirFiyati = (770+80)*2
local IslenmisBakir = 358

local SunucuAdi = "Reval"

if not isElementWithinColShape(plr, bakirBolge) then
outputChatBox("["..SunucuAdi.."]#ffffff Burada bakır kazıması yapamazsın.",plr,255,0,0,true)
return end

if not exports.rl_global:hasItem(plr,Kazma) then outputChatBox("["..SunucuAdi.."]#ffffff Bakır kazabilmek için 'Kazma' satın almalısın.",plr,255,194,14,true) return end
--if exports.rl_global:hasItem(plr,IslenmisBakir) then outputChatBox("[!]#ffffff Envanterinde işlenmiş bakır taşıyorken bakır kazamazsın.",plr,255,194,14,true) return end
if getElementData(plr, "bakir:durum") then
	exports['rl_infobox']:addNotification(plr, "Bakır kazabilmen için 5 dakika beklemen gerekiyor.", "error")
	--outputChatBox("["..SunucuAdi.."]#ffffff Bakır kazabilmen için 5 dakika beklemen gerekiyor.",plr,255,0,0,true)
return end

	if not komut then
		outputChatBox("["..SunucuAdi.."]#FFFFFF /"..cmd.." [kaz] yazarak toplayabilirsiniz.",plr,255,194,14,true)
	return end
	
if komut == "kaz" then
local randomdeger = math.random(1,1)
	exports['rl_infobox']:addNotification(plr, "Bakır kazmaya başladın.", "info")
	--outputChatBox("["..SunucuAdi.."]#ffffff Bakır toplamaya başladın..",plr,0,255,0,true)
	setElementData(plr, "bakir:durum", true)
	exports.rl_global:applyAnimation(plr, "BASEBALL", "bat_4", -1, true, false, false)	
	setTimer(function()
for i=1, randomdeger, 1 do
	exports["rl_items"]:giveItem(plr,IslenmisBakir,1)
end
		exports['rl_infobox']:addNotification(plr, "Tebrikler, işlenmiş madeninizi artık kuyumcuda satabilirsiniz.", "info")
		--outputChatBox("["..SunucuAdi.."]#ffffff Tebrikler, işlenmiş madeninizi artık kuyumcuda satabilirsiniz.",plr,0,255,0,true)
		exports.rl_global:removeAnimation(plr)		
		setTimer(function()
			setElementData(plr, "bakir:durum", nil)
		outputChatBox("["..SunucuAdi.."]#ffffff Süren doldu, yeniden bakır toplayabilirsin.",plr,0,255,0,true)			
		end, 300000, 1)
	end, 10000, 1)

end

end)