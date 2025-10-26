function playPanicSound()
	local x,y,z = getElementPosition(localPlayer)
	sound = playSound3D("panic.mp3", x, y, z, true)
	setTimer(destroyElement, 3000, 1, sound)
	attachElements(sound, localPlayer)
	sound.interior = localPlayer.interior;
	sound.dimension = localPlayer.dimension;
end
addEvent( "playPanicSound", true )
addEventHandler( "playPanicSound", getRootElement(), playPanicSound)