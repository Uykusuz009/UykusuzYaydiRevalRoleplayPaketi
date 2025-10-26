local ifp = engineLoadIFP( "shalat.ifp", "namaz" )

addEvent( "namaz", true )
addEventHandler( "namaz", root,
	function(enable)
		if (enable) then setPedAnimation(source, "namaz", "siji", -1, true, false)
		else setPedAnimation(source)
		end		
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        triggerServerEvent("onClientSync", resourceRoot)
	end
)

addEventHandler("onClientResourceStop", resourceRoot,
	function()
		if ifp then
			for _,player in ipairs(getElementsByType("player")) do
				local _, namaz = getPedAnimation(player)
				if (namaz == "siji") then
					setPedAnimation(player)
				end
			end
			destroyElement(ifp)
		end
	end
)