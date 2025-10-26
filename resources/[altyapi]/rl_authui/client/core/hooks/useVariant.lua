AVAILABLE_VARIANTS = {
    SOLID = "solid",
    SOFT = "soft",
    OUTLINED = "outlined",
    PLAIN = "plain",
    TRANSPARENT = "transparent",
}

DEFAULT_VARIANT = AVAILABLE_VARIANTS.SOLID

function checkVariant(variant)
    return AVAILABLE_VARIANTS[string.upper(variant)] ~= nil
end