function hasSpaceForItem(...)
    return exports.rl_items:hasSpaceForItem(...)
end

function hasItem(element, itemID, itemValue)
    return exports.rl_items:hasItem(element, itemID, itemValue)
end

function giveItem(element, itemID, itemValue)
    return exports.rl_items:giveItem(element, itemID, itemValue, false, true)
end

function takeItem(element, itemID, itemValue)
    return exports.rl_items:takeItem(element, itemID, itemValue)
end

function getPlayerMaskState(player)
	local masks = exports.rl_items:getMasks()
	for index, value in pairs(masks) do
		if getElementData(player, value[1]) then
			return true
		end
	end
	return false
end