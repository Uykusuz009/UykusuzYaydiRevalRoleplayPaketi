hunter, stevie, tyrese, rook = nil

function respawnPed(ped)
	new = createPed(getElementModel(ped),getElementPosition(ped))
	setElementData(new, "name", "Winston Fleming")
	setPedRotation(new, getElementData(ped,"rotation"))
	setElementInterior(new, getElementInterior(ped))
	setElementDimension(new, getElementDimension(ped))
	
	for k, v in next, getAllElementData(ped) do
		setElementData(new, k, v)
	end
	setElementData(new, "activeConvo", 0)
	
	if ped == hunter then
		hunter = new
	elseif ped == stevie then
		stevie = new
	elseif ped == tyrese then
		tyrese = new
	elseif ped == rook then
		rook = new
	end
	destroyElement(ped)
end

addEventHandler("onPedWasted", getResourceRootElement(),
	function()
		setTimer(respawnPed, 360000, 1, source)
	end
)