local vt = getVehicleType
function getVehicleType(...)
	local ret = vt(...)
	if ret == "" then
		return "Trailer"
	end
	return ret
end