function vehicleBlown()
	setElementData(source, "lspd:siren2", false)
	setVehicleSirensOn (source , false)
end
addEventHandler("onVehicleRespawn", getRootElement(), vehicleBlown)

function setsiren2State()
	if exports.rl_global:hasItem(source, 85) then
		setElementData(source, "lspd:siren3", false)
		setElementData(source, "lspd:siren1", false)
		setElementData(source, "lspd:datdat", false)
		local curState = getElementData(source, "lspd:siren2")
		setElementData(source, "lspd:siren2", not curState)
		setVehicleSirensOn (source , not curState)
	end
end
addEvent("lspd:setsiren2State", true)
addEventHandler("lspd:setsiren2State", getRootElement(), setsiren2State)