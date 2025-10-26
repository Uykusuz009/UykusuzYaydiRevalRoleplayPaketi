local demirBolge = createColSphere (-725.4189453125, 1545.4638671875, 39.087566375732, 40, 3, 81)
addCommandHandler("demir", function(plr, cmd,komut)

local Kazma = 361
local DemirFiyati = (920+80)*2
local IslenmisDemir = 357

local SunucuAdi = "Reval"

if not isElementWithinColShape(plr, demirBolge) then
exports.rl_infobox:addBox(plr, "error", "Burada demir kazıması yapamazsın.")
return end

if not exports.rl_global:hasItem(plr,Kazma) then exports.rl_infobox:addBox(plr, "error", "Demir kazabilmek için 'Kazma' satın almalısın.") return end
--if exports.rl_global:hasItem(plr,IslenmisDemir) then outputChatBox("[!]#ffffff Envanterinde işlenmiş demir taşıyorken demir kazamazsın.",plr,255,194,14,true) return end
if getElementData(plr, "demir:durum") then
	exports.rl_infobox:addBox(plr, "error", "Demir kazabilmen için 5 dakika beklemen gerekiyor.")
return end

	if not komut then
		exports.rl_infobox:addBox(plr, "info", "/"..cmd.." [kaz] yazarak toplayabilirsiniz.")
	return end
	
if komut == "kaz" then
local randomdeger = math.random(1,1)
	exports.rl_infobox:addBox(plr, "success", "Demir kazmaya başladın.")
	setElementData(plr, "demir:durum", true)
	exports.rl_global:applyAnimation(plr, "BASEBALL", "bat_4", -1, true, false, false)
	setTimer(function()
for i=1, randomdeger, 1 do
	exports["rl_items"]:giveItem(plr,IslenmisDemir,1)
end
		exports.rl_infobox:addBox(plr, "success", "Tebrikler, işlenmiş madeninizi artık kuyumcuda satabilirsiniz.")
		exports.rl_global:removeAnimation(plr)	
		setTimer(function()
		exports.rl_infobox:addBox(plr, "info", "Süren doldu, yeniden demir toplayabilirsin.")
			setElementData(plr, "demir:durum", nil)
		end, 300000, 1)
	end, 10000, 1)

end

end)