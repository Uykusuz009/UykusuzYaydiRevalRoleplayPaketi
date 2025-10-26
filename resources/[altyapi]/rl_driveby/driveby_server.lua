local settings = {
	driver = get"driveby_driver" or { 28,29,30,32,31 },
	passenger = get"driveby_passenger" or { 28,29,30,32,31 },
	shotdelay = get"driveby_shot_delay" or {},
	blockedVehicles = get"driveby_blocked_vehicles" or { 432,601,437,431,592,553,577,488,497,548,563,512,476,447,425,519,520,460,417,469,513,441,464,501,465,564,538,449,537,539,570,472,473,493,595,484,430,453,452,446,454,606,591,607,611,610,590,569,611,435,608,584,450 },
	steerCars = get"driveby_steer_cars" == true,
	steerBikes = get"driveby_steer_bikes" == false,
	autoEquip = get"driveby_auto_equip" or false
}

local validDrivebyWeapons = {
	[28] = true,
	[29] = true,
	[32] = true,
	[30] = true,
	[31] = true,
	[32] = true,
}

for key,weaponID in ipairs(settings.driver) do
	if not validDrivebyWeapons[weaponID] then
		table.remove (settings.driver, key)
	end
end
for key,weaponID in ipairs(settings.passenger) do
	if not validDrivebyWeapons[weaponID] then
		table.remove (settings.driver, key)
	end
end

addEvent ("driveby_clientScriptLoaded", true)
addEventHandler ("driveby_clientScriptLoaded", root,
	function()
		triggerClientEvent (client, "doSendDriveBySettings", client, settings)
	end
)

