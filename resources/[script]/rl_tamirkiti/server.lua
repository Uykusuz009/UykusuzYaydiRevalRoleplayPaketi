local secretHandle = 'some_shit_that_is_really_secured'

function changeProtectedElementData(thePlayer, index, newvalue)
	setElementData(thePlayer, index, newvalue)
end

function changeProtectedElementDataEx(thePlayer, index, newvalue, sync, nosyncatall)
	if (thePlayer) and (index) then
		setElementData(thePlayer, index, newvalue)
		return true
	end
	return false
end


function tamirkits(thePlayer)
	-- if exports["rl_items"]:hasItem



					local veh =  getNearestVehicle( thePlayer )
					
					if not veh then return end
					
					if exports["rl_items"]:hasItem(thePlayer,999) then 
					local aracinici = getPedOccupiedVehicle(thePlayer)
		            if not aracinici then else return  outputChatBox("[!] #f0f0f0Arabanın içinde tamir kiti kullanamazsın!", thePlayer, 255, 0, 0, true) end
					-- if getElementData(thePlayer,"tamirediyor") then return end
				    setElementFrozen(thePlayer, true)
					setElementData(thePlayer,"tamirediyor",true)
					exports.rl_global:applyAnimation(thePlayer , "bd_fire" , "wash_up" , -1 , true, false, false)
                    outputChatBox("[!]#FFFFFF Araç tamir edilmeye başladı lütfen bekleyiniz.", thePlayer, 255, 194, 14, true)
					setElementFrozen(veh,true)
					setTimer(function(thePlayer)
					if (veh) then
						fixVehicle(veh)
						if (getElementData(veh, "Impounded") == 0) then
							--exports.rl_anticheat:changeProtectedElementDataEx(veh, "enginebroke", 0, false)

								setVehicleDamageProof(veh, false)
						end
						for i = 0, 5 do
							setVehicleDoorState(veh, i, 0)
						end

						exports["rl_items"]:takeItem(thePlayer,999)
						exports["rl_vehicle_manager"]:addVehicleLogs(getElementData(veh,"dbid"), "Tamir Kiti Kullandı", thePlayer)
						outputChatBox("[!]#FFFFFF Aracınız tamir edildi.", thePlayer, 255, 194, 14, true)
						exports.rl_global:applyAnimation(thePlayer , "" , "" , -1 , true, false, false)
							setElementFrozen(thePlayer,false)
					setElementFrozen(veh,false)
					setElementData(thePlayer,"tamirediyor",nil)
						
						end
						end,10000,1,thePlayer)
	end
end
addCommandHandler("tamirkiti", tamirkits)



function getNearestVehicle( thesource )  
    local x, y, z = getElementPosition( thesource )  
    local prevDistance  
    local nearestVehicle  
    for i, v in ipairs( getElementsByType( "vehicle" ) ) do  
        local distance = getDistanceBetweenPoints3D( x+0.50, y, z, getElementPosition( v ) )  
        -- if distance <= ( prevDistance or distance + 1 ) then 
		if ( distance < 3.60 ) then
            prevDistance = distance  
            nearestVehicle = v 
        end  
    end  
    return nearestVehicle or false  
end 