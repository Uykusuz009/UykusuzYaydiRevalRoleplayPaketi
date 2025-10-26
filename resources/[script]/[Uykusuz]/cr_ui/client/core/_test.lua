local renderPairs = {}
local IS_TESTING = true

function test(cb)
    if getElementData(localPlayer, "account_username") ~= "Farid" then
        return false
    end
    
    return {
        render = function()
            table.insert(renderPairs, cb)
        end,
        execute = function()
            cb()
        end
    }
end

if IS_TESTING then
    setTimer(function()
        for _, cb in ipairs(renderPairs) do
            cb(function()
                table.remove(renderPairs, _)
            end)
        end
    end, 0, 0)
end