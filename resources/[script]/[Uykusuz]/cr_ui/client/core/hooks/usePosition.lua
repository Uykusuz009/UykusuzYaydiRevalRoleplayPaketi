function usePosition(position, size, centered)
    if centered then
        position = {
            x = screenSize.x / 2 - size.x / 2,
            y = screenSize.y / 2 - size.y / 2
        }
    end
    return position, size, centered
end