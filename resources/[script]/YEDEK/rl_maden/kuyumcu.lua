-- pavlov --
local SunucuAdi = "Reval"
-----------------------------------
local komurSatim = (3550+80) -- 50
local bakirSatim = (3770+80) -- 100
local demirSatim = (3920+80) -- 150
local altinSatim = (4120+80) -- 200
local elmasSatim = (4420+80) -- 250

local IslenmisKomur = 359
local IslenmisBakir = 358
local IslenmisDemir = 357
local IslenmisAltin = 356
local IslenmisElmas = 360

local genelSatisBolgesi = createColSphere (1578.318359375, -1810.4091796875, 13.346517562866, 40, 3, 81)
setElementDimension(genelSatisBolgesi,395)
setElementInterior(genelSatisBolgesi,3)

addCommandHandler("sat", function(plr, cmd,komut)

	if not isElementWithinColShape(plr, genelSatisBolgesi) then
		outputChatBox("[!]#ffffff Burada kuyumcu satışı işlemi gerçekleştiremezsin.",plr,255,0,0,true)
	return end
	
	if not komut then
		outputChatBox("[!]#FFFFFF /"..cmd.." [kuyumculistesi] yazarak satış listesini ve fiyatları gözlemleyebilirsin.",plr,255,194,14,true)
	return end
	if komut == "kuyumculistesi" then
    outputChatBox("[!]#ffffff kuyumcu Listesi | "..SunucuAdi.."",plr,0,255,0,true)
    outputChatBox("-#ffffff Kömür Satım : "..komurSatim.." ₺",plr,0,255,0,true)
    outputChatBox("-#ffffff Bakır Satım : "..bakirSatim.." ₺",plr,0,255,0,true)
    outputChatBox("-#ffffff Demir Satım : "..demirSatim.." ₺",plr,0,255,0,true)
    outputChatBox("-#ffffff Altın Satım : "..altinSatim.." ₺",plr,0,255,0,true)
	outputChatBox("-#ffffff Elmas Satım : "..elmasSatim.." ₺",plr,0,255,0,true)
end
if komut == "elmas" then
	if not exports.rl_global:hasItem(plr,IslenmisElmas) then outputChatBox("[!]#ffffff Envanterinde 'İşlenmiş Elmas' olmadığından dolayı satış işlemi gerçekleştirilemedi.",plr,255,0,0,true) return end
	outputChatBox("[!]#ffffff Başarıyla 1 adet 'İşlenmiş Elmas' satımı gerçekleştirdin.",plr,0,255,0,true)
	exports.rl_global:giveMoney(plr,elmasSatim)
	
	if getElementData(plr, "vip") == 1 then
	exports.rl_global:giveMoney(plr,elmasSatim+15) -- 10
	end
	if getElementData(plr, "vip") == 2 then
	exports.rl_global:giveMoney(plr,elmasSatim+30) -- 20
	end
	if getElementData(plr, "vip") == 3 then
	exports.rl_global:giveMoney(plr,elmasSatim+45) -- 30
	end
	if getElementData(plr, "vip") == 4 then
	exports.rl_global:giveMoney(plr,elmasSatim+60) -- 40
	end
	
	exports.rl_global:takeItem(plr,IslenmisElmas, 1)
end

if komut == "komur" then
	if not exports.rl_global:hasItem(plr,IslenmisKomur) then outputChatBox("[!]#ffffff Envanterinde 'İşlenmiş Kömür' olmadığından dolayı satış işlemi gerçekleştirilemedi.",plr,255,0,0,true) return end
	outputChatBox("[!]#ffffff Başarıyla 1 adet 'İşlenmiş Kömür' satımı gerçekleştirdin.",plr,0,255,0,true)
	exports.rl_global:giveMoney(plr,komurSatim)
	
	if getElementData(plr, "vip") == 1 then	
	exports.rl_global:giveMoney(plr,komurSatim+15)
	end
	if getElementData(plr, "vip") == 2 then	
	exports.rl_global:giveMoney(plr,komurSatim+30)
	end
	if getElementData(plr, "vip") == 3 then	
	exports.rl_global:giveMoney(plr,komurSatim+45)
	end
	if getElementData(plr, "vip") == 4 then	
	exports.rl_global:giveMoney(plr,komurSatim+60)
	end
	
	exports.rl_global:takeItem(plr,IslenmisKomur, 1)
	
end

if komut == "bakir" then
	if not exports.rl_global:hasItem(plr,IslenmisBakir) then outputChatBox("[!]#ffffff Envanterinde 'İşlenmiş Bakır' olmadığından dolayı satış işlemi gerçekleştirilemedi.",plr,255,0,0,true) return end
	outputChatBox("[!]#ffffff Başarıyla 1 adet 'İşlenmiş Bakır' satımı gerçekleştirdin.",plr,0,255,0,true)
	exports.rl_global:giveMoney(plr,bakirSatim)
	
	if getElementData(plr, "vip") == 1 then
	exports.rl_global:giveMoney(plr,bakirSatim+15)
	end
	if getElementData(plr, "vip") == 2 then
	exports.rl_global:giveMoney(plr,bakirSatim+30)
	end
	if getElementData(plr, "vip") == 3 then
	exports.rl_global:giveMoney(plr,bakirSatim+45)
	end
	if getElementData(plr, "vip") == 4 then
	exports.rl_global:giveMoney(plr,bakirSatim+60)
	end
	
	exports.rl_global:takeItem(plr,IslenmisBakir, 1)	
end

if komut == "demir" then
	if not exports.rl_global:hasItem(plr,IslenmisDemir) then outputChatBox("[!]#ffffff Envanterinde 'İşlenmiş Demir' olmadığından dolayı satış işlemi gerçekleştirilemedi.",plr,255,0,0,true) return end
	outputChatBox("[!]#ffffff Başarıyla 1 adet 'İşlenmiş Demir' satımı gerçekleştirdin.",plr,0,255,0,true)
	exports.rl_global:giveMoney(plr,demirSatim)
	
	if getElementData(plr, "vip") == 1 then
	exports.rl_global:giveMoney(plr,demirSatim+15)	
	end
	if getElementData(plr, "vip") == 2 then
	exports.rl_global:giveMoney(plr,demirSatim+30)	
	end
	if getElementData(plr, "vip") == 3 then
	exports.rl_global:giveMoney(plr,demirSatim+45)	
	end
	if getElementData(plr, "vip") == 4 then
	exports.rl_global:giveMoney(plr,demirSatim+60)	
	end
	
	exports.rl_global:takeItem(plr,IslenmisDemir, 1)	
end

if komut == "altin" then
	if not exports.rl_global:hasItem(plr,IslenmisAltin) then outputChatBox("[!]#ffffff Envanterinde 'İşlenmiş Altın' olmadığından dolayı satış işlemi gerçekleştirilemedi.",plr,255,0,0,true) return end
	outputChatBox("[!]#ffffff Başarıyla 1 adet 'İşlenmiş Altın' satımı gerçekleştirdin.",plr,0,255,0,true)
	exports.rl_global:giveMoney(plr,altinSatim)
	
	if getElementData(plr, "vip") == 1 then
	exports.rl_global:giveMoney(plr,altinSatim+15)
	end
	if getElementData(plr, "vip") == 2 then
	exports.rl_global:giveMoney(plr,altinSatim+45)
	end
	if getElementData(plr, "vip") == 3 then
	exports.rl_global:giveMoney(plr,altinSatim+45)
	end
	if getElementData(plr, "vip") == 4 then
	exports.rl_global:giveMoney(plr,altinSatim+60)
	end
	
	exports.rl_global:takeItem(plr,IslenmisAltin, 1)
end
end)

-- Satış Sistemi 