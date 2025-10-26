addEventHandler("onClientResourceStart", resourceRoot,
function()
	
	local txd = engineLoadTXD("teszt.txd")
	engineImportTXD(txd, 3976)
	
	local dff = engineLoadDFF("teszt.dff", 3976)
	engineReplaceModel(dff, 3976)
	
	local col = engineLoadCOL("teszt.col")
	engineReplaceCOL(col, 3976)
	
	engineSetModelLODDistance(3976, 500)
end
)
local dir = "files"
function loadMod ( f, m )
	if fileExists(dir..'/'.. f ..'.col') then
		col = engineLoadCOL(dir..'/'.. f ..'.col')
		engineReplaceCOL ( col, m )
	end
end



addEventHandler("onClientResourceStart", resourceRoot, 
function ()
	loadMod ( "k", 14846 )
end
)

engineSetAsynchronousLoading ( true, false )