--- Discord : https://discord.gg/DzgEcvy-- Author : ExEr
function centerWindow (center_window)
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize(center_window, false)
    local x, y = (screenW - windowW) /2,(screenH - windowH) /2
    return guiSetPosition(center_window, x, y, false)
end

-- Default
resetFarClipDistance()
resetFogDistance()
resetPedsLODDistance()
resetVehiclesLODDistance()

-- Distancia de visión
vDefault = getFarClipDistance()
vDistance = {
      {"Varsayılan", vDefault},
      {"Normal", 200},
      {"Orta", 500},
      {"Yüksek", 1000},
      {"Çok Yüksek", 2000},
}

-- Distancia de neblina
fDefault = getFogDistance()
fDistance = {
      {"Var Sayılan", fDefault},
      {"Normal", 100},
      {"Orta", 250},
      {"Yüksek", 500},
      {"Çok Yüksek", 1000},
}

-- Distancia de renderizado de personajes
rpDefault = getPedsLODDistance()
rpDistance = {
      {"Varsayılan", rpDefault},
      {"Normal", 25},
      {"Orta", 50},
      {"Yüksek", 90},
      {"Çok Yüksek", 200},
}

-- Distancia de renderizado de vehiculos
rvDefault = getVehiclesLODDistance()
rvDistance = {
      {"Varsayılan", rvDefault},
      {"Normal", 25},
      {"Orta", 50},
      {"Yüksek", 90},
      {"Çok Yüksek", 200},
}

-- Panel Anti-lag
gui = {
      window = {},
      label = {},
      combobox = {},
      button = {},
      checkbox = {},
}

gui.window = guiCreateWindow( 0, 0, 400, 250, "FPS Optimizasyon Panel - Reval Roleplay", false )
gui.label[1] = guiCreateLabel( 10, 30, 200, 20, "Görüş Mesafesi:", false, gui.window )
gui.label[2] = guiCreateLabel( 10, 60, 200, 20, "Duman/Sis:", false, gui.window )
gui.label[3] = guiCreateLabel( 10, 90, 220, 20, "Karakter Detayları:", false, gui.window )
gui.label[4] = guiCreateLabel( 10, 120, 220, 20, "Araba Detayları:", false, gui.window )
gui.combobox[1] = guiCreateComboBox( 230, 27.5, 150, 105, vDistance[1][1], false, gui.window )
gui.combobox[2] = guiCreateComboBox( 230, 57.5, 150, 105, fDistance[1][1], false, gui.window )
gui.combobox[3] = guiCreateComboBox( 230, 87.5, 150, 105, rpDistance[1][1], false, gui.window )
gui.combobox[4] = guiCreateComboBox( 230, 117.5, 150, 105, rvDistance[1][1], false, gui.window )
gui.button[1] = guiCreateButton( 10, 210, 187.5, 30, "Uygula", false, gui.window )
gui.button[2] = guiCreateButton( 205, 210, 187.5, 30, "Kapat", false, gui.window )
gui.checkbox[1] = guiCreateCheckBox( 10, 145, 120, 30, "Güneş Görseli", false, false, gui.window )
gui.checkbox[2] = guiCreateCheckBox( 10, 170, 120, 30, "Ay Görseli", false, false, gui.window )
gui.checkbox[3] = guiCreateCheckBox( 145, 145, 120, 30, "Gökyüzü Görseli", false, false, gui.window )
gui.checkbox[4] = guiCreateCheckBox( 145, 170, 120, 30, "Optimizasyon #1", false, false, gui.window )
gui.checkbox[5] = guiCreateCheckBox( 265, 145, 125, 30, "Optimizasyon #2", false, false, gui.window )
gui.checkbox[6] = guiCreateCheckBox( 265, 170, 120, 30, "Ağaçları Kaldır", false, false, gui.window )

guiSetVisible( gui.window, false )
centerWindow( gui.window )

for i = 1, 5 do
      guiComboBoxAddItem( gui.combobox[1], vDistance[i][1])
      guiComboBoxAddItem( gui.combobox[2], fDistance[i][1])
      guiComboBoxAddItem( gui.combobox[3], rpDistance[i][1])
      guiComboBoxAddItem( gui.combobox[4], rvDistance[i][1])
end

config = {}

addEventHandler( "onClientGUIClick", gui.button[1],
      function()
            for i = 1, 4 do
                  if guiComboBoxGetSelected( gui.combobox[i] ) == -1 then
                        guiComboBoxSetSelected( gui.combobox[i] , 0 )
                  end
            end
            setFarClipDistance( vDistance[guiComboBoxGetSelected( gui.combobox[1] )+1][2] )
            setFogDistance( fDistance[guiComboBoxGetSelected( gui.combobox[2] )+1][2] )
            setPedsLODDistance( rpDistance[guiComboBoxGetSelected( gui.combobox[3] )+1][2] )
            setVehiclesLODDistance( rvDistance[guiComboBoxGetSelected( gui.combobox[4] )+1][2] )
            if guiCheckBoxGetSelected( gui.checkbox[1] ) then
                  setSunColor( 0, 0, 0, 0, 0, 0 )
                  setSunSize( 0 )
            else
                  resetSunColor()
                  resetSunSize()
            end
            if guiCheckBoxGetSelected( gui.checkbox[2] ) then
                  setMoonSize( 0 )
            else
                  resetMoonSize()
            end
            if guiCheckBoxGetSelected( gui.checkbox[3] ) then
                  setSkyGradient( 0, 0, 0, 0, 0, 0 )
            else
                  resetSkyGradient()
            end
            if guiCheckBoxGetSelected( gui.checkbox[4] ) then
                  setCloudsEnabled( false )
                  setBirdsEnabled( false )
            else
                  setCloudsEnabled( true )
                  setBirdsEnabled( true )
            end
            if guiCheckBoxGetSelected( gui.checkbox[5] ) then
                  setOcclusionsEnabled( false )
            else
                  setOcclusionsEnabled( true )
            end
            if guiCheckBoxGetSelected( gui.checkbox[6] ) then -- Idea de remover arboles por Rhypasa99 ( https://community.multitheftauto.com/index.php?p=profile&id=416706 )
                  for i = 615, 904 do      
                        removeWorldModel( i, 100000000, 0, 0, 0 )  
                  end
            else
                  for i = 615, 904 do      
                        restoreWorldModel( i, 100000000, 0, 0, 0 )  
                  end
            end
      end, false
)

addEventHandler( "onClientGUIClick", gui.button[2], 
      function()
            guiSetVisible( gui.window, false )
            showCursor( false )
      end, false
)

addCommandHandler( "fpspanel",
      function()
            guiSetVisible( gui.window, true )
            showCursor( true )
      end
)
-- Author : ExEr-- Türkçe Çeviri : SparroWMTA
--- Sitemiz : https://sparrow-mta.blogspot.com/--- Facebook : https://facebook.com/sparrowgta/--- İnstagram : https://instagram.com/sparrowmta/--- YouTube : https://www.youtube.com/@TurkishSparroW/--- Discord : https://discord.gg/DzgEcvy