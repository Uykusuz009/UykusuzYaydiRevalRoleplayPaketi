local enabledUsers = {
	["BiaX"] = true,
}

local commandList = {
    ["refresh"] = true,
    ["refreshall"] = true,
    ["restart"] = true,
    ["start"] = true,
    ["stop"] = true,
    ["stopall"] = true,
    ["aclrequest"] = true,
    ["reloadacl"] = true,
    ["aexec"] = true,
    ["addaccount"] = true,
    ["chgpass"] = true,
    ["delaccount"] = true,
    ["reloadbans"] = true,
    ["authserial"] = true,
    ["loadmodule"] = true,
    ["sfakelag"] = true,
    ["shutdown"] = true,
    ["sver"] = true,
    ["whois"] = true,
    ["ver"] = true,
    ["chgmypass"] = true,
    ["debugscript"] = true,
    ["login"] = true,
    ["logout"] = true,
    ["msg"] = true,
    ["nick"] = true,
    ["+×÷=_<>[]@#^&*"] = true,
}

addEventHandler("onPlayerCommand", root, function(commandName)
    if commandName == "debugscript" then
		return
	end
	
	if (not getElementData(source, "logged")) then
		cancelEvent()
    end
	
	if (commandList[commandName]) and (not enabledUsers[getElementData(source, "account_username")]) then
		cancelEvent()
    end
end)

function restartSingleResource(thePlayer, commandName, resourceName)
    if exports.rl_integration:isPlayerDeveloper(thePlayer) then
        if resourceName then
            local theResource = getResourceFromName(tostring(resourceName))
            if theResource then
                if getResourceState(theResource) == "running" then
					restartResource(theResource)
                    outputChatBox("[!]#FFFFFF [" .. resourceName .. "] isimli script yeniden başladıldı.", thePlayer, 0, 255, 0, true)
                    exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. resourceName .. "] isimli scripti yeniden başlatdı.")
                elseif getResourceState(theResource) == "loaded" then
                    startResource(theResource, true)
                    outputChatBox("[!]#FFFFFF [" .. resourceName .. "] isimli script yeniden başladıldı.", thePlayer, 0, 255, 0, true)
                    exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. resourceName .. "] isimli scripti yeniden başlatdı.")
                elseif getResourceState(theResource) == "failed to load" then
                    outputChatBox("[!]#FFFFFF [" .. resourceName .. "] isimli scripti restartlanmadı. (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                else
                    outputChatBox("[!]#FFFFFF [" .. resourceName .. "] isimli script başlatılmadı. (" .. getResourceState(theResource) .. ")", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
            else
                outputChatBox("[!]#FFFFFF Böyle bir script bulunamadı.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Script Adı]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("restartres", restartSingleResource, false, false)

function stopSingleResource(thePlayer, commandName, resourceName)
    if exports.rl_integration:isPlayerDeveloper(thePlayer) then
        if resourceName then
			local theResource = getResourceFromName(tostring(resourceName))
			if theResource then
				if stopResource(theResource) then
					outputChatBox("[!]#FFFFFF [" .. resourceName .. "] isimli script stopladı.", thePlayer, 0, 255, 0, true)
					exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. resourceName .. "] isimli scripti dayandırdı.")
				else
					outputChatBox("[!]#FFFFFF [" .. resourceName .. "] isimli script stoplanamadı.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Böyle bir script bulunamadı.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
            outputChatBox("KULLANIM: /" .. commandName .. " [Script Adı]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("stopres", stopSingleResource, false, false)

function startSingleResource(thePlayer, commandName, resourceName)
    if exports.rl_integration:isPlayerDeveloper(thePlayer) then
        if resourceName then
            local theResource = getResourceFromName(tostring(resourceName))
            if theResource then
                if getResourceState(theResource) == "running" then
                    outputChatBox("[!]#FFFFFF [" .. resourceName .. "] isimli script zaten aktif.", thePlayer, 0, 255, 0, true)
                elseif getResourceState(theResource) == "loaded" then
                    startResource(theResource, true)
                    outputChatBox("[!]#FFFFFF [" .. resourceName .. "] isimli script başladıldı.", thePlayer, 0, 255, 0, true)
                    exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. resourceName .. "] isimli scripti başlatdı.")
                elseif getResourceState(theResource) == "failed to load" then
                    outputChatBox("[!]#FFFFFF [" .. resourceName .. "] isimli scripti startlanamadı. (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                else
                    outputChatBox("[!]#FFFFFF [" .. resourceName .. "] isimli script başlatılmadı. (" .. getResourceState(theResource) .. ")", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
            else
                outputChatBox("[!]#FFFFFF Böyle bir script bulunamadı.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Script Adı]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("startres", startSingleResource, false, false)