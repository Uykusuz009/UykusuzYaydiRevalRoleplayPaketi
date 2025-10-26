peds = {
    {28,1425.4140625, -1290.9482421875, 13.557456016541,185}
}
ped = {}

for k=1, #peds do
    ped[k] = createPed(unpack(peds[k]))
    setElementData(ped[k], 'name', 'Black Market')
end
