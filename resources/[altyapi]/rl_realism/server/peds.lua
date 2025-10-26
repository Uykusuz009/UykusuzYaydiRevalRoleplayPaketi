validWalkingStyles = { [57] = true, [58] = true, [59] = true, [60] = true, [61] = true, [62] = true, [63] = true, [64] = true, [65] = true, [66] = true, [67] = true, [68] = true, [118] = true, [119] = true, [120] = true, [121] = true, [122] = true, [123] = true, [124] = true, [125] = false, [126] = true, [128] = true, [129] = true, [130] = true, [131] = true, [132] = true, [133] = true, [134] = true, [135] = true, [136] = true, [137] = true, [138] = true }

function setWalkingStyle(thePlayer, commandName, walkingStyle)
	if not walkingStyle or not validWalkingStyles[tonumber(walkingStyle)] or not tonumber(walkingStyle) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Yürüyüş Stili ID]", thePlayer, 255, 194, 14)
		outputChatBox("[!]#FFFFFF /walklist yazarak yürüyüş stillerinin ID'lerini görüntüleyebilirsiniz.", thePlayer, 0, 0, 255, true)
	else
		local dbid = getElementData(thePlayer, "dbid")
		local updateWalkingStyleSQL = dbExec(exports.rl_mysql:getConnection(), "UPDATE characters SET walking_style = ? WHERE id = ?", tonumber(walkingStyle), dbid)
		if updateWalkingStyleSQL then
			setElementData(thePlayer, "walking_style", tonumber(walkingStyle))
			setPedWalkingStyle(thePlayer, tonumber(walkingStyle))
			outputChatBox("[!]#FFFFFF Başarıyla yürüyüş tarzınız [" .. tonumber(walkingStyle) .. "] olarak değiştirildi.", thePlayer, 0, 255, 0, true)
		else
			outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	end
end
addCommandHandler("setwalkingstyle", setWalkingStyle, false)
addCommandHandler("setwalk", setWalkingStyle, false)

function applyWalkingStyle(style, ignoreSQL)
	if client ~= source then
		return
	end
	
	local gender = getElementData(source, "gender")
	local charid = getElementData(source, "dbid")
	if not style or not validWalkingStyles[tonumber(style)] then
		outputDebugString("Invalid Walking style detected on " .. getPlayerName(source))
		if gender == 1 then
			style = 129
		else
			style = 118
		end
		ignoreSQL = true
	else
		ignoreSQL = false
	end

	if not ignoreSQL then
		dbExec(exports.rl_mysql:getConnection(), "UPDATE characters SET walking_style = ? WHERE id = ?", style, charid)
	end
	
	setElementData(source, "walking_style", tonumber(style))
	setPedWalkingStyle(source, tonumber(style))
end
addEvent("realism:applyWalkingStyle", true)
addEventHandler("realism:applyWalkingStyle", root, applyWalkingStyle)

function switchWalkingStyle()
	if client ~= source then
		return
	end
	
	local walkingStyle = getElementData(client, "walking_style")
	walkingStyle = tonumber(walkingStyle) or 57
	local nextStyle = getNextValidWalkingStype(walkingStyle)
	if not nextStyle then
		nextStyle = getNextValidWalkingStype(56)
	end
	triggerEvent("realism:applyWalkingStyle", client, nextStyle)
end
addEvent("realism:switchWalkingStyle", true)
addEventHandler("realism:switchWalkingStyle", root, switchWalkingStyle)

function getNextValidWalkingStype(cur)
	cur = tonumber(cur)
	local found = false
	for i = cur, 138 do
		if validWalkingStyles[i+1] then
			found = i+1
			break
		end
	end
	
	return found
end

function walkStyleList(thePlayer, commandName)
	outputChatBox("[!]#FFFFFF Yürüyüş stillerinin ID'leri:", thePlayer, 0, 0, 255, true)
	outputChatBox(">>#FFFFFF 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 118,", thePlayer, 0, 0, 255, true)
	outputChatBox(">>#FFFFFF 119, 120, 121, 122, 123, 124, 126, 128,", thePlayer, 0, 0, 255, true)
    outputChatBox(">>#FFFFFF 129, 130, 131, 132, 133, 134, 135, 136, 137, 138.", thePlayer, 0, 0, 255, true)
end
addCommandHandler("walklist", walkStyleList, false, false)