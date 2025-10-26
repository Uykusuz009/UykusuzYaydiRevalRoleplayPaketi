function vehicleBlown()
	setElementData(source, "lspd:siren3", false)
	setVehicleSirensOn (source , false)
end
addEventHandler("onVehicleRespawn", getRootElement(), vehicleBlown)

function setsiren3State()
	if exports.rl_global:hasItem(source, 85) then
		setElementData(source, "lspd:siren2", false)
		setElementData(source, "lspd:siren1", false)
		setElementData(source, "lspd:datdat", false)
		local curState = getElementData(source, "lspd:siren3")
		setElementData(source, "lspd:siren3", not curState)
		setVehicleSirensOn (source , not curState)
	end
end
addEvent("lspd:setSiren3State", true)
addEventHandler("lspd:setSiren3State", getRootElement(), setsiren3State)