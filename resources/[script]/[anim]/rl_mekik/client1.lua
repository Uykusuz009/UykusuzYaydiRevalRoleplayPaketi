local ifp = engineLoadIFP( "mekik.ifp", "mekik" )

addEvent( "mekik", true )
addEventHandler( "mekik", root,
	function(enable)
		if (enable) then setPedAnimation(source, "mekik", "Pres_2", -1, true, false)
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
				local _, mekik = getPedAnimation(player)
				if (mekik == "Pres_2") then
					setPedAnimation(player)
				end
			end
			destroyElement(ifp)
		end
	end
)