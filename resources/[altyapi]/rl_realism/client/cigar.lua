local l_cigar = {}
local r_cigar = {}
local deagle = {}
local isLocalPlayerSmokingBool = false

function setSmoking(player, state, hand)
    setElementData(player, "smoking", state)
    if not (hand) or (hand == 0) then
        setElementData(player, "smoking:hand", 0)
    else
        setElementData(player, "smoking:hand", 1)
    end

    if (isElement(player)) then
        if (state) then
            playerExitsVehicle(player)
        else
            playerEntersVehicle(player)
        end
    end
end

function playerExitsVehicle(player)
    if (getElementData(player, "smoking")) then
        playerEntersVehicle(player)
        local effect = createObject(2008, player.position)
        setElementCollisionsEnabled(effect, false)

        if (getElementData(player, "smoking:hand") == 1) then
            r_cigar[player] = createCigarModel(player, 3027)
            attachElements(effect, r_cigar[player], 0, 0, 0)
            exports.rl_bones:attachElementToBone(r_cigar[player], player, "right-hand", 0.03, 0.03, 0.05, 0, 90, 0)
        else
            l_cigar[player] = createCigarModel(player, 3027)
            attachElements(effect, l_cigar[player], 0, 0, 0)
            exports.rl_bones:attachElementToBone(l_cigar[player], player, "left-hand", 0.03, 0.03, 0.05, 0, 90, 0)
        end
    end
end

function playerEntersVehicle(player)
    if (l_cigar[player]) then
        if (isElement(l_cigar[player])) then
            local attached = getAttachedElements(l_cigar[player])
            if (attached) then
                for k, v in ipairs(attached) do
                    if (isElement(v)) then
                        destroyElement(v)
                    end
                end
            end

            destroyElement(l_cigar[player])
        end
        l_cigar[player] = nil
    end
    if (r_cigar[player]) then
        if (isElement(r_cigar[player])) then
            local attached = getAttachedElements(r_cigar[player])
            if (attached) then
                for k, v in ipairs(attached) do
                    if (isElement(v)) then
                        destroyElement(v)
                    end
                end
            end

            destroyElement(r_cigar[player])
        end
        r_cigar[player] = nil
    end
end

function removeSigOnExit()
    playerExitsVehicle(source)
end
addEventHandler("onPlayerQuit", root, removeSigOnExit)

function syncCigarette(state, hand)
    if (isElement(source)) then
        if (state) then
            setSmoking(source, true, hand)
        else
            setSmoking(source, false, hand)
        end
    end
end
addEvent("realism:smokingsync", true)
addEventHandler("realism:smokingsync", root, syncCigarette, righthand)

function createCigarModel(player, modelid)
    if (l_cigar[player] ~= nil) then
        local currobject = l_cigar[player]
        if (isElement(currobject)) then
            destroyElement(currobject)

            l_cigar[player] = nil
        end
    end

    local object = createObject(modelid, 0, 0, 0)
    setElementCollisionsEnabled(object, false)
    return object
end

function isLocalPlayerSmoking()
    return isLocalPlayerSmokingBool
end