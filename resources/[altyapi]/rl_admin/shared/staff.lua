function canPlayerAccessStaffManager(player)
	return exports.rl_integration:isPlayerTrialAdmin(player) or exports.rl_integration:isPlayerManager(player)
end

function hasPlayerAccess(player)
	if exports.rl_integration:isPlayerManager(player) then
		return true
	end
	return false
end