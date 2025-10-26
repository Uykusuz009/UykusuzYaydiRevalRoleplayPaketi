
function byebyetl()
	removeWorldModel(1283, 999999, 0, 0, 0)
	removeWorldModel(1315, 999999, 0, 0, 0)
	removeWorldModel(1284, 999999, 0, 0, 0)
	removeWorldModel(1350, 999999, 0, 0, 0)
	removeWorldModel(1351, 999999, 0, 0, 0)
	outputDebugString("[Prime Roelplay] Fps Optimizasyonu Yapıldı..") 
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), byebyetl)