local komurBolge = createColSphere (2113.2080078125, -2009.2138671875, 13.699184417725, 40, 3, 81)
addCommandHandler("komur", function(plr, cmd,komut)

local Kazma = 361
local KomurFiyati = (550+80)*2
local IslenmisKomur = 359

local SunucuAdi = "Reval"

if not isElementWithinColShape(plr, komurBolge) then
exports.rl_infobox:addBox(plr, "error", "Burada kömür kazıması yapamazsın.")
return end

if not exports.rl_global:hasItem(plr,Kazma) then exports.rl_infobox:addBox(plr, "error", "Kömür kazabilmek için 'Kazma' satın almalısın.") return end
--if exports.rl_global:hasItem(plr,IslenmisKomur) then outputChatBox("[!]#ffffff Envanterinde işlenmiş kömür taşıyorken kömür kazamazsın.",plr,255,194,14,true) return end
if getElementData(plr, "komur:durum") then
	exports.rl_infobox:addBox(plr, "error", "Kömür kazabilmen için 5 dakika beklemen gerekiyor.")
return end

	if not komut then
		exports.rl_infobox:addBox(plr, "info", "/"..cmd.." [kaz] yazarak toplayabilirsiniz.")
	return end
	
if komut == "kaz" then
local randomdeger = math.random(1,1)
	exports.rl_infobox:addBox(plr, "success", "Kömür toplamaya başladın.")
	setElementData(plr, "komur:durum", true)
	exports.rl_global:applyAnimation(plr, "BASEBALL", "bat_4", -1, true, false, false)	
	setTimer(function()
for i=1, randomdeger, 1 do
	exports["rl_items"]:giveItem(plr,IslenmisKomur,1)
end
		exports.rl_infobox:addBox(plr, "success", "Tebrikler, işlenmiş madeninizi artık kuyumcuda satabilirsiniz.")
		exports.rl_global:removeAnimation(plr)		
		setTimer(function()
		exports.rl_infobox:addBox(plr, "info", "Süren doldu, yeniden kömür toplayabilirsin.")
			setElementData(plr, "komur:durum", nil)
		end, 300000, 1)
	end, 10000, 1)

end

end)