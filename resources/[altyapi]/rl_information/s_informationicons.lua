mysql = exports.rl_mysql

local informationicons = { }

function SmallestID()
	local result = dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM informationicons AS e1 LEFT JOIN informationicons AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result2 = dbPoll(result, -1)
	if result2 then
		local id = tonumber(result2[1]["nextID"]) or 1
		return id
	end
	return false
end

function makeInformationIcon(thePlayer, commandName, ...)
	if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
	if ... then
		local arg = {...}
		local information = table.concat( arg, " " )
		local x, y, z = getElementPosition(thePlayer)
		--z = z + 0.5 only use for i object
		local rx, ry, rz = getElementRotation(thePlayer)
		local interior = getElementInterior(thePlayer)
		local dimension = getElementDimension(thePlayer)
		local id = SmallestID()
		local createdby = getPlayerName(thePlayer):gsub("_", " ")
		local query = dbExec(mysql:getConnection(),"INSERT INTO informationicons SET id="..(id)..",createdby='"..(createdby).."',x='"..(x).."', y='"..(y).."', z='"..(z).."', rx='"..(rx).."', ry='"..(ry).."', rz='"..(rz).."', interior='"..(interior).."', dimension='"..(dimension).."', information='"..(information).."'")
		if query then
			informationicons[id] = createPickup(x, y, z, 3, 1, 0)--createObject(1239, x, y, z, rx, ry, rz)
			setElementInterior(informationicons[id], interior)
			setElementDimension(informationicons[id], dimension)
			setElementData(informationicons[id], "informationicons:id", id)
			setElementData(informationicons[id], "informationicons:createdby", createdby)
			setElementData(informationicons[id], "informationicons:x", x)
			setElementData(informationicons[id], "informationicons:y", y)
			setElementData(informationicons[id], "informationicons:z", z)
			setElementData(informationicons[id], "informationicons:rx", rx)
			setElementData(informationicons[id], "informationicons:ry", ry)
			setElementData(informationicons[id], "informationicons:rz", rz)
			setElementData(informationicons[id], "informationicons:interior", interior)
			setElementData(informationicons[id], "informationicons:dimension", dimension)
			setElementData(informationicons[id], "informationicons:information", information)
			-- outputChatBox("Information icon created with ID: "..id, thePlayer, 0, 255, 0)
		else
			-- outputChatBox("Error creating information icon. Please report on the mantis.", thePlayer, 255, 0, 0)
		end
		else
			outputChatBox("SYNTAX: /infokoy [Information]", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("infokoy", makeInformationIcon, false, false)

function saveAllInformationIcons()
	for key, value in ipairs (informationicons) do
		local id = getElementData(informationicons[key], "informationicons:id")
		local createdby = getElementData(informationicons[key], "informationicons:createdby")
		local x = getElementData(informationicons[key], "informationicons:x")
		local y = getElementData(informationicons[key], "informationicons:y")
		local z = getElementData(informationicons[key], "informationicons:z")
		local rx = getElementData(informationicons[key], "informationicons:rx")
		local ry = getElementData(informationicons[key], "informationicons:ry")
		local rz = getElementData(informationicons[key], "informationicons:rz")
		local interior = getElementData(informationicons[key], "informationicons:interior")
		local dimension = getElementData(informationicons[key], "informationicons:dimension")
		local information = getElementData(informationicons[key], "informationicons:information")
		dbExec(mysql:getConnection(),"UPDATE informationicons SET createdby = '" .. (createdby) .. "', x = '" .. (x) .. "', y = '" .. (y) .. "', z = '" .. (z) .. "', rx = '" .. (rx) .. "', ry = '" .. (ry) .. "', rz = '" .. (rz) .. "', interior = '" .. (interior) .. "', dimension = '" .. (dimension) .. "', information = '" .. (information) .. "' WHERE id='" .. (id) .. "'")
	end
end
addEventHandler("onResourceStop", getResourceRootElement(), saveAllInformationIcons)


function loadAllInformationIcons()
    outputDebugString("Loading all information icons...") -- İşlemin başladığını bildir
    
    dbQuery(
        function(qh)
            local res, rows, err = dbPoll(qh, 0)
            
            if not res then
                outputDebugString("Database query failed: " .. tostring(err), 1)
                return
            end
            
            if rows > 0 then
                outputDebugString("Found " .. rows .. " information icons to load.") -- Kaç satır bulunduğunu bildir
                
                for index, row in ipairs(res) do
                    local id = tonumber(row["id"])
                    local createdby = tostring(row["createdby"])
                    local x = tonumber(row["x"])
                    local y = tonumber(row["y"])
                    local z = tonumber(row["z"])
                    local rx = tonumber(row["rx"])
                    local ry = tonumber(row["ry"])
                    local rz = tonumber(row["rz"])
                    local interior = tonumber(row["interior"])
                    local dimension = tonumber(row["dimension"])
                    local information = tostring(row["information"])

                    -- İkon oluşturma
                    informationicons[id] = createPickup(x, y, z, 3, 1, 0) -- Alternatif: createObject(1239, x, y, z, rx, ry, rz)
                    if informationicons[id] then
                        -- Başarıyla oluşturulmuşsa, devam et
                        setElementInterior(informationicons[id], interior)
                        setElementDimension(informationicons[id], dimension)
                        setElementData(informationicons[id], "informationicons:id", id)
                        setElementData(informationicons[id], "informationicons:createdby", createdby)
                        setElementData(informationicons[id], "informationicons:x", x)
                        setElementData(informationicons[id], "informationicons:y", y)
                        setElementData(informationicons[id], "informationicons:z", z)
                        setElementData(informationicons[id], "informationicons:rx", rx)
                        setElementData(informationicons[id], "informationicons:ry", ry)
                        setElementData(informationicons[id], "informationicons:rz", rz)
                        setElementData(informationicons[id], "informationicons:interior", interior)
                        setElementData(informationicons[id], "informationicons:dimension", dimension)
                        setElementData(informationicons[id], "informationicons:information", information)
                        -- outputDebugString("Loaded information icon #" .. id .. " created by " .. createdby .. ".")
                    else
                        -- Oluşturma başarısızsa hata bildir
                        outputDebugString("Failed to create information icon #" .. id, 1)
                    end
                end
            else
                -- Hiç satır bulunmadıysa
                outputDebugString("No information icons found in the database.", 2)
            end
        end,
        mysql:getConnection(),
        "SELECT * FROM `informationicons`"
    )
end

addEventHandler("onResourceStart", getResourceRootElement(), loadAllInformationIcons)

function getNearbyInformationIcons(thePlayer, commandName)
    
    if not exports.rl_integration:isPlayerAdmin2(thePlayer) then
        outputChatBox("Bu komutu kullanmak için admin olmalısınız!", thePlayer, 255, 0, 0)
        return
    end

    local posX, posY, posZ = getElementPosition(thePlayer)
    outputChatBox("Yakındaki Bilgilendirme İkonları:", thePlayer, 255, 126, 0)

    local count = 0
    for key, icon in pairs(informationicons or {}) do
        if isElement(icon) then
            local x, y, z = getElementPosition(icon)
            local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)

            if distance <= 10 and getElementDimension(icon) == getElementDimension(thePlayer) and getElementInterior(icon) == getElementInterior(thePlayer) then
                local dbid = getElementData(icon, "informationicons:id") or "N/A"
                local createdby = getElementData(icon, "informationicons:createdby") or "Bilinmiyor"
                local information = getElementData(icon, "informationicons:information") or "Bilgi yok"
                outputChatBox("   #" .. dbid .. " - " .. information .. " (Created by: " .. createdby .. ")", thePlayer, 255, 126, 0)
                count = count + 1
            end
        else
            outputDebugString("Geçersiz bir element bulundu. Index: " .. key)
        end
    end

    if count == 0 then
        outputChatBox("   Yakında hiçbir ikon bulunamadı.", thePlayer, 255, 126, 0)
    end
end
addCommandHandler("infolar", getNearbyInformationIcons, false, false)

function deleteInformationIcon(thePlayer, commandName, ID)
    if (exports.rl_integration:isPlayerAdmin2(thePlayer)) then
        if tonumber(ID) then
            local ID = tonumber(ID)
            if informationicons[ID] then
                for k,v in pairs(getAllElementData(informationicons[ID])) do
                    removeElementData(informationicons[ID],k)
                end
                destroyElement(informationicons[ID])
                local query = dbExec(mysql:getConnection('reval'),"DELETE FROM `informationicons` WHERE `id`='" .. ID .. "'")
                if query then
                    informationicons[ID] = nil
                    outputChatBox("Information icon ID: "..ID.." deleted.", thePlayer, 0, 255, 0)
                else
                    outputChatBox("Error deleting information icon. Please report on the mantis.", thePlayer, 255, 0, 0)
                end
            else
                outputChatBox("An information icon with that ID does not exist.", thePlayer, 255, 0, 0)
            end
        else
            outputChatBox("SYNTAX: /delii [ID]", thePlayer, 255, 194, 14)
        end
    end
end
addCommandHandler("infosil", deleteInformationIcon, false, false)