-- Sosyal Rol Alanı Sistemi
local global = exports.rl_global
local para = 500
local parabalik = 500
local dakika = 1
local dakikabalik = 2

local sosyalroltimer = {}
local sosyalrolalani = createColSphere(152.8525390625, -1914.19140625, 3.5997443199158, 70)
local sosyalrolalanibalik = createColSphere(-1537.23046875, 1521.9599609375, -0.51675570011139, 120)

function SosyalRolAlaniGiris ( thePlayer, matchingDimension )
    if thePlayer:getType() == "player" then 
        exports.rl_infobox:addBox(thePlayer, "info", "AFK kal para kazan alanına girdin. Alanda durduğun her " .. dakika .. " dakika boyunca " .. global:formatMoney(para) .. "₺ alacaksın.")
        
        sosyalroltimer[thePlayer] = setTimer(function(thePlayer)	
            if exports.rl_global then
                exports.rl_global:giveMoney(thePlayer, 500)
            else
                outputDebugString("rl_global:giveMoney fonksiyonu bulunamadı!", 1)
            end
        end, 60000, 0, thePlayer)
        -- 60000 1 dk
    end
end
addEventHandler ( "onColShapeHit", sosyalrolalani, SosyalRolAlaniGiris )

function SosyalRolAlaniGiris2 ( thePlayer, matchingDimension )
    if thePlayer:getType() == "player" then 
        exports.rl_infobox:addBox(thePlayer, "info", "Ödül havuzu alanına girdin. Alanda durduğun her " .. dakikabalik .. " dakika boyunca " .. global:formatMoney(parabalik) .. "₺ alacaksın.")
        
        sosyalroltimer[thePlayer] = setTimer(function(thePlayer)	
            if exports.rl_global  then
                exports.rl_global:giveMoney(thePlayer, 500)
            else
                outputDebugString("rl_global:giveMoney fonksiyonu bulunamadı!", 1)
            end
        end, 60000*2, 0, thePlayer)	-- 60000 1 dk
    end
end
addEventHandler ( "onColShapeHit", sosyalrolalanibalik, SosyalRolAlaniGiris2 )

function SosyalRolAlaniCikis(thePlayer, matchingDimension)
    if thePlayer:getType() == "player" then 
        exports.rl_infobox:addBox(thePlayer, "warning", "Alandan çıktığın için para alamayacaksın.")
        if sosyalroltimer[thePlayer] then 
            killTimer(sosyalroltimer[thePlayer])
            sosyalroltimer[thePlayer] = false
        end
    end
end
addEventHandler("onColShapeLeave", sosyalrolalani, SosyalRolAlaniCikis)

function SosyalRolAlaniCikis2(thePlayer, matchingDimension)
    if thePlayer:getType() == "player" then 
        exports.rl_infobox:addBox(thePlayer, "success", "Alandan çıktığın için para alamayacaksın.")
        if sosyalroltimer[thePlayer] then 
            killTimer(sosyalroltimer[thePlayer])
            sosyalroltimer[thePlayer] = false
        end
    end
end
addEventHandler("onColShapeLeave", sosyalrolalanibalik, SosyalRolAlaniCikis)