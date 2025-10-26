local ifp = engineLoadIFP( "sinav.ifp", "sinav" )

addEvent( "sinav", true )
addEventHandler( "sinav", root,
	function(enable)
		if (enable) then setPedAnimation(source, "sinav", "ParkSit_W_loop", -1, true, false)
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
				local _, sinav = getPedAnimation(player)
				if (sinav == "ParkSit_W_loop") then
					setPedAnimation(player)
				end
			end
			destroyElement(ifp)
		end
	end
)