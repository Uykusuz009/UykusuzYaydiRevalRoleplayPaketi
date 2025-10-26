function fadeToBlack(thePlayer)
	if thePlayer and isElement(thePlayer) then
		fadeCamera(thePlayer, true, 0, 0, 0, 0)
		fadeCamera(thePlayer, false, 1, 0, 0, 0)
	end
end

function fadeFromBlack(thePlayer)
	if thePlayer and isElement(thePlayer) then
		fadeCamera(thePlayer, false, 0, 0, 0, 0)
		fadeCamera(thePlayer, true, 1, 0, 0, 0)
	end
end