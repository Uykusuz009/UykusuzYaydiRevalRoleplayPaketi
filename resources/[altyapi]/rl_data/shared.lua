local savedDatas = {}

function save(data, accessKey)
	if data then
		savedDatas[accessKey] = data
		return true
	end
	return false
end

function get(accessKey)
	if savedDatas[accessKey] then
		local temp = savedDatas[accessKey]
		savedDatas[accessKey] = nil
		return temp
	end
	return false
end