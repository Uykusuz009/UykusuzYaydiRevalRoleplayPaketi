function disableClouds ()
    setCloudsEnabled ( false )
end

addEventHandler ( "onPlayerJoin", getRootElement(), disableClouds )
 
function scriptStart()
    setCloudsEnabled ( false )
end

addEventHandler ("onResourceStart",getResourceRootElement(getThisResource()),scriptStart)