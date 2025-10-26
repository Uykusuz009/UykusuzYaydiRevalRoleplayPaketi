promoCodes = {
    {
        code = "Reval",
        description = "Yeni oyunculara özel promo kodu.",
        active = true,
        gift = function(entity)
            
			exports.rl_vip:addVIP(entity, 4, 7)
            exports.rl_global:giveMoney(entity, 10000)
            
			outputChatBox("[!]#FFFFFF 'Reval' promo koduyla kayıt olduğunuz için 7 günlük VIP [4] ve $10,000 kazandınız.", entity, 0, 255, 0, true)
			exports.rl_logs:addLog("promo", getPlayerName(entity):gsub("_", " ") .. " (" .. (getElementData(entity, "account_username") or "?") .. ") isimli oyuncu 'Reval' promo koduyla kayıt olduğu için 3 günlük VIP [3] ve $10,000 kazandı.")
            
			return true
        end
    }
}

function getPromoData(promoKey)
    if not promoKey then
        return false
    end

    for _, promo in ipairs(promoCodes) do
        if promo.code:upper() == promoKey:upper() then
            return promo
        end
    end
    return false
end

function giveEntityPromoGift(entity, promoCode)
    local data = getPromoData(promoCode)
    if data and data.active then
        if type(data.gift) == "function" then
            data.gift(entity)
            return true
        end
    end
    return false
end