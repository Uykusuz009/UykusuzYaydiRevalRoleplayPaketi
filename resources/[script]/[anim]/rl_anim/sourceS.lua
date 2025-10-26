-----------------------------------------------------------------
-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy
-----------------------------------------------------------------

addEvent("setPedAnimationPanel", true)
addEventHandler("setPedAnimationPanel", getRootElement(),
	function (block, anim, loop, posUpdate)
		if isElement(source) and client == source then
			triggerClientEvent("setPedAnimationPanel", client, block, anim, loop, posUpdate)
		end
	end
)

addEvent("stopThePanelAnimation", true)
addEventHandler("stopThePanelAnimation", getRootElement(),
	function ()
		triggerClientEvent("stopThePanelAnimation", client)
	end
)

-----------------------------------------------------------------
-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy
-----------------------------------------------------------------