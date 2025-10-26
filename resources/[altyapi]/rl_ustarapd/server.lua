function getPedWeapons(ped)
	local playerWeapons = {}
	if ped and isElement(ped) and getElementType(ped) == "ped" or getElementType(ped) == "player" then
		for i=1,12 do
			local wep = getPedWeapon(ped,i)
			if wep and wep ~= 0 then
				table.insert(playerWeapons,wep)
			end
		end
	else
		return false
	end
	return playerWeapons
end
local vic = {}
local lastUsage = {} -- Her oyuncunun son komutu kullanma zamanını tutmak için bir tablo oluşturuldu

function aramaSor(arayan, cmd, aranan)
    -- Eğer oyuncu, son komutunu kullanma zamanından 30 saniyeden daha az süre geçirdiyse, işlem yapmadan geri dönecek
    if lastUsage[arayan] and getTickCount() - lastUsage[arayan] < 30000 then
        outputChatBox("#660099[RevalMTA] #ffffffBu komutu tekrar kullanmak için lütfen 30 saniye bekleyin.", arayan, 255, 0, 0, true)
        return
    end

    -- Komutun geri kalanı
    local aranan = exports.rl_global:findPlayerByPartialNick(arayan, aranan)
    local x,y,z = getElementPosition(arayan)
    local px,py,pz = getElementPosition(aranan)
    local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)

    if not aranan then
        exports.rl_infobox:addBox(arayan,"info","[RevalMTA] /" .. cmd .. " [İsim/ID]")
    else
        if aranan == arayan then
            exports.rl_infobox:addBox(arayan,"error","İşlemi kendi üzerinde gerçekleştiremezsin.")
        else
            if (distance > 5) then 
                outputChatBox("#660099[RevalMTA] #ffffff".. getPlayerName(aranan) .. " adlı şahsa yeterince yakın değilsin.", arayan, 255, 0, 0, true) 
                return 
            end
            local arayanIsim = getPlayerName(arayan)
            exports.rl_global:sendLocalMeAction(arayan, "sağ ve sol eli ile karşısındaki şahsın üstünü aramaya çalışır.", false, true)
            exports.rl_infobox:addBox(arayan,"success","[RevalMTA]".. getPlayerName(aranan) .." adlı şahsa üst arama isteği gönderildi.")
            outputChatBox("#660099[RevalMTA] #ffffff".. getPlayerName(aranan) .." adlı şahsa üst arama isteği gönderildi.", arayan, 0, 255, 0, true)
            triggerClientEvent(aranan, "ustunuArama", arayan, arayan, aranan)
        end	
    end

    -- Komut kullanım zamanını güncelle
    lastUsage[arayan] = getTickCount()
end
addCommandHandler("ustara", aramaSor)
function ustuKabulet(arayan, aranan)
local weapons = getPedWeapons(aranan)

	local weaponNames = {}
	for i,v in ipairs(weapons) do
		table.insert(weaponNames,getWeaponNameFromID(v))
	end	
	if exports.rl_global:hasItem(aranan, 115) then
	    silahlar = " ".. table.concat(weaponNames,", ")
	else
	    silahlar = "Silah yok."
	end
	if exports.rl_global:hasItem(aranan, 116) then
	    jarjor = "[Var]"
	else
	    jarjor = "[Yok]"
	end	
	if exports.rl_global:hasItem(aranan, 152) then
	    kimlik = "[Var]"
	else
	    kimlik = "[Yok]"
	end
	if exports.rl_global:hasItem(aranan, 10080) then
		ruhsat = "[Var]"
	else
		ruhsat = "[Yok]"
	end
	exports.rl_global:sendLocalMeAction(arayan, "".. getPlayerName(aranan).." adlı şahsın üstünü aramaya başlar.", false, true)
	outputChatBox("#660099[RevalMTA] #ffffff".. getPlayerName(aranan) .." üstünü aramasına izin verdi, üzerinden çıkanlar;", arayan, 0, 255, 0, true)
    outputChatBox("-- Silahlar: "..silahlar, arayan, 255, 255, 255, true)
    outputChatBox("-- Jarjör: "..jarjor, arayan, 255, 255, 255, true)	
	outputChatBox("-- Nakit Para: "..getElementData(aranan, "money"), arayan, 255, 255, 255, true)
    outputChatBox("-- Kimlik: "..kimlik, arayan, 255, 255, 255, true)
    outputChatBox("-- Ruhsat: "..ruhsat, arayan, 255, 255, 255, true)
	--outputChatBox("-- Uyuşturucular: U-PCP: ".. upcp .. ", Kenevir: ".. kenevir .. ", Morfin: ".. morfin ..", Eroin: ".. eroin ..",", arayan, 255, 255, 255, true)
	--outputChatBox("Metamfetamin: ".. metamfetamin ..", LSD: ".. lsd .. ", PCP: ".. pcp .. ", Marijuana: ".. marijuana .. ", Rollet Marijuana: ".. rmarijuana ..", Kokain: ".. kokain ..", Kokain Alkaloid: ".. kokaina, arayan, 255, 255, 255, true)
	--outputChatBox("-- Banka: Tablet:"..tablet,arayan, 255, 255, 255, true)

    --outputChatBox("-- Banka Kartı: "..bankKart, arayan, 255, 255, 255, true)	
end
addEvent("ustuKabulet", true)
addEventHandler("ustuKabulet", root, ustuKabulet)
function ustuReddet(arayan, aranan)
	exports.rl_infobox:addBox(arayan,"error","[RevalMTA] ".. getPlayerName(aranan).. " üstünü armana izin vermedi.")
end
addEvent("ustuReddet", true)
addEventHandler("ustuReddet", root, ustuReddet)