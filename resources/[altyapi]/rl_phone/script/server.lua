

function fetchWeather()
    local apiKey = "072e1d91279a717752728ce086439b2a"
    local apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=Istanbul&appid="..apiKey

    fetchRemote(apiUrl, function(responseData, errno)
        if errno == 0 then
            local weatherData = fromJSON(responseData)
            if weatherData then
                local temperatureKelvin = weatherData.main.temp
                local temperatureCelsius = temperatureKelvin - 273.15
                local weatherDescription = weatherData.weather[1].description
                local turkishWeatherDescription = translateWeatherToTurkish(weatherDescription)
                setElementData(root, "dereceapi", temperatureCelsius)
                setElementData(root, "havadurumapi", turkishWeatherDescription)
            else
                outputChatBox("Hava durumu verisi alınamadı: JSON verisi işlenemedi.")
            end
        else
            outputChatBox("Hava durumu bilgisi alınamadı: HTTP hata kodu " .. errno)
        end
    end)
end

addEventHandler("onResourceStart", root, fetchWeather)
setTimer(fetchWeather, 3600000, 0)

function translateWeatherToTurkish(weatherDescription)
    local translations = {
        ["clear sky"] = "Açık",
        ["few clouds"] = "Az Bulutlu",
        ["scattered clouds"] = "Parçalı Bulutlu",
        ["broken clouds"] = "Kısmen Bulutlu",
        ["overcast clouds"] = "Bulutlu",
        ["light rain"] = "Hafif Yağmurlu",
        ["moderate rain"] = "Orta Şiddetli Yağmurlu",
        ["heavy intensity rain"] = "Şiddetli Yağmurlu",
        ["shower rain"] = "Sağanak Yağmurlu",
        ["rain"] = "Yağmurlu",
        ["thunderstorm with light rain"] = "Hafif Yağmurlu Fırtına",
        ["thunderstorm with rain"] = "Yağmurlu Fırtına",
        ["thunderstorm with heavy rain"] = "Şiddetli Yağmurlu Fırtına",
        ["thunderstorm"] = "Fırtına",
        ["light snow"] = "Hafif Kar Yağışlı",
        ["snow"] = "Kar Yağışlı",
        ["heavy snow"] = "Yoğun Kar Yağışlı",
        ["mist"] = "Dumanlı",
        ["fog"] = "Sisli",
    }
    return translations[string.lower(weatherDescription)] or weatherDescription
end


local Global = {
    db = dbConnect("sqlite", "assets/db/dados.db"),
    Dados = {},
    Telefones = {},
    Twitchs = {},
}
dbExec(Global.db, "CREATE TABLE IF NOT EXISTS Infos (Login TEXT, Telefone TEXT, Background INTEGER)")
dbExec(Global.db, "CREATE TABLE IF NOT EXISTS TransacoesBanco (Login TEXT, Transacoes TEXT)")
dbExec(Global.db, "CREATE TABLE IF NOT EXISTS Whatsapp (Login TEXT, Recebendo TEXT, Conversas TEXT)")
dbExec(Global.db, "CREATE TABLE IF NOT EXISTS Contatos (Login TEXT, Contatos TEXT)")


function generateNumber()
    local Number
    repeat
        Number = generateString(8)
        Number = string.upper(string.sub(Number, 1, 4).."-"..string.sub(Number, 5, 8))
    until not Global.Telefones[Number]  -- Eğer numara kullanıldıysa, tekrar üret
    return Number
end

-- Rastgele string üretme fonksiyonu, benzersiz tohum kullanımıyla
function generateString(len)
    if tonumber(len) then
        local str = ""
        local charlist = {48, 57}  -- Sadece 0-9 arasındaki sayıları kullanarak
        -- Tohumlama, her oyuncu için benzersiz yapar
        math.randomseed(getTickCount() + len + math.random(1000))
        
        for i = 1, len do
            str = str .. string.char(math.random(charlist[1], charlist[2]))
        end
        return str
    end
    return false
end


function _call(_called, ...)
    local co = coroutine.create(_called);
    coroutine.resume(co, ...);
end

function sleep(time)
    local co = coroutine.running();
    local function resumeThisCoroutine()
        coroutine.resume(co);
    end
    setTimer(resumeThisCoroutine, time, 1);
    coroutine.yield();
end

_call(function()
    local Tabelas = dbPoll(dbQuery(Global.db, "SELECT name FROM sqlite_schema"), -1)
    local Dados = {}
    for _,v in pairs(Tabelas) do
        Dados[v["name"]] = dbPoll(dbQuery(Global.db, "SELECT * FROM "..v["name"]..""), -1)
        Global.Dados[v["name"]] = {}
        if #Dados[v["name"]] ~= 0 then
            for i = 1,#Dados[v["name"]] do
                local value = Dados[v["name"]][i]
                if not Global.Dados[v["name"]][value.Login] then
                    Global.Dados[v["name"]][value.Login] = {}
                end
                local TotalIndex = #Global.Dados[v["name"]][value.Login]
                Global.Dados[v["name"]][value.Login][TotalIndex + 1] = value
                if v["name"] == "Infos" then
                    if not Global.Telefones[value.Telefone] then
                        Global.Telefones[value.Telefone] = value.Login
                    end
                end
            end
        end
        if _ == #Tabelas then
            local Players = getElementsByType("player")
            if #Players ~= 0 then
                for i = 1,#Players do
                    local player = Players[i]
                    if not isGuestAccount(getPlayerAccount(player)) then
                        UpdateNumber174(player)
                    end
                end
            end
        end
        sleep(5)
    end
end)

-- Oyuncu numara güncelleme işlemi
function UpdateNumber174(playerAccount)
    if client and client ~= source then 
        local isim = getPlayerName(client)
        local playerip = getPlayerIP(client)
        local serial = getPlayerSerial(client)
        addBan(playerip, isim, serial, "Ramo AC", "code triggerServerEvent", 0)
        outputDebugString("Ramo AC - 0020: Ban uygulandı.")
        return 
    end 
    
    if playerAccount then
        local AccName = getAccountName(playerAccount)
        outputDebugString("Oyuncu hesabı adı: " .. tostring(AccName))
        
        if not Global.Dados["Infos"][AccName] then
            local Telefone = generateNumber()  -- Benzersiz bir numara üret
            outputDebugString("Oluşturulan numara: " .. tostring(Telefone))
            
            Global.Dados["Infos"][AccName] = {{Login = AccName, Telefone = Telefone, 1}}
            local dbExecSuccess = dbExec(Global.db, "INSERT INTO Infos VALUES (?, ?, ?)", AccName, Telefone, 1)
            
            if dbExecSuccess then
                outputDebugString("Veritabanına kayıt başarıyla eklendi.")
            else
                outputDebugString("Veritabanına kayıt eklenemedi.")
            end

            Global.Telefones[Telefone] = AccName
            outputDebugString("Telefon rehberine eklendi: " .. Telefone .. " -> " .. AccName)
        else
            outputDebugString("Bu hesap için zaten bir numara atanmış.")
        end
    else
        outputDebugString("Geçersiz hesap veya oyuncu giriş yapmamış olabilir.")
    end
end



addEvent("174.Call__key:isbnar5tq", true)
addEventHandler("174.Call__key:isbnar5tq", root, function(telefone)





	local ID = getElementData(source, Config.ElementDataID)
    local AccName = getAccountName(getPlayerAccount(source))
    local MeuNumero = Global.Dados["Infos"][AccName][1].Telefone
    local Player = getPlayerFromNumber(telefone)
    if Player then
        if not getElementData(Player, "174.Call__key:isbnar5tq") then
            setElementData(Player, "174.Call__key:isbnar5tq", {ID, false})
            setElementData(source, "174.Call__key:isbnar5tq", {ID, false})
            triggerClientEvent(source, "174.AddChamada", source, "Chamando", telefone, Player)
            local Contatos = getInfosPlayer(source, "Contatos")
            triggerClientEvent(Player, "174.AddChamada", Player, "Recebendo", MeuNumero, source, (Contatos and fromJSON(Contatos[1].Contatos) or {}))
        else
			triggerClientEvent(source,"phone.showInfo",source,"Telefone","Şu anda meşgul.")
        end
    else
		triggerClientEvent(source, "174.AddChamada", source, "Ulasilmadi", telefone)
    end
end)

addEvent("174.UpdateNumber__key:8161wt4v6", true)
addEventHandler("174.UpdateNumber__key:8161wt4v6", root, function(player)
    local playerAccount = getPlayerAccount(player)
    UpdateNumber174(playerAccount)
end)

addEventHandler("onPlayerLogin", root, function(_, acc)
    UpdateNumber174(acc)
end)


local animTimer = {}
local phone = {}

addEvent("174.OpenCell__key:b0ci9jfxe", true)
addEventHandler("174.OpenCell__key:b0ci9jfxe", root, function()


if client and client ~= source then 
local isim = getPlayerName(client)
local playerip = getPlayerIP(client)
local serial = getPlayerSerial(client)
addBan(playerip, isim, serial, "Ramo AC", "code triggerServerEvent", 0)
print("Ramo AC - 0021")
return end 

    if isGuestAccount(getPlayerAccount(source)) or not isGuestAccount(getPlayerAccount(source)) then
        local Infos = getInfosPlayer(source, "Infos")
        local Transacoes = getInfosPlayer(source, "TransacoesBanco") or {}
        local Whatsapp = getInfosPlayer(source, "Whatsapp") or {}
        local Contatos = getInfosPlayer(source, "Contatos")
        triggerClientEvent(source, "174.OpenCell__key:b0ci9jfxe", source, {Infos = (Infos and Infos[1] or {}), Transacoes = Transacoes, Whatsapp = Whatsapp, Contatos = (Contatos and fromJSON(Contatos[1].Contatos) or {})})
		triggerEvent('sendAme', source, "Elini cebine atar ve telefonu çıkartır.")
		phone[source] = createObject(330, 0, 0, 0, 0, 0, 0)
        setObjectScale(phone[source], 1.5)
	    boneattach:attachElementToBone(phone[source], source, 12, 0, -0.02, -0.04, -15, 270, -15)
		setPedAnimation(source, "ped","phone_in", 1000, false, false, false, true)
	    animTimer[source] = setTimer(function(player)
		    if isElement(player) then
			    setPedAnimationProgress(player, "phone_in", 0.8)
		    end
        end, 500, 0, source)
	end
end)

addEvent("dataFalse__key:025b5xh3d", true)
addEventHandler("dataFalse__key:025b5xh3d", root, function(source)
	removePhone(source)
    setPedAnimation(source, "ped", "phone_out", 50, false, false, false, false)
	triggerEvent('sendAme', source, "Telefonu cebine götürür ve cebine koyar.")
end)

addEventHandler("onPlayerQuit", root, function()
	removePhone(source)
end)

addEventHandler("onPlayerWasted", root, function()
	removePhone(source)
end)

function removePhone(player)
	if (phone[player]) then
		destroyElement(phone[player])
		phone[player] = nil
	end
	if (animTimer[player]) then
		killTimer(animTimer[player])
		animTimer[player] = nil
	end
	setPedAnimation(player)
end

function Global.AddTwitch(author, postText)
    Global.Twitchs[#Global.Twitchs + 1] = {PostText = postText, Author = author, Curtidas = {}, Comentarios = {}}
end

function UpdateInfos(player, tipo)
    if tipo == "TransacoesBanco" then
        local InfosTransacao = getInfosPlayer(player, "TransacoesBanco")
        local Transacoes = getInfosPlayer(source, "TransacoesBanco") or {}
        triggerClientEvent(player, "174.UpdateInfos", player, "Transacoes", Transacoes)
    elseif tipo == "Whatsapp" then
        local Whatsapp = getInfosPlayer(player, "Whatsapp")
        triggerClientEvent(player, "174.UpdateInfos", player, "Whatsapp", Whatsapp)
        triggerClientEvent(player, "wpOyuncu", player, player)
    elseif tipo == "Contatos" then
        local Contatos = getInfosPlayer(source, "Contatos")
        triggerClientEvent(player, "174.UpdateInfos", player, "Contatos", fromJSON(Contatos[1].Contatos))
    end
end


addEvent("174.AddContato__key:ris0wpnfw", true)
addEventHandler("174.AddContato__key:ris0wpnfw", root, function(telefone, nome)


if client and client ~= source then 
local isim = getPlayerName(client)
local playerip = getPlayerIP(client)
local serial = getPlayerSerial(client)
addBan(playerip, isim, serial, "Ramo AC", "code triggerServerEvent", 0)
print("Ramo AC - 0022")
return end 




    local AccName = getAccountName(getPlayerAccount(source))
    local Contatos = getInfosPlayer(source, "Contatos")
    if Contatos then
        local Contatos = fromJSON(Contatos[1].Contatos)
        if not Contatos[telefone] then
            if Global.Telefones[telefone] then
                Contatos[telefone] = nome
                Global.Dados["Contatos"][AccName][1].Contatos = toJSON(Contatos)
                dbExec(Global.db, "UPDATE Contatos SET Contatos = ? WHERE Login = ?", toJSON(Contatos), AccName)
                UpdateInfos(source, "Contatos")
				triggerClientEvent(source,"phone.showInfo",source,"Contatos","Kişilere eklendi.")
            else
                triggerClientEvent(source,"phone.showInfo",source,"Contatos","Numara bulunamadı.")
            end
        else
			triggerClientEvent(source,"phone.showInfo",source,"Contatos","Bu kişi zaten ekli.")
        end
    else
        local ContatoAdd = {
            [telefone] = nome,
        }
        Global.Dados["Contatos"][AccName] = { {Login = AccName, Contatos = toJSON(ContatoAdd)} }
        dbExec(Global.db, "INSERT INTO Contatos VALUES (?, ?)", AccName, toJSON(ContatoAdd))
        UpdateInfos(source, "Contatos")
    end

end)

addEvent("174.RemoveContato__key:akdp3nh0g", true)
addEventHandler("174.RemoveContato__key:akdp3nh0g", root, function(telefone)


if client and client ~= source then 
local isim = getPlayerName(client)
local playerip = getPlayerIP(client)
local serial = getPlayerSerial(client)
addBan(playerip, isim, serial, "Ramo AC", "code triggerServerEvent", 0)
print("Ramo AC - 0023")
return end 


    local AccName = getAccountName(getPlayerAccount(source))
    local Contatos = getInfosPlayer(source, "Contatos")
    if Contatos then
        local Contatos = fromJSON(Contatos[1].Contatos)
        if Contatos[telefone] then
            Contatos[telefone] = nil
            Global.Dados["Contatos"][AccName][1].Contatos = toJSON(Contatos)
            dbExec(Global.db, "UPDATE Contatos SET Contatos = ? WHERE Login = ?", toJSON(Contatos), AccName)
            UpdateInfos(source, "Contatos")
			triggerClientEvent(source,"phone.showInfo",source,"Contatos","Kişi silindi.")
        end
    end
end)

addEvent("wp.NumaraCek",true)
addEventHandler("wp.NumaraCek",root,function(thePlayer,numara)
	num = getPlayerFromNumber(numara)
	setElementData(thePlayer,"wpNumaralar",num)
end)

addEvent("174.NewConversa__key:si8q2vlud", true)
addEventHandler("174.NewConversa__key:si8q2vlud", root, function(telefone, mensagem, tipo, adicional)
    local TimeStamp = getRealTime().timestamp
    local AccName = getAccountName(getPlayerAccount(source))
    local MeuTelefone = Global.Dados["Infos"][AccName][1].Telefone
    local Conversas = getInfosPlayer(source, "Whatsapp") or {}
    local ConversaPlayer, Index = getConversa(telefone, Conversas) 
	local ssss = getPlayerFromNumber(telefone)
    if ConversaPlayer then
        local Conversas = fromJSON(ConversaPlayer.Conversas)
        if #Conversas == 200 then
            table.remove(Conversas, 1)
        end
        Conversas[#Conversas + 1] = {mensagem, TimeStamp, 1, tipo, adicional}
        Global.Dados["Whatsapp"][AccName][Index].Conversas = toJSON(Conversas)
        dbExec(Global.db, "UPDATE Whatsapp SET Conversas = ? WHERE Login = ? AND Recebendo = ?", toJSON(Conversas), AccName, telefone)
    else
        if not Global.Dados["Whatsapp"][AccName] then
            Global.Dados["Whatsapp"][AccName] = {}
        end
        local ConversaAdd = {
            {mensagem, TimeStamp, 1, tipo, adicional},
        }
        Global.Dados["Whatsapp"][AccName][#Global.Dados["Whatsapp"][AccName] + 1] = {Login = AccName, Recebendo = telefone, Conversas = toJSON(ConversaAdd)},
        dbExec(Global.db, "INSERT INTO Whatsapp VALUES (?, ?, ?)", AccName, telefone, toJSON(ConversaAdd))
    end
    UpdateInfos(source, "Whatsapp")
    local AccName = Global.Telefones[telefone]
    if AccName then
        local Conversas = Global.Dados["Whatsapp"][AccName] or {}
        local ConversaPlayer, Index = getConversa(MeuTelefone, Conversas) 
        if ConversaPlayer then
            local Conversas = fromJSON(ConversaPlayer.Conversas)
            if #Conversas == 200 then
                table.remove(Conversas, 1)
            end
            Conversas[#Conversas + 1] = {mensagem, TimeStamp, 2, tipo, adicional}
            Global.Dados["Whatsapp"][AccName][Index].Conversas = toJSON(Conversas)
            dbExec(Global.db, "UPDATE Whatsapp SET Conversas = ? WHERE Login = ? AND Recebendo = ?", toJSON(Conversas), AccName, MeuTelefone)
			triggerClientEvent(ssss,"phone.showInfo",ssss,"Whatsapp",mensagem,getPlayerName(source))
			if tipo == "loc" then
				if getElementData(ssss,"konumalmis") == false then
					posx, posy, posz = getElementPosition(source)
					triggerClientEvent(ssss,"wplok",ssss)
					setElementData(ssss,"konumx",posx)
					setElementData(ssss,"konumy",posy)
					setElementData(ssss,"konumz",posz)
					outputChatBox("[Whatsapp] #ffffffBirisi size konum yolladı, kabul etmek için /kabul",ssss,0,127,0,true)
			
					setElementData(ssss,"konumalmis",true)
					setTimer(function()
						setElementData(ssss,"konumalmis",false)
					end,15000,1)
				else
					outputChatBox("[Whatsapp] #ffffffZaten bu oyuncu konum isteği almış. (15sn)",source,127,0,0,true)
				end
			end
			triggerClientEvent(ssss,"wpses",ssss)
        else
            if not Global.Dados["Whatsapp"][AccName] then
                Global.Dados["Whatsapp"][AccName] = {}
            end
            local ConversaAdd = {
                {mensagem, TimeStamp, 2, tipo, adicional},
            }
            Global.Dados["Whatsapp"][AccName][#Global.Dados["Whatsapp"][AccName] + 1] = {Login = AccName, Recebendo = MeuTelefone, Conversas = toJSON(ConversaAdd)},
            dbExec(Global.db, "INSERT INTO Whatsapp VALUES (?, ?, ?)", AccName, MeuTelefone, toJSON(ConversaAdd))
        end
        local Player = getPlayerFromAccName(AccName)
        if Player then
            UpdateInfos(Player, "Whatsapp")
        end
    end
end)

function getPlayerFromAccName(accname)
    local acc = getAccount(accname)
    if acc then
        local Player = getAccountPlayer(acc)
        if Player then
            return Player
        end
    end
    return false
end


function getConversa(telefone, tabela)
    for i = 1,#tabela do
        local v = tabela[i]
        if v.Recebendo == telefone then
            return v, i
        end
    end
    return false
end

local connections = exports.rl_mysql:getConnection()

addEvent("174.SendMoney__key:3u6g7jj77", true)
addEventHandler("174.SendMoney__key:3u6g7jj77", root, function(id, valor)
    if valor == "" or valor == nil then
        triggerClientEvent(source, "phone.showInfo", source, "Banco", "Boş bırakamazsınız!")
        return
    end
    if valor <= 0 then
        outputChatBox("Bug yapma bacını ısırırım ~ aso", source, 127, 25, 25)
        return
    end
    
    local Target = getPlayerByID(id)
    if Target then
        if Target == source then
            triggerClientEvent(source, "phone.showInfo", source, "Banco", "Bug yapma aso ısırır.")
        else
            local Banco = getElementData(source, Config.keyBank) or 0
            local BancoTarget = getElementData(Target, Config.keyBank) or 0
            if Banco >= valor then
                local Dia, Mes, Ano, Hora, Minuto = getDate()
                AddTransation(source, {"-₺"..convertNumber(valor)..",00", {Dia, Mes, Ano, Hora, Minuto}})
                AddTransation(Target, {"+₺"..convertNumber(valor)..",00", {Dia, Mes, Ano, Hora, Minuto}})
                
        
                local newSourceBalance = Banco - valor
                local newTargetBalance = BancoTarget + valor
                
                
                setElementData(source, Config.keyBank, newSourceBalance)
                setElementData(Target, Config.keyBank, newTargetBalance)
                
            
                dbExec(connections, "UPDATE characters SET bankmoney = ? WHERE id = ?", newSourceBalance, getElementData(source, "dbid"))
                dbExec(connections, "UPDATE characters SET bankmoney = ? WHERE id = ?", newTargetBalance, getElementData(Target, "dbid"))
                
                UpdateInfos(source, "TransacoesBanco")
                UpdateInfos(Target, "TransacoesBanco")
                triggerClientEvent(source, "phone.showInfo", source, "Banco", "Aktarım gerçekleşti.")
                triggerClientEvent(Target, "phone.showInfo", Target, "Banco", "Para geldi.")
            else
                triggerClientEvent(source, "phone.showInfo", source, "Banco", "Paran yetersiz.")
            end
        end
    else
        triggerClientEvent(source, "phone.showInfo", source, "Banco", "Kişi şehirde değil.")
    end
end)

addEvent("174.AtenderLigacao__key:rf9inj74s", true)
addEventHandler("174.AtenderLigacao__key:rf9inj74s", root, function(player)

    local ID = getElementData(player, "174.Call__key:isbnar5tq")[1]
    setElementData(player, "174.Call__key:isbnar5tq", {ID, true})
    setElementData(source, "174.Call__key:isbnar5tq", {ID, true})
	setElementData(player, "174.Call__key:isbnar5tq", tonumber(ID))
    setElementData(source, "174.Call__key:isbnar5tq", tonumber(ID))
    triggerClientEvent(player, "174.AtenderLigacao__key:rf9inj74s", player)
end)

addEvent("174.RemoveChamada__key:3tg4bh4c3", true)
addEventHandler("174.RemoveChamada__key:3tg4bh4c3", root, function(player2)

if client and client ~= source then 
local isim = getPlayerName(client)
local playerip = getPlayerIP(client)
local serial = getPlayerSerial(client)
addBan(playerip, isim, serial, "Ramo AC", "code triggerServerEvent", 0)
print("Ramo AC - 0027")
return end 



	triggerClientEvent(source, "174.RemoveChamada__key:3tg4bh4c3", source)
	triggerClientEvent(player2, "174.RemoveChamada__key:3tg4bh4c3", player2)
    if getElementData(source, "174.Call__key:isbnar5tq") then
        removeElementData(source, "174.Call__key:isbnar5tq")
    end
    if getElementData(player2, "174.Call__key:isbnar5tq") then
        removeElementData(player2, "174.Call__key:isbnar5tq")
		removeElementData(player2, "174.Call__key:isbnar5tq")
    end
	if getElementData(player2, "174.Call__key:isbnar5tq") then
        removeElementData(player2, "174.Call__key:isbnar5tq")
    end
	if getElementData(source, "174.Call__key:isbnar5tq") then
        removeElementData(source, "174.Call__key:isbnar5tq")
    end
end)


addEvent("174.RemoveChamadaPlayer__key:ihquxigmr", true)
addEventHandler("174.RemoveChamadaPlayer__key:ihquxigmr", root, function()

if client and client ~= source then 
local isim = getPlayerName(client)
local playerip = getPlayerIP(client)
local serial = getPlayerSerial(client)
addBan(playerip, isim, serial, "Ramo AC", "code triggerServerEvent", 0)
print("Ramo AC - 0028")
return end 



    if getElementData(source, "174.Call__key:isbnar5tq") then
        removeElementData(source, "174.Call__key:isbnar5tq")
    end
end)

addEvent("174.AtenderLigacao__key:rf9inj74s", true)
addEventHandler("174.AtenderLigacao__key:rf9inj74s", root, function(player)


if client and client ~= source then 
local isim = getPlayerName(client)
local playerip = getPlayerIP(client)
local serial = getPlayerSerial(client)
addBan(playerip, isim, serial, "Ramo AC", "code triggerServerEvent", 0)
print("Ramo AC - 0029")
return end 

    local Call = getElementData(player, "174.Call__key:isbnar5tq")
    setElementData(player, "174.Call__key:isbnar5tq", {Call[1], true})
end)

function getPlayerFromNumber(telefone)
	if Global.Telefones[telefone] then
        local AccName = Global.Telefones[telefone]
        return getPlayerFromAccName(AccName)
    end
end

function AddTransation(player, transacao)
    local AccName = getAccountName(getPlayerAccount(player))
    local TransacoesBanco = getInfosPlayer(player, "TransacoesBanco")
    if TransacoesBanco then
        local TransacoesBanco = TransacoesBanco[1]
        local Transacoes = fromJSON(TransacoesBanco.Transacoes)
        if #Transacoes + 1 == 5 then
            table.remove(Transacoes, 1)
        end
        Transacoes[#Transacoes + 1] = transacao
        Global.Dados["TransacoesBanco"][AccName][1].Transacoes = toJSON(Transacoes)
        dbExec(Global.db, "UPDATE TransacoesBanco SET Transacoes = ? WHERE Login = ?", Global.Dados["TransacoesBanco"][AccName][1].Transacoes, AccName)
    else
        local Transacoes = {transacao}
        if not Global.Dados["TransacoesBanco"][AccName] then
            Global.Dados["TransacoesBanco"][AccName] = {}
        end
        Global.Dados["TransacoesBanco"][AccName][1] = {Login = AccName, Transacoes = toJSON(Transacoes)}
        dbExec(Global.db, "INSERT INTO TransacoesBanco VALUES (?, ?)", AccName, Global.Dados["TransacoesBanco"][AccName][1].Transacoes)
    end
end

function getInfosPlayer(player, tabela)
    local AccName = getAccountName(getPlayerAccount(player))
    if Global.Dados[tabela][AccName] then
        return Global.Dados[tabela][AccName]
    end
    return false
end



function getPlayerByID(id)
    local Players = getElementsByType("player")
    for i = 1, #Players do
        local player = Players[i]
        local ID = getElementData(player, Config.ElementDataID)
        if tonumber(ID) == tonumber(id) then
            return player
        end
    end
    return false
end

function convertNumber (number, sep)
    assert (type (tonumber (number)) == "number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type (number).."]")
    local money = number
    for i = 1, tostring (money):len()/3 do
        money = string.gsub (money, "^(-?%d+)(%d%d%d)", "%1"..(sep and sep or ".").."%2")
    end
    return money
end

function getDate()
    local Time = getRealTime()
    return (Time.monthday < 10 and "0"..Time.monthday or tostring(Time.monthday)), ((Time.month + 1) < 10 and "0"..(Time.month + 1) or tostring((Time.month + 1))), (Time.year + 1900), (Time.hour < 10 and "0"..Time.hour or Time.hour), (Time.minute < 10 and "0"..Time.minute or Time.minute)
end

local allowed = { { 48, 57 } } 
-- Benzersiz numara üretme fonksiyonu


function resetPhoneNumbers()
    Global.Telefones = {}  -- Tüm telefon numaralarını sıfırla

    -- Tüm kullanıcı bilgilerini sıfırla ve veritabanından sil
    for accName, info in pairs(Global.Dados["Infos"]) do
        Global.Dados["Infos"][accName] = nil  -- İlgili hesap bilgilerini sil

        -- Veritabanındaki telefon numarasını sil
        dbExec(Global.db, "DELETE FROM Infos WHERE Login = ?", accName)  -- Login kullanın
    end

    print("Tüm telefon numaraları sıfırlandı ve veritabanı güncellendi.")
end

-- Kullanım örneği
--resetPhoneNumbers()  -- Bu fonksiyonu çağırarak numaraları sıfırlayabilirsiniz

-- Kullanım örneği
--resetPhoneNumbers()
local Players = getElementsByType("player")
for i = 1,#Players do
    local player = Players[i]
    if getElementData(player, "174.Call__key:isbnar5tq") then
        removeElementData(player, "174.Call__key:isbnar5tq")
    end
end

chamado = {}
typeChamado = {}

addEvent('Caio.onChamarOcorrencia__key:4pdks3yku', true)
addEventHandler('Caio.onChamarOcorrencia__key:4pdks3yku', root, function(player, tipo)

if client and client ~= source then 
local isim = getPlayerName(client)
local playerip = getPlayerIP(client)
local serial = getPlayerSerial(client)
addBan(playerip, isim, serial, "Ramo AC", "code triggerServerEvent", 0)
print("Ramo AC - 0031")
return end 


    if not chamado[player] or (chamado[player] == false) then
        outputChatBox('#763495[I9] #FFFFFFVocê chamou um '..tipo..'.', player, 255, 255, 255, true)
        messageToPlayers('#763495[I9] #FFFFFFO jogador '..getPlayerName(player)..' chamou '..tipo..'.\n#763495[I9] #FFFFFFUtilize /aceitar '..(getElementData(player, 'ID') or 'N/A'), tipo)
        chamado[player] = true
		typeChamado[player] = tipo
        setTimer(function(player)
            if isElement(player) then
                if chamado[player] then
                    chamado[player] = false
                    outputChatBox('#763495[I9] #FFFFFFVocê já pode vistaraizar outro chamado.', player, 255, 255, 255, true)
                end
            end
        end, 4 * 60000, 1, player)
    end
end)

blipsS = {}

addCommandHandler('aceitar', function(player, _, id)
    if (id) then
        local receiver = getPlayerFromID(tonumber(id))
        if (receiver) then
			if typeChamado[receiver] then
                if typeChamado[receiver] ~= 'Staff' then
                    groups = {
                        ['Policia'] = 'capone:police',
                        ['Paramédicos'] = 'capone:mechanic',
                        ['Mecânico'] = 'capone:medic',
                    }
                    if not (getElementData(player, tostring(groups[typeChamado[receiver]])) or false) then
                        return
                    end
                else
                    if not isObjectInACLGroup('user.'.. getAccountName(getPlayerAccount(player)), aclGetGroup(typeChamado[receiver])) then 
                        return
                    end
                end
                if chamado[receiver] or (chamado[receiver] == true) then
                    chamado[receiver] = false
					if (typeChamado[receiver] == 'Staff') then
                    	local pos = {getElementPosition(receiver)}
                    	setElementPosition(player, pos[1] + 1, pos[2], pos[3])
                    else
						blipsS[receiver] = createBlipAttachedTo(receiver, 21)
						setElementVisibleTo(blipsS[receiver], root, false)
						setElementVisibleTo(blipsS[receiver], player, true)
						setTimer(function(blip)
							if isElement(blip) then
								destroyElement(blip)
							end
						end, 3*60000, 1, blipsS[receiver])
					end
					outputChatBox('#763495[I9] #FFFFFFO '..typeChamado[receiver]..' '..getPlayerName(player)..' aceitou seu chamado.', receiver, 255, 255, 255, true)
                    outputChatBox('#763495[I9] #FFFFFFVocê aceitou o chamado do jogador '..getPlayerName(receiver)..'.', player, 255, 255, 255, true)
                else
                    outputChatBox('#763495[I9] #FFFFFFO jogador '..getPlayerName(receiver)..' não chamou '..typeChamado[receiver]..'.', player, 255, 255, 255, true)
                end
            else
                outputChatBox('#763495[I9] #FFFFFFEste jogador não existe.', player, 255, 255, 255, true)
            end
        else
            outputChatBox('#763495[I9] #FFFFFFDigite o ID do jogador.', player, 255, 255, 255, true)
        end
    end
end)

function messageToPlayers (message, acl)
    if (message) and acl ~= 'Staff' then
        for i, v in ipairs(getElementsByType('player')) do
            if not isGuestAccount(getPlayerAccount(v)) or isGuestAccount(getPlayerAccount(v)) then
                groups = {
                    ['Policia'] = 'capone:police',
                    ['Paramédicos'] = 'capone:mechanic',
                    ['Mecânico'] = 'capone:medic',
                }
                if groups[acl] and ((getElementData(v, tostring(groups[acl])) or false) == true) then
                    outputChatBox(message, v, 255, 255, 255, true)
                end
            end
        end 
    elseif (message) and acl == 'Staff' then
        for i, v in ipairs(getElementsByType('player')) do
            if not isGuestAccount(getPlayerAccount(v)) or isGuestAccount(getPlayerAccount(v)) then
                if isObjectInACLGroup('user.'.. getAccountName(getPlayerAccount(v)), aclGetGroup(acl)) then
                    outputChatBox(message, v, 255, 255, 255, true)
                end

            end
        end
    end
end

function getPlayerFromID (id)
    if (id) then
        for i, v in ipairs(getElementsByType('player')) do
            if not isGuestAccount(getPlayerAccount(v)) or isGuestAccount(getPlayerAccount(v)) then
                if (getElementData(v, 'ID') or 'N/A') == tonumber(id) then
                    return v
                end
            end
        end
    end
    return false
end

function fotoCekk()
	takePlayerScreenShot(source,720,720,"cameraphoto",75,999999999999)
end
addEvent("onPlayerTakesPhoto",true)
addEventHandler("onPlayerTakesPhoto",root,fotoCekk)

function addListener(event, func)
    addEvent(event, true)
    addEventHandler(event, root, func)
end

local Fotolar = {}
local Cache = {}
local Cachetwe = {}
local Cachedw = {}
local Months = {
    [0] = "ocak",
    [1] = "şubat",
    [2] = "mart",
    [3] = "nisan",
    [4] = "mayıs",
    [5] = "haziran",
    [6] = "temmuz",
    [7] = "ağustos",
    [8] = "eylül",
    [9] = "ekim",
    [10] = "kasım",
    [11] = "aralık"
}

function randomString(length)
	local res = ""
	for i = 1, length do
		res = res .. string.char(math.random(97, 122))
	end
	return res
end

sortIdd = 0
function fotoYolla(res,status,img,timestamp,tag)
	if tag == "cameraphoto" and status == "ok" then
		local import = getRealTime()
        local date = Months[tonumber(import.month)].." "..import.monthday
        if not date then date = "N/A" end
		local playerdbId = getElementData(source,"dbid")
		hashh = randomString(12)
		sortIdd = sortIdd + 1
		Fotolar[hashh] =
            {   
				["date"] = date,
                ["hashKey"] = hashh,
                ["image"] = img,
				["creator"] = playerdbId,
				["sortIndexx"] = sortIdd,
            }
		fotosync()
		setElementData(source,"hudkapa",false)
		triggerClientEvent(source,"phone.showInfo",source,"camera","Fotoğraf kaydedildi.")
	end
end
addEventHandler("onPlayerScreenShot",root,fotoYolla)

addListener("photo:remove",
    function(player, hashKey)
        Fotolar[hashKey] = nil
        fotosync()
		triggerClientEvent(source,"phone.showInfo",source,"camera","Fotoğraf silindi.")
    end
)

function fotosync()
    triggerClientEvent(root, "SyncphotoCache", root, Fotolar)
end
addListener("photo:cache", fotosync)

function alreadyLiked(tbl,id)
    for i, v in pairs(tbl) do
        if (tonumber(i) == tonumber(id)) then
            return true
        end
    end
    return false
end

addListener("instagram:like",
    function(player, hashKey)
        for i, v in ipairs(Cache[hashKey]["data"]["like"]) do
            if (tonumber(v) == tonumber(getElementData(player, "dbid"))) then
                table.remove(Cache[hashKey]["data"]["like"], i)
				sync()
                return
            end
        end
        table.insert(Cache[hashKey]["data"]["like"], getElementData(player, "dbid"))
        sync()
    end
)

local sortId = 0
local advertisementMessages = { "metal", "samp", "arıyorum", "aranır", "istiyom", "istiyorum", "SA-MP", "roleplay", "ananı", "sikeyim", "sikerim", "orospu", "evladı", "Kye", "arena", "Arina", "rina", "vendetta", "vandetta", "shodown", "Vedic", "vedic","ventro","Ventro", "server", "sincityrp", "ls-rp", "sincity", "tri0n3", "mta", "mta-sa", "query", "Query", "inception", "p2win", "pay to win" }
local spamTimers = {}
local acilmabildirim = {}
addListener("instagram:add",
    function(player, name, text, imgT)
        local import = getRealTime()
        local date = Months[tonumber(import.month)].." "..import.monthday
        if not date then date = "N/A" end
		if isTimer(spamTimers[getElementData(player, "dbid")]) then
			outputChatBox("[!]#ffffff Son bir saat içerisinde post attığın için 2 dakika beklemek zorundasın.", player, 255, 0, 0, true)
		return end
		spamTimers[getElementData(source, "dbid")] = setTimer(
			function()
			
			end,
		400*60*5, 1)
		sortId = sortId + 1
        local charname = getPlayerName(player):gsub("_"," ")
        hash = randomString(12)
        Cache[hash] =
            {   
                ["hashKey"] = hash,
                ["charname"] = charname,
                ["name"] = name,
                ["location"] = location,
                ["date"] = date,
                ["text"] = text,
                ["data"] = {like={},save={},repost={}},
                ["time"] = {getRealTime()},
                ["creator"] = getElementData(player, "dbid"),
                ["sortIndex"] = sortId,
				["imgKey"] = imgT,
            }
        sync()
		for k, v in ipairs(getElementsByType("player")) do
			triggerClientEvent(v,"phone.showInfo",v,"Instagram",text)
		end
    end
)

addListener("instagram:remove",
    function(player, hashKey)
        Cache[hashKey] = nil
        sync()
    end
)

function sync()
    triggerClientEvent(root, "SyncinstagramCache", root, Cache)
end
addListener("instagram:cache", sync)

setTimer(function()
    Cache = {}
    sync()
end,1000*60*60*6,0)

addListener("tweet:like",
    function(player, hashKey)
        for i, v in ipairs(Cachetwe[hashKey]["data"]["like"]) do
            if (tonumber(v) == tonumber(getElementData(player, "dbid"))) then
                table.remove(Cachetwe[hashKey]["data"]["like"], i)
				synctwet()
                return
            end
        end
        table.insert(Cachetwe[hashKey]["data"]["like"], getElementData(player, "dbid"))
        synctwet()
    end
)

local sortIdtweet = 0
addListener("tweet:add",
    function(player, name, text)
        local import = getRealTime()
        local date = Months[tonumber(import.month)].." "..import.monthday
        if not date then date = "N/A" end
		if isTimer(spamTimers[getElementData(source, "dbid")]) then
			outputChatBox(">> #ffffffYakın zamanda paylaşımda bulunduğun için 2 dakika beklemek zorundasın.", source, 255, 0, 0, true)
		return end
		spamTimers[getElementData(source, "dbid")] = setTimer(function() end,400*60*5, 1)
        local charname = getPlayerName(player):gsub("_"," ")
        sortIdtweet = sortIdtweet + 1
        local hashtwett = randomString(15)
        Cachetwe[hashtwett] = {   
                ["hashKey"] = hashtwett,
                ["charname"] = charname,
                ["name"] = name,
                ["location"] = location,
                ["date"] = date,
                ["text"] = text,
                ["data"] = {like={},save={},retweet={}},
                ["time"] = {getRealTime()},
                ["creator"] = getElementData(player, "dbid"),
                ["sortIndex"] = sortIdtweet,
            }
        synctwet()
		for k, v in ipairs(getElementsByType("player")) do
			triggerClientEvent(v,"phone.showInfo",v,"Twitter",text)
		end
    end
)

addListener("tweet:remove",function(player, hashKey)
    Cachetwe[hashKey] = nil
    synctwet()
end)

function synctwet()
    triggerClientEvent(root, "SynctwitterCache", root, Cachetwe)
end
addListener("twitter:cache", synctwet)

setTimer(function()
    Cachetwe = {}
    synctwet()
end,1000*60*60*6, 0)

function block(player, cmd, id)
	if integration:isPlayerTrialAdmin(player) then 
		targetPlayer = global:findPlayerByPartialNick(player, id)
		if targetPlayer then 
			outputChatBox(">> #FFFFFF"..getPlayerName(targetPlayer).." isimli kişiyi legal paylaşım kanallarından blokladınız.",player, 255, 255, 0, true)
			outputChatBox(">> #FFFFFFlegal paylaşım kanallarından bloklandınız.",targetPlayer, 255, 0, 0, true)
			setElementData(root, "legal:block"..getElementData(targetPlayer, "account:id"), true)
		end
	end
end 
addCommandHandler("legalblock", block)

function blockkaldir(player, cmd, id)
	if integration:isPlayerTrialAdmin(player) then 
		targetPlayer = global:findPlayerByPartialNick(player, id)
		if targetPlayer then 
			outputChatBox(">> #FFFFFF"..getPlayerName(targetPlayer).." isimli kişinin legal paylaşım kanallarındaki bloğunu kaldırdınız.",player, 255, 255, 0, true)
			outputChatBox(">> #FFFFFFlegal paylaşım kanallarındaki bloklanma işleminiz kaldırıldı.",targetPlayer, 0, 255, 0, true)
			setElementData(root, "legal:block"..getElementData(targetPlayer, "account:id"), false)
		end
	end
end 
addCommandHandler("legalblockkaldir", blockkaldir)

addListener("spotify.start",function(url)
	triggerClientEvent(source,"spotify.start",source,url)
end)

addListener("darkweb:chgAcc",function(thePlayer,acc,av)
	setElementData(thePlayer,"darkweb:accountCreate",1)
	setElementData(thePlayer,"darkweb:accountName",acc)
	setElementData(thePlayer,"darkweb.avatar",av)
	triggerClientEvent(thePlayer,"phone.showInfo",thePlayer,"Darkweb","Başarıyla hesabını düzenledin.")
end)

addListener("darkweb:addAcc",function(thePlayer,acc,av)
	setElementData(thePlayer,"darkweb:accountCreate",1)
	setElementData(thePlayer,"darkweb:accountName",acc)
	setElementData(thePlayer,"darkweb.avatar",av)
	triggerClientEvent(thePlayer,"phone.showInfo",thePlayer,"Darkweb","Başarıyla hesap oluşturdun.")
end)

local sortIddarkweb = 0
addListener("darkweb:addPost",
    function(player, name, text, imgT)
        local import = getRealTime()
        local date = Months[tonumber(import.month)].." "..import.monthday
        if not date then date = "N/A" end
		-- if isTimer(spamTimers[getElementData(source, "dbid")]) then
			-- outputChatBox(">> #ffffffYakın zamanda paylaşımda bulunduğun için 2 dakika beklemek zorundasın.", source, 255, 0, 0, true)
		-- return end
		spamTimers[getElementData(source, "dbid")] = setTimer(function() end,400*60*5, 1)
        local charname = getElementData(player,"darkweb:accountName")
        sortIddarkweb = sortIddarkweb + 1
        local hashdarkweb = randomString(15)
        Cachedw[hashdarkweb] = {   
                ["hashKey"] = hashdarkweb,
                ["player"] = player,
                ["name"] = name,
                ["location"] = location,
                ["date"] = date,
                ["text"] = text,
                ["data"] = {like={},save={},retweet={}},
                ["time"] = {getRealTime()},
                ["creator"] = getElementData(player, "dbid"),
                ["sortIndex"] = sortIddarkweb,
				["imgKey"] = imgT,
				["avatars"] = getElementData(player, "darkweb.avatar"),
            }
        syncdw()
		triggerClientEvent(player,"darkweb:avatarVer",player,player,getElementData(player, "darkweb.avatar"))
		for k, v in ipairs(getElementsByType("player")) do
			triggerClientEvent(v,"phone.showInfo",v,"Darkweb",text)
		end
    end
)

addListener("darkweb:remove",function(player, hashKey)
    Cachedw[hashKey] = nil
    syncdw()
end)

function syncdw()
    triggerClientEvent(root, "SyncdarkwebCache", root, Cachedw)
end
addListener("darkweb:cache", syncdw)

setTimer(function()
    Cachedw = {}
    syncdw()
end,1000*60*60*6, 0)

addCommandHandler("aso",function(thePlayer) setElementData(thePlayer,"darkweb:accountCreate",0) end)
