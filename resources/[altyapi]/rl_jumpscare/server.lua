addCommandHandler("purna", function(thePlayer, commandName, targetPlayer)
	if exports.rl_integration:isPlayerManager(thePlayer) then
		if targetPlayer == "all" then
			triggerClientEvent(root, "jumpscare.renderUI", root)
		else
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				triggerClientEvent(targetPlayer, "jumpscare.renderUI", targetPlayer)
				outputChatBox(inspect(targetPlayer), thePlayer)
			end
		end
	end
end)