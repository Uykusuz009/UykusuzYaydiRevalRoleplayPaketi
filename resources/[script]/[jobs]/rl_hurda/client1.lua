local hurda = createMarker(1610.263671875, -2161.861328125, 13.5546875, "cylinder", 1, 255, 255, 255, 0)

addEventHandler( "onClientRender", root, function()
       local x, y, z = getElementPosition( hurda )
       local Mx, My, Mz = getCameraMatrix(   )
        if ( getDistanceBetweenPoints3D( x, y, z, Mx, My, Mz ) <= 15 ) then
           local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z, 0.07 )
            if ( WorldPositionX and WorldPositionY ) then
			    dxDrawText("/sok [kapı,kaporta,lastik]", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 2.52, "default-bold", "center", "center", false, false, false, false, false)
			    dxDrawText("/sok [kapı,kaporta,lastik]", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 255), 2.50, "default-bold", "center", "center", false, false, false, false, false)
            end
      end
end 
)


local hurda2 = createMarker(1597.2724609375, -2174, 13.5546875, "cylinder", 1, 255, 255, 255, 0)

addEventHandler( "onClientRender", root, function()
       local x, y, z = getElementPosition( hurda2 )
       local Mx, My, Mz = getCameraMatrix(   )
        if ( getDistanceBetweenPoints3D( x, y, z, Mx, My, Mz ) <= 15 ) then
           local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z, 0.07 )
            if ( WorldPositionX and WorldPositionY ) then
			    dxDrawText("/parca sat", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 2.52, "default-bold", "center", "center", false, false, false, false, false)
			    dxDrawText("/parca sat", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 255), 2.50, "default-bold", "center", "center", false, false, false, false, false)
            end
      end
end 
)



local hurda3 = createMarker(1598.822265625,-2154.72265625, 13.5546875, "cylinder", 1, 255, 255, 255, 0)

addEventHandler( "onClientRender", root, function()
       local x, y, z = getElementPosition( hurda3)
       local Mx, My, Mz = getCameraMatrix(   )
        if ( getDistanceBetweenPoints3D( x, y, z, Mx, My, Mz ) <= 15 ) then
           local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z, 0.07 )
            if ( WorldPositionX and WorldPositionY ) then
			    dxDrawText("/satınal arac", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 2.52, "default-bold", "center", "center", false, false, false, false, false)
			    dxDrawText("/satınal arac", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 255), 2.50, "default-bold", "center", "center", false, false, false, false, false)
            end
      end
end 
)




--function sesAc()
   -- playSound( "drill.mp3" )
    --end
   -- addEvent("ses:ac",true)
    --addEventHandler("ses:ac",getLocalPlayer(),sesAc)