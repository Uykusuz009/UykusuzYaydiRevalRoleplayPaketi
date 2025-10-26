setWorldSoundEnabled(42, false)
setWorldSoundEnabled(5, false)
setWorldSoundEnabled(5, 87, true)
setWorldSoundEnabled(5, 58, true)
setWorldSoundEnabled(5, 37, true)

local function playGunfireSound(weaponID)
    local muzzleX, muzzleY, muzzleZ = getPedWeaponMuzzlePosition(source)
    local dimension = getElementDimension(source)

    if weaponID == 22 then
        local sound = playSound3D("public/sounds/weapons/colt_45.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 95)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 23 then
        local sound = playSound3D("public/sounds/weapons/silenced.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 15)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 24 then
        local sound = playSound3D("public/sounds/weapons/deagle.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 120)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 25 then
        local sound = playSound3D("public/sounds/weapons/shotgun.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 120)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 26 then
        local sound = playSound3D("public/sounds/weapons/sawed-off.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 95)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 27 then
        local sound = playSound3D("public/sounds/weapons/combat_shotgun.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 100)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 28 then
        local sound = playSound3D("public/sounds/weapons/uzi.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 105)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 32 then
        local sound = playSound3D("public/sounds/weapons/tec-9.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 105)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 29 then
        local sound = playSound3D("public/sounds/weapons/mp5.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 120)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 30 then
        local sound = playSound3D("public/sounds/weapons/ak47.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 180)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 31 then
        local sound = playSound3D("public/sounds/weapons/m4.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 170)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.4)
    elseif weaponID == 33 then
        local sound = playSound3D("public/sounds/weapons/rifle.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 175)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 34 then
        local sound = playSound3D("public/sounds/weapons/sniper.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 325)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    end
end
addEventHandler("onClientPlayerWeaponFire", root, playGunfireSound)

addEvent("weapon.playHeadshotSound", true)
addEventHandler("weapon.playHeadshotSound", root, function()
	local sound = playSound("public/sounds/headshot.mp3")
	setSoundVolume(sound, 0.5)
end)