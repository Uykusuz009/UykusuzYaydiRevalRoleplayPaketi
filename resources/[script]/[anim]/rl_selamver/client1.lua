local ifp = engineLoadIFP( "anim.ifp", "newAnimBlock" )

addEvent( "anim", true )
addEventHandler( "anim", root,
	function(enable)
		if (enable) then setPedAnimation(source, "newAnimBlock", "continencia", -1, true, false)
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
				local _, anim = getPedAnimation(player)
				if (anim == "continencia") then
					setPedAnimation(player)
				end
			end
			destroyElement(ifp)
		end
	end
)