-- Script: artifacts
-- Description: Handles artifacts (things players can wear that are not clothes)
-- Client-Side
-- Created by Exciter for Reval Roleplay, 15.05.2014 (DD/MM/YYYY)
-- Thanks to Adams, iG Scripting Team and RPP Scripting Team for their base work.
-- License: BSD

function replaceModels()
    -- Credit for models goes to Adams

	--Fishing Rod
	local txd = engineLoadTXD("models/rod.txd")
    engineImportTXD(txd, 16442)
	local dff = engineLoadDFF("models/rod.dff", 16442)
    engineReplaceModel(dff, 16442)
	
	--Motocross Helmet
    local txd = engineLoadTXD("models/pro.txd")
    engineImportTXD(txd, 2799)
    local dff = engineLoadDFF("models/pro.dff", 2799)
    engineReplaceModel(dff, 2799)
    local col = engineLoadCOL("models/helmet.col")
    engineReplaceCOL(col, 2799)

    --Biker Helmet
    local txd = engineLoadTXD("models/bikerhelmet.txd")
    engineImportTXD(txd, 3911)
    local dff = engineLoadDFF("models/bikerhelmet.dff", 3911)
    engineReplaceModel(dff, 3911)
    --local col = engineLoadCOL("models/helmet.col")
    engineReplaceCOL(col, 3911)
	
	
	 --Bass Guitar
    local txd = engineLoadTXD("models/bassguitar01.txd")
    engineImportTXD(txd, 19317)
    local dff = engineLoadDFF("models/bassguitar01.dff", 19317)
    engineReplaceModel(dff, 19317)
    --local col = engineLoadCOL("models/helmet.col")
    engineReplaceCOL(col, 19317)

    --Full Face Helmet
    local txd = engineLoadTXD("models/fullfacehelmet.txd")
    engineImportTXD(txd, 3917)
    local dff = engineLoadDFF("models/fullfacehelmet.dff", 3917)
    engineReplaceModel(dff, 3917)
     --local col = engineLoadCOL("models/helmet.col")
    engineReplaceCOL(col, 3917)
   
    --Gas Mask
    local txd = engineLoadTXD("models/gasmask.txd")
    engineImportTXD(txd, 3890)
    local dff = engineLoadDFF("models/gasmask.dff", 3890)
    engineReplaceModel(dff, 3890)
	
	--Hockey Mask
    local txd = engineLoadTXD("models/hockeymask.txd")
    engineImportTXD(txd, 2397)
    local dff = engineLoadDFF("models/hockeymask.dff", 2397)
    engineReplaceModel(dff, 2397)

	--Katil Mask
    local txd = engineLoadTXD("models/katilmask.txd")
    engineImportTXD(txd, 1667)
    local dff = engineLoadDFF("models/katilmask.dff", 1667)
    engineReplaceModel(dff, 1667)
	
	--Glass
    local txd = engineLoadTXD("models/glass.txd")
    engineImportTXD(txd, 1666)
    local dff = engineLoadDFF("models/glass.dff", 1666)
    engineReplaceModel(dff, 1666)
	
	--İronman Mask
    local txd = engineLoadTXD("models/ironmanmask.txd")
    engineImportTXD(txd, 2409)
    local dff = engineLoadDFF("models/ironmanmask.dff", 2409)
    engineReplaceModel(dff, 2409)
	
	--Cap 
    local txd = engineLoadTXD("models/cap.txd")
    engineImportTXD(txd, 2411)
    local dff = engineLoadDFF("models/cap.dff", 2411)
    engineReplaceModel(dff, 2411)
	
	--Kese Mask
    local txd = engineLoadTXD("models/kesemask.txd")
    engineImportTXD(txd, 2410)
    local dff = engineLoadDFF("models/kesemask.dff", 2410)
    engineReplaceModel(dff, 2410)
	
	--Elektro Mask
    local txd = engineLoadTXD("models/elektromask.txd")
    engineImportTXD(txd, 2408)
    local dff = engineLoadDFF("models/elektromask.dff", 2408)
    engineReplaceModel(dff, 2408)
	
	--Monkey Mask
    local txd = engineLoadTXD("models/monkeymask.txd")
    engineImportTXD(txd, 2398)
    local dff = engineLoadDFF("models/monkeymask.dff", 2398)
    engineReplaceModel(dff, 2398)
	
	--Carnival Mask
    local txd = engineLoadTXD("models/carnivalmask.txd")
    engineImportTXD(txd, 2407)
    local dff = engineLoadDFF("models/carnivalmask.dff", 2407)
    engineReplaceModel(dff, 2407)
	
	--Monkey Mask
    local txd = engineLoadTXD("models/smonkeymask.txd")
    engineImportTXD(txd, 2399)
    local dff = engineLoadDFF("models/smonkeymask.dff", 2399)
    engineReplaceModel(dff, 2399)
	
	--Monster Mask
    local txd = engineLoadTXD("models/monstermask.txd")
    engineImportTXD(txd, 2396)
    local dff = engineLoadDFF("models/monstermask.dff", 2396)
    engineReplaceModel(dff, 2396)

	 --Police Glasses
    local txd = engineLoadTXD("models/PoliceGlasses.txd")
    engineImportTXD(txd, 1918)
    local dff = engineLoadDFF("models/PoliceGlasses1.dff", 1918)
	  local dff = engineLoadDFF("models/PoliceGlasses2.dff", 1918)
	    local dff = engineLoadDFF("models/PoliceGlasses3.dff", 1918)
    engineReplaceModel(dff, 1918)
	
	--Dufflebag
    local txd = engineLoadTXD("models/dufflebag.txd")
    engineImportTXD(txd, 3915)
    local dff = engineLoadDFF("models/dufflebag.dff", 3915)
    engineReplaceModel(dff, 3915)
	
	--Kevlar Vest
    local txd = engineLoadTXD("models/kevlar.txd")
    engineImportTXD(txd, 3916)
    local dff = engineLoadDFF("models/kevlar.dff", 3916)
    engineReplaceModel(dff, 3916)
end
addEventHandler ("onClientResourceStart", resourceRoot,
     function()
         replaceModels()
         setTimer (replaceModels, 1000, 1)
end
)