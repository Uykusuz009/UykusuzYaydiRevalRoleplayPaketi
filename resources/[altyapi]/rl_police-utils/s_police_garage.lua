function killMeByPed(element)
	--killPed(source, element, 29, 9)
	--setPedHeadless(source, true)
end
addEvent("killmebyped", true)
addEventHandler("killmebyped", getRootElement(), killMeByPed)