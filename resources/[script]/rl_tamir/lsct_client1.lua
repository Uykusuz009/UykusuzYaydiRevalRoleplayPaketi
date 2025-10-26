--LSCT GARAJ--
--LSCT GARAJ--
 local LSCT_tamirci_marker = createMarker ( 2689.6298828125, -2650.6025390625, 13.487837791443, "cylinder", 5, 255, 255, 0, 0 )
 
function LSCT_marker_giris ( lsct_giren )
	if lsct_giren == localPlayer then
		local lsct_arac = getPedOccupiedVehicle ( lsct_giren )
		if lsct_arac then
		fixVehicle(lsct_arac)
		 setElementRotation(lsct_arac,0,0,360)
		 setElementFrozen(lsct_arac,true)
		outputChatBox("[!] Aracınız başarıyla tamir edilmiştir. [ITV]", 255, 194, 0)
		setElementFrozen(lsct_arac,false)
		end
	end	
end
addEventHandler ( "onClientMarkerHit", LSCT_tamirci_marker, LSCT_marker_giris )
--LSCT GARAJ--
--LSCT GARAJ--

--LSCT GARAJ YAZI--
--LSCT GARAJ YAZI--
local alpha = 0
local r, g, b = 255, 255, 255
local size = 1.5
local typem = "cylinder"
local posx, posy, posz = 2689.2939453125, -2647.5, 13.489029884338

local entradaB = createMarker (posx, posy, posz, typem, size, r, g, b, alpha)

-- addEventHandler( "onClientRender", root, function (  )
       -- local x, y, z = getElementPosition( entradaB )
       -- local Mx, My, Mz = getCameraMatrix(   )
        -- if ( getDistanceBetweenPoints3D( x, y, z, Mx, My, Mz ) <= 30 ) then
           -- local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z +1, 0.07 )
            -- if ( WorldPositionX and WorldPositionY ) then
			    -- dxDrawText("[ITV] Içeri Girip Bekleyin", WorldPositionX - 1, WorldPositionY - 1, WorldPositionX - 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    -- dxDrawText("[ITV] Içeri Girip Bekleyin", WorldPositionX + 1, WorldPositionY - 1, WorldPositionX + 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    -- dxDrawText("[ITV] Içeri Girip Bekleyin", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    -- dxDrawText("[ITV] Içeri Girip Bekleyin", WorldPositionX + 1, WorldPositionY + 1, WorldPositionX + 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    -- dxDrawText("[ITV] Içeri Girip Bekleyin", WorldPositionX, WorldPositionY, WorldPositionX, WorldPositionY, tocolor(255, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
            -- end
      -- end
-- end 
-- )
--LSCT GARAJ YAZI--
--LSCT GARAJ YAZI--

--İMPOUND GİRİŞ TAMİR--
--İMPOUND GİRİŞ TAMİR--
local LSCT_tamirci_marker1 = createMarker ( 2666.076171875, -2688.595703125, 13.46958732605, "cylinder", 5, 255, 255, 0, 0 )

function LSCT_marker_giris1 ( lsct_giren1 )
	if lsct_giren1 == localPlayer then
		local lsct_arac1 = getPedOccupiedVehicle ( lsct_giren1 )
		if lsct_arac1 then
		fixVehicle(lsct_arac1)
		end
	end	
end
addEventHandler ( "onClientMarkerHit", LSCT_tamirci_marker1, LSCT_marker_giris1 )
--İMPOUND GİRİŞ TAMİR--
--İMPOUND GİRİŞ TAMİR--