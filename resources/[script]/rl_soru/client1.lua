local statusDude = false
addCommandHandler("soru",
	function(cmd, ...)
			statusDude = true
		if getElementData(localPlayer, "loggedin") == 1 then
			if not (...) then
				outputChatBox("[!] #FFFFFFKullanım: /soru <mesaj>", 0,0 ,255, true )
				return
			end
			local mesaj = table.concat({...}, " ")
			triggerServerEvent( "adminSoruSor", getLocalPlayer(  ), mesaj, localPlayer )
			
		setTimer(function (  )
			statusDude = false
		end, 60000, 1 )
			
			
		end
	end
)