local entrada1 = createMarker( 1944.701171875, -1772.755859375, 13.390598297119, "cylinder", 1, 255, 255, 255, 0)
local Font = dxCreateFont("yazitipleri/Font.ttf", 12)
local FontSmall = dxCreateFont("yazitipleri/Font.ttf", 6)

addEventHandler( "onClientRender", root, function()
       local x, y, z = getElementPosition( entrada1 )
       local Mx, My, Mz = getCameraMatrix(   )
        if ( getDistanceBetweenPoints3D( x, y, z, Mx, My, Mz ) <= 30 ) then
           local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z +0.2, 0.07 )
           local WorldPositionX2, WorldPositionY2 = getScreenFromWorldPosition( x, y, z +0.08, 0.07 )
            if ( WorldPositionX and WorldPositionY ) then
			    dxDrawText("/yakital\n #ffffff[Lt $2#ffffff]", WorldPositionX - 2, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(0,0,0, 255), 1.12, Font, "center", "center", false, false, false, true, false)
			    dxDrawText("/yakital\n #ffffff[Lt $2#ffffff]", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255,255,255, 255), 1.12, Font, "center", "center", false, false, false, true, false)
            end
      end
end 
)