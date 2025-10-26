mysql = exports.rl_mysql
objects = {}

function loadDimension(dimension, demotable)
    if dimension then
        objects[dimension] = {}
        
        local tableselect = demotable and "tempobjects" or "objects"
        
        local query = dbQuery(mysql:getConnection(), "SELECT * FROM `" .. tableselect .. "` WHERE dimension = ?", dimension)
        local result = dbPoll(query, -1)
        
        if result then
            for _, row in ipairs(result) do
                for key, value in pairs(row) do
                    row[key] = tonumber(value)
                end
                
                table.insert(objects[dimension], {
                    row.model,
                    row.posX,
                    row.posY,
                    row.posZ,
                    row.rotX,
                    row.rotY,
                    row.rotZ,
                    row.interior,
                    row.solid == 1,
                    row.doublesided == 1,
                    tostring(row.id),
                    row.scale,
                    row.breakable == 1,
                    tonumber(row.alpha) or 255
                })
            end
        end

        syncDimension(dimension)
        return #objects[dimension]
    end
    return 0
end

function reloadDimension(thePlayer, commandName, dimensionID)
    if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
        if dimensionID then
            triggerClientEvent(root, "object:clear", root, dimensionID)
            local count = loadDimension(tonumber(dimensionID))
            if count > 0 then
                outputChatBox("Reloaded " .. count .. " items in interior " .. dimensionID, thePlayer, 0, 255, 0)
            end
        end
    end
end
addCommandHandler("reloadinterior", reloadDimension, false, false)

function reloadInteriorObjects(theDimension)
    if theDimension then
        triggerClientEvent(root, "object:clear", root, theDimension)
        loadDimension(tonumber(theDimension))
    end
end

function removeInteriorObjects(theDimension)
    if theDimension and tonumber(theDimension) >= 0 then
        dbExec(mysql:getConnection(), "DELETE FROM `objects` WHERE `dimension` = ?", theDimension)
        triggerClientEvent(root, "object:clear", root, theDimension)
        loadDimension(tonumber(theDimension))
    end
end

function startObjectSystem()
    local query = dbQuery(mysql:getConnection(), "SELECT DISTINCT(`dimension`) FROM `objects` ORDER BY `dimension` ASC")
    local result = dbPoll(query, -1)
    
    if result then
        for _, row in ipairs(result) do
            local co = coroutine.create(loadDimension)
            coroutine.resume(co, tonumber(row.dimension), false)
        end
    end
end
addEventHandler("onResourceStart", resourceRoot, startObjectSystem)