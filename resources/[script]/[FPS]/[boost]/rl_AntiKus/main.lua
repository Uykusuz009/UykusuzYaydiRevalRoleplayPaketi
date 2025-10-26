function disableBirds ()
    setBirdsEnabled ( false )
end

addEventHandler ( "onClientPlayerJoin", getRootElement(), disableBirds )
 
function scriptStart()
    setBirdsEnabled ( false )
end

addEventHandler ("onClientResourceStart",getResourceRootElement(getThisResource()),scriptStart)