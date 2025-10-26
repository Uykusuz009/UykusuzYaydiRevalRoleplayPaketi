local mysql = exports.rl_mysql

addEvent("wearable.buyItem", true)
addEventHandler("wearable.buyItem", root, function(modelID, price)
    if client ~= source then
        exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	local boneTable, bone = findThemBonePosition(modelID)
    if exports.rl_global:hasMoney(client, price) then
        if exports.rl_global:takeMoney(client, price) then
            outputChatBox("[!]#FFFFFF Aksesuarı başarıyla satın aldınız.", client, 0, 255, 0, true)
            dbExec(mysql:getConnection(), "INSERT INTO `wearables` SET `model` = ?, `owner` = ?, `x` = '0', `y` = '0', `z` = '0', `rx` = '0', `ry` = '0', `rz` = '0', `bone` = ?", tonumber(modelID), tonumber(client:getData("dbid")), tonumber(bone))
            triggerEvent("wearable.loadMyWearables", root, client)
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli paranız olmadığı için aksesuarı satın alamadınız.", client, 255, 0, 0, true)
    end
end)

function findThemBonePosition(modelID)
    for index, value in ipairs(getWearables()) do
        for _, data in ipairs(value['list']) do
            if tonumber(data['modelid']) == tonumber(modelID) then
                return value['position'], value['bone']
            end
        end
    end
    return {0, 0, 0, 0, 0, 0, 1, 1, 1}, 1
end