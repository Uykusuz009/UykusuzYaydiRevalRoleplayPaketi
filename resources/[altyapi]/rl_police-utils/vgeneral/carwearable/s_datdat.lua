function vehicleBlown()
	setElementData(source, "lspd:datdat", false)
	setVehicleSirensOn (source , false)
end
addEventHandler("onVehicleRespawn", getRootElement(), vehicleBlown)

function setDatdatState()
	if exports.rl_global:hasItem(source, 85) then
		setElementData(source, "lspd:siren3", false)
		setElementData(source, "lspd:siren2", false)
		setElementData(source, "lspd:siren1", false)
		local curState = getElementData(source, "lspd:datdat")
		setElementData(source, "lspd:datdat", not curState)
	end
end
addEvent("lspd:setDatdatState", true)
addEventHandler("lspd:setDatdatState", getRootElement(), setDatdatState)