AVAILABLE_PLACEMENTS = registerEnum({ "horizontal", "vertical" })

function checkPlacement(placement)
    return AVAILABLE_PLACEMENTS[string.upper(placement)] ~= nil
end