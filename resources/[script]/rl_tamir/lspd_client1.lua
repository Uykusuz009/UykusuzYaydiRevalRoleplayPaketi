--LSPD GARAJ--
--LSPD GARAJ--
 local LSPD_tamirci_marker = createMarker ( 1602.740234375, -1629.3310546875, 24, "cylinder", 5, 255, 255, 0, 0 )
 local DEA_tamirci_marker = createMarker ( 1535.7939453125, -1478.4189453125, 9.5, "cylinder", 5, 255, 255, 0, 0 )
 -- local LSPD_tamirci_marker = createMarker ( 1261.19140625, -1795.1591796875, 13.420709609985, "cylinder", 5, 255, 255, 0, 0 )
 -- local LSPD_tamirci_marker = createMarker ( 796.5703125, -1615.7449951172, 13.358750343323, "cylinder", 5, 255, 255, 0, 0 )
 -- local LSPD_tamirci_marker = createMarker ( 1547.125, -1642.958984375, 5.890625, "cylinder", 5, 255, 255, 0, 0 )
 
function LSPD_marker_giris ( lspd_giren )
	local fact = getElementData(localPlayer, "faction")
	if  (fact == 1) then 
	if lspd_giren == localPlayer then
		local lspd_arac = getPedOccupiedVehicle ( lspd_giren )
		if lspd_arac then
		fixVehicle(lspd_arac)
		 setElementFrozen(lspd_arac,true)
		 setElementFrozen(lspd_arac,false)
		outputChatBox("[!] Aracınız başarıyla tamir edilmiştir. [REM]", 255, 194, 0)
		else
		outputChatBox("[!] REM Üyesi değilsiniz.", 255, 194, 0)
		setElementFrozen(lspd_arac,false)
		end
		end
	end	
end
addEventHandler ( "onClientMarkerHit", LSPD_tamirci_marker, LSPD_marker_giris )

 -- local LSPD_tamirci_marker = createMarker ( 2402.962890625, -1496.2587890625, 24, "cylinder", 5, 255, 255, 0, 0 )
 local LSPD_tamirci_marker1 = createMarker ( 1261.19140625, -1795.1591796875, 13.420709609985, "cylinder", 5, 255, 255, 0, 0 )
 -- local LSPD_tamirci_marker = createMarker ( 796.5703125, -1615.7449951172, 13.358750343323, "cylinder", 5, 255, 255, 0, 0 )
 -- local LSPD_tamirci_marker = createMarker ( 1547.125, -1642.958984375, 5.890625, "cylinder", 5, 255, 255, 0, 0 )
 
function LSPD_marker_giris1 ( lspd_giren )
	local fact = getElementData(localPlayer, "faction")
	if  (fact == 1) then 
	if lspd_giren == localPlayer then
		local lspd_arac = getPedOccupiedVehicle ( lspd_giren )
		if lspd_arac then
		fixVehicle(lspd_arac)
		 setElementFrozen(lspd_arac,true)
		 setElementFrozen(lspd_arac,false)
		outputChatBox("[!] Aracınız başarıyla tamir edilmiştir. [REM]", 255, 194, 0)
		else
		outputChatBox("[!] REM Üyesi değilsiniz.", 255, 194, 0)
		setElementFrozen(lspd_arac,false)
		end
		end
	end	
end
addEventHandler ( "onClientMarkerHit", LSPD_tamirci_marker1, LSPD_marker_giris1 )

 -- local LSPD_tamirci_marker = createMarker ( 2402.962890625, -1496.2587890625, 24, "cylinder", 5, 255, 255, 0, 0 )
 -- local LSPD_tamirci_marker = createMarker ( 1261.19140625, -1795.1591796875, 13.420709609985, "cylinder", 5, 255, 255, 0, 0 )
 local LSPD_tamirci_marker2 = createMarker ( 796.5703125, -1615.7449951172, 13.358750343323, "cylinder", 5, 255, 255, 0, 0 )
 -- local LSPD_tamirci_marker = createMarker ( 1547.125, -1642.958984375, 5.890625, "cylinder", 5, 255, 255, 0, 0 )
 
function LSPD_marker_giris2 ( lspd_giren )
	local fact = getElementData(localPlayer, "faction")
	if  (fact == 1) then 
	if lspd_giren == localPlayer then
		local lspd_arac = getPedOccupiedVehicle ( lspd_giren )
		if lspd_arac then
		fixVehicle(lspd_arac)
		 setElementFrozen(lspd_arac,true)
		 setElementFrozen(lspd_arac,false)
		outputChatBox("[!] Aracınız başarıyla tamir edilmiştir. [REM]", 255, 194, 0)
		else
		outputChatBox("[!] REM Üyesi değilsiniz.", 255, 194, 0)
		setElementFrozen(lspd_arac,false)
		end
		end
	end	
end
addEventHandler ( "onClientMarkerHit", LSPD_tamirci_marker2, LSPD_marker_giris2 )

 -- local LSPD_tamirci_marker = createMarker ( 2402.962890625, -1496.2587890625, 24, "cylinder", 5, 255, 255, 0, 0 )
 -- local LSPD_tamirci_marker = createMarker ( 1261.19140625, -1795.1591796875, 13.420709609985, "cylinder", 5, 255, 255, 0, 0 )
 -- local LSPD_tamirci_marker = createMarker ( 796.5703125, -1615.7449951172, 13.358750343323, "cylinder", 5, 255, 255, 0, 0 )
 local LSPD_tamirci_marker3 = createMarker ( 1547.125, -1642.958984375, 5.890625, "cylinder", 5, 255, 255, 0, 0 )
 
function LSPD_marker_giris3 ( lspd_giren )
	local fact = getElementData(localPlayer, "faction")
	if  (fact == 1) then 
	if lspd_giren == localPlayer then
		local lspd_arac = getPedOccupiedVehicle ( lspd_giren )
		if lspd_arac then
		fixVehicle(lspd_arac)
		 setElementFrozen(lspd_arac,true)
		 setElementFrozen(lspd_arac,false)
		outputChatBox("[!] Aracınız başarıyla tamir edilmiştir. [REM]", 255, 194, 0)
		else
		outputChatBox("[!] REM Üyesi değilsiniz.", 255, 194, 0)
		setElementFrozen(lspd_arac,false)
		end
		end
	end	
end
addEventHandler ( "onClientMarkerHit", LSPD_tamirci_marker3, LSPD_marker_giris3 )

 local DEA_tamirci_marker2 = createMarker ( 355.7236328125, 892.783203125, 1154.9787597656, "cylinder", 5, 255, 255, 0, 0 )

function DEA_tamirci_marker ( lspd_giren )
	local fact = getElementData(localPlayer, "faction")
	if  (fact == 2) then 
	if lspd_giren == localPlayer then
		local lspd_arac = getPedOccupiedVehicle ( lspd_giren )
		if lspd_arac then
		fixVehicle(lspd_arac)
		 setElementFrozen(lspd_arac,true)
		 setElementFrozen(lspd_arac,false)
		outputChatBox("[!] Aracınız başarıyla tamir edilmiştir. [RSM]", 255, 194, 0)
		else
		outputChatBox("[!] RSM Üyesi değilsiniz.", 255, 194, 0)
		setElementFrozen(lspd_arac,false)
		end
		end
	end	
end

addEventHandler( "onClientMarkerHit", DEA_tamirci_marker2, DEA_tamirci_marker )

--LSPD GARAJ--
--LSPD GARAJ--

--LSPD GARAJ YAZI--
--LSPD GARAJ YAZI--
--local alpha = 0
--local r, g, b = 255, 255, 255
--local size = 1.5
--local typem = "cylinder"
--local posx, posy, posz = 2402.962890625, -1496.2587890625, 24

--local entradaB = createMarker (posx, posy, posz, typem, size, r, g, b, alpha)

--addEventHandler( "onClientRender", root, function (  )
       --local x, y, z = getElementPosition( entradaB )
      -- local Mx, My, Mz = getCameraMatrix(   )
     --   if ( getDistanceBetweenPoints3D( x, y, z, Mx, My, Mz ) <= 20 ) then
          -- local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z +1, 0.07 )
            --( WorldPositionX and WorldPositionY ) then
			   -- dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX - 1, WorldPositionY - 1, WorldPositionX - 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			   -- dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX + 1, WorldPositionY - 1, WorldPositionX + 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			   -- dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			   -- dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX + 1, WorldPositionY + 1, WorldPositionX + 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    --dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX, WorldPositionY, WorldPositionX, WorldPositionY, tocolor(255, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
            --end
      --end
--end 
-- )
--LSPD GARAJ YAZI--
--LSPD GARAJ YAZI--
-- local alpha = 0
-- local r, g, b = 255, 255, 255
-- local size = 1.5
-- local typem = "cylinder"
-- local posx, posy, posz = 1260.8505859375, -1795.529296875, 13.420930862427

-- local entradaB = createMarker (posx, posy, posz, typem, size, r, g, b, alpha)

-- addEventHandler( "onClientRender", root, function (  )
       -- local x, y, z = getElementPosition( entradaB )
       -- local Mx, My, Mz = getCameraMatrix(   )
        -- if ( getDistanceBetweenPoints3D( x, y, z, Mx, My, Mz ) <= 20 ) then
           -- local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z +1, 0.07 )
            -- if ( WorldPositionX and WorldPositionY ) then
			    -- dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX - 1, WorldPositionY - 1, WorldPositionX - 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    -- dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX + 1, WorldPositionY - 1, WorldPositionX + 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    -- dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    -- dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX + 1, WorldPositionY + 1, WorldPositionX + 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    -- dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX, WorldPositionY, WorldPositionX, WorldPositionY, tocolor(255, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
            -- end
      -- end
-- end 
-- )
-- local alpha = 0
-- local r, g, b = 255, 255, 255
-- local size = 1.5
-- local typem = "cylinder"
-- local posx, posy, posz = 796.5703125, -1615.7449951172, 13.358750343323

-- local entradaB = createMarker (posx, posy, posz, typem, size, r, g, b, alpha)

-- addEventHandler( "onClientRender", root, function (  )
       -- local x, y, z = getElementPosition( entradaB )
       -- local Mx, My, Mz = getCameraMatrix(   )
        -- if ( getDistanceBetweenPoints3D( x, y, z, Mx, My, Mz ) <= 20 ) then
           -- local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z +1, 0.07 )
            -- if ( WorldPositionX and WorldPositionY ) then
			    -- dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX - 1, WorldPositionY - 1, WorldPositionX - 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    -- dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX + 1, WorldPositionY - 1, WorldPositionX + 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    -- dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    -- dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX + 1, WorldPositionY + 1, WorldPositionX + 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    -- dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX, WorldPositionY, WorldPositionX, WorldPositionY, tocolor(255, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
            -- end
      -- end
-- end 
-- )
-- local alpha = 0
-- local r, g, b = 255, 255, 255
-- local size = 1.5
-- local typem = "cylinder"
-- local posx, posy, posz = 1547.125, -1642.958984375, 5.890625

-- local entradaB = createMarker (posx, posy, posz, typem, size, r, g, b, alpha)

-- addEventHandler( "onClientRender", root, function (  )
       -- local x, y, z = getElementPosition( entradaB )
       -- local Mx, My, Mz = getCameraMatrix(   )
        -- if ( getDistanceBetweenPoints3D( x, y, z, Mx, My, Mz ) <= 20 ) then
           -- local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z +1, 0.07 )
            -- if ( WorldPositionX and WorldPositionY ) then
			    -- dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX - 1, WorldPositionY - 1, WorldPositionX - 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    -- dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX + 1, WorldPositionY - 1, WorldPositionX + 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    -- dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    -- dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX + 1, WorldPositionY + 1, WorldPositionX + 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    -- dxDrawText("[PD] Içeri Girip Bekleyin", WorldPositionX, WorldPositionY, WorldPositionX, WorldPositionY, tocolor(255, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
            -- end
      -- end
-- end 
-- )