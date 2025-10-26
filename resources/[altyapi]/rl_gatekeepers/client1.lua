wPedRightClick = nil
bTalkToPed, bClosePedMenu = nil
ax, ay = nil
closing = nil
sent=false

function talkPed(element)
	local ped 		   = getElementData(element, "name")
	local isFuelped    = getElementData(element,"ped:fuelped")
	local isTollped    = getElementData(element,"ped:tollped")
	local isShopKeeper = getElementData(element,"shopkeeper") or false
	if (ped=="Kevin Mitchell") then
		triggerServerEvent("start.crusher", getLocalPlayer())
	elseif (ped=="Gişe Görevlisi") then
		triggerEvent("toll.display", getLocalPlayer(), element)
	elseif (ped=="Letty Grambell") then
		triggerEvent("bank.display", getLocalPlayer())
	elseif (ped=="Tiffany Carney") then
		triggerEvent("prison.display", getLocalPlayer())
	elseif (ped=="Richard Bowman") then
		triggerEvent("crusher.display", getLocalPlayer())
	elseif (ped=="Selena Northgard") then
		triggerEvent("tax.display", getLocalPlayer())
	elseif (ped=="Tiffany Morgan") then
		triggerEvent("skinshop.display", getLocalPlayer())
	elseif (ped=="Sergio Vushlat") then
		triggerEvent("toggleCarshop", localPlayer)
	elseif (ped=="Daryl Lively") then
		triggerEvent("independent.start", getLocalPlayer())
	elseif (ped=="Merve Ayaz") then
		triggerEvent("license.display", getLocalPlayer())
	elseif (ped=="Ehliyet Kursu") then
		triggerEvent("onLicense", localPlayer)
	elseif (ped=="Hüseyin Ak") then
		triggerEvent("pdaraccikart", getLocalPlayer())
	elseif (ped=="Korna") then
		triggerEvent("korna:panel", getLocalPlayer())
	elseif (ped=="Julie Dupont") then
		triggerServerEvent('clothing:list', getResourceRootElement(getResourceFromName("rl_dupont")))
	elseif (ped=="Black Market") then
		triggerEvent("bmarket:open", getLocalPlayer())	
	elseif (ped=="Vale") then
		triggerEvent("valepanel", getLocalPlayer())	
	elseif (ped=="Bitcoin") then
		triggerEvent("odin:btcpanel", getLocalPlayer())	
	elseif (ped=="Kasiyer") then
		local type = getElementData(element, "type")
		triggerEvent("shop.display", getLocalPlayer(), type)
	else
		exports.rl_hud:sendBottomNotification(getLocalPlayer(), (ped or "NPC").." diyor ki:", "'Sana yardımcı olabileceğim bir konu yok, üzgünüm.'")
	end
end
addEvent("npc:talk",true)
addEventHandler("npc:talk", root, talkPed)

function pedDamage()
	cancelEvent()
end
addEventHandler("onClientPedDamage", getRootElement(), pedDamage)

function hidePedMenu()
	if (isElement(bTalkToPed)) then
		destroyElement(bTalkToPed)
	end
	bTalkToPed = nil

	if (isElement(bClosePedMenu)) then
		destroyElement(bClosePedMenu)
	end
	bClosePedMenu = nil

	if (isElement(wPedRightClick)) then
		destroyElement(wPedRightClick)
	end
	wPedRightClick = nil

	ax = nil
	ay = nil
	sent=false
	showCursor(false)
end
