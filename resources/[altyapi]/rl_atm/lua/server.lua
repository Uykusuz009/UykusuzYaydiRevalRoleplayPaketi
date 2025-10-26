function bankCek(thePlayer,edit)


if client ~= source then 
kickPlayer(client,"Awx Guard - triggerServerEvent")
print("rl_ac 134")
return end

if edit <= 0 then return end
	if tonumber(thePlayer:getData("bank_money")) >= tonumber(edit)then
		global:giveMoney(thePlayer,edit)
		thePlayer:setData("bank_money",thePlayer:getData("bank_money")-edit,true)
		dbExec(mysql:getConnection(),  "UPDATE `characters` SET `bank_money`=bank_money-"..edit.." WHERE `id`='"..getElementData(thePlayer, "dbid").."' ") 
		thePlayer:outputChat("'' #d0d0d0Başarıyla hesabınızdan "..edit.." ₺ miktar para çektiniz",0,155,255,true)
	else
		thePlayer:outputChat("'' #d0d0d0Hesabınızda bu kadar para yok!",255,0,0,true)
	end
end
addEvent("bank:giveMoney",true)
addEventHandler("bank:giveMoney",root,bankCek)

function bankYatir(thePlayer,edit)

if client ~= source then 
kickPlayer(client,"Awx Guard - triggerServerEvent")
print("rl_ac 135")
return end

if edit <= 0 then return end
	if global:hasMoney(thePlayer,edit) then
		global:takeMoney(thePlayer,edit)
		thePlayer:setData("bank_money",thePlayer:getData("bank_money")+edit,true)
		dbExec(mysql:getConnection(),  "UPDATE `characters` SET `bank_money`=bank_money+"..edit.." WHERE `id`='"..getElementData(thePlayer, "dbid").."' ") 
		thePlayer:outputChat("'' #d0d0d0Başarıyla hesabınızdan "..edit.." ₺ miktar para yatırdın",0,155,255,true)
	else
		thePlayer:outputChat("'' #d0d0d0Üzerinizde bu kadar para yok!",255,0,0,true)
	end
end
addEvent("bank:takeMoney",true)
addEventHandler("bank:takeMoney",root,bankYatir)

function bankTransfer(thePlayer,edit,id)

if client ~= source then 
kickPlayer(client,"Awx Guard - triggerServerEvent")
print("rl_ac 135")
return end

if edit <= 0 then return end
local targetPlayer, targetPlayerName = global:findPlayerByPartialNick(thePlayer, id)
	if targetPlayer then
		if tonumber(thePlayer:getData("bank_money")) >= tonumber(edit)then
			thePlayer:setData("bank_money",thePlayer:getData("bank_money")-edit,true)
			dbExec(mysql:getConnection(),  "UPDATE `characters` SET `bank_money`=bank_money-"..edit.." WHERE `id`='"..getElementData(thePlayer, "dbid").."' ") 
			targetPlayer:setData("bank_money",targetPlayer:getData("bank_money")+edit,true)
			dbExec(mysql:getConnection(),  "UPDATE `characters` SET `bank_money`=bank_money+"..edit.." WHERE `id`='"..getElementData(targetPlayer, "dbid").."' ") 
			thePlayer:outputChat("'' #d0d0d0Başarıyla "..edit.."₺ tutarında transfer gerçekleştirdiniz.",0,155,255,true)
		else
			thePlayer:outputChat("'' #d0d0d0Üzerinizde bu kadar para yok!",255,0,0,true)
		end
	else
		thePlayer:outputChat("'' #d0d0d0Oyuncu Bulunamadı!",255,0,0,true)
	end
end
addEvent("bank:transferMoney",true)
addEventHandler("bank:transferMoney",root,bankTransfer)
