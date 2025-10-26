local stores = {}

function useStore(key)
    if not stores[key] then
        stores[key] = {}
    end

    return {
        get = function(column)
            return stores[key][column]
        end,
        set = function(column, value)
            stores[key][column] = value
            triggerEvent("store." .. key .. ".listen", resourceRoot, column, value)
        end,
        mock = function(column, mockedValue)
            return mockedValue
        end,
        value = stores[key]
    }
end

---@param key string
function clearStore(key)
    stores[key] = nil
    collectgarbage()
end