local sn, oran = 120, 10 -- kaç saniyede bir ne kadar can eksilcek
local mysql = exports.rl_mysql

kanayanlar = {}
silahlar = {
	[4] = true,
	[22] = true,
	[23] = true,
	[24] = true,
	[25] = true,
	[26] = true,
	[27] = true,
	[28] = true,
	[29] = true,
	[30] = true,
	[31] = true,
	[32] = true,
	[33] = true,
	[34] = true,
}

addEventHandler("onPlayerDamage", root,function(saldiran, silah, bodypart, kayip) 
	if isElement(saldiran) and saldiran ~= source and silahlar[silah] then
		if kanayanlar[source] then return end
		triggerClientEvent(source, "bleeding:control", source, "add")
		setElementData(source, "injured", 1)
		local dbid = getElementData(source, "dbid")
		
		toggle(source, false)
		kanayanlar[source] = {}
		kanayanlar[source].kanayan = source
		kanayanlar[source].sure = setTimer(function(oyuncu)
			if kanayanlar[oyuncu] then
				local kanayan = kanayanlar[oyuncu].kanayan
				if not isElement(kanayan) then
					if isTimer(kanayanlar[oyuncu].sure) then killTimer(kanayanlar[oyuncu].sure) end
					return
				end
				local can = getElementHealth(kanayan)
				if getElementData(kanayan, "injured") ~= 1 then
					if isTimer(kanayanlar[oyuncu].sure) then killTimer(kanayanlar[oyuncu].sure) end
					triggerClientEvent(kanayan, "bleeding:control", kanayan, "remove")
					toggle(kanayan, true)
					kanayanlar[oyuncu] = nil
					return
				end
				toggle(kanayan, false)
				if can > 20 then
					setElementHealth(kanayan, can-oran)
				end
			end	
		end,1000*sn,0,source)
	end
end)

addEventHandler("onElementDataChange", root, function(veri, eskideger)
	if veri == "injured" then
		if getElementData(source, "injured") ~= 1 then
			if kanayanlar[source] and isTimer(kanayanlar[source].sure) then killTimer(kanayanlar[source].sure) end
			triggerClientEvent(source, "bleeding:control", source, "remove")
			toggle(source,true)
			kanayanlar[source] = nil
		end
	end
end)

function toggle(oyuncu, bool)
	if isElement(oyuncu) then
		toggleControl(oyuncu, "sprint", bool)
	end
end