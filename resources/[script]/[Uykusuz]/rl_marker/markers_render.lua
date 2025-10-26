local r1_0 = dxCreateTexture("img/light.png", "argb")
local r2_0 = dxCreateTexture("img/arrow.dds", "argb")
local r3_0 = dxCreateTexture("img/house.dds", "argb")
local r4_0 = dxCreateTexture("img/house_sale.dds", "argb")
local r5_0 = dxCreateTexture("img/business.dds", "argb")
local r6_0 = dxCreateTexture("img/business_sale.dds", "argb")
local r7_0 = "foward"
local r8_0 = 50
local r9_0 = 0
local r10_0 = {}
local r11_0 = dxCreateFont("BebasNeueRegular.otf", 20)

setTimer(function()
  for r3_2, r4_2 in ipairs(getElementsByType("marker", root, true)) do
    if getElementData(r4_2, "custom_marker") then
      local r5_2 = getElementData(r4_2, "custom_marker_type")
      local r6_2 = getElementData(r4_2, "custom_marker_data")
      if r5_2 then
        if not r10_0[r3_2] then
          r10_0[r3_2] = dxCreateRenderTarget(400, 150, true)
        end
        local r7_2, r8_2, r9_2 = getElementPosition(r4_2)
        local r10_2, r11_2, r12_2 = getElementPosition(localPlayer)
        local r13_2, r14_2, r15_2, r16_2 = getMarkerColor(r4_2)
        if getDistanceBetweenPoints3D(r7_2, r8_2, r9_2, r10_2, r11_2, r12_2) < r8_0 then
          local r18_2 = getMarkerSize(r4_2)
          if r7_0 == "back" then
            local r19_2 = (getTickCount() - r9_0) / 1500
            position = math.floor(interpolateBetween(0, 0, 0, 200, 0, 0, r19_2, "InQuad"))
            if r19_2 > 1 then
              r7_0 = "foward"
              r9_0 = getTickCount()
            end
          else
            local r19_2 = (getTickCount() - r9_0) / 1500
            position = math.floor(interpolateBetween(200, 0, 0, 0, 0, 0, r19_2, "OutQuad"))
            if r19_2 > 1 then
              r7_0 = "back"
              r9_0 = getTickCount()
            end
          end
          if r5_2 == "arrow" then
            dxDrawMaterialLine3D(r7_2, r8_2, r9_2 + 1 + 0.7 + position / 1000 - 0.3, r7_2, r8_2, r9_2 + 1 + position / 1000 - 0.3, r2_0, 1, tocolor(r13_2, r14_2, r15_2, 200))
          elseif r5_2 == "arrow_house" then
            dxDrawMaterialLine3D(r7_2, r8_2, r9_2 + 1 + 0.7 + position / 1000 - 0.3, r7_2, r8_2, r9_2 + 1 + position / 1000 - 0.3, r2_0, 1, tocolor(r13_2, r14_2, r15_2, 200))
            if r6_2 then
              dxSetRenderTarget(r10_0[r3_2], true)
              material = r10_0[r3_2]
              dxDrawText(r6_2.name .. " (#" .. r6_2.id .. ")", 0, 0, 400, 210, tocolor(255, 255, 255, 255), 1, r11_0, "center", "center", true, true)
              dxSetRenderTarget()
              dxDrawMaterialLine3D(r7_2, r8_2, r9_2 + 1 + 0.2 + position / 1000, r7_2, r8_2, r9_2 + 1.8 + 0.2 + position / 1000 - 1.4, material, 1, tocolor(255, 255, 255, 255))
            end
          elseif r5_2 == "house" then
            dxDrawMaterialLine3D(r7_2, r8_2, r9_2 + 1 + 0.7 + position / 1000 - 0.3, r7_2, r8_2, r9_2 + 1 + position / 1000 - 1, r3_0, 1, tocolor(r13_2, r14_2, r15_2, 200))
            if r6_2 then
              dxSetRenderTarget(r10_0[r3_2], true)
              material = r10_0[r3_2]
              dxDrawText(r6_2.name .. " (#" .. r6_2.id .. ")", 0, 0, 400, 240, tocolor(255, 255, 255, 255), 1, r11_0, "center", "center", true, true)
              dxSetRenderTarget()
              dxDrawMaterialLine3D(r7_2, r8_2, r9_2 + 1 + 0.2 + position / 1000, r7_2, r8_2, r9_2 + 1.8 + 0.2 + position / 1000 - 1.4, material, 1, tocolor(255, 255, 255, 255))
            end
          elseif r5_2 == "business" then
            dxDrawMaterialLine3D(r7_2, r8_2, r9_2 + 1 + 0.7 + position / 1000 - 0.3, r7_2, r8_2, r9_2 + 1 + position / 1000 - 1, r5_0, 1, tocolor(r13_2, r14_2, r15_2, 200))
            if r6_2 then
              dxSetRenderTarget(r10_0[r3_2], true)
              material = r10_0[r3_2]
              dxDrawText(r6_2.name .. " (#" .. r6_2.id .. ")", 0, 0, 400, 240, tocolor(255, 255, 255, 255), 1, r11_0, "center", "center", true, true)
              dxSetRenderTarget()
              dxDrawMaterialLine3D(r7_2, r8_2, r9_2 + 1 + 0.2 + position / 1000, r7_2, r8_2, r9_2 + 1.8 + 0.2 + position / 1000 - 1.4, material, 1, tocolor(255, 255, 255, 255))
            end
          elseif r5_2 == "house_sale" then
            dxDrawMaterialLine3D(r7_2, r8_2, r9_2 + 1 + 0.7 + position / 1000 - 0.3, r7_2, r8_2, r9_2 + 1 + position / 1000 - 1, r4_0, 1, tocolor(r13_2, r14_2, r15_2, 200))
            if r6_2 then
              dxSetRenderTarget(r10_0[r3_2], true)
              material = r10_0[r3_2]
              dxDrawText(r6_2.name .. " (#" .. r6_2.id .. ")", 0, 0, 400, 250, tocolor(255, 255, 255, 255), 1, r11_0, "center", "center", true, true)
              dxSetRenderTarget()
              dxDrawMaterialLine3D(r7_2, r8_2, r9_2 + 1 + 0.2 + position / 1000, r7_2, r8_2, r9_2 + 1.8 + 0.2 + position / 1000 - 1.4, material, 1, tocolor(255, 255, 255, 255))
            end
          elseif r5_2 == "business_sale" then
            dxDrawMaterialLine3D(r7_2, r8_2, r9_2 + 1 + 0.7 + position / 1000 - 0.3, r7_2, r8_2, r9_2 + 1 + position / 1000 - 1, r6_0, 1, tocolor(r13_2, r14_2, r15_2, 200))
            if r6_2 then
              dxSetRenderTarget(r10_0[r3_2], true)
              material = r10_0[r3_2]
              dxDrawText(r6_2.name .. " (#" .. r6_2.id .. ")", 0, 0, 400, 250, tocolor(255, 255, 255, 255), 1, r11_0, "center", "center", true, true)
              dxSetRenderTarget()
              dxDrawMaterialLine3D(r7_2, r8_2, r9_2 + 1 + 0.2 + position / 1000, r7_2, r8_2, r9_2 + 1.8 + 0.2 + position / 1000 - 1.4, material, 1, tocolor(255, 255, 255, 255))
            end
          end
          dxDrawMaterialLine3D(r7_2 + r18_2, r8_2 + r18_2, r9_2 + 0.04, r7_2 - r18_2, r8_2 - r18_2, r9_2 + 0.04, r1_0, r18_2 * 3, tocolor(r13_2, r14_2, r15_2, 155), r7_2, r8_2, r9_2)
        end
      end
    end
  end
end, 0, 0)

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), function()
  for r3_3, r4_3 in ipairs(getElementsByType("marker")) do
    if getElementData(r4_3, "custom_marker") then
      destroyElement(r4_3)
    end
  end
end)
