local sx, sy = guiGetScreenSize()
local browser = guiCreateBrowser(0, 0, sx, sy, true, true, false)
guiSetVisible(browser, false)
local theBrowser = guiGetBrowser(browser)

addEventHandler("onClientBrowserCreated", theBrowser, 
	function()
		loadBrowserURL(source, "http://mta/local/index.html")
	end
)

function kenevirinfo(thePlayer)
	guiSetVisible( browser, not guiGetVisible( browser ) )
    showCursor(true)
    showChat(false)
end
addCommandHandler("kenevir", kenevirinfo)

addEvent("kenevir:kapat",true)
addEventHandler("kenevir:kapat",root,function()
	guiSetVisible(browser, false)
	showCursor(false)
	showChat(true)
end)
