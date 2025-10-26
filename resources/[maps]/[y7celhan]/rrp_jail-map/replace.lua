function replaceTexture ()
txd = engineLoadTXD("jetdoor.txd") 
engineImportTXD(txd, 3095)
end
addEventHandler( "onClientResourceStart", resourceRoot, replaceTexture )