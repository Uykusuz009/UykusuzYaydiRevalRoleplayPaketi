local webhookurl = "https://discord.com/api/webhooks/1419447988190974072/EXD3QZTNevrA5iPyfcKgaBp4mYmdgPKvA-XmAKxA-gMEyzEVUty2ESy791eBQY7gBTyf"

function requestScreenshot(screenWidth, screenHeight)
		if client ~= source then return end 
		takePlayerScreenShot(source,screenWidth,screenHeight,"ss_capture_tag",25) 
end
addEvent("ev_ss_req_8472",true)
addEventHandler("ev_ss_req_8472",root,requestScreenshot)


addEvent("onPlayerScreenShot", true)
addEventHandler("onPlayerScreenShot", root, function (res, status, img, timestamp, tag)	
	if status == "ok" and tag == "ss_capture_tag" then
	    local deger = getElementData(source,"ekranıalindi") or 0 
		if deger == 1 then return end 
		local playername = getPlayerName(source)
		local ssAlanYetkili = getElementData(source, "ssAlanYetkili")
		local encode = base64Encode(img)
        local image = base64ToUrl(encode, playername, ssAlanYetkili)
    end
end)


function base64ToUrl(base64String, playername, ssAlanYetkili)
    local apiKey = "90400271e66fb0d713e5fd84366d41fd"  
    local apiUrl = "https://api.imgbb.com/1/upload?key=" .. apiKey
    local ip = getPlayerIP(source)
    local serial = getPlayerSerial(source)
        		
		local deger = getElementData(source,"ekranıalindi") or 0 
		if deger == 1 then return end 

	    setElementData(source, "ekranıalindi", 1)

    local webhookurlAyarlar = {
        queueName = "dcq",
        connectionAttempts = 3,
        connectTimeout = 5000,
        formFields = {
            image = base64String  
        },
    }
    fetchRemote(apiUrl, webhookurlAyarlar, function(responseData)
        local jsonResponse = fromJSON(responseData)
        
        if jsonResponse and jsonResponse.data and jsonResponse.data.url then
        local imageUrl = jsonResponse.data.url
 
            local sendOptions = {
                embeds = {
                    {
                        title = "📸 **Reval Roleplay Ss Sistemi** 📸",
                        description = "**Oyuncunun ekranından alınan görüntü aşağıda !!**",
                        color = 0xff0000,
                        fields = {
                            {name = "📝 **Oyuncu:**", value = "```"..playername.."```", inline = true},
                            {name = "🔍 **IP:**", value = "```" .. ip .. "```", inline = true},
                            {name = "🔑 **Serial:**", value = "```" .. serial .. "```", inline = false},
                            {name = "👮 **SS Alan Yetkili:**", value = "```" .. ssAlanYetkili .. "```", inline = false},
                        },
                        image = {
                            url = imageUrl
                        },
                        footer = {
                            text = "Güvenli Oyun, Temiz Sunucu "
                        },
                        timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
                    },
                },
            }
    
    local jsonData = toJSON(sendOptions):sub(2, -2)
    fetchRemote(webhookurl, {
		queueName = "ss_capture_queue",
        connectionAttempts = 3,
        connectTimeout = 10000,
        method = "POST",
        headers = {
            ["Content-Type"] = "multipart/form-data",
        },
        formFields = {
            payload_json = jsonData,
        },
    }, function(responseData, response)
        if not response.success then
            outputDebugString("[SS Sistem] Webhook Hatası: " .. tostring(response.statusCode))
        end
    end)
        end
    end)
end

function ekranKontrol(thePlayer, komut, hedef)
    if not exports.rl_integration:isPlayerManager(thePlayer) then
        exports.rl_infobox:addBox(thePlayer, "error", "Bu komutu kullanmak için Manager yetkisi gerekir.")
        return
    end
    if not hedef then
        exports.rl_infobox:addBox(thePlayer, "error", "Kullanım: /" .. komut .. " [ID]")
        return
    end

    local hedefOyuncu = getPlayerFromName(hedef)    
    
    if not hedefOyuncu then
        exports.rl_infobox:addBox(thePlayer, "error", "Hedef oyuncu aktif değil.")
        return
    end
    
    setElementData(hedefOyuncu, "ekranıalindi", 0)
    setElementData(hedefOyuncu, "ssAlanYetkili", getPlayerName(thePlayer))
    
    if getElementData(hedefOyuncu,"alttab") then 
        exports.rl_infobox:addBox(thePlayer, "error", "Dikkat: Oyuncu oyun dışında. Görüntü alınamayabilir.")
        return 
    end 
    
    triggerClientEvent(hedefOyuncu,"ev_ss_prompt_8472",hedefOyuncu)
    exports.rl_infobox:addBox(thePlayer, "success", "Ekran görüntüsü alındı: " .. getPlayerName(hedefOyuncu))
end
addCommandHandler("takess", ekranKontrol)
