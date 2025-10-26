local bakirBolge = createColSphere (-782.119140625, -1859.0498046875, 11.620872497559, 40, 3, 81)
addCommandHandler("bakir", function(plr, cmd,komut)

local Kazma = 361
local BakirFiyati = (770+80)*2
local IslenmisBakir = 358

local SunucuAdi = "Reval"

if not isElementWithinColShape(plr, bakirBolge) then
exports.rl_infobox:addBox(plr, "error", "Burada bakır kazıması yapamazsın.")
return end

if not exports.rl_global:hasItem(plr,Kazma) then exports.rl_infobox:addBox(plr, "error", "Bakır kazabilmek için 'Kazma' satın almalısın.") return end
--if exports.rl_global:hasItem(plr,IslenmisBakir) then outputChatBox("[!]#ffffff Envanterinde işlenmiş bakır taşıyorken bakır kazamazsın.",plr,255,194,14,true) return end
if getElementData(plr, "bakir:durum") then
	exports.rl_infobox:addBox(plr, "error", "Bakır kazabilmen için 5 dakika beklemen gerekiyor.")
return end

	if not komut then
		exports.rl_infobox:addBox(plr, "info", "/"..cmd.." [kaz] yazarak toplayabilirsiniz.")
	return end
	
if komut == "kaz" then
local randomdeger = math.random(1,1)
	exports.rl_infobox:addBox(plr, "success", "Bakır kazmaya başladın.")
	setElementData(plr, "bakir:durum", true)
	exports.rl_global:applyAnimation(plr, "BASEBALL", "bat_4", -1, true, false, false)	
	setTimer(function()
for i=1, randomdeger, 1 do
	exports["rl_items"]:giveItem(plr,IslenmisBakir,1)
end
		exports.rl_infobox:addBox(plr, "success", "Tebrikler, işlenmiş madeninizi artık kuyumcuda satabilirsiniz.")
		exports.rl_global:removeAnimation(plr)		
		setTimer(function()
			setElementData(plr, "bakir:durum", nil)
		exports.rl_infobox:addBox(plr, "info", "Süren doldu, yeniden bakır toplayabilirsin.")
		end, 300000, 1)
	end, 10000, 1)

end

end)