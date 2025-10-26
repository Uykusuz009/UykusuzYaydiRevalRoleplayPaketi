local mysql = exports.rl_mysql

rktimer = {}

kai = function( ammo, attacker, weapon, bodypart )
	if getElementData(source,"logged") then
		if attacker then
			if ( getElementType ( attacker ) == "player" ) then
				if weapon >= 10 then 
					local dbid = getElementData(source, "dbid")
					setElementData(source, "rk", 1)
					setPedWeaponSlot(source, 0)
					outputChatBox("[!]#FFFFFF Silahla yaralandın 30 dakika rk süren var.", source, 255, 0, 0, true)
					rktimer[source] = setTimer(function(source)
						if isElement(source) then
							local dbid = getElementData(source, "dbid")
							if dbid then 
								setElementData(source, "rk", 0)
								setElementData(source, "injured", 0)
							end
						else
							outputDebugString("RK Timer: source is not a valid element.")
						end
					end, 1800000, 1, source)
				end 
			end
		end
	end
end 
addEventHandler("onPlayerWasted", root, kai)


kaiweapon = function(p, c)
	if getElementData(source, "rk") == 1 then 
	if getElementData(source, "logged") then
		if c == 0 then 
			return 
		end 
		if c <= 10 then 
			return 
		end
		if isTimer(rktimer[source]) then 
		else 
			rktimer[source] = setTimer(function(source)
				local dbid = getElementData(source, "dbid")
				setElementData(source, "rk", 0)
				setElementData(source, "injured", 0)
			end, 120000, 1, source)
		end
		setPedWeaponSlot(source, 0)
		outputChatBox("[!]#FFFFFF RK süren varken silah çekemezsin.", source, 255, 0, 0, true)
	end
	end
	
	if getElementData(source, "adminjailed") == true then 
	outputChatBox("mariel bug yapmaya çalışanın bacısını ısırıyor.", source, 255, 0, 0, true) 
	setPedWeaponSlot(source, 0)
	return end
end 
addEventHandler("onPlayerWeaponSwitch", root, kaiweapon)

function rkkaldir(plr, cmd, target)
    local ocmariel = getElementData(plr, "account_username")
    if ocmariel and ocmariel == "dev" then
        outputChatBox("bu komudu kullanamazsin orospucocugu sg 40 dk bekle", plr)
        return
    end

    if exports.rl_integration:isPlayerManager(plr) then
        if not (target) then
            outputChatBox("#575757RevalMTA: #FFFFFF/"..cmd.." [Kişi/ID]", plr, 0, 0, 0, true)
            return 
        end
        
        local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(plr, target)
        local dbid = getElementData(plr, "dbid")
        setElementData(targetPlayer, "rk", 0)
        setElementData(targetPlayer, "injured", 0)
        outputChatBox("[!]#FFFFFF Başarıyla "..target.." idli kişinin rk'sı kaldırıldı.", plr, 0, 255, 0, true)
        outputChatBox("[!]#FFFFFF RK süren kaldırıldı.", targetPlayer, 0, 255, 0, true)
    end    
end
addCommandHandler("rkkaldir", rkkaldir)

-- function rksurem(plr, cmd)
-- if getElementData(plr, "rk") == 1 then
-- 	outputChatBox("[!]#FFFFFF RK süren: ", plr, 0, 255, 0, true)
-- else
-- 	outputChatBox("[!]#FFFFFF RK süren bulunmamakta.", plr, 255, 0, 0, true)
-- end	
-- end
-- addCommandHandler("rksure",rksurem)

timer = function()
	for i,v in ipairs(getElementsByType("player")) do
		if getElementData(v,"rk") == 1 then
			setPedWeaponSlot(v,0)
		end
		
		if getElementData(v,"adminjailed") then
			setPedWeaponSlot(v,0)
		end
	end
end
setTimer(timer,300,0)

damage = function( attacker, weapon, bodypart, loss )
	if (attacker and attacker ~= source and getElementData(source,"adminjailed")) then
		setElementHealth(source,100)
	end
end
addEventHandler ( "onPlayerDamage", root, damage )