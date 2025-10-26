local elmasBolge = createColSphere (-110.828125, 1982.8037109375, -12.703633308411, 40, 3, 81)
addCommandHandler("elmas", function(plr, cmd,komut)

local Kazma = 361
local ElmasFiyati = (1420+80)*2
local IslenmisElmas = 360

local SunucuAdi = "Reval"

if not isElementWithinColShape(plr, elmasBolge) then
exports.rl_infobox:addBox(plr, "error", "Burada elmas kazıması yapamazsın.")
return end

if not exports.rl_global:hasItem(plr,Kazma) then exports.rl_infobox:addBox(plr, "error", "Elmas kazabilmek için 'Kazma' satın almalısın.") return end
--if exports.rl_global:hasItem(plr,IslenmisElmas) then outputChatBox("[!]#ffffff Envanterinde işlenmiş elmas Elmasıyorken elmas kazamazsın.",plr,255,194,14,true) return end
if getElementData(plr, "elmas:durum") then
	exports.rl_infobox:addBox(plr, "error", "Elmas kazabilmen için 5 dakika beklemen gerekiyor.")
return end

	if not komut then
		exports.rl_infobox:addBox(plr, "info", "/"..cmd.." [kaz] yazarak kazabilirsiniz.")
	return end
	
if komut == "kaz" then
local randomdeger = math.random(1,1)
	exports.rl_infobox:addBox(plr, "success", "Elmas kazmaya başladın.")
	setElementData(plr, "elmas:durum", true)
	exports.rl_global:applyAnimation(plr, "BASEBALL", "bat_4", -1, true, false, false)	
	setTimer(function()
for i=1, randomdeger, 1 do
	exports["rl_items"]:giveItem(plr,IslenmisElmas,1)
end
		exports.rl_infobox:addBox(plr, "success", "Tebrikler, işlenmiş madeninizi artık kuyumcuda satabilirsiniz.")
		exports.rl_global:removeAnimation(plr)			
		setTimer(function()
		exports.rl_infobox:addBox(plr, "info", "Süren doldu, yeniden elmas toplayabilirsin.")
			setElementData(plr, "elmas:durum", nil)
		end, 300000, 1)
	end, 10000, 1)

end

end)