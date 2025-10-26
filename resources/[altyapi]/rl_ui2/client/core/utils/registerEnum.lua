function registerEnum(arr)
    local enum = {}
    for _, v in ipairs(arr) do
        enum[string.upper(v)] = v
    end
    return enum
end