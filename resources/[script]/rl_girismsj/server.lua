
local msg_red,msg_green,msg_blue = 100,50,255
 
function servertalkprivate(message, sendto)
	outputChatBox(tostring(message), sendto, msg_red, msg_green, msg_blue, true)
end
 
function servertalk(message)
        --Talk to everyone
	servertalkprivate(message, getRootElement())
end
 
function onJoin()
	servertalkprivate("#676767★ #d0d0d0Reval Roleplay - v2 sürümüne hoş geldin.", source)
	servertalkprivate("#676767★ #d0d0d0Sunucumuz sesli, global ve hard konsepttedir.. ", source)
    servertalkprivate("#676767★ #d0d0d0Discord adresimize katılarak sunucu hakkında detaylı bilgi alabilirsiniz.", source)
    servertalkprivate("#676767★ #d0d0d0Discord: #676767discord.gg/revalroleplay", source)
	servertalkprivate("#676767★ #d0d0d0Sorun ile karşılaştığınızda #676767www.revalroleplay.com", source)
	servertalkprivate("#676767★ #d0d0d0Web sitemizden destek talebi açabilirsiniz. İyi Oyunlar Keyifli Roller ;)", source)
	servertalkprivate("#676767★ #d0d0d0Bu sunucu #676767LargeS ve Uykusuz #d0d0d0tarafından geliştirilmiştir.", source)
	servertalkprivate("#676767★ #d0d0d0Tüm araç modellemeleri #676767y7celhan #d0d0d0tarafından modellenmiştir.", source)

end
 
addEventHandler("onPlayerJoin",getRootElement(),onJoin)