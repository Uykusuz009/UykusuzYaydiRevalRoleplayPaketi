
function texture()

	local txd = engineLoadTXD ('jetdor.txd')
    engineImportTXD(txd,3095)

end
addEventHandler('onClientResourceStart',resourceRoot,texture)
