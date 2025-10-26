function asignarID(  )

	local newId = findAID ( )
	setElementData( source, "player_id", newId )
	setElementData( source, "rapor_atti", false )
end
addEventHandler( "onPlayerJoin", getRootElement(  ), asignarID )

function asignarIds(  )

	for _, player in ipairs( getElementsByType("player") ) do
		removeElementData( player, "player_id" )
	end

	for _, player in ipairs( getElementsByType("player") ) do
		local newId = findAID ( )
		setElementData( player, "player_id", newId )
	end

end
addEventHandler( "onResourceStart", getResourceRootElement( getThisResource() ), asignarIds )

function estaLaIDEnUso( id )
	
	for _, player in ipairs( getElementsByType("player") ) do
		local theId = getElementData( player, "player_id" ) or false
		if theId == id then
			return true
		end
	end

	return false

end

function findAID(  )

	for i=1,200 do

		local id = estaLaIDEnUso ( i )
		if not id then
			return i
		end

	end

end

function getPlayerID( player )
	return getElementData( player, "player_id" ) or false
end

function getPlayerFromID( id )
	
	for _, player in ipairs( getElementsByType("player") ) do
		local theId = getElementData( player, "player_id" ) or false
		if theId == id then
			return player
		end
	end

	return nil

end

function yollaAdminSorular( mesaj, thePlayer )
if getElementData( source, "rapor_atti" ) == false then
	setElementData( source, "rapor_atti", true )
	local playerId = getPlayerID( source )
	if playerId then
		local playerName = getPlayerName( source )
		for _, player in ipairs( getElementsByType("player") ) do			
		if (exports.rl_integration:isPlayerTrialAdmin(player) or exports.rl_integration:isPlayerSupporter(player)) then
				outputChatBox("[!] #BEBEBE===================================", player, 0, 0, 255, true)
				outputChatBox("[!] #BEBEBE[SORU ID: #" .. playerId .. "]#FFFFFF " ..playerName.." bir soru sordu.", player, 0, 0, 255, true )
				outputChatBox("[!] #BEBEBE[Gelen Soru:] #FFFFFF "..mesaj, player, 0, 0, 255, true )
				outputChatBox("[!] #BEBEBE===================================", player, 0, 0, 255, true)
     		end
		end
		outputChatBox("#00FF00[!]#FFFFFF Sorunuz gönderildi, cevaplanmasını bekleyin.", thePlayer, 255,0 ,0, true )
		outputChatBox("[!]#FFFFFF Sorunuz: " .. mesaj, thePlayer, 0, 255, 0, true)
	else
		outputChatBox("[!]#FFFFFF Bir hata oluştu daha sonra tekrar deneyin.", thePlayer, 255,0 ,0, true )
	end
	else
		outputChatBox("[!]#FFFFFF Zaten bir soru sordunuz, cevaplanmasını bekleyin.", thePlayer, 255,0 ,0, true )
	
end
end
addEvent( "adminSoruSor", true )
addEventHandler( "adminSoruSor", getRootElement(  ), yollaAdminSorular )


function responderDuda( source, cmd, id, ... )

if (exports.rl_integration:isPlayerTrialAdmin(source) or exports.rl_integration:isPlayerSupporter(source)) then
	local mesaj = table.concat( { ... }, " ")
	if id and type( tonumber( id ) ) == "number" then

		local Tplayer = getPlayerFromID( tonumber( id ) )
		if estaLaIDEnUso( tonumber( id ) ) then

			if getElementData( Tplayer, "rapor_atti" ) == true then
            setElementData( Tplayer, "rapor_atti", false )
		
				local playerName = getPlayerName( source )
				for _, player in ipairs( getElementsByType("player") ) do
    					if (exports.rl_integration:isPlayerTrialAdmin(player) or exports.rl_integration:isPlayerSupporter(player)) then
    					outputChatBox( "[SORU-LOG] #FFFFFF" .. playerName:gsub("_"," ") .. " isimli yetkili #" .. id .. "'e ait soruyu cevapladı; "..mesaj, player, 255, 0, 0, true )
     				end
				end

				local playerId = getPlayerID( source )
			
				outputChatBox("[!]#FFFFFF [YETKILI] "..playerName:gsub("_", " ") .."  isimli yetkili soruna cevap verdi.", Tplayer, 0, 50, 125, true )
				outputChatBox("[!]#FFFFFF [CEVAP]: " .. mesaj, Tplayer, 0, 50, 125, true)
			else
				outputChatBox("[!]#FFFFFF Oyuncu herhangi bir soru sormamış.", source, 255,0 ,0, true )				
			end
		else
			outputChatBox("[!]#FFFFFF Oyuncu bulunamadı.", source, 255,0 ,0, true )
		end
	else
		outputChatBox("[!]#FFFFFF Doğru kullanım: /"..cmd.." <soruid> <cevap>", source, 0,0 ,255, true )
	end
else
	outputChatBox("[!]#FFFFFF Bu komutu kullanma yetkiniz bulunmamakta.", source, 255,0 ,0, true )
end
	end
addCommandHandler( "cevap", responderDuda )