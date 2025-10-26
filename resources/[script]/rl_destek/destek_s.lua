local destekpdPlayers = {}
local destekmdPlayers = {}
local takipPlayers  = {}
function destekpdMain(plr)
	if tonumber(getElementData(plr,'faction')) == 1 then
	if takipPlayers[plr] then
		outputChatBox('[!]#ffffff Zaten bir destek çağrın var',plr,0,0,255,true)
	return end
	if not destekpdPlayers[plr] then	
	outputChatBox("Reval Roleplay:#ffffff REM Destek çağrısı açtınız.",plr,201,201,201,true)
    for i, player in ipairs(getElementsByType 'player') do
    	if tonumber(getElementData(player,'faction')) == 1 and player ~= plr then
        triggerClientEvent(player, 'lspd:destekpd', player, true, plr)
        outputChatBox('[!]#ffffff '..getPlayerName(plr)..' isimli üye REM Destek çağırısı açtı',player,0,0,255,true)
    end
    end
    destekpdPlayers[plr] = true
else
	outputChatBox("Reval Roleplay:#ffffff REM Destek çağrısını kapttınız.",plr,201,201,201,true)
    for i, player in ipairs(getElementsByType 'player') do
    	if tonumber(getElementData(player,'faction')) == 1 and player ~= plr then
        triggerClientEvent(player, 'lspd:destekpd', player, false, plr)
        outputChatBox('[!]#ffffff '..getPlayerName(plr)..' isimli üye REM Destek çağırısını kapattı',player,0,0,255,true)
    end
    end
    destekpdPlayers[plr] = nil
end
else
	outputChatBox('[!]#ffffff Yeterli yetkin yok',plr,0,0,255,true)
end
end
addCommandHandler('destekpd',destekpdMain)


function destekmdMain(plr)
	if tonumber(getElementData(plr,'faction')) == 2 then
	if takipPlayers[plr] then
		outputChatBox('[!]#ffffff Zaten bir destek çağrın var',plr,0,0,255,true)
	return end
	if not destekmdPlayers[plr] then	
	outputChatBox("Reval Roleplay:#ffffff RSM Destek çağrısı açtınız.",plr,201,201,201,true)
    for i, player in ipairs(getElementsByType 'player') do
    	if tonumber(getElementData(player,'faction')) == 2 and player ~= plr then
        triggerClientEvent(player, 'lsfd:destekmd', player, true, plr)
        outputChatBox('[!]#ffffff '..getPlayerName(plr)..' isimli üye RSM Destek çağırısı açtı',player,0,0,255,true)
    end
    end
    destekmdPlayers[plr] = true
else
	outputChatBox("Reval Roleplay:#ffffff RSM Destek çağrısını kapttınız.",plr,201,201,201,true)
    for i, player in ipairs(getElementsByType 'player') do
    	if tonumber(getElementData(player,'faction')) == 2 and player ~= plr then
        triggerClientEvent(player, 'lsfd:destekmd', player, false, plr)
        outputChatBox('[!]#ffffff '..getPlayerName(plr)..' isimli üye RSM Destek çağırısını kapattı',player,0,0,255,true)
    end
    end
    destekmdPlayers[plr] = nil
end
else
	outputChatBox('[!]#ffffff Yeterli yetkin yok',plr,0,0,255,true)
end
end
addCommandHandler('destekmd',destekmdMain)


function takipMain(plr)
	if tonumber(getElementData(plr,'faction')) == 1 then
	if destekPlayers[plr] then
		outputChatBox('[!]#ffffff Zaten bir destek çağrın var',plr,0,0,255,true)
	return end
	if not takipPlayers[plr] then	
	outputChatBox("Reval Roleplay:#ffffff takip çağrısı açtınız.",plr,201,201,201,true)
    for i, player in ipairs(getElementsByType 'player') do
    	if tonumber(getElementData(player,'faction')) == 1 and player ~= plr  then
        triggerClientEvent(player, 'lspd:takip', player, true, plr)
        outputChatBox('[!]#ffffff '..getPlayerName(plr)..' isimli üye takip çağırısı açtı',player,0,0,255,true)
    end
    end
    takipPlayers[plr] = true
else
	outputChatBox("Reval Roleplay:#ffffff Takip çağrısını kapattınız.",plr,201,201,201,true)
    for i, player in ipairs(getElementsByType 'player') do
    	if tonumber(getElementData(player,'faction')) == 1 and player ~= plr then
        triggerClientEvent(player, 'lspd:takip', player, false, plr)
        outputChatBox('[!]#ffffff '..getPlayerName(plr)..' isimli üye takip çağırısını kapattı',player,0,0,255,true)
    end
    end
    takipPlayers[plr] = nil
end
else
	outputChatBox('[!]#ffffff Yeterli yetkin yok',plr,0,0,255,true)
end
end
addCommandHandler('takip',takipMain)

function checkCarJack(thePlayer, seat, jacked)
   if jacked and seat == 0 then
      cancelEvent()  
      outputChatBox("Reval Roleplay:#ffffff Carjack yapamazsın!", thePlayer,100,0,255,true)
   end
end
addEventHandler("onVehicleStartEnter", getRootElement(), checkCarJack)