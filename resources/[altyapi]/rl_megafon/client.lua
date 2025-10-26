function soundLSPD(player,file,x,y,z)

local uSound = playSound3D(file,x,y,z) 
setSoundMaxDistance(uSound, 50)
-- setSoundVolume(uSound, 1.5)
local car = getPedOccupiedVehicle ( player )
attachElements ( uSound, car, 0, 5, 1 )

end
addEvent("play:lspd",true)
addEventHandler("play:lspd",getRootElement(),soundLSPD)

