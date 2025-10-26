local cache = {};
local timers = {};

addEventHandler("onResourceStart",resourceRoot,function()
    for k, v in pairs(pos) do 
        local loc,x,y,z,rot,dim,inter = unpack(v);
        local obj = createObject(2942,x,y,z,0,0,rot);
        cache[obj] = true; --Rabolható
        setElementData(obj,"srob.loc",loc);
        setElementData(obj,"srob.state",true);
        setElementData(obj,"srob.timeleft",0);
        setElementData(obj,"srob.rabolja",false);
    end
end);

addEventHandler("onElementDataChange",root,function(dataName,oldValue,newValue)
    if getElementType(source) == "object" and getElementData(source,"srob.loc") then 
        if dataName == "srob.state" then 
            cache[source] = newValue;
            local obj = source;
            if newValue then 
                if timers[obj] then 
                    if isTimer(timers[obj]) then 
                        killTimer(timers[obj]);
                    end
                end
                setElementData(obj,"srob.rabolja",false);
            else 
                if timers[source] then 
                    killTimer(timers[source]);
                end
                setElementData(source,"srob.timeleft",120);
                timers[obj] = setTimer(function()
                    local timeLeft = (getElementData(obj,"srob.timeleft") or 0);
                    if timeLeft <= 0 then 
                        setElementData(obj,"srob.state",true);
                        setElementData(obj,"srob.rabolja",false);
                    else 
                        setElementData(obj,"srob.timeleft",timeLeft-1);
                    end
                end,1000*60,0);
            end
        end
    end
end);

addEvent('anim', true)
addEventHandler('anim', root, function(player)
	setTimer(function(player)
        setPedAnimation(player, "BOMBER", "BOM_Plant_Loop", -1, true, false, false)
    end, 500, 1)
end)

addEvent('river >> atmihbar', true)
addEventHandler('river >> atmihbar', root, function()
		for k , v in ipairs(getElementsByType("player")) do
			if v:getData('faction') == 1 then
			local x, y, z = getElementPosition(source)
			ihbarBolgesi = createBlip(x, y, z, 52)
			setElementVisibleTo(ihbarBolgesi,root,false)
			setElementVisibleTo(ihbarBolgesi,v,true)
				outputChatBox('Soygun İhbarı:#FFFFFF Haritada oluşan dolar işaretinden bir atm soygunu ihbarı var!', v ,100, 0, 255, true)
				outputChatBox('Soygun İhbarı:#FFFFFF Dikkatli olun, kişiler silahlı olabilir.', v ,100, 0, 255, true)
			setTimer(function()
			destroyElement(ihbarBolgesi)
			--setElementVisibleTo(ihbarBolgesi,v,false)
			end, 30000, 1)
		end
	end
end
)

addEvent("srob.giveMoney",true);
addEventHandler("srob.giveMoney",root,function(player,money)
    --outputChatBox("#FFA4E3[!] #FFFFFFBir paket para çıkardın. ( #FFA4E3"..exports.rl_global:formatMoney(money).."#FFFFFF₺ )",player,255,255,255,true);
	exports.rl_global:giveMoney(player, money)
	player:setData('river >> atmstate', nil)
end);