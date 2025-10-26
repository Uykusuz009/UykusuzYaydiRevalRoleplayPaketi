

--[[local marker1 = createMarker(1545.55859375, -1659.109375, 4.890625, "cylinder", 5, 255, 194, 14, 150)
exports.pool:allocateElement(marker1)
local marker2 = createMarker(1545.580078125, -1663.462890625, 4.890625, "cylinder", 5, 255, 181, 165, 213)
exports.pool:allocateElement(marker2)]]

-- Nice little guard ped
guard1 = createPed(280, -1700.9560546875, 688.8603515625, 24.890625)
exports.rl_pool:allocateElement(guard1)
setElementFrozen(guard1, true)
setPedRotation(guard1, 140)
setTimer(giveWeapon, 50, 1, guard1, 29, 15000, true)
-- Guard ped @ CPU
guard2 = createPed(280, -1572.8173828125, 657.6123046875, 7.1875)
exports.rl_pool:allocateElement(guard2)
setElementFrozen(guard2, true)
setPedRotation(guard2, 330)
setTimer(giveWeapon, 50, 1, guard2, 29, 15000, true)

function killMeByPed(element)
	killPed(source, element, 29, 9)
	setPedHeadless(source, true)
end
addEvent("killmebyped", true)
addEventHandler("killmebyped", getRootElement(), killMeByPed)