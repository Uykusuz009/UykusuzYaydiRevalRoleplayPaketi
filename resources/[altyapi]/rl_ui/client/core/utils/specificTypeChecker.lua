function specificTypeChecker(baseOptions, options, componentName)
    if options.variant then
        assert(checkVariant(options.variant), componentName .. " > Invalid variant " .. options.variant)
    end

    if options.placement then
        assert(checkPlacement(options.placement), componentName .. " > Invalid placement " .. options.placement)
    end
    
    if not options.position then
        assert(options.position, componentName .. " > position is required")
    end

    local hasLeakProperty = false
    for key, value in pairs(options) do
        if not baseOptions[key] and baseOptions[key] == nil then
            hasLeakProperty = key
            break
        end
    end

    assert(not hasLeakProperty, componentName .. " > Invalid property " .. tostring(hasLeakProperty))
end