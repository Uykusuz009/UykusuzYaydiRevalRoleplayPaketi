function createCustomMarker(r0_2, r1_2, r2_2, r3_2, r4_2, r5_2, r6_2, r7_2, r8_2, r9_2)
  if not r9_2 then
    r9_2 = {}
  end

  if r0_2 and r1_2 and r2_2 and r3_2 and r4_2 and r5_2 and r6_2 and r7_2 then
    local r10_2 = createMarker(r0_2, r1_2, r2_2, r3_2, r4_2, r5_2, r6_2, r7_2, 0)
    setElementData(r10_2, "custom_marker", true)
    setElementData(r10_2, "custom_marker_type", r8_2)
    setElementData(r10_2, "custom_marker_data", r9_2)
    return r10_2
  end
end
