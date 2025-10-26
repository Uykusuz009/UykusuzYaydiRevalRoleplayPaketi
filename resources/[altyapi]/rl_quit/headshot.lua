function dxDrawImage3D( x, y, z, width, height, material, color, rotation, ... )
    return dxDrawMaterialLine3D( x, y, z, x + width, y + height, z + tonumber( rotation or 0 ), material, height, color or 0xFFFFFFFF, ... )
end

ibneler = {}
timer = {}

addEvent("quit:add", true)
addEventHandler("quit:add", root, function(x, y, z, name, data, interior, dimension)
table.insert(ibneler, {x =x , y = y, z = z, isim = name, data = data, interior = interior, dimension = dimension})
timer[#ibneler] = setTimer(
    function()
table.remove(ibneler, 1)
    end, 10000, 1
)
end)

soru = dxCreateTexture("soru.png")

size = 1

addEventHandler("onClientRender", root, function()
    for i, v in ipairs(ibneler) do
    if tonumber(v.interior) == getElementInterior(localPlayer) and tonumber(v.dimension) == getElementDimension(localPlayer) then
    local px,py,pz = getElementPosition(getLocalPlayer()) 
    local distance = getDistanceBetweenPoints3D ( v.x,v.y,v.z,px,py,pz ) 
    if distance <= 10 then 
        local sx,sy = getScreenFromWorldPosition ( v.x, v.y, v.z+1, 0.06 ) 
        if not sx then return end 
        x, y, z = getElementPosition(localPlayer)
        local scale = 1/(0.3 * (distance / 150)) 
        dxDrawText ( ""..v.isim..":"..v.data.."", sx, sy , sx, sy , tocolor(255,255,255,255), math.min ( 0.4*(150/distance)*1.4,0.5), "bankgothic", "center", "bottom", false, false, false ) 
        dxDrawMaterialLine3D(v.x+size, v.y+size, v.z, v.x-size, v.y-size, v.z, soru, size*2,tocolor(255, 255, 255, 255), false, v.x, v.y-30, v.z)
    end 
end
end 
end)