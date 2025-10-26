addEvent('artifacts:removeAllOnPlayer', true)
addEvent('artifacts:add', true)
addEvent('artifacts:remove', true)
addEvent('artifacts:toggle', true)
addEvent('artifacts:update', true)

local artifacts = {}
local artifactsList = {}
local texturedArtifacts = {}

function removeAllOnPlayer(player) --Remove all artifacts on a given player
	if artifactsList[player] then
		triggerClientEvent(player, 'artifacts:startChecking', player, false)
		for k,v in ipairs(artifactsList[player]) do
			if (isElement(v[2])) then
				destroyElement(v[2])
				artifacts[player][v[1]] = nil
			end
		end
		artifacts[player] = nil
		artifactsList[player] = nil
	end
end
addEventHandler('artifacts:removeAllOnPlayer', root, removeAllOnPlayer)

addCommandHandler("myartifacts", function(player, cmd)
	if artifactsList[player] and #artifactsList[player] > 0 then
		outputChatBox("--",player)
		for k,v in ipairs(artifactsList[player]) do
			outputChatBox(tostring(v[1]),player)
		end
		outputChatBox(tostring(#artifactsList[player]) .. " items worn.",player)
		outputChatBox("--",player)
	else
		outputChatBox("You are not wearing any artifacts.",player)
	end
end)

function addArtifact(player, artifact, noOutput, customItemTexture) --Start to wear an artifact the player is not already wearing
	if client ~= source then
		return
	end
	
	if client ~= player then
		return
	end
	
	if player and artifact then	
		if artifacts[player] and artifacts[player][artifact] then
			return
		else
			local data = g_artifacts[artifact]
			local skin = getElementModel(player)
			if (g_skinSpecifics[artifact]) then
				if (g_skinSpecifics[artifact][skin]) then
					data = g_skinSpecifics[artifact][skin]
				end
			end
			local x, y, z = getElementPosition(player)
			local int = getElementInterior(player)
			local dim = getElementDimension(player)
			local object = createObject(data[ART_MODEL], x, y, z)
			setElementInterior(object, int)
			setElementDimension(object, dim)
			setObjectScale(object, data[ART_SCALE])
			setElementDoubleSided(object, data[ART_DOUBLESIDED])
			exports.rl_bones:attachElementToBone(object,player,data[ART_BONE],data[ART_X],data[ART_Y],data[ART_Z],data[ART_RX],data[ART_RY],data[ART_RZ])
			triggerClientEvent(player, 'artifacts:startChecking', player, true)
			if not artifacts[player] then
				artifacts[player] = {}
			end
			if not artifactsList[player] then
				artifactsList[player] = {}
			end
			artifacts[player][artifact] = object
			table.insert(artifactsList[player], {artifact,object})
			if data[ART_TEXTURE] then
				for k,v in ipairs(data[ART_TEXTURE]) do
					exports["rl_item-texture"]:addTexture(object, v[2], v[1])
				end
			elseif customItemTexture then
				if type(customItemTexture) == "table" then
					for k,v in ipairs(customItemTexture) do
						exports["rl_item-texture"]:addTexture(object, v[2], v[1])
					end					
				end
			end
			if not noOutput and g_artifacts_mes[artifact] and g_artifacts_mes[artifact][1] then
				exports.rl_global:sendLocalMeAction(player, tostring(g_artifacts_mes[artifact][1]))
			end
		end
	end
end
addEventHandler('artifacts:add', root, addArtifact)

function removeArtifact(player, artifact, noOutput) --Removing an artifact the player is wearing
	if player and artifact then	
		if not artifacts[player] or not artifacts[player][artifact] then
			return
		else
			if (#artifacts[player] <= 1) then --stop the int/dim checking when there is no need for it anymore (when player is not wearing any artifacts)
				triggerClientEvent(player, 'artifacts:startChecking', player, false)
			end
			destroyElement(artifacts[player][artifact])
			artifacts[player][artifact] = nil
			for k,v in ipairs(artifactsList[player]) do
				if (v[1] == artifact) then
					v = nil
					artifactsList[player][k] = nil
					break
				end
			end
			if not noOutput and g_artifacts_mes[artifact] and g_artifacts_mes[artifact][2] then
				exports.rl_global:sendLocalMeAction(player, tostring(g_artifacts_mes[artifact][2]))
			end
		end
	end
end
addEventHandler('artifacts:remove', root, removeArtifact)

function toggleArtifact(player, artifact, noOutput)
	if player and artifact then	
		if not artifacts[player] or not artifacts[player][artifact] then
			addArtifact(player, artifact, noOutput)
		else
			removeArtifact(player, artifact, noOutput)
		end
	end
end
addEventHandler('artifacts:toggle', root, toggleArtifact)

addEventHandler('artifacts:update', root,
function(player, newInt, newDim)
	if artifacts[source] then
		for k,v in ipairs(artifacts[source]) do
			if (isElement(v)) then
				setElementInterior(v, newInt)
				setElementDimension(v, newDim)
			end
		end
		artifacts[source] = nil
	end
end)

addEventHandler("onPlayerQuit", root, function()
	removeAllOnPlayer(source)
end)

addCommandHandler("removeartifacts", function(thePlayer, commandName)
	outputChatBox(#artifactsList[thePlayer] .. " artifacts removed.", thePlayer)
	removeAllOnPlayer(thePlayer)
end)

addCommandHandler("removeallartifacts", function(thePlayer, commandName)
	if exports.rl_integration:isPlayerDeveloper(thePlayer) then
		outputChatBox(#artifactsList .. " artifacts removed.", thePlayer)
		for _, player in ipairs(getElementsByType("player")) do
			removeAllOnPlayer(player)
		end
	end
end)

function countPlayerArtifacts(player)
	local count = 0
	if artifacts[player] then
		for k,v in ipairs(artifacts[player]) do
			if (isElement(v)) then
				count = count + 1
			end
		end
	end
	return count
end

function getPlayerArtifacts(player, withElements)
	local resultTable = {}
	local tableWithElements = {}
	if artifacts[player] then
		for k,v in pairs(artifacts[player]) do
			if (isElement(v)) then
				table.insert(resultTable, k)
				table.insert(tableWithElements, {v,k})
			end
		end
	end
	if withElements then
		return tableWithElements
	end
	return resultTable
end

function isPlayerWearingArtifact(player, artifact)
	if artifacts[player] and artifacts[player][artifact] and isElement(artifacts[player][artifact]) then
		return true
	end
	return false
end

function setPlayerArtifactProperty(player, artifact, property, value)
	if artifacts[player] and artifacts[player][artifact] and isElement(artifacts[player][artifact]) then
		local object = artifacts[player][artifact]
		if (property == "model") then
			local result = setElementModel(object, value)
			return result
		elseif (property == "scale") then
			local result = setObjectScale(object, value)
			return result
		elseif (property == "alpha") then
			local result = setElementAlpha(object, value)
			return result
		elseif (property == "doublesided") then
			local result = setElementDoubleSided(object, value)
			return result
		elseif (property == "texture") then
			if value then
				table.insert(texturedArtifacts, {object, value})
				triggerClientEvent(root, "artifacts:addTexture", player, object, value)
				return true
			else
				return false
			end
		elseif (property == "bone") then
			local ped, bone, x, y, z, rx, ry, rz = exports.rl_bones:getElementBoneAttachmentDetails(object)
			exports.rl_bones:detachElementFromBone(object)
			local result = exports.rl_bones:attachElementToBone(object,ped,value,x,y,z,rx,ry,rz)
			if not result then
				exports.rl_bones:attachElementToBone(object,ped,bone,x,y,z,rx,ry,rz)
			end
			return result
		elseif (property == "x") then
			local ped, bone, x, y, z, rx, ry, rz = exports.rl_bones:getElementBoneAttachmentDetails(object)
			exports.rl_bones:detachElementFromBone(object)
			local result = exports.rl_bones:attachElementToBone(object,ped,bone,(x+value),y,z,rx,ry,rz)
			if not result then
				exports.rl_bones:attachElementToBone(object,ped,bone,x,y,z,rx,ry,rz)
			end
			return result
		elseif (property == "y") then
			local ped, bone, x, y, z, rx, ry, rz = exports.rl_bones:getElementBoneAttachmentDetails(object)
			exports.rl_bones:detachElementFromBone(object)
			local result = exports.rl_bones:attachElementToBone(object,ped,bone,x,(y+value),z,rx,ry,rz)
			if not result then
				exports.rl_bones:attachElementToBone(object,ped,bone,x,y,z,rx,ry,rz)
			end
			return result
		elseif (property == "z") then
			local ped, bone, x, y, z, rx, ry, rz = exports.rl_bones:getElementBoneAttachmentDetails(object)
			exports.rl_bones:detachElementFromBone(object)
			local result = exports.rl_bones:attachElementToBone(object,ped,bone,x,y,(z+value),rx,ry,rz)
			if not result then
				exports.rl_bones:attachElementToBone(object,ped,bone,x,y,z,rx,ry,rz)
			end
			return result
		elseif (property == "rx") then
			local ped, bone, x, y, z, rx, ry, rz = exports.rl_bones:getElementBoneAttachmentDetails(object)
			exports.rl_bones:detachElementFromBone(object)
			local result = exports.rl_bones:attachElementToBone(object,ped,bone,x,y,z,(rx+value),ry,rz)
			if not result then
				exports.rl_bones:attachElementToBone(object,ped,bone,x,y,z,rx,ry,rz)
			end
			return result
		elseif (property == "ry") then
			local ped, bone, x, y, z, rx, ry, rz = exports.rl_bones:getElementBoneAttachmentDetails(object)
			exports.rl_bones:detachElementFromBone(object)
			local result = exports.rl_bones:attachElementToBone(object,ped,bone,x,y,z,rx,(ry+value),rz)
			if not result then
				exports.rl_bones:attachElementToBone(object,ped,bone,x,y,z,rx,ry,rz)
			end
			return result
		elseif (property == "rz") then
			local ped, bone, x, y, z, rx, ry, rz = exports.rl_bones:getElementBoneAttachmentDetails(object)
			exports.rl_bones:detachElementFromBone(object)
			local result = exports.rl_bones:attachElementToBone(object,ped,bone,x,y,z,rx,ry,(rz+value))
			if not result then
				exports.rl_bones:attachElementToBone(object,ped,bone,x,y,z,rx,ry,rz)
			end
			return result
		elseif (property == "reset") then
			removeArtifact(player, artifact, true)
			addArtifact(player, artifact, true)
		end
	end
	return false
end