--[[
***********************
-Written by Felipe.
***********************
--]]


function getNearestElement(theplayer, elementType, distance)
	local lastMinDis = distance-0.0001
	local nearestElement = false
	local px,py,pz = getElementPosition(theplayer)
	local pInt = getElementInterior(theplayer)
	local pDim = getElementDimension(theplayer)
    
	for _,e in pairs(getElementsByType(elementType)) do
		local eInt,eDim = getElementInterior(e),getElementDimension(e)
		if eInt == pInt and eDim == pDim and e ~= theplayer then
			local ex,ey,ez = getElementPosition(e)
			local dis = getDistanceBetweenPoints3D(px,py,pz,ex,ey,ez)
			if dis < distance then
				if dis < lastMinDis then
					lastMinDis = dis
					nearestElement = e
				end
			end
		end
	end
	return nearestElement
end

function bagajabin(thePlayer, commandName,targetPlayer)
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
local vehicle = getNearestElement(thePlayer, "vehicle", 5)
if getElementData(targetPlayer, "bagajda") then
outputChatBox("#FF0000[!]#FFFFFFZaten bagajda!", targetPlayer, 255, 255, 255, true)
return
end
if vehicle then
outputChatBox("#dede03[!]#FFFFFFBagaja girdiniz.Eğer sizin isteğiniz dışında bagaja atıldıysanız rapor atınız.",targetPlayer, 255, 255,255, true)
setElementData(targetPlayer, "bagajda", true)
exports.rl_global:applyAnimation(targetPlayer, "crack", "crckidle2", -1, true, false, false)
unbindKey(targetPlayer, "space", "down", stopAnimation)
attachElements(targetPlayer, vehicle, 0, -2.5, 0.8)
end
end
addCommandHandler("bagajaat", bagajabin)

function bagajdancik(thePlayer, commandName,targetPlayer)
if getElementData(thePlayer, "bagajda") then
outputChatBox("#FF0000[!]#FFFFFFBagajdayken çıkamazsın!", thePlayer, 255, 255, 255, true)
return
end
bool = not bool
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
if getElementData(targetPlayer, "bagajda")  then
local vehicle = getNearestElement(thePlayer, "vehicle", 2)
detachElements(targetPlayer, vehicle)
outputChatBox("#dede03[!]#FFFFFFBagajdan çıkarıldınız!", targetPlayer, 255, 255, 255, true)
setElementData(targetPlayer, "bagajda", nill)
setPedAnimation(targetPlayer, false)
end
end
addCommandHandler("bagajcikar", bagajdancik)

function cikar(thePlayer, commandName, targetPlayer)
if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
local vehicle = getNearestElement(thePlayer, "vehicle", 2)
detachElements(targetPlayer, vehicle)
setElementData(thePlayer, "bagajda", nill)
outputChatBox("[West Roleplay]: #FFFFFFBir admin tarafından bagajdan çıkarıldınız.",targetPlayer,0,255,255,true)
end
end
addCommandHandler("bcikar", cikar)