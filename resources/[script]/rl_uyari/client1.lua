local sounds = { }

function acilcagri()
	local x, y, z = getElementPosition(source)
	sounds[source] = playSound3D("cagri.wav", x, y, z, false)
	attachElements( sounds[source], source )
	setSoundVolume(sounds[source], 1.2)
	setSoundMaxDistance(sounds[source], 10)
	setElementDimension(sounds[source], getElementDimension(source))
	setElementInterior(sounds[source], getElementInterior(source))
end
addEvent("cagri",true)
addEventHandler("cagri",getRootElement(),acilcagri)
