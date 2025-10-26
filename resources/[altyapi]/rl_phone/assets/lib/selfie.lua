local rootElement = getRootElement ( )
local mplayer = getLocalPlayer ( )
local sw, sh = guiGetScreenSize ( )

local speed, strafespeed = 0, 0
local rotX, rotY = 0,0
local mouseFrameDelay = 0


addEventHandler( "onClientResourceStart", getRootElement( ),
    function ( startedRes )
       setPedAnimation( mplayer, false)
	   removeEventHandler ( "onClientPreRender", rootElement, render )
	   removeEventHandler ( "onClientCursorMove", rootElement, mousecalc )
	 --  setCameraTarget ( mplayer )
    end
);


local options = 
{
    invertMouseLook = false,
    mouseSensitivity = 0.15
}

function math.clamp ( value, lower, upper )
 value, lower, upper = tonumber ( value ), tonumber ( lower ), tonumber ( upper )
 if value and lower and upper then
  if value < lower then 
   value = lower
  elseif value > upper then 
   value = upper 
  end
  return value
 end
 return false
end

function getElementOffset ( entity, offX, offY, offZ )
 local posX, posY, posZ = 0, 0, 0
 if isElement ( entity ) and type ( offX ) == "number" and type ( offY ) == "number" and type ( offZ ) == "number" then
  local center = getElementMatrix ( entity )
  if center then
   posX = offX * center [ 1 ] [ 1 ] + offY * center [ 2 ] [ 1 ] + offZ * center [ 3 ] [ 1 ] + center [ 4 ] [ 1 ]
   posY = offX * center [ 1 ] [ 2 ] + offY * center [ 2 ] [ 2 ] + offZ * center [ 3 ] [ 2 ] + center [ 4 ] [ 2 ]
   posZ = offX * center [ 1 ] [ 3 ] + offY * center [ 2 ] [ 3 ] + offZ * center [ 3 ] [ 3 ] + center [ 4 ] [ 3 ]
  end
 end
 return posX, posY, posZ
end
addEvent("selfiephone",true)
addEventHandler ( "selfiephone", root,function()
  if isElement ( ) then
   -- setPedAnimation( mplayer, "PED", "gang_gunstand")
   addEventHandler ( "onClientPreRender", rootElement, render )
   addEventHandler ( "onClientCursorMove", rootElement, mousecalc )
   setPlayerHudComponentVisible ( "radar", false )
 else
	-- setPedAnimation( mplayer, false)
   removeEventHandler ( "onClientPreRender", rootElement, render )
   removeEventHandler ( "onClientCursorMove", rootElement, mousecalc )
 --  setCameraTarget ( mplayer )
   --showPlayerHudComponent ( "radar", true )
  end
end )

addEventHandler("onClientPreRender", root, function()
	for i, player in ipairs(getElementsByType("player")) do
		if getElementData(player,"selfiemod") == true then
			setElementBoneRotation(player, 22, 0, 260, 0)
			setElementBoneRotation(player, 23, 0, 0, 20)
			setElementBoneRotation(player, 25, 50, 0, 0)
			updateElementRpHAnim(player)
		end
	end
end)

addCommandHandler("aso",function()
	setElementData(localPlayer,"selfiemod",false)
end)

function render ( )
 local PI = math.pi
 if getKeyState ( "num_4" ) then
  rotX = rotX - options.mouseSensitivity * 0.05745
 elseif getKeyState ( "num_6" ) then
  rotX = rotX + options.mouseSensitivity * 0.05745
 end
 if getKeyState ( "num_8" ) then
  rotY = rotY + options.mouseSensitivity * 0.05745  
  rotY = math.clamp ( rotY, -PI / 2.05, PI / 2.05 )
 elseif getKeyState ( "num_2" ) then
  rotY = rotY - options.mouseSensitivity * 0.05745
  rotY = math.clamp ( rotY, -PI / 2.05, PI / 2.05 )
 end
 local cameraAngleX = rotX 
 local cameraAngleY = rotY

 local freeModeAngleZ = math.sin(cameraAngleY)
 local freeModeAngleY = math.cos(cameraAngleY) * math.cos(cameraAngleX)
 local freeModeAngleX = math.cos(cameraAngleY) * math.sin(cameraAngleX)
 if getElementData(localPlayer,"selfiemod") == true then
	camPosX, camPosY, camPosZ = getPedBonePosition ( mplayer, 25)
 else
	camPosX, camPosY, camPosZ = getPedBonePosition ( mplayer, 4)
 end
 camPosZ = camPosZ + 0.29
 --Puxando a câmera na frente do estômago
 if rotY < 0  then --Se a câmera olhar para baixo
  local r = getPedRotation ( mplayer )
  camPosX = camPosX - math.sin ( math.rad(r) ) * (-rotY/4.5)
  camPosY = camPosY + math.cos ( math.rad(r) ) * (-rotY/4.5)
 end
 local camTargetX = camPosX + freeModeAngleX * 100
 local camTargetY = camPosY + freeModeAngleY * 100
 local camTargetZ = camPosZ + freeModeAngleZ * 100
  
 local camAngleX = camPosX - camTargetX
 local camAngleY = camPosY - camTargetY
 local camAngleZ = 0
 
 local angleLength = math.sqrt(camAngleX*camAngleX+camAngleY*camAngleY+camAngleZ*camAngleZ)

  local camNormalizedAngleX = camAngleX / angleLength
  local camNormalizedAngleY = camAngleY / angleLength
  local camNormalizedAngleZ = 0
  local normalAngleX = 0
  local normalAngleY = 0
  local normalAngleZ = 1
  local normalX = (camNormalizedAngleY * normalAngleZ - camNormalizedAngleZ * normalAngleY)
  local normalY = (camNormalizedAngleZ * normalAngleX - camNormalizedAngleX * normalAngleZ)
  local normalZ = (camNormalizedAngleX * normalAngleY - camNormalizedAngleY * normalAngleX)
  camPosX = camPosX + freeModeAngleX * speed
  camPosY = camPosY + freeModeAngleY * speed
  camPosZ = camPosZ + freeModeAngleZ * speed
  camPosX = camPosX + normalX * strafespeed
  camPosY = camPosY + normalY * strafespeed
  camPosZ = camPosZ + normalZ * strafespeed
  camTargetX = camPosX + freeModeAngleX * 100
  camTargetY = camPosY + freeModeAngleY * 100
  camTargetZ = camPosZ + freeModeAngleZ * 100
  if isPedInVehicle ( mplayer ) and getKeyState ( "mouse1" ) ~= true then
   -- if getPedControlState ( "vehicle_look_behind" ) then
    -- camTargetX, camTargetY, camTargetZ = getElementOffset ( mplayer, 0, -3, 0 )
   -- else
    camTargetX, camTargetY, camTargetZ = getElementOffset ( mplayer, 0, 3, 0 )
   -- end
  end
 setPedAimTarget ( mplayer, camTargetX, camTargetY, camTargetZ )
-- setCameraMatrix ( camPosX, camPosY, camPosZ, camTargetX, camTargetY, camTargetZ )
end

function mousecalc ( _, _, aX, aY )
 if isCursorShowing ( ) or isMTAWindowActive ( ) then
  mouseFrameDelay = 5
  return
 elseif mouseFrameDelay > 0 then
  mouseFrameDelay = mouseFrameDelay - 1
  return
 end
 
 aX = aX - sw / 2 
 aY = aY - sh / 2
 
 if options.invertMouseLook then
  aY = -aY
 end
 
 rotX = rotX + aX * options.mouseSensitivity * 0.01745
 rotY = rotY - aY * options.mouseSensitivity * 0.01745
    
 local PI = math.pi
 if rotX > PI then
  rotX = rotX - 2 * PI
 elseif rotX < -PI then
  rotX = rotX + 2 * PI
 end
    
 if rotY > PI then
  rotY = rotY - 2 * PI
 elseif rotY < -PI then
  rotY = rotY + 2 * PI
 end

 rotY = math.clamp ( rotY, -PI / 2.05, PI / 2.05 )
end