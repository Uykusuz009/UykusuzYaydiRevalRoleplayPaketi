Portao = createMarker ( 1225.6518554688, -1011.0338745117, 32.689556121826, "cylinder", 9.0, 0, 0, 255, 0 )

function createGate ()
	Gate = createObject ( 989,  1225.6518554688, -1011.0338745117, 32.689556121826, 0, 0, 289.51916503906)
	
end
addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource () ), createGate )


function gateCheckingTeam ( thePlayer )
	moveObject ( Gate, 2000, 1220.2496337891, -1011.0338745117, 32.689556121826 )
	
end
addEventHandler ( "onMarkerHit", Portao, gateCheckingTeam )


function movingBackPolice ( thePlayer )
	moveObject ( Gate, 2000, 1225.6518554688, -1011.0338745117, 32.689556121826 )
	
end
addEventHandler ( "onMarkerLeave", Portao, movingBackPolice )
