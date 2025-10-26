_outputDebugString = outputDebugString
function outputDebugString(str)
	if getElementData(resourceRoot, "debug_enabled") then
		str = tostring(str)
		_outputDebugString(str)
	end
end