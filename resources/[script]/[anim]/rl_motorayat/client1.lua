local ifp = engineLoadIFP( "yat.ifp", "yat" )

addEvent( "yat", true )
addEventHandler( "yat", root,
	function(enable)
		if (enable) then setPedAnimation(source, "yat", "BIKEs_Back", -1, true, false)
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
				local _, yat = getPedAnimation(player)
				if (yat == "BIKEs_Back") then
					setPedAnimation(player)
				end
			end
			destroyElement(ifp)
		end
	end
)


