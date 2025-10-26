local mysql = exports.rl_mysql

function addInteriorLogs(intID, action, actor, clearPreviousLogs)
    if intID and action then
        if clearPreviousLogs then
            local query1 = dbExec(mysql:getConnection(),"DELETE FROM `interior_logs` WHERE `intID`='" .. tostring(intID).. "'")
            if not query1 then
                outputDebugString("[INTERIOR MANAGER] Failed to clean previous logs #" .. intID .. " from `interior_logs`.")
                return false
            end
        end

        local adminID = nil
        if actor and isElement(actor) and getElementType(actor) == "player" then
            adminID = getElementData(actor, "account_id") 
        end
        
        local query3 = dbExec(mysql:getConnection(), "INSERT INTO `interior_logs` SET `intID`= '" .. tostring(intID) .. "', `action` = '" .. (action) .. "' " .. (adminID and (", `actor` = '" .. adminID .. "' ") or ""))
        if query3 then
            return true
        else
            outputDebugString("[INTERIOR MANAGER] Failed to add interior logs.")
            return false
        end
    else
        outputDebugString("[INTERIOR MANAGER] Lack of arguments #1 or #2 for the function addInteriorLogs().")
        return false
    end
end