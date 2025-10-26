local splittableItems = {
    [30] = " gram(s)", [31] = " gram(s)", [32] = " gram(s)", 
    [33] = " gram(s)", [34] = " gram(s)", [35] = " ml(s)", 
    [36] = " tablet(s)", [37] = " gram(s)", [38] = " gram(s)", 
    [39] = " gram(s)", [40] = " ml(s)", [41] = " tab(s)", 
    [42] = " shroom(s)", [43] = " tablet(s)", [134] = " money"
}

-- Reset Frame Fonksiyonu
function resetFrame(player, itemID, itemValue)
    if exports.rl_global:takeItem(player, itemID, itemValue) and exports.rl_global:giveItem(player, 147, 1) then
        outputChatBox("[!]#FFFFFF Texture bilgileri biçimlendirildi.", player, 0, 255, 0, true)
    end
end
addEvent("resetFrame", true)
addEventHandler("resetFrame", root, resetFrame)

-- Split Komutu (Belirli miktarda ayırma)
function splitItem(player, cmd, itemID, amount)
    itemID, amount = tonumber(itemID), tonumber(amount)
    
    if not itemID or not amount then
        outputChatBox("KULLANIM: /" .. cmd .. " [Item ID] [Miktar]", player, 255, 194, 14)
        outputChatBox("[!]#FFFFFF Bölünebilir öğelerin listesi için '/splits' yazın.", player, 0, 0, 255, true)
        return false
    end
    
    if itemID % 1 ~= 0 or amount % 1 ~= 0 then
        outputChatBox("[!]#FFFFFF Item ID ve Miktar tam sayı olmalıdır.", player, 255, 0, 0, true)
        return false
    end
    
    if not splittableItems[itemID] then
        outputChatBox("[!]#FFFFFF ID '" .. itemID .. "' ayrılabilir bir item değil.", player, 255, 0, 0, true)
        return false
    end
    
    if amount <= 0 then
        outputChatBox("[!]#FFFFFF Tutar sıfırın üzerinde olmalıdır.", player, 255, 0, 0, true)
        return false
    end
    
    local hasItem, itemSlot, itemValue = exports.rl_global:hasItem(player, itemID)
    if not hasItem then
        outputChatBox("[!]#FFFFFF Envanterinizde böyle bir item yok.", player, 255, 0, 0, true)
        return false
    end
    
    local itemValueNum = tonumber(tostring(itemValue):match("%d+"))
    if not itemValueNum then
        outputChatBox("[!]#FFFFFF Bir sorun oluştu.", player, 255, 0, 0, true)
        return false
    end
    
    if amount > itemValueNum then
        outputChatBox("[!]#FFFFFF Tutar, envanterinizde bulunandan daha yüksek olamaz.", player, 255, 0, 0, true)
        return false
    end
    
    if amount == itemValueNum then
        return false
    end
    
    local itemRemaining = itemValueNum - amount
    if exports.rl_global:takeItem(player, itemID, itemValue) and 
       exports.rl_global:giveItem(player, itemID, amount) and 
       exports.rl_global:giveItem(player, itemID, itemRemaining) then
        return true
    else
        outputChatBox("[!]#FFFFFF Bir sorun oluştu.", player, 255, 0, 0, true)
        return false
    end
end
addCommandHandler("split", splitItem, false, false)
addEvent("drugsystem:splitItem", true)
addEventHandler("drugsystem:splitItem", root, splitItem)


-- Splittable Items Listesi
function listSplittable(thePlayer)
    outputChatBox("[!]#FFFFFF Ayrılabilir itemler:", thePlayer, 0, 0, 255, true)
    
    local itemCache = {}
    for itemID in pairs(splittableItems) do
        itemCache[itemID] = getItemName(itemID)
    end
    
    local sortedIDs = {}
    for itemID in pairs(itemCache) do table.insert(sortedIDs, itemID) end
    table.sort(sortedIDs)
    
    for _, itemID in ipairs(sortedIDs) do
        outputChatBox(">>#FFFFFF ID " .. itemID .. " - " .. itemCache[itemID] .. splittableItems[itemID], thePlayer, 0, 255, 0, true)
    end
end
addCommandHandler("splits", listSplittable, false, false)

function splitAllItems(player, cmd)
    for itemID in pairs(splittableItems) do
        local hasItem, itemSlot, itemValue = exports.rl_global:hasItem(player, itemID)
        if hasItem then
            local itemValueNum = tonumber(tostring(itemValue):match("%d+"))
            if itemValueNum and itemValueNum > 1 then
                -- Mevcut itemi sil
                if exports.rl_global:takeItem(player, itemID, itemValue) then
                    -- Her biri 1 olacak şekilde dağıt
                    for i = 1, itemValueNum do
                        exports.rl_global:giveItem(player, itemID, 1)
                    end
                    outputChatBox("[!]#FFFFFF ".. getItemName(itemID) .." ".. itemValueNum .." adet parçalandı.", player, 0, 255, 0, true)
                else
                    outputChatBox("[!]#FFFFFF ".. getItemName(itemID) .." ayrılırken hata oluştu.", player, 255, 0, 0, true)
                end
            end
        end
    end
end
addCommandHandler("hepsinibol", splitAllItems, false, false)
