local objects = {
    --Disco
    createObject(10184, 608.79364, -76.14168, 998.55304, 0, 0, 180, 2)
}

local col = createColSphere(620.18, -70.89, 997.99, 20)

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

for index, object in ipairs(objects) do
    setElementDoubleSided(object, true)
    --setElementCollisionsEnabled ( object, true )
end


