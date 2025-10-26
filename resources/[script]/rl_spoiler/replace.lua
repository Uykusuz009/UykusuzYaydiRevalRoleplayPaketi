local spoilers = {
	[1000] = "1",
	[1001] = "2",
	[1002] = "3",
	[1003] = "4",
	[1023] = "5",
	[1014] = "6",
	[1015] = "7",
	[1016] = "8",
	[1049] = "9",
	[1050] = "10", 
}

function replaceModel()
	setTimer(
		function()
			engineImportTXD(engineLoadTXD("spoilers.txd", 1000), 1000)
			for model, name in pairs(spoilers) do
				if name ~= nil then
					engineReplaceModel(engineLoadDFF(name .. ".dff", model), model)
				end
			end
		end, 1000, 1
	)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)


-- Sitemiz : https://sparrow-mta.blogspot.com/
-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://youtube.com/c/SparroWMTA/

-- Discord : https://discord.gg/DzgEcvy