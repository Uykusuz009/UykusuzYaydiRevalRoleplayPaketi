local objects = {
    --Disco
    createObject(5302, 681.42938, -450.44696, -24.65371, 0, 0, 270, 1),
    createObject(1496, 680.76935, -450.50797, -26.61719, 0, 0, 0, 1)
}

local col = createColSphere(681.70, -451.37, -25.61, 20)

local function watchChanges()
    if getElementDimension(localPlayer) > 0 and getElementDimension(localPlayer) ~= getElementDimension(objects[1]) and getElementInterior(localPlayer) == getElementInterior(objects[1]) then
        for key, value in pairs(objects) do
            setElementDimension(value, getElementDimension(localPlayer))
        end
    elseif getElementDimension(localPlayer) == 0 and getElementDimension(objects[1]) ~= 65535 then
        for key, value in pairs(objects) do
            setElementDimension(value, 65535)
        end
    end
end
addEventHandler("onClientColShapeHit", col,
        function(element)
            if element == localPlayer then
                addEventHandler("onClientRender", root, watchChanges)
            end
        end
)
addEventHandler("onClientColShapeLeave", col,
        function(element)
            if element == localPlayer then
                removeEventHandler("onClientRender", root, watchChanges)
            end
        end
)

-- Put them standby for now.
for key, value in pairs(objects) do
    setElementDimension(value, 65535)
end

-- for index, object in ipairs ( objects ) do
-- setElementDoubleSided ( object, true )
-- setElementCollisionsEnabled ( object, true )
-- end


