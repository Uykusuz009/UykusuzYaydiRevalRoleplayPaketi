function addListener(event, func)
    addEvent(event, true)
    addEventHandler(event, root, func)
end

addEventHandler( "onClientResourceStart", getRootElement( ),
    function ( startedRes )
		for k,v in ipairs(getElementsByType("player")) do
			setElementData(v,"telefonacik",false)
		end
    end
);

Global = {
    Screen = {guiGetScreenSize()},
    Fonts = {
        ["PoppinsRegular"] = {
            [13] = dxCreateFont("assets/font/PoppinsRegular.ttf", 14),
            [12] = dxCreateFont("assets/font/PoppinsRegular.ttf", 13),
            [11] = dxCreateFont("assets/font/PoppinsRegular.ttf", 13),
            [17] = dxCreateFont("assets/font/PoppinsRegular.ttf", 18),
            [18] = dxCreateFont("assets/font/PoppinsRegular.ttf", 35),
            [15] = dxCreateFont("assets/font/PoppinsRegular.ttf", 16),
            ["11"] = _dxCreateFont("assets/font/PoppinsRegular.ttf", 13),
        },
        ["PoppinsMedium"] = {
            [10] = dxCreateFont("assets/font/PoppinsMedium.ttf", 13),
            [11] = dxCreateFont("assets/font/PoppinsMedium.ttf", 13),
            [13] = dxCreateFont("assets/font/PoppinsMedium.ttf", 15),
            [12] = dxCreateFont("assets/font/PoppinsMedium.ttf", 15),
            [15] = dxCreateFont("assets/font/PoppinsMedium.ttf", 16),
            [18] = dxCreateFont("assets/font/PoppinsMedium.ttf", 35),
            [17] = dxCreateFont("assets/font/PoppinsMedium.ttf", 18),
            [14] = dxCreateFont("assets/font/PoppinsMedium.ttf", 15),
            [31] = dxCreateFont("assets/font/PoppinsMedium.ttf", 14),
            [32] = dxCreateFont("assets/font/PoppinsMedium.ttf", 12),
            ["10"] = _dxCreateFont("assets/font/PoppinsMedium.ttf", 13),
            ["11"] = _dxCreateFont("assets/font/PoppinsMedium.ttf", 13),
            ["15"] = _dxCreateFont("assets/font/PoppinsMedium.ttf", 16),
        },
        ["PoppinsSemiBold"] = {
            [10] = dxCreateFont("assets/font/PoppinsSemiBold.ttf", 13),
            [12] = dxCreateFont("assets/font/PoppinsSemiBold.ttf", 15),
            [13] = dxCreateFont("assets/font/PoppinsSemiBold.ttf", 17),
            [17] = dxCreateFont("assets/font/PoppinsSemiBold.ttf", 18),
            [25] = dxCreateFont("assets/font/PoppinsSemiBold.ttf", 26),
            [26] = dxCreateFont("assets/font/PoppinsSemiBold.ttf", 70),
            ["13"] = _dxCreateFont("assets/font/PoppinsSemiBold.ttf", 17),

        },
        ["PoppinsBold"] = {
            [17] = dxCreateFont("assets/font/PoppinsBold.ttf", 18),
            [16] = dxCreateFont("assets/font/PoppinsBold.ttf", 17),
            [12] = dxCreateFont("assets/font/PoppinsBold.ttf", 14),
            [14] = dxCreateFont("assets/font/PoppinsBold.ttf", 13),
            ["16"] = _dxCreateFont("assets/font/PoppinsBold.ttf", 17),
        },
        ["inUIDisplayRegular"] = {
            [40] = dxCreateFont("assets/font/PoppinsMedium.ttf", 23),
        },
		["awesome"] = {
            [1] = dxCreateFont(":resources/font/FontAwesome.ttf", 14),
            [2] = dxCreateFont(":resources/font/FontAwesome.ttf", 23),
            [3] = dxCreateFont(":resources/font/FontAwesome.ttf", 23),
            [4] = dxCreateFont(":resources/font/FontAwesome.ttf", 10),
            [5] = dxCreateFont("assets/font/PoppinsMedium.ttf", 30),
        },
    },
    Files = {},
    Svgs = {},
    Componentes = {
        PosicoesRender = {}
    },
}

images = {}
addListener("SyncphotoCache",
	function(dat)
		Fotolar = dat
		fotoFlow = Fotolar or {}
		flowCountFoto = count(fotoFlow) or 0
		local getFlow = (fotoFlow)
		local flowTable = {}
		for i, v in pairs(getFlow) do
			flowTable[#flowTable + 1] = v
		end
		table.sort(flowTable,
			function(a, b)
				local indexOne = tonumber(a.sortIndexx)
				local indexTwo = tonumber(b.sortIndexx)
			return indexOne > indexTwo
		end
		)
		for i, v in pairs(flowTable) do
			images[v.sortIndexx] = dxCreateTexture(v.image)
			local pixelsss = dxGetTexturePixels(myScreenSource)
			local png = dxConvertPixels(pixelsss, "png")
			local pngFile = fileCreate("realphoto"..(v.creator)..""..(v.sortIndexx)..".png")
			fileWrite(pngFile, png)
			fileClose(pngFile)
		end
	end
)
addEventHandler("onClientResourceStart", resourceRoot, function()
    local txd = engineLoadTXD("model/phone.txd")
    engineImportTXD(txd, 330)
    local dff = engineLoadDFF("model/phone.dff")
    engineReplaceModel(dff, 330)
end)
local asoawesome = assets:getFont("AwesomeFont",15)
local asoawesome2 = assets:getFont("AwesomeFont",8)
local screenSizeX,screenSizeY = guiGetScreenSize()
local imgtexture
local takenBy

function fotoCek()
	setTimer(function()
	triggerServerEvent("onPlayerTakesPhoto",localPlayer)
	end,0,1)
end
addEvent("foto.cek",true)
addEventHandler("foto.cek",root,fotoCek)

goruntulu = {}
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        myScreenSource = dxCreateScreenSource ( 1024, 1080 )
    end
)

screenCam2 = {guiGetScreenSize()}
screenCam = dxCreateScreenSource(screenCam2[1], screenCam2[2])

if not fileExists("assets/json/apps.json") then
    Global.Files.Apps = fileCreate("assets/json/apps.json")
else
    Global.Files.Apps = fileOpen("assets/json/apps.json")
end

local Size = fileGetSize(Global.Files.Apps)
local Read = fileRead(Global.Files.Apps, Size)
if Read == "" then
    local Json = toJSON(Config.PosAppsPadrao)
    fileWrite(Global.Files.Apps, Json)
    Global.PosApps = Config.PosAppsPadrao
else
    Global.PosApps = fromJSON(Read)
end

fileClose(Global.Files.Apps)

addListener("SyncinstagramCache",
	function(dat)
		Cache = dat
	end
)

addListener("SyncdarkwebCache",
	function(dat)
		Cachedw = dat
	end
)

addListener("SynctwitterCache",
	function(dat)
		Cachetwe = dat
	end
)
caiosvg = {
    ['bar'] = svgCreate(246, 60,
        [[
            <svg width="246" height="60" viewBox="0 0 246 60" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect width="246" height="60" rx="8" fill="#181818"/>
            </svg>
        ]]
    ),
    ['tel'] = svgCreate(132, 132,
        [[
            <svg width="33" height="33" viewBox="0 0 33 33" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M7.5 8.10833C7.5 7.79167 7.6 7.52778 7.8 7.31667C8 7.10556 8.25 7 8.55 7H12.6C12.8333 7 13.0377 7.07917 13.213 7.2375C13.3883 7.39583 13.5007 7.59815 13.55 7.84444L14.25 11.4861C14.2833 11.7324 14.2623 11.9833 14.187 12.2387C14.1117 12.4942 13.9993 12.7007 13.85 12.8583L11.5 15.3389C12.2667 16.6759 13.175 17.8986 14.225 19.0069C15.275 20.1153 16.4 21.0389 17.6 21.7778L20.05 19.2444C20.2 19.0861 20.371 18.9848 20.563 18.9404C20.755 18.8961 20.9673 18.8919 21.2 18.9278L24.7 19.6139C24.9333 19.6491 25.125 19.7634 25.275 19.9569C25.425 20.1505 25.5 20.3704 25.5 20.6167V24.8917C25.5 25.2083 25.4 25.4722 25.2 25.6833C25 25.8944 24.75 26 24.45 26C22.3 26 20.204 25.494 18.162 24.4821C16.12 23.4702 14.3117 22.1331 12.737 20.471C11.1623 18.8089 9.89567 16.9001 8.937 14.7446C7.97833 12.5892 7.49933 10.3771 7.5 8.10833Z" fill="white"/>
            </svg>            
        ]]
    ),
    ['bank'] = svgCreate(132, 132,
        [[
            <svg width="33" height="33" viewBox="0 0 33 33" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M16.5 10.3125C16.9102 10.3125 17.3037 10.1495 17.5938 9.85945C17.8839 9.56936 18.0469 9.1759 18.0469 8.76565C18.0469 8.35539 17.8839 7.96194 17.5938 7.67184C17.3037 7.38174 16.9102 7.21877 16.5 7.21877C16.0897 7.21877 15.6963 7.38174 15.4062 7.67184C15.1161 7.96194 14.9531 8.35539 14.9531 8.76565C14.9531 9.1759 15.1161 9.56936 15.4062 9.85945C15.6963 10.1495 16.0897 10.3125 16.5 10.3125ZM18.018 3.00096C17.5889 2.65226 17.0529 2.46191 16.5 2.46191C15.9471 2.46191 15.411 2.65226 14.982 3.00096L4.66535 11.385C3.41135 12.408 4.13323 14.4375 5.75023 14.4375H6.18748V23.1C4.96235 23.725 4.12498 24.9975 4.12498 26.4681V27.8438C4.12498 28.1173 4.23362 28.3796 4.42702 28.573C4.62042 28.7664 4.88272 28.875 5.15623 28.875H27.8437C28.1172 28.875 28.3795 28.7664 28.5729 28.573C28.7663 28.3796 28.875 28.1173 28.875 27.8438V26.4681C28.875 24.9996 28.0376 23.725 26.8125 23.1V14.4375H27.2497C28.8667 14.4375 29.5886 12.406 28.3325 11.385L18.02 2.9989L18.018 3.00096ZM16.2855 4.60146C16.3468 4.5519 16.4232 4.52486 16.502 4.52486C16.5809 4.52486 16.6573 4.5519 16.7186 4.60146L26.2783 12.375H6.7196L16.2855 4.60146ZM24.75 22.6875H22.6875V14.4375H24.75V22.6875ZM20.625 22.6875H17.5312V14.4375H20.625V22.6875ZM15.4687 22.6875H12.375V14.4375H15.4687V22.6875ZM25.0944 24.75C26.0432 24.75 26.8125 25.5193 26.8125 26.4681V26.8125H6.18748V26.4681C6.18748 25.5193 6.95679 24.75 7.90554 24.75H25.0944ZM10.3125 22.6875H8.24998V14.4375H10.3125V22.6875Z" fill="white"/>
            </svg>        
        ]]
    ),
    ['pass'] = svgCreate(132, 132,
        [[
            <svg width="33" height="33" viewBox="0 0 33 33" fill="none" xmlns="http://www.w3.org/2000/svg">
            <g clip-path="url(#clip0_5116_596)">
            <path d="M14.85 10.725V3.29999H9.07498C8.41856 3.29999 7.78904 3.56075 7.32489 4.0249C6.86073 4.48905 6.59998 5.11858 6.59998 5.77499V23.925C6.59998 24.5814 6.86073 25.2109 7.32489 25.6751C7.78904 26.1392 8.41856 26.4 9.07498 26.4H21.45C22.3252 26.4 23.1646 26.0523 23.7834 25.4334C24.4023 24.8146 24.75 23.9752 24.75 23.1V13.2H17.325C16.6686 13.2 16.039 12.9392 15.5749 12.4751C15.1107 12.0109 14.85 11.3814 14.85 10.725ZM9.89998 17.325C9.89998 17.1062 9.9869 16.8963 10.1416 16.7416C10.2963 16.5869 10.5062 16.5 10.725 16.5C10.9438 16.5 11.1536 16.5869 11.3083 16.7416C11.4631 16.8963 11.55 17.1062 11.55 17.325C11.55 17.5438 11.4631 17.7536 11.3083 17.9084C11.1536 18.0631 10.9438 18.15 10.725 18.15C10.5062 18.15 10.2963 18.0631 10.1416 17.9084C9.9869 17.7536 9.89998 17.5438 9.89998 17.325ZM10.725 21.45C10.5062 21.45 10.2963 21.3631 10.1416 21.2084C9.9869 21.0536 9.89998 20.8438 9.89998 20.625C9.89998 20.4062 9.9869 20.1963 10.1416 20.0416C10.2963 19.8869 10.5062 19.8 10.725 19.8C10.9438 19.8 11.1536 19.8869 11.3083 20.0416C11.4631 20.1963 11.55 20.4062 11.55 20.625C11.55 20.8438 11.4631 21.0536 11.3083 21.2084C11.1536 21.3631 10.9438 21.45 10.725 21.45ZM14.025 18.15C13.8062 18.15 13.5963 18.0631 13.4416 17.9084C13.2869 17.7536 13.2 17.5438 13.2 17.325C13.2 17.1062 13.2869 16.8963 13.4416 16.7416C13.5963 16.5869 13.8062 16.5 14.025 16.5H20.625C20.8438 16.5 21.0536 16.5869 21.2083 16.7416C21.3631 16.8963 21.45 17.1062 21.45 17.325C21.45 17.5438 21.3631 17.7536 21.2083 17.9084C21.0536 18.0631 20.8438 18.15 20.625 18.15H14.025ZM13.2 20.625C13.2 20.4062 13.2869 20.1963 13.4416 20.0416C13.5963 19.8869 13.8062 19.8 14.025 19.8H20.625C20.8438 19.8 21.0536 19.8869 21.2083 20.0416C21.3631 20.1963 21.45 20.4062 21.45 20.625C21.45 20.8438 21.3631 21.0536 21.2083 21.2084C21.0536 21.3631 20.8438 21.45 20.625 21.45H14.025C13.8062 21.45 13.5963 21.3631 13.4416 21.2084C13.2869 21.0536 13.2 20.8438 13.2 20.625ZM16.5 10.725V3.71249L24.3375 11.55H17.325C17.1062 11.55 16.8963 11.4631 16.7416 11.3084C16.5869 11.1536 16.5 10.9438 16.5 10.725ZM28.05 14.85C28.05 14.4124 27.8761 13.9927 27.5667 13.6833C27.2573 13.3738 26.8376 13.2 26.4 13.2V23.1C26.4 24.4128 25.8785 25.6719 24.9502 26.6002C24.0219 27.5285 22.7628 28.05 21.45 28.05H9.89998C9.89998 28.4876 10.0738 28.9073 10.3832 29.2167C10.6927 29.5262 11.1124 29.7 11.55 29.7H21.549C22.4027 29.7 23.2481 29.5318 24.0368 29.2051C24.8255 28.8784 25.5422 28.3996 26.1459 27.7959C26.7496 27.1922 27.2284 26.4756 27.5551 25.6868C27.8818 24.8981 28.05 24.0527 28.05 23.199V14.85Z" fill="white"/>
            </g>
            <defs>
            <clipPath id="clip0_5116_596">
            <rect width="33" height="33" fill="white"/>
            </clipPath>
            </defs>
            </svg>            
        ]]
    )
}

if not fileExists("assets/json/notify.json") then
    Global.Files.Notify = fileCreate("assets/json/notify.json")
else
    Global.Files.Notify = fileOpen("assets/json/notify.json")
end
local Size = fileGetSize(Global.Files.Notify)
local Read = fileRead(Global.Files.Notify, Size)
if Read == "" then
    local Json = toJSON(Config.TabelaNotify)
    fileWrite(Global.Files.Notify, Json)
    Global.Notify = Config.TabelaNotify
else
    Global.Notify = fromJSON(Read)
end
fileClose(Global.Files.Notify)

lastBind = 0
function telac()
		if not getElementData(localPlayer,logData) == 1 then return end
		if lastBind + 800 <= getTickCount() then
			lastBind = getTickCount()
			if Global.Celular and Global.PosX == Global.Celular[3] then
				Global.Celular = {getTickCount(), 1920, 1920 + 700}
				setTimer(function()
					closeCell()
					showCursor(false)
					Global.Componentes.createPost = nil
				end, 800, 1)
			else
				setTimer(function()
				triggerServerEvent("174.OpenCell__key:b0ci9jfxe", localPlayer)
				end,0,1)
			end
		end
end
bindKey(Config.Bind, "down", telac)	
addEvent("phone.open",true)
addEventHandler("phone.open",root,telac)

addEvent("174.OpenCell__key:b0ci9jfxe", true)
addEventHandler("174.OpenCell__key:b0ci9jfxe", root, function(infos)
	setElementData(localPlayer,"telefonacik",true)
    if not Global.Celular then
		Global.Celular = {getTickCount(), 1920 + 500, 1920}
        Global.Componentes = {
            PosicoesRender = {}
        }
        Global.Componentes.Infos = infos
        Global.Componentes.Mensageinormat = FormatarMensagens()
		Global.Componentes.Aba = "kilitEkran"
		yy = 0
		possYY = false
		telefonacildi = false
		if getElementData(localPlayer,"phone.avatar") and not Global.Avatar then
			local Link = getElementData(localPlayer,"phone.avatar")
            requestBrowserDomains({Link}, true, function(wasAccepted)
				if wasAccepted then
					fetchRemote(Link, function(data, error)
						if error == 0 and type(data) == "string" then
							SetAvatar(data,0)
						end
					end)
				end
            end)
		end
		telefonTimer = setTimer(drawCelular,3,0)
    end
end)

function SetAvatar(pixels,configmi)
	if configmi == 1 then
		drawInfo("Config","Avatar ayarlandı.")
	end
    Global.Avatar = dxCreateTexture(pixels)
end

addEvent("174.UpdateInfos", true)
addEventHandler("174.UpdateInfos", root, function(tabela, infos)
    if Global.Celular then
        Global.Componentes.Infos[tabela] = infos
        if tabela == "Whatsapp" then
            Global.Componentes.Mensageinormat = FormatarMensagens()
            if Global.Componentes.Aba == "Whatsapp" then
                local Conversas = Global.Componentes.Infos["Whatsapp"]
                Global.Componentes.ConversasWhatsapp = Conversas
                UpdateRender("Conversas", Global.Componentes.PosRender)
            elseif Global.Componentes.Aba == "Whatsapp-Conversa" then
                local Conversas = Global.Componentes.Infos["Whatsapp"]
                Global.Componentes.ConversasWhatsapp = Conversas
                local MensagensRender = #Global.Componentes.PositionsWhatsapp
                local MensagensReceber = fromJSON(Global.Componentes.Mensageinormat[Global.Componentes.Select].Conversas)
                UpdateRender("Mensagem", Global.Componentes.PosRender)
                if MensagensRender ~= #MensagensReceber then
                    if #Global.Componentes.PositionsWhatsapp ~= 0 then
                        local UltimaPosicao = Global.Componentes.PositionsWhatsapp[#Global.Componentes.PositionsWhatsapp][2] + Global.Componentes.PositionsWhatsapp[#Global.Componentes.PositionsWhatsapp][4] - 412
                        if UltimaPosicao > 0 then
                            UpdateRender("Mensagem", UltimaPosicao)
                        end
                    end
                end
            end
        elseif tabela == "Contatos" then
            if Global.Componentes.Aba == "Contatos" then
                Global.Contatoinormat = FormartContatos(Global.Componentes.Infos[tabela])
                UpdateRender("Contatos", 0)
            end
        end
    end
end)

function FormatarMensagens()
    local Conversas = Global.Componentes.Infos["Whatsapp"]
    local Tabela = {}
    for i = 1,#Conversas do
        local v = Conversas[i]
        Tabela[v.Recebendo] = v
    end
    return Tabela
end

function FormartContatos(tabela)
    local TabelaContatos = {}
    for telefone, v in pairs(tabela) do
        local nome = v
        local PrimeiraCaractere = string.upper(string.sub(nome, 1, 1))
        if not TabelaContatos[PrimeiraCaractere] then
            TabelaContatos[PrimeiraCaractere] = {} 
        end
        TabelaContatos[PrimeiraCaractere][#TabelaContatos[PrimeiraCaractere] + 1] = {telefone, nome} 
    end
    local TabelaIndices = {}
    for letra,v in pairs(TabelaContatos) do
        TabelaIndices[#TabelaIndices + 1] = letra
    end
    table.sort(TabelaIndices, function(a, b)
        return a < b
    end)
    local TabelaContatosPrincipal = {}
    TabelaContatosPrincipal[1] = {
        "",
        {
        },
    }
    for i,v in ipairs(TabelaIndices) do
        TabelaContatosPrincipal[i + 1] = {}
        TabelaContatosPrincipal[i + 1] = {v, TabelaContatos[v]}
        table.sort(TabelaContatosPrincipal[i + 1][2], function(a, b)
            return (a[2] < b[2])
        end)
    end
    return TabelaContatosPrincipal
end

addEvent("wpses",true)
addEventHandler("wpses",root,function()
	playSound("assets/sound.mp3")
end)

sending = false

addEvent("wplok",true)
addEventHandler("wplok",root,function(posx,posy,posz)
	konumyollandi()
	sending = true
end)

function konumyollandi1()
	x,y,z = getElementData(localPlayer,"konummx"), getElementData(localPlayer,"konummy"), getElementData(localPlayer,"konummz")
	radar:setGPSDestination(x,y)
	createBlip(x,y,z,41,25,255,255,255,255)
	setTimer(function()
		sending = false
	end,15000,1)
end
addCommandHandler("konumkabul",konumyollandi1)

function konumyollandi()
	x,y,z = getElementData(localPlayer,"konumx"), getElementData(localPlayer,"konumy"), getElementData(localPlayer,"konumz")
	radar:setGPSDestination(x,y)
	createBlip(x,y,z,41,25,255,255,255,255)
	setTimer(function()
		sending = false
	end,15000,1)
end
addCommandHandler("kabul",konumyollandi)

function count(table)
	if not table then return 0 end
	local counter = 0
	for i, v in pairs(table) do
		counter = counter + 1
	end
	return counter
end

function sendMessage(texto)
    if Global.Componentes.Aba == "Whatsapp-Conversa" then
        local TelefoneReceber = Global.Componentes.Select
		setTimer(function()
        triggerServerEvent("174.NewConversa__key:si8q2vlud", localPlayer, TelefoneReceber, texto, "msg")
		end,0,1)
    end
end

function closeCell()
	setElementData(localPlayer,"telefonacik",false)
    Global.Celular = nil
	killTimer(telefonTimer)
    Global.Componentes = {
        PosicoesRender = {}
    },
    ChangeAba("")
	setTimer(function()
	triggerServerEvent("dataFalse__key:025b5xh3d",localPlayer,localPlayer)
	end,0,1)
end

requestBrowserDomains({ "www.revalroleplay.com" })

musicList = {}

function startMusicc(responseData, errorCode)
	local response = fromJSON(responseData)
	local url = response["response"][1]['url']
	setTimer(function()
	triggerServerEvent("spotify.start",localPlayer,url)
	end,0,1)
end

musicBox = {}
musicDuratSay = 1
function startMusic(url)
	if isElement(musicBox[source]) then		
		destroyElement(musicBox[source]) 
		killTimer(timersay)
		killTimer(spotifyBox)
		musicDuratSay = 1
	end
	if isTimer(spotifyBox) then killTimer(spotifyBox) end
	played = true
	triggerEvent("phone.spotify",localPlayer,"open")
	musicBox[source] = playSound(url,true)
	local xxxxxx = (195 - musicDuratSay) / musicDuration
	timersay = setTimer(function() 
		if played == true then
			musicDuratSay = musicDuratSay + xxxxxx
		end
			if musicDuratSay >= 195 then
				killTimer(timersay)
				musicDuratSay = 1
			end
	end,1000-195,musicDuration)
end
addEvent("spotify.start",true)
addEventHandler("spotify.start",root,startMusic)

local currentRow, maxRow = 1, 5
local lastClick = 0
local totalHeight = 0
local auth = {}
local alphas = {}
local ucakmodu = false
local increasing = true
local possYY = false
local increasingY  = false
local yCoord = 950
local ay_isimleri = {[1] = "Ocak",[2] = "Şubat",[3] = "Mart",[4] = "Nisan",[5] = "Mayıs",[6] = "Haziran",[7] = "Temmuz",[8] = "Ağustos",[9] = "Eylül",[10] = "Ekim",[11] = "Kasım",[12] = "Aralık"}
local days = {"Pazar", "Pazartesi", "Sali", "Çarsamba", "Persembe", "Cuma", "Cumartesi"}
local zaman = os.date("*t")
local dayName = days[zaman.wday]

resim = {}
addEvent("darkweb:avatarVer",true)
addEventHandler("darkweb:avatarVer",root,function(player,avatar)
	darkwebFlow = Cachedw or {}
	local getFlow = (darkwebFlow)
	local flowTable = {}
	for i, v in pairs(getFlow) do
		flowTable[#flowTable + 1] = v
	end
	table.sort(flowTable,
		function(a, b)
			local indexOne = tonumber(a.sortIndex)
			local indexTwo = tonumber(b.sortIndex)
			return indexOne > indexTwo
		end
	)
	for i, v in pairs(flowTable) do
		if not resim[v.creator] then
			local Link = v.avatars
            requestBrowserDomains({Link}, true, function(wasAccepted)
				if wasAccepted then
					fetchRemote(Link, function(data, error)
						if error == 0 and type(data) == "string" then
							resim[v.creator] = dxCreateTexture(data)
						elseif error ~= 0 then
							triggerEvent("phone.showInfo",localPlayer,"darkweb","Avatar oluşturulamadı!")
						end
					end)
				end
            end)
		end
	end
end)

lockY = 620
openY = 0
siralama = 0
infosY = 50
countt = 0
acilmabildirim = {}
Whatsappbildirim = {}
YYY = 0
alphaA = 0
addImage = 0
scroll = 0
Global.lockScreen = 0
maxScrool = 0
selectedImagePost = {}
function drawCelular()
	if getElementData(localPlayer,"hudkapa") == true then return end
	Global.PosX = interpolateBetween(Global.Celular[2], 0, 0, Global.Celular[3], 0, 0, (getTickCount() - Global.Celular[1])/0, "Linear")
    Global.PosY = interpolateBetween(Global.Celular[2], 0, 0, Global.Celular[3], 0, 0, (getTickCount() - Global.Celular[1])/650, "Linear")
    local Time = getRealTime()
    local Hora, Minuto = (Time.hour < 10 and "0"..Time.hour or Time.hour), (Time.minute < 10 and "0"..Time.minute or Time.minute)
    if not Global.Componentes.Aba or (Global.Componentes.TickAba and getTickCount() <= Global.Componentes.TickAba[1] + 1000 ) then
        dxDrawImage(1555, 380, 296, 620,"assets/img/wallpapers/"..(getElementData(localPlayer,"phone.wallpaper") or 2)..".png", 0, 0, 0)
        dxDrawBordRectangle(1561+9.5, 922, 284-20, 70, 25,tocolor(200, 200, 200, 150))
        dxDrawBordRectangle(1675+12, 900, 40, 10, 5,tocolor(200, 200, 200, 200))
        dxDrawBordRectangle(1675+19, 902, 6, 6, 4,tocolor(100, 100, 100, 200))
        dxDrawBordRectangle(1675+15+14, 902, 6, 6, 4,tocolor(0, 0, 0, 200))
        dxDrawBordRectangle(1675+10+14+14, 902, 6, 6, 4,tocolor(100, 100, 100, 200))
        dxDrawImage(1570-2.5, 444-5,130, 132,"assets/img/widget.png")
        dxDrawImage(1570+135+2.5, 444-5,130, 132,"assets/img/widget2.png")
		dxDrawText("Reval", 1585, 450, 0, 0, tocolor(241, 241, 241, 200), 1, Global.Fonts["PoppinsBold"][16],"left", "top")
		dxDrawText(string.upper(dayName), 1585+135+2.5, 450, 0, 0, tocolor(255,39,84, 235), 1, Global.Fonts["PoppinsBold"][17],"left", "top")
		dxDrawText(zaman.day, 1585+135+2.5, 450+20, 0, 0, tocolor(225,225,225, 255), 1, Global.Fonts["awesome"][5],"left", "top")
		dxDrawText("Bugün başka", 1585+140+2.5, 450+70+3, 0, 0, tocolor(225,225,225, 255), 1, Global.Fonts["PoppinsRegular"][12],"left", "top")
		dxDrawText("etkinlik yok.", 1585+140+2.5, 450+88, 0, 0, tocolor(225,225,225, 255), 1, Global.Fonts["PoppinsRegular"][12],"left", "top")
		dxDrawText("Roleplay", 1585, 470, 0, 0, tocolor(241, 241, 241, 200), 1, Global.Fonts["PoppinsBold"][16],"left", "top")
		dxDrawText("", 1585, 530, 0, 0, tocolor(241, 241, 241, 200), 1, Global.Fonts["PoppinsBold"][16],"left", "top")
        local PosXApps, PosYApps = 0, 0
        for i = 1,16 do
            if Global.PosApps.Normal[tostring(i)] then
                local Nome = Global.PosApps.Normal[tostring(i)]
                if Global.Componentes.SelectedApp == i then
                    local mx, my = getCursorPosition()
                    local fullx, fully = guiGetScreenSize()
                    local cursorx, cursory = mx*fullx, my*fully
                    _dxDrawImage(cursorx - (48 / 2), cursory - (48 / 2), 48, 48, "assets/img/apps/"..Nome..".png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
                else
                    if isCursorOnElement(1592 - 17 + (70 * PosXApps), 444+145 + (76 * PosYApps), 48, 48) then
                        dxDrawImage(1592 - 17 + (70 * PosXApps) -1, 444+145 + (76 * PosYApps) - 1, 48 + 2, 48 + 2, "assets/img/apps/"..Nome..".png")
                    else
                        dxDrawImage(1592 - 17 + (70 * PosXApps), 444+145 + (76 * PosYApps), 48, 48, "assets/img/apps/"..Nome..".png")
                    end
                    if Nome == "config" then
                        Nome = "ayarlar"
                    elseif Nome == "banco" then
                        Nome = "cüzdan"
					elseif Nome == "camera" then
                        Nome = "kamera"
                    elseif Nome == "contatos" then
                        Nome = "kişiler"
                    elseif Nome == "telefone" then
                        Nome = "telefon"
                    elseif Nome == "infos" then
                        Nome = "bilgiler"
                    end
                    dxDrawText(string.upper(string.sub(Nome, 1, 1))..string.sub(Nome, 2, #Nome), 1588 - 15.5 + (70 * PosXApps), 495+145 + (76 * PosYApps), 54, 15, tocolor(255, 255, 255, 255), 1, Global.Fonts["PoppinsSemiBold"][10], "center")
                end
            else
                if isCursorOnElement(1592 - 17 + (70 * PosXApps), 444+145 + (76 * PosYApps), 48, 48) and Global.Componentes.SelectedApp then
                    dxDrawImage(1592 - 17 + (70 * PosXApps), 444+145 + (76 * PosYApps), 48, 48, "assets/img/apps/default.png")
                end
            end
            PosXApps = PosXApps + 1
            if PosXApps == 4 then
                PosXApps = 0
                PosYApps = PosYApps + 1
            end
			
        end
			if countt > 0 then
				dxDrawBordRectangle(1612, 495+88, 20, 20,20,tocolor(255,0,0,255))
				dxDrawText(countt, 1612 - 15.5, 495+91, 54, 15, tocolor(255, 255, 255, 255),0.9, Global.Fonts["PoppinsBold"][14], "center")
			end
		
        for i = 1,4 do
            if Global.PosApps.Bar[tostring(i)] then
                if isCursorOnElement(1522 + (63 * i), 933, 48, 48) then
                    dxDrawImage(1522 + (63 * i) - 1, 933 - 1, 48 + 2, 48 + 2, "assets/img/apps/"..Global.PosApps.Bar[tostring(i)]..".png")
                else
                    dxDrawImage(1522 + (63 * i), 933, 48, 48, "assets/img/apps/"..Global.PosApps.Bar[tostring(i)]..".png")
                end
            end
        end
		lockY = interpolateBetween(365,0,0,0,0,0, (getTickCount() - Global.lockScreen)/300, "OutQuad")
		openY = interpolateBetween(365,0,0,0,0,0, (getTickCount() - Global.lockScreen)/150, "Linear")
		openW = interpolateBetween(296,0,0,0,0,0, (getTickCount() - Global.lockScreen)/150, "Linear")
		openX = interpolateBetween(1555,0,0,1700,0,0, (getTickCount() - Global.lockScreen)/150, "Linear")
		openH = interpolateBetween(380,0,0,420,0,0, (getTickCount() - Global.lockScreen)/150, "Linear")
		lockAlpha = interpolateBetween(255,0,0,0,0,0, (getTickCount() - Global.lockScreen)/150, "Linear")
		dxDrawImage(openX, 380, openW, lockY,"assets/img/wallpapers/"..(getElementData(localPlayer,"phone.wallpaper") or 2)..".png", 0, 0, 0,tocolor(255,255,255,lockAlpha))
    end 
	if Global.Componentes.Aba then
        if (Global.Componentes.TickAba and getTickCount() <= Global.Componentes.TickAba[1] + 1000) then
            local Px, Py, Width = interpolateBetween(Global.Componentes.TickAba[2][1], Global.Componentes.TickAba[2][2], Global.Componentes.TickAba[2][3], Global.Componentes.TickAba[3][1], Global.Componentes.TickAba[3][2], Global.Componentes.TickAba[3][3], (getTickCount() - Global.Componentes.TickAba[1])/200, "Linear")
            local Height = interpolateBetween(Global.Componentes.TickAba[2][4], 0, 0, Global.Componentes.TickAba[3][4], 0, 0, (getTickCount() - Global.Componentes.TickAba[1])/200, "Linear")
            dxDrawImage(Px-7, Py-2, Width+14, Height+2, "assets/img/load.png")
            local PosX = (Px + (Width/2)) - (48/2)
            local PosY = (Py + (Height/2)) - (48/2)
            dxDrawImage(PosX, PosY, 48, 48, "assets/img/apps/"..Global.Componentes.TickAba[4]..".png", 0, 0, 0)
        else
			if Global.Componentes.Aba == "kilitEkran" then
				dxDrawImage(1555, 380, 296, 620,"assets/img/wallpapers/"..(getElementData(localPlayer,"phone.wallpaper") or 2)..".png", 0, 0, 0)
				dxDrawImage(1555, 380, 296, 620,"assets/img/wallpapers/lockbg.png", 0, 0, 0,tocolor(255,255,255,150))
				dxDrawImage(1555, 380, 296, lockY,"assets/img/wallpapers/"..(getElementData(localPlayer,"phone.wallpaper") or 2)..".png", 0, 0, 0)
				dxDrawBordRectangle(1555, 380, 296, 620,30,tocolor(20,20,20,125))
				dxDrawImage(1531, 359, 344, 672, "assets/img/overlay.png", 0, 0, 0)
				local Time = getRealTime()
				local Hora, Minuto = (Time.hour < 10 and "0"..Time.hour or Time.hour), (Time.minute < 10 and "0"..Time.minute or Time.minute)
				dxDrawText(Hora..":"..Minuto, 1627+77, 428, 0, 0, tocolor(241, 241, 241, 200), 1, Global.Fonts["PoppinsSemiBold"][26],"center", "top")
				dxDrawText(zaman.day.." "..ay_isimleri[zaman.month].." "..os.date("%Y"), 1650+55, 419+3, 0, 0, tocolor(241, 241, 241, 200), 1, Global.Fonts["PoppinsSemiBold"][12], "center", "top")
				if getCursorPosition() then
					mx, my = getCursorPosition()
				else
					mx, my = 0,0
				end
                local fullx, fully = guiGetScreenSize()
                local cursorx, cursory = mx*fullx, my*fully
				if isCursorOnElement(1555, cursory - (fully/5), 296, 620) and getKeyState("mouse1") then
					lockY = cursory - (fully/5)
					if lockY < 365 then
						Global.lockScreen = getTickCount()
						Global.Componentes.Aba = nil
						acilmabildirim = {}
						possYY = false
					elseif lockY > 620 then
						lockY = 620
					end
				else
					if increasing then
						alphaA = alphaA + 2
						if alphaA >= 225 then
							increasing = false
						end
					else
						alphaA = alphaA - 2
						if alphaA <= 0 then
							increasing = true
						end
					end
						
					if increasingY then
						yCoord = yCoord - 0.19
						if yCoord <= 940 then
							increasingY = false
						end
					else
						yCoord = yCoord + 0.19
						if yCoord >= 950 then
							increasingY = true
						end
					end
					
					if isCursorOnElement(1585, 914, 50, 50, 50) then
						dxDrawBordRectangle(1585-2.5, 914-2.5, 55, 55, 55,tocolor(100, 100, 100, 100))
					else
						dxDrawBordRectangle(1585, 914, 50, 50, 50,tocolor(100, 100, 100, 100))
					end
					if isCursorOnElement(1770, 914, 50, 50) then
						dxDrawBordRectangle(1770-2.5, 914-2.5, 55, 55, 55,tocolor(100, 100, 100, 100))
						if getKeyState("mouse1") then
							Global.Componentes.Aba = "Camera"
							triggerEvent("selfiephone",localPlayer)
							cammod = true
						end
					else
						dxDrawBordRectangle(1770, 914, 50, 50, 50,tocolor(100, 100, 100, 100))
					end
					
					dxDrawText("yukarı kaydır", 1650+52.5, yCoord, 0, 0, tocolor(255, 255, 255, alphaA), 1, Global.Fonts["PoppinsSemiBold"][12], "center", "top")
					dxDrawImage(1597, 926, 25, 25, "assets/img/app-png/fener.png", 0, 0, 0)
					dxDrawImage(1782, 926, 25, 25, "assets/img/app-png/camera.png", 0, 0, 0)
					lockY = 620
				end
				
				bildirimY = 0
				if ucakmodu == false then
					for index, value in ipairs(acilmabildirim) do
						if index <= 3 then
							if lockY >= 620 then
								dxDrawImage(1580, 678+165-bildirimY, 250, 50, "assets/img/bildirimbg.png", 0, 0, 0, tocolor(255,255,255,200))
								dxDrawImage(1590, 687+165-bildirimY, 30, 30, "assets/img/apps/"..value[1]..".png", 0, 0, 0, tocolor(255,255,255,alpha))
								dxDrawText(value[2], 1630, 700+165-bildirimY, 0, 0, tocolor(255, 255, 255, 255), 1, Global.Fonts["PoppinsSemiBold"][12], "left", "top")
								dxDrawText(value[3], 1630, 685+165-bildirimY, 0, 0, tocolor(255, 255, 255, 255), 1, Global.Fonts["PoppinsSemiBold"][12], "left", "top")
								bildirimY = bildirimY + 60
							end
						end
					end
				end
            elseif Global.Componentes.Aba == "Banco" then
                local Banco = getElementData(localPlayer, Config.keyBank) or 0
                dxDrawImage(1558, 378, 290, 623, "assets/img/app-banco/fundo.png")
                dxDrawImage(1594, 501, 218, 82, "assets/img/app-banco/card.png", 0, 0, 0)
                dxDrawText("BANKA", 1561, 434, 284, 20, tocolor(241, 241, 241, 255), 1, Global.Fonts["PoppinsMedium"][13], "center", "center")
                dxDrawText(getPlayerName(localPlayer):gsub("_"," "), 1561, 452, 284, 26, tocolor(241, 241, 241, 255), 1, Global.Fonts["PoppinsBold"][17], "center", "center")
                dxDrawText(convertNumber(Banco), 1681, 531, 53, 24, tocolor(34, 35, 61, 255), 1, Global.Fonts["PoppinsBold"][16], "left", "center")
                dxDrawText("İşlem :", 1631, 617, 54, 18, tocolor(27, 27, 27, 255), 1, Global.Fonts["PoppinsMedium"][12])
                dxDrawText("Para Transferi", 1684, 617, 99, 18, tocolor(27, 27, 27, 255), 1, Global.Fonts["PoppinsBold"][12])
                dxDrawText("Son işlemler", 1591, 670, 152, 44, tocolor(241, 241, 241, 255), 1, Global.Fonts["PoppinsMedium"][12], "center", "center")
                local Transacoes = (Global.Componentes.Infos.Transacoes and Global.Componentes.Infos.Transacoes[1] and fromJSON(Global.Componentes.Infos.Transacoes[1].Transacoes) or {})
                for i = 1,4 do
                    if #Transacoes >= i then
                        local Index = #Transacoes + 1 - i
                        local Transacao = Transacoes[Index]
                        dxDrawImage(1591, 679 + (58 * i), 45, 45, "assets/img/app-banco/icon.png", 0, 0, 0, tocolor(255, 255, 255, 255))
                        dxDrawText("Para gönderimi", 1650, 679 + 5 + (58 * i), 0, 0, tocolor(16, 16, 16, 255), 1, Global.Fonts["PoppinsSemiBold"][12])
                        dxDrawText(Transacao[1], 1650, 679 + 21 + (58 * i), 0, 0, tocolor(50, 50, 50, 255), 1, Global.Fonts["PoppinsRegular"][12])
                        local Dia, Mes, Ano, Hora, Minuto = unpack(Transacao[2])
                        dxDrawText(Hora..":"..Minuto, 1788, 679 + 6 + (58 * i), 0, 0, tocolor(0, 0, 0, 255), 1, Global.Fonts["PoppinsMedium"][11])
                        dxDrawText(Dia.."/"..Mes.."/"..Ano, 1762, 679 + 6 + 16 + (58 * i), 0, 0, tocolor(0, 0, 0, 255), 1, Global.Fonts["PoppinsMedium"][11])
                    end
                end

                if Global.Componentes.Traninerir then
                    dxDrawBordRectangle(1559, 380, 287, 621, 15, tocolor(0, 0, 0, 76))
                    dxDrawBordRectangle(1561, 827, 284, 172, 25, tocolor(255, 255, 255, 255))
                    dxDrawImage(1580, 891, 246, 34, "assets/img/app-banco/editbox.png", 0, 0, 0)
                    if Global.Componentes.Traninerir[1] == 1 then
                        dxDrawText("IBAN girin.", 1561, 848, 284, 26, tocolor(22, 22, 22, 255), 1, Global.Fonts["PoppinsSemiBold"][17], "center")
                        dxDrawText("İlerle", 1561, 939, 284, 23, isCursorOnElement(1673, 939, 61, 23) and tocolor(67, 74, 249, 255) or tocolor(22, 22, 22, 255), 1, Global.Fonts["PoppinsMedium"][15], "center")
                    elseif Global.Componentes.Traninerir[1] == 2 then
                        dxDrawText("Miktarı girin", 1561, 848, 284, 26, tocolor(22, 22, 22, 255), 1, Global.Fonts["PoppinsSemiBold"][17], "center")
                        dxDrawText("Onayla", 1561, 939, 284, 23, isCursorOnElement(1673, 939, 61, 23) and tocolor(67, 74, 249, 255) or tocolor(22, 22, 22, 255), 1, Global.Fonts["PoppinsMedium"][15], "center")
                    end
                end
            elseif Global.Componentes.Aba == "Whatsapp" then
                dxDrawBordRectangle(1559, 380, 287, 621, 15, tocolor(12, 12, 15, 255))
                dxDrawText("Sohbetler", 1590, 439+3, 0, 0, tocolor(241, 241, 241, 255), 1, Global.Fonts["PoppinsMedium"][17])
                dxDrawImage(1585, 481, 236, 38, "assets/img/app-whatsapp/editbox.png", 0, 0, 0)
				dxDrawBordRectangle(1585,535,50,20,10,tocolor(200,255,200,50))
				dxDrawText("Tümü",1593,526+10,57,13,tocolor(200,255,200),1, Global.Fonts["PoppinsMedium"][32],"left","top")
				dxDrawBordRectangle(1585+55,535,90,20,10,tocolor(255,255,255,50))
				dxDrawText("Okunmamış",1593+55,526+10,57,13,tocolor(200,200,200),1, Global.Fonts["PoppinsMedium"][32],"left","top")
				dxDrawBordRectangle(1585+55+95,535,60,20,10,tocolor(255,255,255,50))
				dxDrawText("Gruplar",1593+55+95,526+10,57,13,tocolor(200,200,200),1, Global.Fonts["PoppinsMedium"][32],"left","top")
                dxSetBlendMode("add")
                dxDrawImage(1583, 576, 238, 353, Global.Componentes.Render, 0, 0, 0)
                dxSetBlendMode("blend")
                dxDrawImage(1787, 942, 38, 38, "assets/img/app-whatsapp/circle.png", 0, 0, 0, isCursorOnElement(1787, 942, 38, 38) and tocolor(79, 197, 126, 255) or tocolor(78, 154, 108, 255))
                dxDrawImage(1798, 955, 16, 12, "assets/img/app-whatsapp/msg.png", 0, 0, 0, tocolor(255, 255, 255, 255))
                local Conversas = Global.Componentes.ConversasWhatsapp
                if #Conversas > 4 then
                    local ProgressConversa = Global.Componentes.ScrollWhatsapp:GetProgress()
                    local TamanhoTotal = Global.Componentes.PosicoesRender["Conversas"][#Global.Componentes.PosicoesRender["Conversas"]][2] + Global.Componentes.PosicoesRender["Conversas"][#Global.Componentes.PosicoesRender["Conversas"]][4] - 353
                    local PosRender = TamanhoTotal / 100 * ProgressConversa
                    if PosRender ~= Global.Componentes.PosRender then
                        UpdateRender("Conversas", PosRender)
                    end
                end
                
                if Global.Componentes.IniciarConversa then
                    dxDrawBordRectangle(1559, 380, 287, 621, 15, tocolor(0, 0, 0, 76))
                    if Global.Componentes.IniciarConversa[1] == 1 then
                        dxDrawBordRectangle(1561, 849, 284, 151, 25, tocolor(255, 255, 255, 255))
                        dxDrawText("Bir eylem seçin", 1561, 885, 284, 26, tocolor(22, 22, 22, 255), 1, Global.Fonts["PoppinsMedium"][17], "center", "center", false, false)
                        dxDrawText("Kişiler", 1561, 923, 284, 26, isCursorOnElement(1664, 923, 79, 26) and tocolor(1, 100, 235, 255) or tocolor(22, 22, 22, 255), 1, Global.Fonts["PoppinsRegular"][17], "center", "center", false, false)
                    elseif Global.Componentes.IniciarConversa[1] == 2 then
                        dxDrawBordRectangle(1561, 807, 284, 192, 25, tocolor(255, 255, 255, 255))
                        dxDrawText("Bir eylem seçin", 1561, 833, 284, 26, tocolor(22, 22, 22, 255), 1, Global.Fonts["PoppinsMedium"][17], "center", "center", false, false)
                        local Broken = isNumberBroken((#Global.Componentes.Contatoinormatados / 2))
                        local TotalAbas = (Broken and math.floor((#Global.Componentes.Contatoinormatados / 2)) + 1 or (#Global.Componentes.Contatoinormatados / 2))
                        dxDrawText(Global.Componentes.IniciarConversa[2].."/"..TotalAbas, 1561, 940, 284, 21, tocolor(18, 18, 18, 255), 1, Global.Fonts["PoppinsMedium"][14], "center", "center", false, false)
                        for i = 1,2 do
                            local v = Global.Componentes.Contatoinormatados[Global.Componentes.IniciarConversa[2] - 1 + i]
                            if v then
                                dxDrawText(v[2], 1561, 871 - 31 + (31 * i), 284, 26, tocolor(22, 22, 22, 255), 1, Global.Fonts["PoppinsRegular"][17], "center")
                            end
                        end
                    end
                end
            elseif Global.Componentes.Aba == "Whatsapp-Conversa" then
                dxDrawImage(1555, 380, 296, 621, "assets/img/app-whatsapp-conversa/fundo.png", 0, 0, 0, tocolor(255, 255, 255, 255))
                dxDrawImage(1582, 430, 33, 33, Global.Avatar or "assets/avatars/1.png")
                dxDrawText(Global.Componentes.Infos["Contatos"][Global.Componentes.Select] or Global.Componentes.Select, 1632, 431, 0, 0, tocolor(241, 241, 241, 255), 1, Global.Fonts["PoppinsSemiBold"][13])
				dxDrawText("Online", 1632, 448, 0, 0, tocolor(135, 135, 135, 255), 1, Global.Fonts["PoppinsMedium"][11])
                dxDrawRectangle(1582, 483, 243, 1, tocolor(255, 255, 255, 13))
                dxSetBlendMode("add")
                dxDrawImage(1582, 503, 243, 412, Global.Componentes.Render, 0, 0, 0)
                dxSetBlendMode("blend")
                dxDrawImage(1575, 924, 255, 39, "assets/img/app-whatsapp-conversa/editbox.png", 0, 0, 0, tocolor(255, 255, 255, 255))
                dxDrawImage(1765, 435, 60, 29, "assets/img/app-whatsapp-conversa/bar.png")
                if #Global.Componentes.PositionsWhatsapp ~= 0 then
                    local UltimaPosicao = Global.Componentes.PositionsWhatsapp[#Global.Componentes.PositionsWhatsapp][2] + Global.Componentes.PositionsWhatsapp[#Global.Componentes.PositionsWhatsapp][4] - 412
                    if UltimaPosicao > 0 then
                        if Global.Componentes.PosRender ~= UltimaPosicao then
                            dxDrawImage(1793, 882, 26, 26, "assets/img/app-whatsapp-conversa/descer.png", 0, 0, 0)
                        end
                    end
                end

                if Global.Componentes.Anexo then
                    if Global.Componentes.selecionarContatosWhatsapp then
                        dxDrawBordRectangle(1561, 807, 284, 192, 25, tocolor(255, 255, 255, 255))
                        dxDrawText("Bir eylem seçin", 1561, 833, 284, 26, tocolor(22, 22, 22, 255), 1, Global.Fonts["PoppinsMedium"][17], "center", "center", false, false)
                        local Broken = isNumberBroken((#Global.Componentes.Contatoinormatados / 2))
                        local TotalAbas = (Broken and math.floor((#Global.Componentes.Contatoinormatados / 2)) + 1 or (#Global.Componentes.Contatoinormatados / 2))
                        dxDrawText(Global.Componentes.selecionarContatosWhatsapp[2].."/"..TotalAbas, 1561, 940, 284, 21, tocolor(18, 18, 18, 255), 1, Global.Fonts["PoppinsMedium"][14], "center", "center", false, false)
                        for i = 1,2 do
                            local v = Global.Componentes.Contatoinormatados[Global.Componentes.selecionarContatosWhatsapp[2] - 1 + i]
                            if v then
                                dxDrawText(v[2], 1561, 871 - 31 + (31 * i), 284, 26, tocolor(22, 22, 22, 255), 1, Global.Fonts["PoppinsRegular"][17], "center")
                            end
                        end
                    else
                        dxDrawBordRectangle(1559, 380, 287, 621, 15, tocolor(0, 0, 0, 76))
                        dxDrawBordRectangle(1561, 788, 284, 211, 25, tocolor(255, 255, 255, 255))
                        dxDrawText("Bir eylem seçin", 1561, 820, 284, 26, tocolor(22, 22, 22, 255), 1, Global.Fonts["PoppinsSemiBold"][17], "center", "center")
                        dxDrawText("Konum Gönder", 1561, 879, 284, 26, isCursorOnElement(1652, 879, 101, 26) and tocolor(1, 100, 235, 255) or tocolor(22, 22, 22, 255), 1, Global.Fonts["PoppinsRegular"][17], "center", "center")
                        dxDrawText("Kişi Paylaş", 1561, 920, 284, 26, isCursorOnElement(1667, 920, 70, 26) and tocolor(1, 100, 235, 255) or tocolor(22, 22, 22, 255), 1, Global.Fonts["PoppinsRegular"][17], "center", "center")    
                    end

                end

            elseif Global.Componentes.Aba == "Contatos" then

                dxDrawImage(1555, 380, 296, 621, "assets/img/app-contatos/fundo.png", 0, 0, 0, tocolor(255, 255, 255, 255))
                dxDrawImage(1585, 481, 236, 38, "assets/img/app-contatos/editbox.png", 0, 0, 0, tocolor(255, 255, 255, 255))
                dxDrawImage(1799, 437, 16, 33, "assets/img/app-contatos/add.png", 0, 0, 0, tocolor(255, 255, 255, 255))

                dxSetBlendMode("add")
                dxDrawImage(1585, 530, 260, 389, Global.Componentes.Render, 0, 0, 0)
                dxSetBlendMode("blend")
                if Global.Componentes.AddContato then
                    dxDrawBordRectangle(1559, 380, 287, 621, 15, tocolor(0, 0, 0, 76))
                    dxDrawBordRectangle(1561, 827, 284, 172, 25, tocolor(255, 255, 255, 255))
                    dxDrawImage(1580, 891, 246, 34, "assets/img/app-banco/editbox.png", 0, 0, 0, tocolor(255, 255, 255, 255))
                    if #Global.Componentes.AddContato == 0 then
                        dxDrawText("Numarayı girin", 1561, 848, 284, 26, tocolor(22, 22, 22, 255), 1, Global.Fonts["PoppinsMedium"][17], "center", "center", false, false)
                        dxDrawText("Sonraki", 1561, 939, 284, 23, isCursorOnElement(1673, 939, 61, 23) and tocolor(1, 100, 235, 255) or tocolor(22, 22, 22, 255), 1, Global.Fonts["PoppinsMedium"][15], "center", "center", false, false)
                    elseif #Global.Componentes.AddContato == 1 then
                        dxDrawText("Bu numara için\nbir ad girin", 1561, 848, 284, 26, tocolor(22, 22, 22, 255), 1, Global.Fonts["PoppinsMedium"][17], "center", "center", false, false)
                        dxDrawText("Kaydet", 1561, 939, 284, 23, isCursorOnElement(1677, 939, 50, 23) and tocolor(1, 100, 235, 255) or tocolor(22, 22, 22, 255), 1, Global.Fonts["PoppinsMedium"][15], "center", "center", false, false)
                    end
                end
            elseif Global.Componentes.Aba == "Config" then
			 local telefone = Global.Componentes.Infos and (Global.Componentes.Infos.Infos.Telefone and Global.Componentes.Infos.Infos.Telefone or '0000-0000') or '0000-0000'
                local passaporte = getElementData(localPlayer, 'playerid') or 'n/a'
                local bank = convertNumber(getElementData(localPlayer, Config.keyBank) or 0)
                dxDrawImage(1555, 380, 296, 621, "assets/img/app-config/fundo.png", 0, 0, 0, tocolor(255, 255, 255, 255))
                dxDrawBordRectangle(1572, 489, 262, 90, 10, tocolor(235, 235, 235, 255))
				dxDrawImage(1587+2.5,502+5,55,55, Global.Avatar or "assets/avatars/1.png")
				if Global.Avatar then
					dxDrawImage(1587+2.5-5,502+5-5,65,65, "assets/img/inicio/avbgc.png")
				end
				dxDrawText(getPlayerName(localPlayer), 1660, 500, 100, 18, tocolor(0, 0, 0, 255), 1, Global.Fonts["PoppinsRegular"][15])
				dxDrawText("NO: "..telefone, 1660, 521, 100, 18, tocolor(0, 0, 0, 200), 1, Global.Fonts["PoppinsRegular"][15])
				dxDrawText("IBAN: "..passaporte, 1660, 542, 100, 18, tocolor(0, 0, 0, 200), 1, Global.Fonts["PoppinsRegular"][15])
                dxDrawBordRectangle(1572, 489+100, 262, 85, 10, tocolor(235, 235, 235, 255))
                dxDrawBordRectangle(1572, 489+100+105, 262, 125, 10, tocolor(235, 235, 235, 255))
				--wallpaper
                dxDrawImage(1584, 510+90, 22, 22, "assets/img/app-config/papel.png",0,0,0,tocolor(0,0,0,200))
                dxDrawText("Duvar kağıdı", 1614+5, 503+97, 100, 18, tocolor(0, 0, 0, 200), 1, Global.Fonts["PoppinsRegular"][15])
				dxDrawRectangle(1584+35,600+30,215,1,tocolor(0,0,0,50))
				--avatars
				dxDrawImage(1581, 510+90+39, 29, 29, "assets/img/app-config/avatar.png",0,0,0,tocolor(0,0,0,200))
                dxDrawText("Avatar", 1614+5, 503+97+40, 100, 18, tocolor(0, 0, 0, 200), 1, Global.Fonts["PoppinsRegular"][15])

				--bildirim
				dxDrawImage(1585, 510+90+106, 20, 20, "assets/img/app-config/notify.png",0,0,0,tocolor(0,0,0,200))
                dxDrawText("Bildirimler", 1614+5, 503+97+105, 100, 18, tocolor(0, 0, 0, 200), 1, Global.Fonts["PoppinsRegular"][15])
				dxDrawRectangle(1584+35,600+30+105,215,1,tocolor(0,0,0,50))
				--isimsiz Arama
				dxDrawImage(1585, 510+90+106+40, 20, 20, "assets/img/app-config/phone2.png",0,0,0,tocolor(0,0,0,200))
                dxDrawText("Isimsiz arama", 1614+5, 503+97+105+40, 100, 18, tocolor(0, 0, 0, 200), 1, Global.Fonts["PoppinsRegular"][15])
				dxDrawRectangle(1584+35,600+30+105+40,215,1,tocolor(0,0,0,50))
				--uçak modu
				dxDrawImage(1585, 510+90+106+40+40, 20, 20, "assets/img/app-png/airplane.png",0,0,0,tocolor(0,0,0,200))
                dxDrawText("Uçak modu", 1614+5, 503+97+105+40+40, 100, 18, tocolor(0, 0, 0, 200), 1, Global.Fonts["PoppinsRegular"][15])
				dxDrawBordRectangle(1795, 745+41, 22, 22, 5, ucakmodu == true and tocolor(88, 189, 129) or tocolor(200,200,200))
				
				dxDrawText(">",1800,585,57,13,tocolor(0,0,0,150),1,Global.Fonts["PoppinsRegular"][18])
				dxDrawText(">",1800,585+40,57,13,tocolor(0,0,0,150),1,Global.Fonts["PoppinsRegular"][18])
				dxDrawText(">",1800,585+105,57,13,tocolor(0,0,0,150),1,Global.Fonts["PoppinsRegular"][18])
				
                if Global.Componentes.PapelParede then
                    dxDrawBordRectangle(1559, 380, 287, 621, 15, tocolor(0, 0, 0, 76))
                    dxDrawBordRectangle(1561, 827, 284, 172, 25, tocolor(255, 255, 255, 255))
                    dxDrawText("geçerli bir URL girin", 1561, 848, 284, 26, tocolor(22, 22, 22, 255), 1, Global.Fonts["PoppinsMedium"][17], "center", "center")
                    dxDrawImage(1580, 891, 246, 34, "assets/img/app-banco/editbox.png")
                    dxDrawText("Kaydet", 1564, 939, 281, 23, isCursorOnElement(1679, 939, 50, 23) and tocolor(1, 100, 235, 255) or tocolor(22, 22, 22, 255), 1, Global.Fonts["PoppinsMedium"][15], "center", "center")
                end
            elseif Global.Componentes.Aba == "config.wallpaper" then
				dxDrawImage(1555, 380, 296, 621, "assets/img/app-config/fundo.png", 0, 0, 0, tocolor(255, 255, 255, 255))
				addImage = 0
				addYImage = 0
				counter = 0
				for i = 1, 48 do
					if i > scroll and counter < 9 then
						if getElementData(localPlayer,"phone.wallpaper") == i then
							dxDrawImage(1580+addImage,480+addYImage,296/4, 621/4,"assets/img/wallpapers/"..i..".png",0,0,0,tocolor(255,255,255,255))
						else
							dxDrawImage(1580+addImage,480+addYImage,296/4, 621/4,"assets/img/wallpapers/"..i..".png",0,0,0,tocolor(200,200,200,200))
						end
						addImage = addImage + 84
						counter = counter + 1
						if addImage >= 84*3 then
							addYImage = addYImage + 155.25+10
							addImage = 0
						end
					end
				end
            elseif Global.Componentes.Aba == "Notify" then
                dxDrawImage(1555, 380, 296, 621, "assets/img/app-notify/fundo.png", 0, 0, 0, tocolor(255, 255, 255, 255))
				dxDrawBordRectangle(1572, 489, 262, 125, 10, tocolor(235, 235, 235, 255))
				--Mesajlar
				dxDrawImage(1585, 500, 24, 18, "assets/img/app-config/msg1.png",0,0,0,tocolor(0,0,0,200))
                dxDrawText("Mesajlar", 1614+5, 497, 100, 18, tocolor(0, 0, 0, 200), 1, Global.Fonts["PoppinsRegular"][15])
				dxDrawRectangle(1584+35,525,215,1,tocolor(0,0,0,50))
				--Bağlantılar
				dxDrawImage(1585, 500+40, 20, 20, "assets/img/app-config/phone2.png",0,0,0,tocolor(0,0,0,200))
                dxDrawText("Bağlantılar", 1614+5, 497+40, 100, 18, tocolor(0, 0, 0, 200), 1, Global.Fonts["PoppinsRegular"][15])
				dxDrawRectangle(1584+35,525+40,215,1,tocolor(0,0,0,50))
				--Yabancılardan
				dxDrawImage(1585, 500+80, 24, 18, "assets/img/app-config/msg1.png",0,0,0,tocolor(0,0,0,200))
                dxDrawText("Bilinmeyen mesajlar", 1614+5, 497+80, 100, 18, tocolor(0, 0, 0, 200), 1, Global.Fonts["PoppinsRegular"][15])
            elseif Global.Componentes.Aba == "Telefone" then
                dxDrawBordRectangle(1559, 380, 287, 621, 15, tocolor(243, 243, 243, 255))

                dxDrawText(Hora..":"..Minuto, 1581, 394, 0, 0, tocolor(16, 16, 16, 255), 1, Global.Fonts["PoppinsMedium"][10])
				
                dxDrawImage(1793, 398, 35, 6, "assets/img/inicio/statusbar.png", 0, 0, 0, tocolor(16, 16, 16, 255))
                dxDrawImage(1596, 599, 214, 234, "assets/img/app-telefone/numeros.png")
                dxDrawImage(1615, 883, 16, 15, "assets/img/app-telefone/barra.png")
                dxDrawImage(1767, 884, 35, 19, "assets/img/app-telefone/back.png")

                dxDrawImage(1672, 859, 61, 61, "assets/img/app-telefone/circle.png", 0, 0, 0, isCursorOnElement(1672, 859, 61, 61) and tocolor(69, 189, 131, 255) or tocolor(72, 155, 155, 255))
                dxDrawImage(1692, 879, 22, 22, "assets/img/app-telefone/icon.png")

                dxDrawText(Global.Componentes.Number, 1561, 513, 284, 48, tocolor(16, 16, 16, 255), 1, Global.Fonts["inUIDisplayRegular"][40], "center", "center")
            elseif Global.Componentes.Aba == "Ligação" then
                local Tipo = Global.Componentes.InfosLigacao[1]
                local Telefone = Global.Componentes.InfosLigacao[2]
                local Player = Global.Componentes.InfosLigacao[3]
                if isElement(Player) then
                     dxDrawImage(1555, 380, 296, 621, "assets/img/app-telefone/fundo.png")
                    dxDrawText(Global.Componentes.Infos["Contatos"][Telefone] or Telefone, 1561, 450, 284, 48, tocolor(255, 255, 255, 255), 1, Global.Fonts["PoppinsSemiBold"][25], "center", "center")
                    if Tipo == "Chamando" then
                        dxDrawText("Çalıyor...", 1561, 489, 284, 23, tocolor(255, 255, 255, 255), 1, Global.Fonts["PoppinsRegular"][15], "center", "center")
                        dxDrawImage(1675, 880, 56, 56, "assets/img/app-telefone/desligar.png", 0, 0, 0, tocolor(255, 255, 255, isCursorOnElement(1675, 880, 56, 56) and 200 or 255))
					elseif Tipo == "Ulasilmadi" then
                        dxDrawText("Ulaşılmıyor...", 1561, 489, 284, 23, tocolor(255, 255, 255, 255), 1, Global.Fonts["PoppinsRegular"][15], "center", "center")
                        dxDrawImage(1675, 880, 56, 56, "assets/img/app-telefone/desligar.png", 0, 0, 0, tocolor(255, 255, 255, isCursorOnElement(1675, 880, 56, 56) and 200 or 255))
                    elseif Tipo == "Recebendo" then
						local Tipo = Global.Componentes.InfosLigacao[1]
                        local Telefone = Global.Componentes.InfosLigacao[2]
                        local Player = Global.Componentes.InfosLigacao[3]
                        dxDrawText("Gelen Arama", 1561, 489, 284, 23, tocolor(255, 255, 255, 255), 1, Global.Fonts["PoppinsRegular"][15], "center", "center")
                        dxDrawImage(1625, 880, 56, 56, "assets/img/app-telefone/ligar.png", 0, 0, 0, tocolor(255, 255, 255, isCursorOnElement(1625, 880, 56, 56) and 200 or 255))
                        dxDrawImage(1725, 880, 56, 56, "assets/img/app-telefone/desligar.png", 0, 0, 0, tocolor(255, 255, 255, isCursorOnElement(1725, 880, 56, 56) and 200 or 255))
					elseif Tipo == "Atendido" then
                        local TimeTempo = getTickCount() - Global.Componentes.InfosLigacao[4]
                        local Minutes, Seconds = convertTime(TimeTempo)
                        dxDrawText((Minutes < 10 and "0"..Minutes or Minutes)..":"..(Seconds < 10 and "0"..Seconds or Seconds), 1561, 489, 284, 23, tocolor(255, 255, 255, 255), 1, Global.Fonts["PoppinsRegular"][15], "center", "center")
                        dxDrawImage(1675, 880, 56, 56, "assets/img/app-telefone/desligar.png", 0, 0, 0, tocolor(255, 255, 255, isCursorOnElement(1675, 880, 56, 56) and 200 or 255))
                    end
                else
					setTimer(function()
                    triggerServerEvent("174.RemoveChamada__key:3tg4bh4c3", localPlayer, Player)
					end,0,1)
                    Global.Componentes.InfosLigacao = nil
                    if Global.Componentes.Sound and isElement(Global.Componentes.Sound) then
                        destroyElement(Global.Componentes.Sound)
                        Global.Componentes.Sound = nil
                    end
                    Global.Componentes.Aba = "Telefone"
                    ChangeAba("Telefone")
                end
            elseif Global.Componentes.Aba == "Infos" then
                dxDrawBordRectangle(1559, 380, 287, 621, 15, tocolor(18, 18, 18, 255))
                dxDrawText('Kişisel Bilgiler', 1581, 432, 284, 20, tocolor(255, 255, 255, 255), 1, Global.Fonts["PoppinsSemiBold"][17], 'left', 'center')
                local telefone = Global.Componentes.Infos and (Global.Componentes.Infos.Infos.Telefone and Global.Componentes.Infos.Infos.Telefone or '0000-0000') or '0000-0000'
                local passaporte = getElementData(localPlayer, 'dbid') or 'n/a'
                local bank = convertNumber(getElementData(localPlayer, Config.keyBank) or 0)

                dxDrawImage(1580, 479, 246, 60, caiosvg['bar'], 0, 0, 0, tocolor(255, 255, 255, 255))
                dxDrawImage(1593, 479+13, 33, 33, caiosvg['bank'], 0, 0, 0, tocolor(79, 169, 251, 255))
                dxDrawText('Banka Hesap Bakiyesi', 1639, 479+13+5, 57, 13, tocolor(255, 255, 255, 255), 1, Global.Fonts["PoppinsRegular"][15], 'left', 'center')
                dxDrawText(bank.."₺", 1639, 479+13+15+5, 57, 13, tocolor(90, 90, 90, 255), 1, Global.Fonts["PoppinsRegular"][15], 'left', 'center')

                dxDrawImage(1580, 547, 246, 60, caiosvg['bar'], 0, 0, 0, tocolor(255, 255, 255, 255))
                dxDrawImage(1593, 547+13, 33, 33, caiosvg['pass'], 0, 0, 0, tocolor(79, 169, 251, 255))
                dxDrawText('IBAN', 1639, 547+13+5, 57, 13, tocolor(255, 255, 255, 255), 1, Global.Fonts["PoppinsRegular"][15], 'left', 'center')
                dxDrawText(passaporte, 1639, 547+13+15+5, 57, 13, tocolor(90, 90, 90, 255), 1, Global.Fonts["PoppinsRegular"][15], 'left', 'center')
                
                dxDrawImage(1580, 615, 246, 60, caiosvg['bar'], 0, 0, 0, tocolor(255, 255, 255, 255))
                dxDrawImage(1593, 628, 33, 33, caiosvg['tel'], 0, 0, 0, tocolor(79, 169, 251, 255))
                dxDrawText('Telefon Numarası', 1639, 628+5, 57, 13, tocolor(255, 255, 255, 255), 1, Global.Fonts["PoppinsRegular"][15], 'left', 'center')
                dxDrawText(telefone, 1639, 643+5, 57, 13, tocolor(90, 90, 90, 255), 1, Global.Fonts["PoppinsRegular"][15], 'left', 'center')
			elseif Global.Componentes.Aba == "Camera" then
				if myScreenSource then
					dxUpdateScreenSource( myScreenSource )    
					dxDrawImageSection( 1556+5,  380+3,  285, 610, 100,100,900,900,myScreenSource )
				end
                dxDrawImage(1556, 380, 295, 621, "assets/img/app-kamera/bg.png", 0, 0, 0, tocolor(255, 255, 255, 255))
                dxDrawImage(1677, 900, 50, 50, "assets/img/app-kamera/deklansor.png", 0, 0, 0,isCursorOnElement(1677, 900, 50, 50) and tocolor(255,255,255) or tocolor(200, 200, 200))
                dxDrawImage(1775, 900+7.5, 35, 35, "assets/img/app-kamera/mod.png", 0, 0, 0, tocolor(255, 255, 255, 255))
				dxDrawText("5-10 saniye sürmektedir.",1677,445,57,13,tocolor(255,255,255),1,Global.Fonts["PoppinsBold"][14],"center","top")
				fotoFlow = Fotolar or {}
				flowCountFoto = count(fotoFlow) or 0
				local getFlow = (fotoFlow)
				local flowTable = {}
				for i, v in pairs(getFlow) do
					flowTable[#flowTable + 1] = v
				end
				table.sort(flowTable,
					function(a, b)
						local indexOne = tonumber(a.sortIndexx)
						local indexTwo = tonumber(b.sortIndexx)
					return indexOne < indexTwo
				end
				)
				local counter = 0
				for i, v in pairs(flowTable) do
					if v.creator == getElementData(localPlayer,"dbid") then
					dxDrawImage(1600,  900+7.5,  35, 35, images[v.sortIndexx],0,0,0,tocolor(255,255,255),true)
					end
				end
			elseif Global.Componentes.Aba == "Harita" then
				dxDrawImage(1556, 380, 295, 621, "assets/img/app-harita/bg.png", 0, 0, 0, tocolor(255, 255, 255, 255))
			elseif Global.Componentes.Aba == "Galeri" then
				dxDrawImage(1556, 380, 295, 621, "assets/img/app-galeri/bg.png", 0, 0, 0, tocolor(255, 255, 255, 255))
				fotoFlow = Fotolar or {}
				flowCountFoto = count(fotoFlow) or 0
				local getFlow = (fotoFlow)
				local flowTable = {}
				for i, v in pairs(getFlow) do
					flowTable[#flowTable + 1] = v
				end
				table.sort(flowTable,
					function(a, b)
						local indexOne = tonumber(a.sortIndexx)
						local indexTwo = tonumber(b.sortIndexx)
					return indexOne > indexTwo
				end
				)
				local counter = 0
				local addX = 0
				local addY = 0
				for i, v in pairs(flowTable) do
					if v.creator == getElementData(localPlayer,"dbid") then
						dxDrawImage(1565+addX,460+addY,87,87, images[v.sortIndexx],0,0,0,tocolor(255,255,255))
						if isCursorOnElement(1565+addX,460+addY,87,87) and getKeyState("mouse1") then
							selectedImage = images[v.sortIndexx]
							imageCreator = v.creator
							imageIndexId = v.sortIndexx
							imageSelect = v.hashKey
							imageIndex = v.sortIndexx
							imageDate = v.date
							Global.Componentes.selectImage = true
							Global.imageSelecttt = {getTickCount(), 1920, 1920 + 700}
							selectX = 1565+addX
							selectY = 460+addY
						end
						addX = addX + 93
						if addX == 93*3 then
							addX = 0
							addY = addY + 93
						end
					end
				end
				if Global.Componentes.selectImage then
					local imageX = interpolateBetween(selectX,0,0,1558,0,0, (getTickCount() - Global.imageSelecttt[1])/150, "OutQuad")
					local imageY = interpolateBetween(selectY,0,0,460,0,0, (getTickCount() - Global.imageSelecttt[1])/150, "OutQuad")
					local imageW = interpolateBetween(87,0,0,290,0,0, (getTickCount() - Global.imageSelecttt[1])/150, "OutQuad")
					local imageH = interpolateBetween(87,0,0,475,0,0, (getTickCount() - Global.imageSelecttt[1])/150, "OutQuad")
					local imageWW = interpolateBetween(159,0,0,295,0,0, (getTickCount() - Global.imageSelecttt[1])/150, "OutQuad")
					local imageHH = interpolateBetween(255,0,0,621,0,0, (getTickCount() - Global.imageSelecttt[1])/150, "OutQuad")
					dxDrawImage(1556,380,imageWW,imageHH, "assets/img/app-galeri/bgg.png",0,0,0,tocolor(255,255,255))
					dxDrawImage(imageX,imageY,imageW,imageH, selectedImage,0,0,0,tocolor(255,255,255))
					dxDrawText("",1575,425,57,13,tocolor(0,155,255),1,Global.Fonts["awesome"][1],"left","top")
					dxDrawText(imageDate,1675,425,57,13,tocolor(16,16,16),1,Global.Fonts["PoppinsMedium"][13],"center","top")
					dxDrawText("",1695,945,57,13,tocolor(0,155,255),1,Global.Fonts["awesome"][1],"left","top")
					dxDrawText("",1695+115,945,57,13,tocolor(0,155,255),1,Global.Fonts["awesome"][1],"left","top")
					if isCursorOnElement(1570,425,25+5,25) and getKeyState("mouse1") then
						selectedImage = nil
						Global.Componentes.selectImage = false
					elseif isCursorOnElement(1690,940,25,25) and getKeyState("mouse1") then
						selectedImage = nil
						Global.Componentes.selectImage = false
						imageDate = nil
							setTimer(function()
						triggerServerEvent("photo:remove", localPlayer, localPlayer, imageSelect)
							end,0,1)
					end
				end
			elseif Global.Componentes.Aba == "Instagram" then
                dxDrawImage(1556, 380, 295, 621, "assets/img/app-instagram/bg.png", 0, 0, 0, tocolor(255, 255, 255, 255))
				if Global.Componentes.createPost then
					dxDrawText("Bir fotoğraf seç",1575,475-10,57,13,tocolor(225,225,225),1,Global.Fonts["PoppinsRegular"][15],"left","top")
					fotoFlow = Fotolar or {}
					flowCountFoto = count(fotoFlow) or 0
					local getFlow = (fotoFlow)
					local flowTable = {}
					for i, v in pairs(getFlow) do
						flowTable[#flowTable + 1] = v
					end
					table.sort(flowTable,
						function(a, b)
							local indexOne = tonumber(a.sortIndexx)
							local indexTwo = tonumber(b.sortIndexx)
						return indexOne > indexTwo
					end
					)
					local counter = 0
					local addX = 0
					local addY = 0
					for i, v in pairs(flowTable) do
						if i <= 9 then
							if v.creator == getElementData(localPlayer,"dbid") then
								dxDrawImage(1565+addX,500+addY,87,87, images[v.sortIndexx],0,0,0,tocolor(255,255,255))
								if isCursorOnElement(1565+addX,500+addY,87,87) and getKeyState("mouse1") and lastClick+400 <= getTickCount() then
									lastClick = getTickCount()
									selectedImagePost[v.hashKey] = images[v.sortIndexx]
									setElementData(root,"imgSort"..(v.sortIndexx),v.sortIndexx)
									triggerEvent("phone.showInfo",localPlayer,"instagram","Resim başarıyla seçildi.")
									imageSelectPost = v.sortIndexx
								end
								addX = addX + 93
								if addX == 93*3 then
									addX = 0
									addY = addY + 93
								end
							end
						end
					end
					dxDrawBordRectangle(1565,800,220,25,5,tocolor(200,200,200))
					dxDrawBordRectangle(1665+12.5,820+15,50,50,5,isCursorOnElement(1665,820,75,75) and tocolor(225,225,225) or tocolor(200,200,200))
					dxDrawText("",1680+12.5,838+10,57,13,tocolor(0,0,0),1,asoawesome,"left","top")
				else
					local instagramFlow = Cache or {}
					flowCount = count(instagramFlow) or 0
					if flowCount < maxRow and currentRow >= 4 then
						currentRow = 1
					end
					if flowCount == 0 then
						dxDrawText("Buralar boş..\nHadi, ilk postu sen oluştur!", 1675,700, 57, 13, tocolor(255, 255, 255), 1, Global.Fonts["PoppinsRegular"][15], "center", "center")
					else
						local getFlow = (instagramFlow)
						local flowTable = {}
						for i, v in pairs(getFlow) do
							flowTable[#flowTable + 1] = v
						end
						table.sort(flowTable,
							function(a, b)
								local indexOne = tonumber(a.sortIndex)
								local indexTwo = tonumber(b.sortIndex)
								return indexOne > indexTwo
							end
						)
						local counter = 0
						local addXX = 0
						for i, v in pairs(flowTable) do
							counter = counter + 1
							if counter >= currentRow and counter <= 2 then
								dxDrawRectangle(1555,510-30+addXX,295,202.5,tocolor(200,200,200))
								dxDrawText(v.charname, 1600,520-30+addXX,57,13, tocolor(35,35,35), 1, Global.Fonts["PoppinsBold"][14], "left", "top")
								dxDrawText(v.date, 1780, 520-30+(addXX), 57, 13, tocolor(35,35,35, 175), 1, Global.Fonts["PoppinsRegular"][11], "right", "top")
								if v.imgKey then
									dxDrawImage(1570,550-30+addXX,115,115,images[getElementData(root,"imgSort"..(v.imgKey))])
								end
								dxDrawText(stringDivide(v.text,40), 1575, 690-30+addXX, 57, 13, tocolor(35,35,35,255), 1, Global.Fonts["PoppinsRegular"][11], "left", "top", false, false, false, true)
								if integration:isPlayerDeveloper(localPlayer) then
									dxDrawText("", 1575+245, 672-30+addXX, 57, 13, isCursorOnElement(1570+245,668-30+addXX,20,20) and tocolor(0,0,0) or tocolor(35,35,35, 255), 1, asoawesome, "left", "top")
									if isCursorOnElement(1570+245,668-30+addXX,20,20) then
										if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
											lastClick = getTickCount()
											setTimer(function()
											triggerServerEvent("instagram:remove", localPlayer, localPlayer, v.hashKey)
											end,0,1)
										end
									end
								end
								dxDrawText("", 1575, 672-30+addXX, 57, 13,isCursorOnElement(1570+2,668-30+addXX,20,20) and tocolor(0,0,0) or tocolor(35,35,35, 255), 1,  asoawesome2, "left", "top")
								if isCursorOnElement(1570+2,668-30+addXX,20,20) and getKeyState("mouse1") and lastClick+200 <= getTickCount() then
									lastClick = getTickCount()
									setTimer(function()
									triggerServerEvent("instagram:like", localPlayer, localPlayer, v.hashKey)
									end,0,1)
								end
								dxDrawText(count(v.data.like).." liked", 1575+25, 672-30+addXX, 57, 13,tocolor(35,35,35, 255), 1,  Global.Fonts["PoppinsRegular"][13], "left", "top")
								addXX = addXX + 212.5
							end
						end
					end
                end
			elseif Global.Componentes.Aba == "Twitter" then
				dxDrawImage(1556, 380, 295, 621, "assets/img/app-tweet/bg.png", 0, 0, 0, tocolor(255, 255, 255, 255))
				dxDrawRectangle(1556,905,295,1,tocolor(255,255,255,50))
				dxDrawImage(1800, 920, 35, 35, "assets/img/app-tweet/tweet.png", 0, 0, 0,isCursorOnElement(1800, 920, 35, 35) and tocolor(255,255,255) or tocolor(200, 200, 200, 255))
				twitterFlow = Cachetwe or {}
				flowCount = count(twitterFlow) or 0
				if flowCount < maxRow and currentRow >= 3 then
					currentRow = 1
				end
				if flowCount == 0 then
					dxDrawText("Buralar boş..\nHadi, ilk postu sen oluştur!", 1675,700, 57, 13, tocolor(255, 255, 255), 1, Global.Fonts["PoppinsRegular"][15], "center", "center")
				else
					local getFlow = (twitterFlow)
					local flowTable = {}
					for i, v in pairs(getFlow) do
						flowTable[#flowTable + 1] = v
					end
					table.sort(flowTable,
						function(a, b)
							local indexOne = tonumber(a.sortIndex)
							local indexTwo = tonumber(b.sortIndex)
							return indexOne > indexTwo
						end
					)
					local counter = 0
					for i, v in pairs(flowTable) do
						counter = counter + 1
						if counter >= currentRow and counter <= 5 then
							dxDrawText(v.name, 1575, 368+(i*90), 57, 13, tocolor(255,255,255), 0.8, Global.Fonts["PoppinsBold"][16], "left", "top")
							dxDrawText(stringDivide(v.text,25), 1595, 368+20+(i*90), 57, 13, tocolor(255,255,255), 0.75, Global.Fonts["PoppinsRegular"][15], "left", "top", false, false, false, true)
							dxDrawText(v.date, 1780, 368+(i*90), 57, 13, tocolor(255,255,255, 100), 0.8, Global.Fonts["PoppinsRegular"][15], "right", "top")
							dxDrawRectangle(1556,370+75+(i*90),295,1,tocolor(255,255,255,50))
							if integration:isPlayerDeveloper(localPlayer) then
								dxDrawText("", 1600, 368+50+(i*90), 57, 13, tocolor(232, 65, 24, 255), 0.7, asoawesome, "left", "top")
								if isCursorOnElement(1592,370+46+(i*90),25,25) then
									if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
										lastClick = getTickCount()
										setTimer(function()
										triggerServerEvent("tweet:remove", localPlayer, localPlayer, v.hashKey)
										end,0,1)
									end
								end
							end
							dxDrawText("", 1660, 368+50+(i*90), 57, 13,tocolor(200,200,200, 255), 0.6, asoawesome, "left", "top")
							dxDrawText(""..count(v.data.like), 1755, 368+50+(i*90), 57, 13,isCursorOnElement(1750-3,370+46+(i*90),25,25) and tocolor(255,200,200) or tocolor(200,200,200, 255), 0.6, asoawesome, "left", "top")
							if isCursorOnElement(1750-3,370+46+(i*90),25,25) and getKeyState("mouse1") and lastClick+200 <= getTickCount() then
								lastClick = getTickCount()
								setTimer(function()
								triggerServerEvent("tweet:like", localPlayer, localPlayer, v.hashKey)
								end,0,1)
							end
						end
					end
				end
			elseif Global.Componentes.Aba == "Darkweb" then
				if Global.Componentes.darkwebSettings == true then
					dxDrawImage(1556, 380, 295, 621, "assets/img/app-darkweb/sett.png", 0, 0, 0, tocolor(255, 255, 255, 255))
					dxDrawRectangle(1575,700,250,30,isCursorOnElement(1575,700,250,40) and tocolor(235,235,235) or tocolor(200,200,200))
					dxDrawRectangle(1575,740,250,30,isCursorOnElement(1575,740,250,40) and tocolor(235,235,235) or tocolor(200,200,200))
					dxDrawRectangle(1575,780,250,40,isCursorOnElement(1575,780,250,40) and tocolor(160,160,97) or tocolor(110,110,67))
					dxDrawText("Kaydet",1675,789,57,13,isCursorOnElement(1575,780,250,40) and tocolor(255,255,255) or tocolor(200,200,200),1,Global.Fonts["PoppinsBold"][16],"center","top")
					dxDrawText("",1580,435,57,13,isCursorOnElement(1575,430,25,25) and tocolor(255,255,255) or tocolor(200,200,200),1,asoawesome,"left","top")
				else
					dxDrawImage(1556, 380, 295, 621, "assets/img/app-darkweb/bg.png", 0, 0, 0, tocolor(255, 255, 255, 255))
					dxDrawText("",1805,435,57,13,isCursorOnElement(1800,430,25,25) and tocolor(255,255,255) or tocolor(200,200,200),1,asoawesome,"left","top")
					dxDrawBordRectangle(1575,920,250,35,5,tocolor(200,200,200))
					dxDrawBordRectangle(1575,920,50,35,5,isCursorOnElement(1575,920,50,35) and tocolor(125,125,125) or tocolor(175,175,175))
					dxDrawText("",1588,927,57,13,isCursorOnElement(1575,920,50,35) and tocolor(16,16,16) or tocolor(35,35,35),1,asoawesome2,"left","top")
					dxDrawBordRectangle(1775,920,50,35,5,isCursorOnElement(1775,920,50,35) and tocolor(140,140,97) or tocolor(110,110,67))
					dxDrawText("Yolla",1785,930,57,13,isCursorOnElement(1775,920,50,35) and tocolor(255,255,255) or tocolor(225,225,225),1,Global.Fonts["PoppinsRegular"][13],"left","top")
					darkwebFlow = Cachedw or {}
					flowCount = count(darkwebFlow) or 0
					if flowCount < maxRow and currentRow >= 3 then
						currentRow = 1
					end
					if flowCount == 0 then
						dxDrawText("Buralar boş..\nHadi, ilk postu sen oluştur!", 1675,700, 57, 13, tocolor(255, 255, 255), 1, Global.Fonts["PoppinsRegular"][15], "center", "center")
					else
						local getFlow = (darkwebFlow)
						local flowTable = {}
						for i, v in pairs(getFlow) do
							flowTable[#flowTable + 1] = v
						end
						table.sort(flowTable,
							function(a, b)
								local indexOne = tonumber(a.sortIndex)
								local indexTwo = tonumber(b.sortIndex)
								return indexOne > indexTwo
							end
						)
						local counter = 0
						local imgX = 0
						local dwCounter = 1
						for i, v in pairs(flowTable) do
							counter = counter + 1
							if counter >= currentRow and counter <= dwCounter then
								dxDrawImage(1565, 310+50+(i*70)+imgX, 25, 25, resim[v.creator] or "assets/avatars/1.png", 0, 0, 0)
								dxDrawImage(1565, 310+50+(i*70)+imgX, 25, 25, "assets/img/inicio/avbgd.png")
								dxDrawText(v.name, 1595, 310+50+(i*70)+imgX, 57, 13, tocolor(255,255,255), 0.8, Global.Fonts["PoppinsBold"][16], "left", "top")
								dxDrawText(stringDivide(v.text,25), 1575, 268+78+50+(i*70)+imgX, 57, 13, tocolor(255,255,255), 0.9, Global.Fonts["PoppinsRegular"][15], "left", "top", false, false, false, true)
								dxDrawText(v.date, 1595, 255+70+50+(i*70)+imgX, 57, 13, tocolor(255,255,255, 100), 0.8, Global.Fonts["PoppinsRegular"][15], "right", "top")
								if v.imgKey then
									dxDrawImage(1570,380+45+(i*70)+imgX,125,85,images[getElementData(root,"imgSort"..(v.imgKey))])
									imgX = imgX + 130
									dxDrawRectangle(1556,400+(i*70)+imgX,295,2,tocolor(255,255,255,50))
								else
									dxDrawRectangle(1556,370+50+(i*70)+imgX,295,2,tocolor(255,255,255,50))
								end
								if integration:isPlayerDeveloper(localPlayer) then
									dxDrawText("", 1770, 360+(i*70)+imgX, 57, 13, tocolor(232, 65, 24, 255), 0.7, asoawesome, "left", "top")
									if isCursorOnElement(1770,360+(i*70)+imgX,25,25) then
										if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
											lastClick = getTickCount()
											setTimer(function()
											triggerServerEvent("darkweb:remove", localPlayer, localPlayer, v.hashKey)
											end,0,1)
										end
									end
								end
								if (i*70 + imgX <= 370) then
									dwCounter = dwCounter + 1
								else	
									dwCounter = dwCounter - 1
								end
							end
						end
					end
					if Global.Componentes.darkwebGallery == true then
						ChangeAba("Darkweb")
						fotoFlow = Fotolar or {}
						flowCountFoto = count(fotoFlow) or 0
						local getFlow = (fotoFlow)
						local flowTable = {}
						for i, v in pairs(getFlow) do
							flowTable[#flowTable + 1] = v
						end
						table.sort(flowTable,
							function(a, b)
								local indexOne = tonumber(a.sortIndexx)
								local indexTwo = tonumber(b.sortIndexx)
							return indexOne > indexTwo
						end
						)
						local counter = 0
						local addX = 0
						local addY = 0
						dxDrawBordRectangle(1561, 827, 284, 172, 25, tocolor(255, 255, 255, 255))
						for i, v in pairs(flowTable) do
							if i <= 6 then
								if v.creator == getElementData(localPlayer,"dbid") then
									dxDrawImage(1585+addX,905+addY,65,65, images[v.sortIndexx],0,0,0,tocolor(255,255,255))
									if isCursorOnElement(1585+addX,905+addY,65,65) and getKeyState("mouse1") and lastClick+400 <= getTickCount() then
										lastClick = getTickCount()
										selectedImagePost[v.hashKey] = images[v.sortIndexx]
										setElementData(root,"imgSort"..(v.sortIndexx),v.sortIndexx)
										triggerEvent("phone.showInfo",localPlayer,"darkweb","Resim başarıyla seçildi.")
										imageSelectPost = v.sortIndexx
									end
									addX = addX + 83
									if addX == 83*3 then
										addX = 0
										addY = addY + -70
									end
								end
							end
						end
					end
				end
				if (getElementData(localPlayer,"darkweb:accountCreate") or 0) == 0 then 
					dxDrawImage(1556, 380, 295, 621, "assets/img/app-darkweb/auth.png", 0, 0, 0, tocolor(255, 255, 255, 255))
					dxDrawRectangle(1575,700,250,30,isCursorOnElement(1575,700,250,40) and tocolor(235,235,235) or tocolor(200,200,200))
					dxDrawRectangle(1575,740,250,30,isCursorOnElement(1575,740,250,40) and tocolor(235,235,235) or tocolor(200,200,200))
					dxDrawRectangle(1575,780,250,40,isCursorOnElement(1575,780,250,40) and tocolor(160,160,97) or tocolor(110,110,67))
					dxDrawText("Hesap Oluştur",1675,789,57,13,isCursorOnElement(1575,780,250,40) and tocolor(255,255,255) or tocolor(200,200,200),1,Global.Fonts["PoppinsBold"][16],"center","top")
				end
			elseif Global.Componentes.Aba == "Spotify" then
				dxDrawImage(1556, 380, 295, 621, "assets/img/app-spotify/bg.png", 0, 0, 0, tocolor(255, 255, 255, 255))
				dxDrawText(getPlayerName(localPlayer),1617,441,57,13,tocolor(255,255,255),0.95,Global.Fonts["PoppinsBold"][14],"left","top")
				if musicDuration then
					dxDrawBordRectangle(1602,945,195,5,5,tocolor(25,25,25,150))
					dxDrawBordRectangle(1602,945,musicDuratSay,5,5,tocolor(29,185,84,235))
					if musicDuratSay == musicDuration then killTimer(timersay) end
					dxDrawBordRectangle(1800,880,25,25,10,isCursorOnElement(1800,880,25,25) and tocolor(29,185,84,255) or tocolor(29,185,84,150))
					if played == true then
						dxDrawText("", 1803, 883, 57, 13,isCursorOnElement(1800,880,25,25) and tocolor(255,255,255) or tocolor(235,235,235, 255), 0.7, asoawesome, "left", "top")	
					else
						dxDrawText("", 1807, 884, 57, 13,isCursorOnElement(1800,880,25,25) and tocolor(255,255,255) or tocolor(235,235,235, 255), 0.7, asoawesome, "left", "top")	
					end
				end
				if musicArtist then
					dxDrawText(kisalt(musicArtist,27),1602,902+20,57,13,tocolor(200,200,200),0.95,Global.Fonts["PoppinsBold"][14],"left","top")
				end
				if musicTitle then
					dxDrawText(kisalt(musicTitle,27),1602,902,57,13,tocolor(255,255,255),0.9,Global.Fonts["PoppinsRegular"][15],"left","top")
				end
				local spocounter = 0
				for i, v in pairs(musicList) do
					spocounter = spocounter + 1
					if spocounter >= 1 and spocounter <= 6 then
						dxDrawBordRectangle(1570,445+(i*60),260,50,5,isCursorOnElement(1570,445+(i*60),260,50) and tocolor(20,20,20) or tocolor(16,16,16,200))
						dxDrawText(kisalt(v.title,27),1580,450+(i*60),57,13,tocolor(255,255,255),0.9,Global.Fonts["PoppinsRegular"][15],"left","top")
						dxDrawText(kisalt(v.artist,25),1580,450+18+(i*60),57,13,isCursorOnElement(1570,445+(i*60),260,50) and tocolor(235,235,235) or tocolor(200,200,200),0.95,Global.Fonts["PoppinsBold"][14],"left","top")
						dxDrawText(convertToTime(v.duration),1760,450+18+(i*60),57,13,tocolor(200,200,200),0.95,Global.Fonts["PoppinsBold"][14],"right","top")
					end
				end
				if spocounter == 0 then
					dxDrawText("Sonuç bulunamadı..\nArama yapmaya ne dersin?", 1675,700, 57, 13, tocolor(255, 255, 255), 1, Global.Fonts["PoppinsRegular"][15], "center", "center")
				end
			end
            if Global.Componentes.Aba then
				if Global.Componentes.Aba == "Galeri" or Global.Componentes.Aba == "Harita" or Global.Componentes.Aba == "Config" or Global.Componentes.Aba == "Notify" or Global.Componentes.Aba == "config.wallpaper" then
					dxDrawBordRectangle(1634, 977, 137, 6, 5, isCursorOnElement(1634, 977, 137, 6) and tocolor(0, 0, 0, 217) or tocolor(0, 0, 0, 127), true)
				elseif Global.Componentes.Aba == "kilitEkran" then
					dxDrawBordRectangle(1634, 977, 137, 6, 5, isCursorOnElement(1634, 977, 137, 6) and tocolor(100, 100, 100, 100) or tocolor(75, 75, 75, 100), true)
				else
					dxDrawBordRectangle(1634, 977, 137, 6, 5, isCursorOnElement(1634, 977, 137, 6) and tocolor(203, 204, 205, 217) or tocolor(203, 204, 205, 127), true)
				end
            end
        
        end
    end    
    if (not Global.Componentes.Aba or Global.Componentes.Aba ~= "Telefone") then
		if Global.Componentes.Aba == "Galeri" or Global.Componentes.Aba == "Config" or Global.Componentes.Aba == "Notify" or Global.Componentes.Aba == "config.wallpaper" then
			dxDrawText(Hora..":"..Minuto, 1581, 394, 0, 0, tocolor(0, 0, 0, 255), 1, Global.Fonts["PoppinsMedium"][31])
			dxDrawImage(1793-32, 383, 75, 40, "assets/img/inicio/statusbar.png", 0, 0, 0, tocolor(0, 0, 0))
			if ucakmodu == true then
				dxDrawImage(1625, 395, 15, 15, "assets/img/app-png/airplane.png", 0, 0, 0, tocolor(0, 0, 0, 255))
			end
		else
			dxDrawText(Hora..":"..Minuto, 1581, 394, 0, 0, tocolor(255, 255, 255, 255), 1, Global.Fonts["PoppinsMedium"][31])
			dxDrawImage(1793-32, 383, 75, 40, "assets/img/inicio/statusbar.png", 0, 0, 0)
			if ucakmodu == true then
				dxDrawImage(1625, 395, 15, 15, "assets/img/app-png/airplane.png", 0, 0, 0, tocolor(255, 255, 255, 255))
			end
		end
    end
	if Global.Componentes.Aba == nil then
	dxDrawBordRectangle(1634, 985, 137, 6, 5, isCursorOnElement(1634, 985, 137, 6) and tocolor(0, 0, 0, 255) or tocolor(0, 0, 0, 200), true)
    end
    dxDrawImage(1531, 359, 344, 672, "assets/img/overlay.png", 0, 0, 0)
end

function kisalt(metin, uzunluk)
    if #metin > uzunluk then
        return string.sub(metin, 1, uzunluk - 3) .. "..."
    else
        return metin
    end
end

function stringDivide(text,limit)
    local new_text = ""
    if (string.len(text)>limit) then 
        local i = math.floor(string.len(text)/limit)
        local c = 1
        for l=1,i do 
            new_text = new_text .. string.sub(text,c,l*limit) .. "\n"
            c = l* limit +1
        end
        new_text = new_text .. string.sub(text,c,string.len(text))
        return new_text
    end
    return text
end

function convertToTime(text)
    local minutes = tonumber(text)
    local hours = math.floor(minutes / 60)
    local mins = minutes % 60
    return string.format("%d:%02d", hours, mins)
end

function convertTime(ms)
    local min = math.floor( ms/60000 )
    local sec = math.floor( (ms/1000)%60 )
    return min, sec 
end

function ChangeAba(aba)
    Global2.Functions["DestroyEdit"]("Traniner")
    Global2.Functions["DestroyEdit"]("Buscar")
    Global2.Functions["DestroyEdit"]("Buscar2")
    Global2.Functions["DestroyEdit"]("Mensagem")
    Global2.Functions["DestroyEdit"]("Add")
    Global2.Functions["DestroyEdit"]("dwMessage")
    Global2.Functions["DestroyEdit"]("dwAccount")
    Global2.Functions["DestroyEdit"]("dwAvatar")
    Global2.Functions["DestroyEdit"]("post")
    Global2.Functions["DestroyEdit"]("tweetPostMess")
    Global2.Functions["DestroyEdit"]("spotifySearch")
    Global2.Functions["DestroyEdit"]("Papel")
    Global2.Functions["DestroyEdit"]("ID")
	if cammod == true then
		triggerEvent("selfiephone",localPlayer)
		setElementData(localPlayer,"selfiemod",false)
		cammod = false
	end
    if Global.Componentes.ScrollWhatsapp then
        Global.Componentes.ScrollWhatsapp:Destroy()
        Global.Componentes.ScrollWhatsapp = nil
    end
    if Global.Componentes.Render and isElement(Global.Componentes.Render) then
        destroyElement(Global.Componentes.Render)
        Global.Componentes.Render = nil
    end
    Global.Componentes.Traninerir = nil
    Check.DestroyChecks()
    if aba == "Whatsapp" then
        Global2.Functions["CreateEdit"]("Buscar", 1631, 491, 180, 18, 15, false, tocolor(241, 241, 241, 255), tocolor(0, 0, 0, 0), "Sohbet ara", Global.Fonts["PoppinsRegular"][13], 1, false)
        Global.Componentes.Render = dxCreateRenderTarget(238, 353, true)
        local Conversas = Global.Componentes.Infos["Whatsapp"]
        Global.Componentes.ConversasWhatsapp = Conversas

        UpdateRender("Conversas", 0)
        if #Conversas > 4 and not Global.Componentes.ScrollWhatsapp then
            Global.Componentes.ScrollWhatsapp = ScrollBar.CreateScroll(1841, 589, 4, 362, 71, tocolor(255, 255, 255, 25), tocolor(124, 216, 134, 255), tocolor(61, 159, 72, 255), false)
        end
    elseif aba == "Whatsapp-Conversa" then
        Global2.Functions["CreateEdit"]("Mensagem", 1590, 924, 195, 39, 100, false, tocolor(241, 241, 241, 255), tocolor(0, 0, 0, 0), "Buraya yaz", Global.Fonts["PoppinsRegular"][13], 1, false)
        Global.Componentes.Render = dxCreateRenderTarget(243, 412, true)
        
        UpdateRender("Mensagem", 0)
        if #Global.Componentes.PositionsWhatsapp ~= 0 then
            local UltimaPosicao = Global.Componentes.PositionsWhatsapp[#Global.Componentes.PositionsWhatsapp][2] + Global.Componentes.PositionsWhatsapp[#Global.Componentes.PositionsWhatsapp][4] - 412
            if UltimaPosicao > 0 then
                UpdateRender("Mensagem", UltimaPosicao)
            end
        end
    elseif aba == "Contatos" then
        Global2.Functions["CreateEdit"]("Buscar2", 1631, 491, 180, 18, 15, false, tocolor(241, 241, 241, 255), tocolor(0, 0, 0, 0), "Kişi ara", Global.Fonts["PoppinsRegular"][13], 1, false)
        Global.Componentes.Render = dxCreateRenderTarget(260, 389, true)
        Global.Componentes.Contatoinormat = FormartContatos(Global.Componentes.Infos["Contatos"])
        UpdateRender("Contatos", 0)
    elseif aba == "Config" then
        local InfosNotify = Global.Notify
        Check.CreateCheck(1780, 745, 43, 22, tocolor(203, 203, 203, 255), tocolor(88, 189, 129, 255), 1, InfosNotify.LigacaoAnonima)
    elseif aba == "Notify" then
        local InfosNotify = Global.Notify
        Check.CreateCheck(1800, 500, 18, 18, nil, nil, 2, InfosNotify.Mensagens)
        Check.CreateCheck(1800, 540, 18, 18, nil, nil, 3, InfosNotify.Ligacoes)
        Check.CreateCheck(1800, 580, 18, 18, nil, nil, 4, InfosNotify.MensagensEstranhos)
	elseif aba == "Twitter" then
		Global.Componentes.tweetPost = true
		if Global.Componentes.tweetPost then
			Global2.Functions["CreateEdit"]("tweetPostMess", 1580, 928, 202, 20, 40, false, tocolor(215,215,215, 255), tocolor(0, 0, 0, 0), "Neler düşünüyorsun?", Global.Fonts["PoppinsRegular"][13], 1, false)
		end
	elseif aba == "Spotify" then
		Global.Componentes.spotifySearch = true
		if Global.Componentes.spotifySearch then
			Global2.Functions["CreateEdit"]("spotifySearch", 1610, 474, 202, 20, 24, false, tocolor(255,255,255, 255), tocolor(0, 0, 0, 0), "Bir şarkı arat!", Global.Fonts["PoppinsRegular"][13], 0.8, false)
		end
    elseif aba == "Telefone" then
        Global.Componentes.Number = ""
	elseif aba == "Harita" then
		Global2.Functions["CreateEdit"]("ID", 1625, 825, 250, 20, 40, false, tocolor(71, 71, 71, 255), tocolor(0, 0, 0, 0), "ID Giriniz", Global.Fonts["PoppinsRegular"][13], 1, true)
	elseif aba == "Darkweb" then
		if (getElementData(localPlayer,"darkweb:accountCreate") or 0) == 0 then
			Global2.Functions["CreateEdit"]("dwAccount", 1585, 705, 202, 20, 24, false, tocolor(46,46,46, 255), tocolor(0, 0, 0, 0), "Görünecek isim.", Global.Fonts["PoppinsRegular"][15], 1, false)
			Global2.Functions["CreateEdit"]("dwAvatar", 1585, 745, 202, 20, 40, false, tocolor(46,46,46, 255), tocolor(0, 0, 0, 0), "Görünecek resim. (URL)", Global.Fonts["PoppinsRegular"][15], 1, false)
		else
			if Global.Componentes.darkwebSettings ~= true then
				Global2.Functions["CreateEdit"]("dwMessage", 1628, 930, 125, 20, 40, false, tocolor(46,46,46, 255), tocolor(0, 0, 0, 0), "Bir mesaj yolla.", Global.Fonts["PoppinsRegular"][15], 1, false)
			end
		end
		if Global.Componentes.darkwebSettings == true then
			Global2.Functions["CreateEdit"]("dwAccount", 1585, 705, 202, 20, 24, false, tocolor(46,46,46, 255), tocolor(0, 0, 0, 0), "Görünecek isim.", Global.Fonts["PoppinsRegular"][15], 1, false)
			Global2.Functions["CreateEdit"]("dwAvatar", 1585, 745, 202, 20, 40, false, tocolor(46,46,46, 255), tocolor(0, 0, 0, 0), "Görünecek resim. (URL)", Global.Fonts["PoppinsRegular"][15], 1, false)
		end
		if Global.Componentes.darkwebGallery == true then
			Global2.Functions["DestroyEdit"]("dwMessage")
		end
	elseif aba == "Camera" then
        triggerEvent("selfiephone",localPlayer)
		cammod = true
    end
end

function searchMusic(responseData, errorCode)
	local response = fromJSON(responseData)
	musicList = {}
	for i, muzik in pairs(response["response"]["items"]) do
		table.insert(musicList, {artist = muzik.artist, title = muzik.title, url = muzik.ads.content_id, duration = muzik.ads.duration})
	end
end	

addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
    if Global.Celular then
        if state == "down" then
			if Global.Componentes.Aba == nil then
				if isCursorOnElement(1634, 985, 137, 6) then
					closeCell()
				end
			end
            if not Global.Componentes.Aba then
                local PosXApps, PosYApps = 0, 0
                for i = 1,24 do
                    if Global.PosApps.Normal[tostring(i)] then
                        if isCursorOnElement(1592 - 17 + (70 * PosXApps), 444+145 + (76 * PosYApps), 48, 48) then
                            if button == "right" then
                                Global.Componentes.SelectedApp = i
                            else
                                local Nome = Global.PosApps.Normal[tostring(i)]
                                Global.Componentes.Aba = string.upper(string.sub(Nome, 1, 1))..string.sub(Nome, 2, #Nome)
                                Global.Componentes.TickAba = {getTickCount(), {1592 - 17 + (70 * PosXApps), 444+145 + (76 * PosYApps), 48, 48}, {1561, 382, 284, 618}, Nome}
                                ChangeAba(string.upper(string.sub(Nome, 1, 1))..string.sub(Nome, 2, #Nome))
                            end
                        end
                    end
					PosXApps = PosXApps + 1
					if PosXApps == 4 then
						PosXApps = 0
						PosYApps = PosYApps + 1
					end
                end
                for i = 1,4 do
                    if Global.PosApps.Bar[tostring(i)] then
                        if isCursorOnElement(1522 + (63 * i), 933, 48, 48) then
                            if button == "right" then
                            else
                                local Nome = Global.PosApps.Bar[tostring(i)]
                                Global.Componentes.Aba = string.upper(string.sub(Nome, 1, 1))..string.sub(Nome, 2, #Nome)
                                Global.Componentes.TickAba = {getTickCount(), {1522 + (63 * i), 933, 48, 48}, {1561, 382, 284, 618}, Nome}
                                ChangeAba(string.upper(string.sub(Nome, 1, 1))..string.sub(Nome, 2, #Nome))
                            end
                        end
                    end
                end
            else
                if button == "left" then
                    if Global.Componentes.Aba == "Banco" then
                        if not Global.Componentes.Traninerir then
                            if isCursorOnElement(1603, 602, 200, 47) then
                                Global.Componentes.Traninerir = {1}
                                Global2.Functions["CreateEdit"]("Traniner", 1614, 899, 201, 20, 8, false, tocolor(71, 71, 71, 255), tocolor(0, 0, 0, 0), "TR", Global.Fonts["PoppinsRegular"][13], 1, true)
                            end
                        else
                            if isCursorOnElement(1561, 409, 284, 417) then
                                Global2.Functions["DestroyEdit"]("Traniner")
                                Global.Componentes.Traninerir = nil
                            end
                            if Global.Componentes.Traninerir then
                                if Global.Componentes.Traninerir[1] == 1 then
                                    if isCursorOnElement(1673, 939, 61, 23) then
                                        local ID = Global2.Functions["GetTextEdit"]("Traniner")
                                        if ID ~= "" then
                                            Global.Componentes.Traninerir[2] = tonumber(ID)
                                            Global.Componentes.Traninerir[1] = 2 
                                            Global2.Functions["SetInfoEdit"]("Traniner", "Text2", "Değer")
                                            Global2.Functions["SetInfoEdit"]("Traniner", "Text", "")
                                        end
                                    end
                                elseif Global.Componentes.Traninerir[1] == 2 then
									if isCursorOnElement(1673, 939, 61, 23) then
										local Valor = Global2.Functions["GetTextEdit"]("Traniner")
										
										triggerServerEvent("174.SendMoney__key:3u6g7jj77", localPlayer, Global.Componentes.Traninerir[2], tonumber(Valor))
										      
										
										Global2.Functions["DestroyEdit"]("Traniner")
										Global.Componentes.Traninerir = nil
									end
                                end
                            end
                        end
                    elseif Global.Componentes.Aba == "Whatsapp" then
						countt = 0
                        if Global.Componentes.IniciarConversa then
                            if Global.Componentes.IniciarConversa[1] == 1 and not isCursorOnElement(1561, 849, 284, 151) then
                                Global.Componentes.IniciarConversa = nil
                                return
                            end
                            if Global.Componentes.IniciarConversa[1] == 2 and not isCursorOnElement(1561, 807, 284, 192) then
                                Global.Componentes.IniciarConversa = nil
                                return
                            end
                            if Global.Componentes.IniciarConversa[1] == 1 then
                                if isCursorOnElement(1664, 923, 79, 26) then
                                    Global.Componentes.IniciarConversa = {2, 1}
                                end
                            elseif Global.Componentes.IniciarConversa[1] == 2 then
                                local Broken = isNumberBroken((#Global.Componentes.Contatoinormatados / 2))
                                local TotalAbas = (Broken and math.floor((#Global.Componentes.Contatoinormatados / 2)) + 1 or (#Global.Componentes.Contatoinormatados / 2))
                                for i = 1,2 do
                                    local v = Global.Componentes.Contatoinormatados[Global.Componentes.IniciarConversa[2] - 1 + i]
                                    if v then
                                        if isCursorOnElement(1561, 871 - 31 + (31 * i), 284, 26) then
                                            Global.Componentes.Aba = "Whatsapp-Conversa"
                                            Global.Componentes.Select = v[1]
                                            ChangeAba("Whatsapp-Conversa")
                                            Global.Componentes.IniciarConversa = nil
                                            break
                                        end
                                    end
                                end
                            end
                            return
                        end
                        if isCursorOnElement(1583, 586, 238, 353) then
                            for i = 1,#Global.Componentes.PosicoesRender["Conversas"] do
                                local v = Global.Componentes.PosicoesRender["Conversas"][i]
                                if isCursorOnElement(v[1] + 1583, v[2] + 586 - Global.Componentes.PosRender, v[3], v[4]) then
                                    Global.Componentes.Aba = "Whatsapp-Conversa"
                                    local Recebendo = Global.Componentes.ConversasWhatsapp[v[5]].Recebendo
                                    Global.Componentes.Select = Recebendo
                                    ChangeAba("Whatsapp-Conversa")
                                    break
                                end
                            end
                        elseif isCursorOnElement(1787, 942, 38, 38) then
                            Global.Componentes.Contatoinormatados = {}
                            for telefone,nome in pairs(Global.Componentes.Infos.Contatos) do
                                Global.Componentes.Contatoinormatados[#Global.Componentes.Contatoinormatados + 1] = {telefone, nome}
                            end
                            table.sort(Global.Componentes.Contatoinormatados, function(a, b)
                                return (a[2] < b[2])
                            end)
                            Global.Componentes.IniciarConversa = {1}
                        end
                    elseif Global.Componentes.Aba == "Whatsapp-Conversa" then
                        if Global.Componentes.Anexo then
                            if Global.Componentes.selecionarContatosWhatsapp then
                                for i = 1,2 do
                                    local v = Global.Componentes.Contatoinormatados[Global.Componentes.selecionarContatosWhatsapp[2] - 1 + i]
                                    if v then
                                        if isCursorOnElement(1561, 871 - 31 + (31 * i), 284, 26) then
										setTimer(function()
                                            triggerServerEvent("174.NewConversa__key:si8q2vlud", localPlayer, Global.Componentes.Select, v[2]..': '..v[1], "msg")
											end,0,1)
                                        end
                                    end
                                end
                                Global.Componentes.Anexo = nil
                                Global.Componentes.selecionarContatosWhatsapp = nil
                            else
                                if isCursorOnElement(1652, 879, 101, 26) then
                                    local x, y, z = getElementPosition(localPlayer)
                                    local Area = getZoneName(x, y, z)
									setTimer(function()
                                    triggerServerEvent("174.NewConversa__key:si8q2vlud", localPlayer, Global.Componentes.Select, "Lokasyon", "loc", {getElementPosition(localPlayer)})
                                    end,0,1)
									Global.Componentes.Anexo = nil
                                    Global.Componentes.selecionarContatosWhatsapp = nil
                                elseif isCursorOnElement(1667, 920, 70, 26) then
                                    Global.Componentes.Contatoinormatados = {}
                                    for telefone,nome in pairs(Global.Componentes.Infos.Contatos) do
                                        Global.Componentes.Contatoinormatados[#Global.Componentes.Contatoinormatados + 1] = {telefone, nome}
                                    end
                                    table.sort(Global.Componentes.Contatoinormatados, function(a, b)
                                        return (a[2] < b[2])
                                    end)
                                    Global.Componentes.selecionarContatosWhatsapp = {1, 1}
                                else
                                    Global.Componentes.selecionarContatosWhatsapp = nil
                                    Global.Componentes.Anexo = nil
                                end
                            end
                        end
                        if #Global.Componentes.PositionsWhatsapp ~= 0 then
                            local UltimaPosicao = Global.Componentes.PositionsWhatsapp[#Global.Componentes.PositionsWhatsapp][2] + Global.Componentes.PositionsWhatsapp[#Global.Componentes.PositionsWhatsapp][4] - 412
                            if UltimaPosicao > 0 then
                                if Global.Componentes.PosRender ~= UltimaPosicao then
                                    if isCursorOnElement(1793, 882, 26, 26) then
                                        UpdateRender("Mensagem", UltimaPosicao)
                                    end
                                end
                            end
                        end
                        if isCursorOnElement(1791, 924, 39, 39) then
                            Global.Componentes.Anexo = {}
                        end
                    elseif Global.Componentes.Aba == "Contatos" then
                        if Global.Componentes.AddContato then
                            if isCursorOnElement(1561, 827, 284, 172) then
                                if isCursorOnElement(1673, 939, 61, 23) then
                                    if #Global.Componentes.AddContato == 0 then
                                        local Telefone = Global2.Functions["GetTextEdit"]("Add")
                                        if #Telefone == 9 then
                                            Global.Componentes.AddContato[1] = Telefone
                                            Global2.EditBox["Add"].Text = ""
                                            Global2.EditBox["Add"].Text2 = "ISIM"
                                            Global2.EditBox["Add"].Number = false
                                        else
											drawInfo("Contatos","Geçersiz Numara.")
                                        end
                                    elseif #Global.Componentes.AddContato == 1 then
                                        local Nome = Global2.Functions["GetTextEdit"]("Add")
                                        if Nome ~= "" then
                                            Global.Componentes.AddContato[2] = Nome
											setTimer(function()
												triggerServerEvent("174.AddContato__key:ris0wpnfw", localPlayer, Global.Componentes.AddContato[1], Global.Componentes.AddContato[2])
												Global.Componentes.AddContato = nil
												Global2.Functions["DestroyEdit"]("Add")
											end,0,1)
                                        else
											drawInfo("Contatos","Hata.")
                                        end
                                    end
                                end
                            else
                                Global.Componentes.AddContato = nil
                                Global2.Functions["DestroyEdit"]("Add")
                            end
                            return
                        end
                        if isCursorOnElement(1801, 443, 12, 12) then
                            Global.Componentes.AddContato = {}
                            Global2.Functions["CreateEdit"]("Add", 1614, 898, 202, 20, 9, false, tocolor(71, 71, 71, 255), tocolor(0, 0, 0, 0), "Numara", Global.Fonts["PoppinsRegular"][13], 1, true)
                        end
                        if isCursorOnElement(1585, 530, 260, 389) then
                            if #Global.Componentes.PositionsContatos ~= 0 then
                                for i = 1,#Global.Componentes.PositionsContatos do
                                    local v = Global.Componentes.PositionsContatos[i]
                                    if v[6] == "Emergencias" then
                                        if isCursorOnElement(v[1] + 219 + 1585, v[2] - 39 + 530 - Global.Componentes.PosRender, 21, 21) then
                                            chamandoEmergencias = v[5][2]
											setTimer(function()
                                            triggerServerEvent('Caio.onChamarOcorrencia__key:4pdks3yku', localPlayer, localPlayer, chamandoEmergencias)
											end,0,1)
                                        end
                                    else
                                        if isCursorOnElement(v[1] + 219 + 1585, v[2] - 39 + 530 - Global.Componentes.PosRender, 21, 21) then
										setTimer(function()
                                            triggerServerEvent("174.RemoveContato__key:akdp3nh0g", localPlayer, v[5][1])
											end,0,1)
                                            break
                                        elseif isCursorOnElement(v[1] + 189 + 1585, v[2] - 39 + 530 - Global.Componentes.PosRender, 21, 21) then
                                            Global.Componentes.Aba = "Whatsapp-Conversa"
                                            local Recebendo = v[5][1]
                                            Global.Componentes.Select = Recebendo
                                            ChangeAba("Whatsapp-Conversa")
                                            break
                                        elseif isCursorOnElement(v[1] + 159 + 1585, v[2] - 39 + 530 - Global.Componentes.PosRender, 21, 21) then
										setTimer(function()
											triggerServerEvent("174.Call__key:isbnar5tq", localPlayer, v[5][1])
										end,0,1)
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    elseif Global.Componentes.Aba == "config.wallpaper" then
						addImage = 0
						addYImage = 0
						counter = 0
						for i = 1, 48 do
							if i > scroll and counter < 9 then
								if isCursorOnElement(1580+addImage,480+addYImage,296/4, 621/4) then
									setElementData(localPlayer,"phone.wallpaper",i)
									drawInfo("Config","Duvar kağıdı değiştirildi.")
								end
								addImage = addImage + 84
								counter = counter + 1
								if addImage >= 84*3 then
									addYImage = addYImage + 155.25+10
									addImage = 0
								end
							end
						end
					elseif Global.Componentes.Aba == "Harita" then
						if isCursorOnElement(1635, 880, 135, 30) then
							local id = Global2.Functions["GetTextEdit"]("ID")
							setTimer(function()
							--	triggerServerEvent("konumYolla",localPlayer,localPlayer,id)
							end,0,1)
						end
                    elseif Global.Componentes.Aba == "Config" then
                        if Global.Componentes.PapelParede then
                             if isCursorOnElement(1561, 827, 284, 172) then
                                if isCursorOnElement(1679, 939, 50, 23) then
                                    local Link = Global2.Functions["GetTextEdit"]("Papel")
									setElementData(localPlayer,"phone.avatar",Link)
                                    if Global.Componentes.Loading then return end
                                    Global.Componentes.Loading = true
                                    requestBrowserDomains({Link}, true, function(wasAccepted)
                                        if wasAccepted then
                                            fetchRemote(Link, function(data, error)
                                                if error == 0 and type(data) == "string" then
                                                    SetAvatar(data,1)
                                                    Global.Componentes.PapelParede = nil
                                                    Global2.Functions["DestroyEdit"]("Papel")
                                                    Global.Componentes.Loading = false
                                                end
                                            end)
                                        end
                                    end)
                                end
                            else
                                Global.Componentes.PapelParede = nil
                                Global2.Functions["DestroyEdit"]("Papel")
                            end
                            return
                        end
                        if isCursorOnElement(1572, 631, 262, 42) then
                            Global.Componentes.PapelParede = true
							Global2.Functions["CreateEdit"]("Papel", 1614, 898, 202, 20, 1000, false, tocolor(71, 71, 71, 255), tocolor(0, 0, 0, 0), "URL", Global.Fonts["PoppinsRegular"][13], 1)
						elseif isCursorOnElement(1580,510+90+100,250, 35) then
                            Global.Componentes.Aba = "Notify"
                            ChangeAba("Notify")
						elseif isCursorOnElement(1572, 489+100, 262, 85/2) then
                            Global.Componentes.Aba = "config.wallpaper"
                            ChangeAba("config.wallpaper")
						elseif isCursorOnElement(1795, 745+41, 22, 22) then
							if ucakmodu == true then
								ucakmodu = false
								drawInfo("Config","Uçak modunu kapattınız.")
							else
								ucakmodu = true
								drawInfo("Config","Uçak modunu açtınız.")
							end
                        end
                    elseif Global.Componentes.Aba == "Telefone" then
                        local Px, Py = 0, 0
                        for i = 1, 12 do
                            if isCursorOnElement(1596 + (90 * Px), 599 + (61 * Py), 31, 36) then
                                if #Global.Componentes.Number == 9 then
                                    return
                                end
                                if i <= 9 then
                                    if #Global.Componentes.Number == 4 then
                                        Global.Componentes.Number = Global.Componentes.Number.."-"
                                    end
                                    Global.Componentes.Number = Global.Componentes.Number..i
                                    playSound("assets/sound/click.mp3")
                                elseif i == 11 then
                                    if #Global.Componentes.Number == 4 then
                                        Global.Componentes.Number = Global.Componentes.Number.."-"
                                    end
                                    Global.Componentes.Number = Global.Componentes.Number.."0"
                                    playSound("assets/sound/click.mp3")
                                end
                            end
                            Px = Px + 1
                            if Px == 3 then
                                Py = Py + 1
                                Px = 0
                            end
                        end
                        if isCursorOnElement(1767, 884, 35, 19) then
                            if #Global.Componentes.Number == 0 then
                                return
                            end
                            Global.Componentes.Number = string.sub(Global.Componentes.Number, 1, #Global.Componentes.Number - 1)
                            if #Global.Componentes.Number == 5 then
                                Global.Componentes.Number = string.sub(Global.Componentes.Number, 1, #Global.Componentes.Number - 1)
                            end
                        elseif isCursorOnElement(1672, 859, 61, 61) then
							if ucakmodu == true then
								drawInfo("Telefone", "Aramaya yapmak için uçak modundan çıkmanız gerekmektedir!")
							else
								if #Global.Componentes.Number == 9 then
								setTimer(function()
									triggerServerEvent("174.Call__key:isbnar5tq", localPlayer, Global.Componentes.Number)
								end,0,1)
								end
							end
						end
					elseif Global.Componentes.Aba == "Galeri" then
						if selectedImage and isCursorOnElement(1690+115,940,25,25) then
							imageCreatorr = imageCreator
							imageIndexIdd = imageIndexId
							imguraVer(imageCreatorr,imageIndexIdd)
							selectedImage = nil
							imageIndexId = nil
							imageCreator = nil
							Global.Componentes.selectImage = false
							imageDate = nil
							Global.Componentes.Aba = nil
							ChangeAba("")
						end
                    elseif Global.Componentes.Aba == "Ligação" then
                        local Tipo = Global.Componentes.InfosLigacao[1]
                        local Telefone = Global.Componentes.InfosLigacao[2]
                        local Player = Global.Componentes.InfosLigacao[3]
                        if Tipo == "Chamando" and isCursorOnElement(1675, 880, 56, 56) then
						setTimer(function()
                            triggerServerEvent("174.RemoveChamada__key:3tg4bh4c3", localPlayer, Player)
							end,0,1)
                            Global.Componentes.InfosLigacao = nil
                            if Global.Componentes.Sound and isElement(Global.Componentes.Sound) then
                                destroyElement(Global.Componentes.Sound)
                                Global.Componentes.Sound = nil
                            end
                            Global.Componentes.Aba = "Telefone"
                            ChangeAba("Telefone")
						elseif Tipo == "Ulasilmadi" and isCursorOnElement(1675, 880, 56, 56) then
						setTimer(function()
                            triggerServerEvent("174.RemoveChamada__key:3tg4bh4c3", localPlayer, Player)
							end,0,1)
                            Global.Componentes.InfosLigacao = nil
                            if Global.Componentes.Sound and isElement(Global.Componentes.Sound) then
                                destroyElement(Global.Componentes.Sound)
                                Global.Componentes.Sound = nil
                            end
                            Global.Componentes.Aba = "Telefone"
                            ChangeAba("Telefone")
                        elseif Tipo == "Recebendo" then
                            if isCursorOnElement(1725, 880, 56, 56) then
							setTimer(function()
                                triggerServerEvent("174.RemoveChamada__key:3tg4bh4c3", localPlayer, Player)
								end,0,1)
                                Global.Componentes.InfosLigacao = nil
                                if Global.Componentes.Sound and isElement(Global.Componentes.Sound) then
                                    destroyElement(Global.Componentes.Sound)
                                    Global.Componentes.Sound = nil
                                end
                                Global.Componentes.Aba = "Telefone"
                                ChangeAba("Telefone")
								drawCall("close")
                            elseif isCursorOnElement(1625, 880, 56, 56) then
								setTimer(function()
                                triggerServerEvent("174.AtenderLigacao__key:rf9inj74s", localPlayer, Player)
								end,0,1)
                                Global.Componentes.InfosLigacao[1] = "Atendido"
								drawCall("open")
                                Global.Componentes.InfosLigacao[4] = getTickCount()
                                if Global.Componentes.Sound and isElement(Global.Componentes.Sound) then
                                    destroyElement(Global.Componentes.Sound)
                                    Global.Componentes.Sound = nil
                                end
                            end
                        elseif Tipo == "Atendido" and isCursorOnElement(1675, 880, 56, 56) then
						setTimer(function()
                            triggerServerEvent("174.RemoveChamada__key:3tg4bh4c3", localPlayer, Player)
							end,0,1)
                            Global.Componentes.InfosLigacao = nil
                            Global.Componentes.Aba = "Telefone"
                            ChangeAba("Telefone")
							drawCall("close")
                        end
					elseif Global.Componentes.Aba == "Instagram" then
						if isCursorOnElement(1715, 920, 35, 35) then
							Global.Componentes.createPost = true
							ChangeAba("Instagram")
							if Global.Componentes.createPost then
								Global2.Functions["CreateEdit"]("post", 1575, 729+50+25, 202, 20, 40, false, tocolor(71, 71, 71, 255), tocolor(0, 0, 0, 0), "Hadi bir şeyler yaz!", Global.Fonts["PoppinsRegular"][13], 1, false)
							end
						elseif isCursorOnElement(1655, 920, 35, 35) then
							Global.Componentes.createPost = nil
							Global2.Functions["DestroyEdit"]("post")
						elseif isCursorOnElement(1665,820,75,75) then
							if Global.Componentes.createPost then
								if getElementData(root, "legal:block"..getElementData(localPlayer, "account:id")) then
									outputChatBox(">> #FFFFFFlegal paylaşım kanalları üzerinde engellenmişsiniz.", 255, 0, 0, true)
								return end
								if imageSelectPost then
									local playerName = getPlayerName(localPlayer):gsub("_", "")
									local playerName = "@"..playerName
									local postText = Global2.Functions["GetTextEdit"]("post")
									if postText ~= "" then
										setTimer(function()
											triggerServerEvent("instagram:add", localPlayer, localPlayer, playerName, postText, imageSelectPost)
											imageSelectPost = nil
										end,0,1)
									else
										triggerEvent("phone.showInfo",localPlayer,"instagram","Lütfen bir metin girin.")
									end
								else
									triggerEvent("phone.showInfo",localPlayer,"instagram","Lütfen bir resim seçin.")
								end
							end
						end
					
					elseif Global.Componentes.Aba == "Darkweb" then
						if (getElementData(localPlayer,"darkweb:accountCreate") or 0) == 0 then
							if isCursorOnElement(1575,780,250,40) then
								local accText = Global2.Functions["GetTextEdit"]("dwAccount")
								local avvText = Global2.Functions["GetTextEdit"]("dwAvatar")
								if accText == "" or #accText < 4 then
									triggerEvent("phone.showInfo",localPlayer,"darkweb","Geçersiz isim.")
								elseif avvText == "" then
									triggerEvent("phone.showInfo",localPlayer,"darkweb","Lütfen bir url girin!")
								else
									setTimer(function()
									triggerServerEvent("darkweb:addAcc",localPlayer,localPlayer,accText,avvText)
									end,0,1)
									Global2.Functions["DestroyEdit"]("dwAccount")
									Global2.Functions["DestroyEdit"]("dwAvatar")
									setTimer(function()
									ChangeAba("Darkweb")
									end,250,1)
								end
							end
						else
							if isCursorOnElement(1575,920,50,35) and Global.Componentes.darkwebSettings ~= true then
								Global.Componentes.darkwebGallery = true
							end
							if isCursorOnElement(1565,300,300,500) and Global.Componentes.darkwebGallery == true then
								Global.Componentes.darkwebGallery = nil
								ChangeAba("Darkweb")
							end
							if isCursorOnElement(1775,920,50,35) and Global.Componentes.darkwebSettings ~= true and Global.Componentes.darkwebGallery ~= true then
								local playerName = "@"..getElementData(localPlayer,"darkweb:accountName")
								local postTextDark = Global2.Functions["GetTextEdit"]("dwMessage")
								if postTextDark == "" then
									triggerEvent("phone.showInfo",localPlayer,"darkweb","Metin girin.")
								else
									setTimer(function()
										
									triggerServerEvent("darkweb:addPost",localPlayer, localPlayer, playerName, postTextDark, imageSelectPost)
									imageSelectPost = nil
									end,0,1)
								end
							end
							if isCursorOnElement(1575,780,250,40) and Global.Componentes.darkwebSettings == true then
									local accText = Global2.Functions["GetTextEdit"]("dwAccount")
									local avvText = Global2.Functions["GetTextEdit"]("dwAvatar")
								if accText == "" or #accText < 4 then
									triggerEvent("phone.showInfo",localPlayer,"darkweb","Geçersiz isim.")
								elseif avvText == "" then
									triggerEvent("phone.showInfo",localPlayer,"darkweb","Lütfen bir url girin!")
								else
									setTimer(function()
									triggerServerEvent("darkweb:chgAcc",localPlayer,localPlayer,accText,avvText)
									end,0,1)
									Global2.Functions["DestroyEdit"]("dwAccount")
									Global2.Functions["DestroyEdit"]("dwAvatar")
									Global.Componentes.darkwebSettings = nil
									ChangeAba("Darkweb")
								end
							end
							if isCursorOnElement(1800,430,25,25) then
								Global.Componentes.darkwebSettings = true
								ChangeAba("Darkweb")
							end
							if Global.Componentes.darkwebSettings == true then
								if isCursorOnElement(1575,430,25,25) then
									Global2.Functions["DestroyEdit"]("dwAccount")
									Global2.Functions["DestroyEdit"]("dwAvatar")
									Global.Componentes.darkwebSettings = nil
									ChangeAba("Darkweb")
								end
							end
						end
					elseif Global.Componentes.Aba == "Camera" then
						if isCursorOnElement(1677, 900, 50, 50) then
							setElementData(localPlayer,"hudkapa",true)
							triggerEvent("foto.cek",localPlayer)
						end
						if isCursorOnElement(1775, 900+7.5, 35, 35) then
							if getElementData(localPlayer,"selfiemod") == true then
								setElementData(localPlayer,"selfiemod",false)
							else
								setElementData(localPlayer,"selfiemod",true)
							end
						end
					elseif Global.Componentes.Aba == "yenipage" then
						if isCursorOnElement(1575+10, 457, 50,50,50) then
							if ucakmodu == true then
								ucakmodu = false
								drawInfo("Config","Uçak modunu kapattınız.")
							else
								ucakmodu = true
								drawInfo("Config","Uçak modunu açtınız.")
							end
						elseif isCursorOnElement(1720+40, 457+65, 20, 20) then
							if played == true then
								played = false
								setSoundVolume(musicBox[localPlayer], 0)
								triggerEvent("phone.spotify",localPlayer,"close")
							else
								played = true
								setSoundVolume(musicBox[localPlayer], 1)
							end
						end
					elseif Global.Componentes.Aba == "Twitter" then
						if isCursorOnElement(1800, 920, 35, 35) then
							if Global.Componentes.tweetPost and Global2.Functions["GetTextEdit"]("tweetPostMess") then
								if getElementData(root, "legal:block"..getElementData(localPlayer, "account:id")) then
									outputChatBox(">> #FFFFFFlegal paylaşım kanalları üzerinde engellenmişsiniz.", 255, 0, 0, true)
								return end
								local playerName = getPlayerName(localPlayer):gsub("_", "")
								local playerName = "@"..playerName
								local postTextTwee = Global2.Functions["GetTextEdit"]("tweetPostMess")
								setTimer(function()
									triggerServerEvent("tweet:add", localPlayer, localPlayer, playerName, postTextTwee)
								end,0,1)
							end
						end
					elseif Global.Componentes.Aba == "Spotify" then
						local spogetText = Global2.Functions["GetTextEdit"]("spotifySearch")
						if isCursorOnElement(1580, 470, 25, 25) or getKeyState("enter") then
							fetchRemote("https://api.vk.com/method/audio.search?access_token="..musicToken.."&q="..spogetText.."&count=10&v=5.95", searchMusic)
							
						end
						if isCursorOnElement(1800,880,25,25) then
							if played == true then
								played = false
								setSoundVolume(musicBox[localPlayer], 0)
								acilmabildirim = {}
								triggerEvent("phone.spotify",localPlayer,"close")
							else
								played = true
								setSoundVolume(musicBox[localPlayer], 1)
								triggerEvent("phone.spotify",localPlayer,"open")
							end
						end
						local spocounter = 0
						for i, v in pairs(musicList) do
							spocounter = spocounter + 1
							if spocounter >= 1 and spocounter <= 6 then
								if isCursorOnElement(1570,445+(i*60),260,50) then
									table.insert(acilmabildirim, 1, {"spotify", musicTitle, musicArtist})
									local musicUrl = v.url
									musicDuration = v.duration
									musicArtist = v.artist
									musicTitle = v.title
									fetchRemote("https://api.vk.com/method/audio.getById?access_token="..musicToken.."&audios="..musicUrl.."&v=5.95", startMusicc)
								end
							end
						end
					end
                    if isCursorOnElement(1634, 977, 137, 6) then
                        if Global.Componentes.Aba and Global.Componentes.Aba == "Ligação" then
                            return
                        end
						Global.Componentes.createPost = nil
                        if Global.Componentes.Aba == "Whatsapp-Conversa" then
                            Global.Componentes.Aba = "Whatsapp"
                            ChangeAba("Whatsapp")
                        elseif Global.Componentes.Aba == "Notify" then
                            Global.Componentes.Aba = "Config"
                            ChangeAba("Config")
						else
							if Global.Componentes.Aba == "kilitEkran" then
							else
								ChangeAba("")
								Global.Componentes.Aba = nil
								if Global.Componentes.Aba == "Spotify" then
								else
									acilmabildirim = {}
								end
								if Global.Componentes.TickAba then
									Global.Componentes.TickAba = {getTickCount(), Global.Componentes.TickAba[3], Global.Componentes.TickAba[2], Nome}
								end
							end
                        end
                    end
                end
            end
        elseif state == "up" then
            if button == 'right' then
                if Global.Componentes.SelectedApp then
                    local PosXApps, PosYApps = 0, 0
                    for i = 1,16 do
                        if isCursorOnElement(1592 - 17 + (70 * PosXApps), 444 + 145 + (76 * PosYApps), 48, 48) then
                            if not Global.PosApps.Normal[tostring(i)] then
                                Global.PosApps.Normal[tostring(i)] = Global.PosApps.Normal[tostring(Global.Componentes.SelectedApp)]
                                Global.PosApps.Normal[tostring(Global.Componentes.SelectedApp)] = nil
                            else
                                local AppAntigo = Global.PosApps.Normal[tostring(i)]
                                Global.PosApps.Normal[tostring(i)] = Global.PosApps.Normal[tostring(Global.Componentes.SelectedApp)]
                                Global.PosApps.Normal[tostring(Global.Componentes.SelectedApp)] = AppAntigo
                            end
                            SaveJSON("apps")
                        end
						PosXApps = PosXApps + 1
						if PosXApps == 4 then
							PosXApps = 0
							PosYApps = PosYApps + 1
						end
                    end
                    Global.Componentes.SelectedApp = nil
                end
            end
        end
    end
end)

function drawSpotify(statessa)
	if isTimer(spotifyBox) then killTimer(spotifyBox) end
	if statessa == "close" then if isTimer(spotifyBox) then killTimer(spotifyBox) end return end
	if not isTimer(spotifyBox) and statessa == "open" then
		Global.TelefonInfo = {getTickCount(), 1920, 1920 + 700}
		spotifyBox = setTimer(function()
			if Global.Celular then
				Global.PosX = interpolateBetween(Global.Celular[2], 0, 0, Global.Celular[3], 0, 0, (getTickCount() - Global.Celular[1])/0, "Linear")
				Global.PosY = interpolateBetween(Global.Celular[2], 0, 0, Global.Celular[3], 0, 0, (getTickCount() - Global.Celular[1])/650, "Linear")
				alpha = interpolateBetween(0,0,0,255,0,0, (getTickCount() - Global.TelefonInfo[1])/350, "Linear")
				size = interpolateBetween(0,0,0,1,0,0, (getTickCount() - Global.TelefonInfo[1])/350, "Linear")
				infoY = interpolateBetween(390,0,0,386,0,0, (getTickCount() - Global.TelefonInfo[1])/350, "Linear")
				infoW = interpolateBetween(0,0,0,265,0,0, (getTickCount() - Global.TelefonInfo[1])/350, "Linear")
				infoH = interpolateBetween(15,0,0,55,0,0, (getTickCount() - Global.TelefonInfo[1])/350, "Linear")
				spoX = interpolateBetween(1626.5+152/2,0,0,1625,0,0, (getTickCount() - Global.TelefonInfo[1])/500, "Linear")
				dxDrawImage(spoX, infoY, infoW/2, infoH/2, "assets/img/info.png", 0, 0, 0, tocolor(255,255,255), true)
				dxDrawImage(spoX+5, infoY+6, 15, 15, "assets/img/Spotify.png", 0, 0, 0, tocolor(255,255,255,alpha), true)
				dxDrawText(math.floor(musicDuratSay), spoX+65, infoY+10, 57,13, tocolor(200,200,200,alpha), size, Global.Fonts["PoppinsMedium"][14], "right", "center", true, true, true, true)
			end
		end,0,0)
	end
end
addEvent("phone.spotify",true)
addEventHandler("phone.spotify",root,drawSpotify)

function drawInfo(type,text,text2)
	if isTimer(infobox) then killTimer(infobox) killTimer(kapatma) end
	if not text2 then
		text2 = "Sistem"
	end
	if not isTimer(infobox) then
		Global.TelefonInfo = {getTickCount(), 1920, 1920 + 700}
		infobox = setTimer(function()
			if Global.Celular then
				Global.PosX = interpolateBetween(Global.Celular[2], 0, 0, Global.Celular[3], 0, 0, (getTickCount() - Global.Celular[1])/0, "Linear")
				Global.PosY = interpolateBetween(Global.Celular[2], 0, 0, Global.Celular[3], 0, 0, (getTickCount() - Global.Celular[1])/650, "Linear")
				alpha = interpolateBetween(0,0,0,255,0,0, (getTickCount() - Global.TelefonInfo[1])/350, "Linear")
				size = interpolateBetween(0,0,0,1,0,0, (getTickCount() - Global.TelefonInfo[1])/350, "Linear")
				infoX = interpolateBetween(1626.5+152/2,0,0,1570,0,0, (getTickCount() - Global.TelefonInfo[1])/350, "Linear")
				infoY = interpolateBetween(390,0,0,386,0,0, (getTickCount() - Global.TelefonInfo[1])/350, "Linear")
				infoW = interpolateBetween(0,0,0,265,0,0, (getTickCount() - Global.TelefonInfo[1])/350, "Linear")
				infoH = interpolateBetween(15,0,0,55,0,0, (getTickCount() - Global.TelefonInfo[1])/350, "Linear")
			else
				Global.PosX = interpolateBetween(Global.TelefonInfo[2], 0, 0, Global.TelefonInfo[3], 0, 0, (getTickCount() - Global.TelefonInfo[1])/0, "Linear")
				Global.PosY = interpolateBetween(Global.TelefonInfo[2]+200, 0, 0, 2000, 0, 0, (getTickCount() - Global.TelefonInfo[1])/350, "Linear")
				dxDrawImage(1531+24, 865+21, 296, 620, "assets/img/wallpapers/"..(getElementData(localPlayer,"phone.wallpaper") or 2)..".png", 0, 0, 0, tocolor(255,255,255), true)
				dxDrawImage(1531, 865, 344, 672, "assets/img/overlay.png", 0, 0, 0, tocolor(255,255,255), true)
				alpha = interpolateBetween(0,0,0,255,0,0, (getTickCount() - Global.TelefonInfo[1])/500, "Linear")
				size = interpolateBetween(0,0,0,1,0,0, (getTickCount() - Global.TelefonInfo[1])/500, "Linear")
				infoX = interpolateBetween(1626.5+152/2,0,0,1570,0,0, (getTickCount() - Global.TelefonInfo[1])/500, "Linear")
				infoY = interpolateBetween(920+6,0,0,895,0,0, (getTickCount() - Global.TelefonInfo[1])/500, "Linear")
				infoW = interpolateBetween(0,0,0,265,0,0, (getTickCount() - Global.TelefonInfo[1])/500, "Linear")
				infoH = interpolateBetween(15,0,0,55,0,0, (getTickCount() - Global.TelefonInfo[1])/500, "Linear")
			end
			dxDrawImage(infoX, infoY, infoW, infoH, "assets/img/info.png", 0, 0, 0, tocolor(0,0,0), true)
			dxDrawImage(infoX+15, infoY+14, 25, 25, "assets/img/apps/"..type..".png", 0, 0, 0, tocolor(255,255,255,alpha), true)
			dxDrawText(kisalt(text2,28), infoX+47, infoY+14, 57,13, tocolor(200,200,200,alpha), size, Global.Fonts["PoppinsMedium"][32], "left", "center", true, true, true, true)
			dxDrawText(kisalt(text,28), infoX+47, infoY+31, 57,13, tocolor(255,255,255,alpha), size, Global.Fonts["PoppinsMedium"][31], "left", "center", true, true, true, true)
		end,0,0)
		kapatma = setTimer(function()
			killTimer(infobox)
		end,2500,1)
		if Global.Componentes.Aba == "Instagram" or Global.Componentes.Aba == "Darkweb" or Global.Componentes.Aba == "Twitter" or Global.Componentes.Aba == "Kamera" or Global.Componentes.Aba == "Galeri" then
		else		
		table.insert(acilmabildirim, 1, {type, text, text2})
		end
		if type == "Whatsapp" then
			countt = countt + 1
		end
	end
end
addEvent("phone.showInfo",true)
addEventHandler("phone.showInfo",root,drawInfo)

function drawCall(statessa)
	if isTimer(callBox) then killTimer(callBox) end
	if statessa == "close" then if isTimer(callBox) then killTimer(callBox) killTimer(callSay) end return end
	if not isTimer(callBox) and statessa == "open" then
		callDuration = 0
		Global.TelefonInfo = {getTickCount(), 1920, 1920 + 700}
		callSay = setTimer(function() callDuration = callDuration + 1 end,1000,0)
		callBox = setTimer(function()
			if Global.Celular then
				Global.PosX = interpolateBetween(Global.Celular[2], 0, 0, Global.Celular[3], 0, 0, (getTickCount() - Global.Celular[1])/0, "Linear")
				Global.PosY = interpolateBetween(Global.Celular[2], 0, 0, Global.Celular[3], 0, 0, (getTickCount() - Global.Celular[1])/650, "Linear")
				alpha = interpolateBetween(0,0,0,255,0,0, (getTickCount() - Global.TelefonInfo[1])/350, "Linear")
				size = interpolateBetween(0,0,0,1,0,0, (getTickCount() - Global.TelefonInfo[1])/350, "Linear")
				infoY = interpolateBetween(390,0,0,386,0,0, (getTickCount() - Global.TelefonInfo[1])/350, "Linear")
				infoW = interpolateBetween(0,0,0,265,0,0, (getTickCount() - Global.TelefonInfo[1])/350, "Linear")
				infoH = interpolateBetween(15,0,0,55,0,0, (getTickCount() - Global.TelefonInfo[1])/350, "Linear")
				spoX = interpolateBetween(1626.5+152/2,0,0,1625,0,0, (getTickCount() - Global.TelefonInfo[1])/500, "Linear")
			else
				Global.PosX = interpolateBetween(Global.TelefonInfo[2], 0, 0, Global.TelefonInfo[3], 0, 0, (getTickCount() - Global.TelefonInfo[1])/0, "Linear")
				Global.PosY = interpolateBetween(Global.TelefonInfo[2]+200, 0, 0, 2000, 0, 0, (getTickCount() - Global.TelefonInfo[1])/350, "Linear")
				dxDrawImage(1531+24, 865+21, 296, 620, "assets/img/wallpapers/"..(getElementData(localPlayer,"phone.wallpaper") or 2)..".png", 0, 0, 0, tocolor(255,255,255), true)
				dxDrawImage(1531, 865, 344, 672, "assets/img/overlay.png", 0, 0, 0, tocolor(255,255,255), true)
				alpha = interpolateBetween(0,0,0,255,0,0, (getTickCount() - Global.TelefonInfo[1])/500, "Linear")
				size = interpolateBetween(0,0,0,1,0,0, (getTickCount() - Global.TelefonInfo[1])/500, "Linear")
				spoX = interpolateBetween(1626.5+152/2,0,0,1625,0,0, (getTickCount() - Global.TelefonInfo[1])/500, "Linear")
				infoY = interpolateBetween(920+6,0,0,895,0,0, (getTickCount() - Global.TelefonInfo[1])/500, "Linear")
				infoW = interpolateBetween(0,0,0,265,0,0, (getTickCount() - Global.TelefonInfo[1])/500, "Linear")
				infoH = interpolateBetween(15,0,0,55,0,0, (getTickCount() - Global.TelefonInfo[1])/500, "Linear")
			end
			dxDrawImage(spoX, infoY, infoW/2, infoH/2, "assets/img/info.png", 0, 0, 0, tocolor(255,255,255), true)
			dxDrawImage(spoX+5, infoY+6, 15, 15, "assets/call.png", 0, 0, 0, tocolor(255,255,255,alpha), true)
			dxDrawImage(spoX+108, infoY+6, 15, 15, "assets/callEnd.png", 0, 0, 0, tocolor(255,255,255,alpha), true)
			if isCursorOnElement(spoX+108, infoY+6, 15, 15) and getKeyState("mouse1") then
				local Player = Global.Componentes.InfosLigacao[3]
				setTimer(function()
				triggerServerEvent("174.RemoveChamada__key:3tg4bh4c3", localPlayer, Player)
				end,0,1)
                Global.Componentes.InfosLigacao = nil
                if Global.Componentes.Sound and isElement(Global.Componentes.Sound) then
                    destroyElement(Global.Componentes.Sound)
                    Global.Componentes.Sound = nil
                end
                Global.Componentes.Aba = "Telefone"
                ChangeAba("Telefone")
				drawCall("close")
			end
			dxDrawText(math.floor(callDuration), spoX+45, infoY+10, 57,13, tocolor(200,200,200,alpha), size, Global.Fonts["PoppinsMedium"][14], "right", "center", true, true, true, true)
		end,0,0)
	end
end
addEvent("phone.drawCall",true)
addEventHandler("phone.drawCall",root,drawCall)

function UpdateRender(tipo, pos)
    dxSetRenderTarget(Global.Componentes.Render, true)
    dxSetBlendMode("modulate_add")
    if tipo == "Conversas" then
        local Conversas = Global.Componentes.ConversasWhatsapp
        if #Conversas > 4 and not Global.Componentes.ScrollWhatsapp then
            Global.Componentes.ScrollWhatsapp = ScrollBar.CreateScroll(1841, 589, 4, 362, 71, tocolor(255, 255, 255, 25), tocolor(124, 216, 134, 255), tocolor(61, 159, 72, 255), false)
        elseif #Conversas <= 4 and Global.Componentes.ScrollWhatsapp then
            Global.Componentes.ScrollWhatsapp:Destroy()
            Global.Componentes.ScrollWhatsapp = nil
        end
        Global.Componentes.PosicoesRender[tipo] = {}
        table.sort(Conversas, function(a, b)
            local TimeStamp1 = fromJSON(a.Conversas)[#fromJSON(a.Conversas)][2]
            local TimeStamp2 = fromJSON(b.Conversas)[#fromJSON(b.Conversas)][2]
            return TimeStamp1 < TimeStamp2
        end)
        
        for i,v in pairs(Conversas) do
            local Index = #Conversas + 1 - i
            _dxDrawImage(0, -79 + (79 * i) - pos, 40, 40, Global.Avatar or "assets/avatars/1.png")
            local Recebendo = Conversas[Index].Recebendo
            _dxDrawText(Global.Componentes.Infos["Contatos"][Recebendo] or Recebendo, 59, -77 + (79 * i) - pos, 0, 0, tocolor(241, 241, 241, 255), 1, Global.Fonts["PoppinsBold"]["16"])
            local UltimaMensagem = fromJSON(Conversas[Index].Conversas)[#fromJSON(Conversas[Index].Conversas)]
            _dxDrawText(#UltimaMensagem[1] > 20 and string.sub(UltimaMensagem[1], 1, 20).." ..." or UltimaMensagem[1], 59, -57 + (79 * i) - pos, 0, 0, tocolor(241, 241, 241, 140), 1, Global.Fonts["PoppinsRegular"]["11"])
            local Time = getRealTime(UltimaMensagem[2])
            _dxDrawText((Time.hour < 10 and "0"..Time.hour or Time.hour)..":"..(Time.minute < 10 and "0"..Time.minute or Time.minute), 200, -68 + (79 * i) - pos, 0, 0, tocolor(241, 241, 241, 255), 1, Global.Fonts["PoppinsMedium"][31])
            _dxDrawRectangle(59, -21 + (78 * i) - pos, 177, 1, tocolor(255, 255, 255, 25))
            Global.Componentes.PosicoesRender[tipo][i] = {0, -79 + (79 * i), 238, 58, Index}
        end
        
    elseif tipo == "Mensagem" then
        Global.Componentes.PositionsWhatsapp = {}
        local Mensagens = Global.Componentes.Mensageinormat
        if Mensagens[Global.Componentes.Select] then
            local Conversas = fromJSON(Mensagens[Global.Componentes.Select].Conversas)
            for i,v in pairs(Conversas) do
                local Tipo = v[4]
                local _, Height = dxGetTextSize(v[1], 145, 1, Global.Fonts["PoppinsMedium"]["11"], true)
                if v[3] == 1 then
                    if Tipo == "loc" then
                        local Adicionais = v[5]
                        local Zone = getZoneName(Adicionais[1], Adicionais[2], Adicionais[3])
                        local Width = dxGetTextWidth(Zone, 1, Global.Fonts["PoppinsMedium"]["11"])
                        local Adicional = (33 + Width) - 41 + 8
                        local PosYAnterior = (i == 1 and -10 or (Global.Componentes.PositionsWhatsapp[i - 1][2] + Global.Componentes.PositionsWhatsapp[i - 1][4])) + 10 
                        dxDrawRoundedRectangle(202 - Adicional, PosYAnterior - pos, 41 + Adicional, 32, tocolor(32, 32, 38, 255), 7)
                        _dxDrawText(Zone, 202 - Adicional + 30, PosYAnterior + 2.5 - pos, 41 + Adicional + (202 - Adicional), 32 + PosYAnterior + 2.5 - pos, tocolor(255, 255, 255, 255), 1, Global.Fonts["PoppinsMedium"]["11"], "left", "center")
                        _dxDrawImage(202 + 8 - Adicional, PosYAnterior + 8 - pos, 16, 16, "assets/img/app-whatsapp/loc.png")
                        Global.Componentes.PositionsWhatsapp[i] = {202 - Adicional, PosYAnterior, 41 + Adicional, 32}   
                    else
                        local Width = dxGetTextWidth(v[1], 1, Global.Fonts["PoppinsMedium"]["11"])
                        local Adicional = (33 + Width) - 41
                        local PosYAnterior = (i == 1 and -10 or (Global.Componentes.PositionsWhatsapp[i - 1][2] + Global.Componentes.PositionsWhatsapp[i - 1][4])) + 10 
                        if (41 + Adicional) <= 168 then
                            dxDrawRoundedRectangle(202 - Adicional, PosYAnterior - pos, 41 + Adicional, 30, tocolor(32, 32, 38, 255), 7)
                            _dxDrawText(v[1], 202 - Adicional + 14, PosYAnterior + 2.5 - pos, 41 + Adicional + (202 - Adicional), 30 + PosYAnterior + 2.5 - pos, tocolor(255, 255, 255, 255), 1, Global.Fonts["PoppinsMedium"]["11"], "left", "center")
                            Global.Componentes.PositionsWhatsapp[i] = {202 - Adicional, PosYAnterior, 41 + Adicional, 30}
                        else
                            dxDrawRoundedRectangle(75, PosYAnterior - pos, 168, Height + 13, tocolor(32, 32, 38, 255), 7)
                            _dxDrawText(v[1], 86 - 3, PosYAnterior + 2.5 - pos, 168 + 75, Height + 13 + PosYAnterior + 2.5 - pos, tocolor(255, 255, 255, 255), 1, Global.Fonts["PoppinsMedium"]["11"], "left", "center", false, true)
                            Global.Componentes.PositionsWhatsapp[i] = {75, PosYAnterior, 168, Height + 13}
                        end
                    end
                    
                elseif v[3] == 2 then
                    if Tipo == "loc" then
                        local Adicionais = v[5]
                        local Zone = getZoneName(Adicionais[1], Adicionais[2], Adicionais[3])
                        local Width = dxGetTextWidth(Zone, 1, Global.Fonts["PoppinsMedium"]["11"])
                        local Adicional = (33 + Width) - 41 + 8
                        local PosYAnterior = (i == 1 and -10 or (Global.Componentes.PositionsWhatsapp[i - 1][2] + Global.Componentes.PositionsWhatsapp[i - 1][4])) + 10 
                        dxDrawRoundedRectangle(0, PosYAnterior - pos, 41 + Adicional, 32, tocolor(38, 45, 49, 255), 7)
                        _dxDrawText(Zone, 0 + 30, PosYAnterior + 2.5 - pos, 41 + Adicional, 32 + PosYAnterior + 2.5 - pos, tocolor(255, 255, 255, 255), 1, Global.Fonts["PoppinsMedium"]["11"], "left", "center")
                        _dxDrawImage(0 + 8, PosYAnterior + 8 - pos, 16, 16, "assets/img/app-whatsapp/loc.png")
                        Global.Componentes.PositionsWhatsapp[i] = {0, PosYAnterior, 41 + Adicional, 32}   
                    else
                        local Width = dxGetTextWidth(v[1], 1, Global.Fonts["PoppinsMedium"][11])
                        local Adicional = (33 + Width) - 41
                        local PosYAnterior = (i == 1 and -10 or (Global.Componentes.PositionsWhatsapp[i - 1][2] + Global.Componentes.PositionsWhatsapp[i - 1][4])) + 10 
                        if (41 + Adicional) <= 168 then
                            dxDrawRoundedRectangle(0, PosYAnterior - pos, 41 + Adicional, 30, tocolor(38, 45, 49, 255), 7)
                            _dxDrawText(v[1], 0 + 14, PosYAnterior + 2.5 - pos, 41 + Adicional, 30 + PosYAnterior + 2.5 - pos, tocolor(255, 255, 255, 255), 1, Global.Fonts["PoppinsMedium"]["11"], "left", "center")
                            Global.Componentes.PositionsWhatsapp[i] = {0, PosYAnterior, 41 + Adicional, 30}
                        else
                            dxDrawRoundedRectangle(0, PosYAnterior - pos, 168, Height + 13, tocolor(38, 45, 49, 255), 7)
                            _dxDrawText(v[1], 14 - 3, PosYAnterior + 2.5 - pos, 168, Height + 13 + PosYAnterior + 2.5 - pos, tocolor(255, 255, 255, 255), 1, Global.Fonts["PoppinsMedium"]["11"], "left", "center", false, true)
                            Global.Componentes.PositionsWhatsapp[i] = {0, PosYAnterior, 168, Height + 13}
                        end
                    end
                end
            end
        end
    elseif tipo == "Contatos" then
        local PosicaoLetra = 0
        local Index = 0
        Global.Componentes.PositionsContatos = {}
        for _,v1 in pairs(Global.Componentes.Contatoinormat) do
            local Letra = v1[1]
            local Contatos = v1[2]
            _dxDrawText(Letra, 0, PosicaoLetra - pos, 0, 0, tocolor(115, 115, 115, 255), 1, Global.Fonts["PoppinsSemiBold"]["13"])
            for i,v2 in pairs(Contatos) do
                Index = Index + 1
                local Telefone = v2[1]
                local Nome = v2[2]
                _dxDrawText(Nome, 0, (PosicaoLetra + 31 - 51) + (51 * i) - pos, 0, 0, tocolor(208, 208, 208, 255), 1, Global.Fonts["PoppinsMedium"]["15"])
                _dxDrawRectangle(0, (PosicaoLetra + 31 - 51) + (51 * i) + 33 - pos, 260, 1, tocolor(37, 37, 37, 255))
                if Letra == "Emergencias" then
                    _dxDrawImage(219, (PosicaoLetra + 31 - 51) + (51 * i) - 2 - pos, 21, 21, "assets/img/app-contatos/circle.png", 0, 0, 0)
                    _dxDrawImage(225, (PosicaoLetra + 31 - 51) + (51 * i) + 4 - pos, 9, 9, "assets/img/app-contatos/ligar.png", 0, 0, 0)
                else
                    _dxDrawImage(159, (PosicaoLetra + 31 - 51) + (51 * i) - 2 - pos, 21, 21, "assets/img/app-contatos/circle.png", 0, 0, 0)
                    _dxDrawImage(165, (PosicaoLetra + 31 - 51) + (51 * i) + 4 - pos, 9, 9, "assets/img/app-contatos/ligar.png", 0, 0, 0)

                    _dxDrawImage(189, (PosicaoLetra + 31 - 51) + (51 * i) - 2 - pos, 21, 21, "assets/img/app-contatos/circle.png", 0, 0, 0)
                    _dxDrawImage(195, (PosicaoLetra + 31 - 51) + (51 * i) + 5 - pos, 10, 7.5, "assets/img/app-contatos/msg.png", 0, 0, 0)

                    _dxDrawImage(219, (PosicaoLetra + 31 - 51) + (51 * i) - 2 - pos, 21, 21, "assets/img/app-contatos/circle.png", 0, 0, 0)
                    _dxDrawImage(225, (PosicaoLetra + 31 - 51) + (51 * i) + 4 - pos, 9, 9, "assets/img/app-contatos/excluir.png", 0, 0, 0)
                end
                Global.Componentes.PositionsContatos[Index] = {0, (PosicaoLetra + 31 - 51) + (51 * i) + 33, 260, 1, v2, Letra}
                if i == #Contatos then
                    PosicaoLetra = (PosicaoLetra + 31 - 51) + (51 * i) + 57
                end
                
            end
        end
	elseif tipo == "Twitter" then
		Global.Componentes.ScrollTweet = ScrollBar.CreateScroll(1841, 589, 4, 362, 71, tocolor(255, 255, 255, 25), tocolor(124, 216, 134, 255), tocolor(61, 159, 72, 255), false)
    end
    dxSetBlendMode("blend")
    dxSetRenderTarget()
    Global.Componentes.PosRender = pos
end

function isNumberBroken(n)
    return (n - math.floor(n)) ~= 0
end

function Scroll(b)
    if Global.Celular then
        if Global.Componentes.IniciarConversa then
            if Global.Componentes.IniciarConversa[1] == 2 and isCursorOnElement(1561, 807, 284, 192) then
                local Broken = isNumberBroken((#Global.Componentes.Contatoinormatados / 2))
                local TotalAbas = (Broken and math.floor((#Global.Componentes.Contatoinormatados / 2)) + 1 or (#Global.Componentes.Contatoinormatados / 2))
                if b == "mouse_wheel_down" then
                    if Global.Componentes.IniciarConversa[2] ~= TotalAbas then
                        Global.Componentes.IniciarConversa[2] = Global.Componentes.IniciarConversa[2] + 1
                    end
                elseif b == "mouse_wheel_up" then
                    if Global.Componentes.IniciarConversa[2] ~= 1 then
                        Global.Componentes.IniciarConversa[2] = Global.Componentes.IniciarConversa[2] - 1
                    end
                end
            end
            return
        end
        if Global.Componentes.selecionarContatosWhatsapp or Global.Componentes.Anexo then
            if Global.Componentes.selecionarContatosWhatsapp then
                if isCursorOnElement(1561, 807, 284, 192) then
                    local Broken = isNumberBroken((#Global.Componentes.Contatoinormatados / 2))
                    local TotalAbas = (Broken and math.floor((#Global.Componentes.Contatoinormatados / 2)) + 1 or (#Global.Componentes.Contatoinormatados / 2))
                    if b == "mouse_wheel_down" then
                        if Global.Componentes.selecionarContatosWhatsapp[2] ~= TotalAbas then
                            Global.Componentes.selecionarContatosWhatsapp[2] = Global.Componentes.selecionarContatosWhatsapp[2] + 1
                        end
                    elseif b == "mouse_wheel_up" then
                        if Global.Componentes.selecionarContatosWhatsapp[2] ~= 1 then
                            Global.Componentes.selecionarContatosWhatsapp[2] = Global.Componentes.selecionarContatosWhatsapp[2] - 1
                        end
                    end
                end
                return
            end
        end
        if Global.Componentes.Aba == "Whatsapp" and isCursorOnElement(1583, 586, 238, 353) then
            if Global.ScrollWhatsapp then
                local ProgressConversa = Global.Componentes.ScrollWhatsapp:GetProgress()
                if b == "mouse_wheel_up" then
                    if ProgressConversa ~= 0 then
                        if ProgressConversa - 10 < 0 then
                            Global.Componentes.ScrollWhatsapp:SetProgress(0)
                        else
                            Global.Componentes.ScrollWhatsapp:SetProgress(ProgressConversa - 10)
                        end
                    end
                elseif b == "mouse_wheel_down" then
                    if ProgressConversa ~= 100 then
                        if ProgressConversa + 10 > 100 then
                            Global.Componentes.ScrollWhatsapp:SetProgress(100)
                        else
                            Global.Componentes.ScrollWhatsapp:SetProgress(ProgressConversa + 10)
                        end
                    end
                end
            end 
        elseif Global.Componentes.Aba == "Whatsapp-Conversa" and isCursorOnElement(1582, 503, 243, 412) then
            if #Global.Componentes.PositionsWhatsapp ~= 0 then
                local UltimaPosicao = Global.Componentes.PositionsWhatsapp[#Global.Componentes.PositionsWhatsapp][2] + Global.Componentes.PositionsWhatsapp[#Global.Componentes.PositionsWhatsapp][4] - 412
                if UltimaPosicao > 0 then
                    if b == "mouse_wheel_up" then
                        if Global.Componentes.PosRender ~= 0 then
                            if Global.Componentes.PosRender - 15 < 0 then
                                UpdateRender("Mensagem", 0)
                            else
                                UpdateRender("Mensagem", Global.Componentes.PosRender - 15)
                            end
                        end
                    elseif b == "mouse_wheel_down" then
                        if Global.Componentes.PosRender ~= UltimaPosicao then
                            if Global.Componentes.PosRender + 15 > UltimaPosicao then
                                UpdateRender("Mensagem", UltimaPosicao)
                            else
                                UpdateRender("Mensagem", Global.Componentes.PosRender + 15)
                            end
                        end
                    end
                end
            end
        elseif Global.Componentes.Aba == "Contatos" and isCursorOnElement(1585, 530, 260, 389) then
            if #Global.Componentes.PositionsContatos ~= 0 then
                local UltimaPosicao = Global.Componentes.PositionsContatos[#Global.Componentes.PositionsContatos][2] + Global.Componentes.PositionsContatos[#Global.Componentes.PositionsContatos][4] - 389
                if UltimaPosicao > 0 then
                    if b == "mouse_wheel_up" then
                        if Global.Componentes.PosRender ~= 0 then
                            if Global.Componentes.PosRender - 15 < 0 then
                                UpdateRender("Contatos", 0)
                            else
                                UpdateRender("Contatos", Global.Componentes.PosRender - 15)
                            end
                        end
                    elseif b == "mouse_wheel_down" then
                        if Global.Componentes.PosRender ~= UltimaPosicao then
                            if Global.Componentes.PosRender + 15 > UltimaPosicao then
                                UpdateRender("Contatos", UltimaPosicao)
                            else
                                UpdateRender("Contatos", Global.Componentes.PosRender + 15)
                            end
                        end
                    end
                end
            end
        end
    end
end
bindKey("mouse_wheel_down", "down", Scroll)
bindKey("mouse_wheel_up", "down", Scroll)

addEventHandler("onClientRestore", root, function()
    if Global.Celular and Global.Componentes.Render and isElement(Global.Componentes.Render) then
        if Global.Componentes.Aba == "Whatsapp" then
            UpdateRender("Conversas", Global.Componentes.PosRender)
        elseif Global.Componentes.Aba == "Whatsapp-Conversa" then
            UpdateRender("Mensagem", Global.Componentes.PosRender)
        elseif Global.Componentes.Aba == "Contatos" then
            UpdateRender("Contatos", Global.Componentes.PosRender)
        end
    end
end)

function imguraVer(creat, indexId)
	local imagePath = "realphoto" .. creat .. indexId .. ".png"
    local file = fileOpen(imagePath)
    if not file then
        outputChatBox("Resim dosyası bulunamadı: " .. imagePath)
        return false
    end
    local imageData = fileRead(file, fileGetSize(file))
    fileClose(file)
    local base64Data = encodeString(imageData)
    fetchRemote("https://api.imgur.com/3/image", 
        function(responseData, errno)
            if errno == 0 then
                local responseData = fromJSON(responseData)
                if responseData.success then
                    local imgUrl = responseData.data.link
                    outputChatBox("Resim başarıyla yüklendi ve kopyalandı. > " .. imgUrl)
					setClipboard(imgUrl)
                else
                    outputChatBox("Imgur API hatası: " .. responseData.data.error)
                end
            else
                outputChatBox("Resim yükleme hatası: " .. errno)
            end
        end,
    base64Data, true, {["Authorization"] = "Client-ID " .. imgurToken})
end


addEvent("174.AddChamada", true)
addEventHandler("174.AddChamada", root, function(tipo, telefone, player, contatos, target)
    if tipo == "Recebendo" and Global.Notify.LigacaoAnonima == 0 and not contatos[telefone] then
	setTimer(function()
        triggerServerEvent("174.RemoveChamadaPlayer__key:ihquxigmr", localPlayer)
		end,0,1)
        return
    end
	if not player then player = localPlayer end
    if not Global.Celular then
	setTimer(function()
        triggerServerEvent("174.OpenCell__key:b0ci9jfxe", localPlayer)
		end,0,1)
    end 
    if Global.Componentes.Sound and isElement(Global.Componentes.Sound) then
        destroyElement(Global.Componentes.Sound)
        Global.Componentes.Sound = nil
    end
    setTimer(function()
	    if tipo == "Chamando" then
			Global.Componentes.Sound = playSound("assets/sound/calling.mp3", true)
		elseif tipo == "Recebendo" then
			Global.Componentes.Sound = playSound("assets/sound/receiving.mp3", true)
		elseif tipo == "Ulasilmadi" then
			Global.Componentes.Sound = playSound("assets/sound/ulasilamadi.mp3", true)
			setTimer(function() 
				destroyElement(Global.Componentes.Sound)
				Global.Componentes.Sound = nil
				ChangeAba("Telefone") 
				Global.Componentes.Aba = "Telefone"
			end,7000,1)
		end
        Global.Componentes.InfosLigacao = {tipo, telefone, player}
        Global.Componentes.Aba = "Ligação"
        ChangeAba("Ligação")
    end, 200, 1)
end)

addEvent("174.AtenderLigacao__key:rf9inj74s", true)
addEventHandler("174.AtenderLigacao__key:rf9inj74s", root, function()
    Global.Componentes.InfosLigacao[1] = "Atendido"
    Global.Componentes.InfosLigacao[4] = getTickCount()
	if Global.Componentes.Sound and isElement(Global.Componentes.Sound) then
        destroyElement(Global.Componentes.Sound)
        Global.Componentes.Sound = nil
    end
end)

addEvent("174.RemoveChamada__key:3tg4bh4c3", true)
addEventHandler("174.RemoveChamada__key:3tg4bh4c3", root, function()
    Global.Componentes.InfosLigacao = nil
    if Global.Componentes.Sound and isElement(Global.Componentes.Sound) then
        destroyElement(Global.Componentes.Sound)
        Global.Componentes.Sound = nil
    end
    Global.Componentes.Aba = "Telefone"
    ChangeAba("Telefone")
	drawCall("close")
end)

local SvgsRectangle = {}

function dxDrawBordRectangle(x, y, w, h, radius, color, post)
    if not SvgsRectangle[radius] then
        SvgsRectangle[radius] = {}
    end
    if not SvgsRectangle[radius][w] then
        SvgsRectangle[radius][w] = {}
    end
    if not SvgsRectangle[radius][w][h] then
        local Path = string.format([[
            <svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect opacity="1" width="%s" height="%s" rx="%s" fill="#FFFFFF"/>
            </svg>
        ]], w, h, w, h, w, h, radius)
        SvgsRectangle[radius][w][h] = svgCreate(w, h, Path)
    end
    if SvgsRectangle[radius][w][h] then
        dxDrawImage(x, y, w, h, SvgsRectangle[radius][w][h], 0, 0, 0, color, post)
    end
end

bindKey("backspace", "down", function()
    if Global.Celular then
        if Global.Componentes.Aba == "Banco" and Global.Componentes.Traninerir then
            Global2.Functions["DestroyEdit"]("Traniner")
            Global.Componentes.Traninerir = nil
        end
    end
end)

function SaveJSON(tipo)
    if tipo == "apps" then
        Global.Files.Apps = fileOpen("assets/json/apps.json")
        local Json = toJSON(Global.PosApps)
        fileWrite(Global.Files.Apps, Json)
        fileClose(Global.Files.Apps)
    elseif tipo == "notify" then
        Global.Files.Notify = fileOpen("assets/json/notify.json")
        local Json = toJSON(Global.Notify)
        fileWrite(Global.Files.Notify, Json)
        fileClose(Global.Files.Notify)
    end
end

function formatTableConversas(text)
    if Global.Celular and Global.Componentes.Aba == "Whatsapp" then
        if text ~= "" then
            local Conversas = {}
            if #Global.Componentes.Infos["Whatsapp"] ~= 0 then
                for i = 1,#Global.Componentes.Infos["Whatsapp"] do
                    local v = Global.Componentes.Infos["Whatsapp"][i]
                    local Recebendo = Global.Componentes.Infos["Contatos"][v.Recebendo] or v.Recebendo
                    if string.find(string.lower(Recebendo), string.lower(text)) then
                        Conversas[#Conversas + 1] = v
                    end
                end
            end
            Global.Componentes.ConversasWhatsapp = Conversas
        else
            Global.Componentes.ConversasWhatsapp = Global.Componentes.Infos["Whatsapp"]
        end
        
        UpdateRender("Conversas", 0)
        if #Global.Componentes.ConversasWhatsapp > 4 then
            Global.Componentes.ScrollWhatsapp:SetProgress(0)
        end
    end
end

function convertNumber ( number )   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')     
        if ( k==0 ) then       
            break   
        end   
    end   
    return formatted 
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

function dxDrawRoundedRectangle(x, y, rx, ry, color, radius)
    rx = rx - radius * 2
    ry = ry - radius * 2
    x = x + radius
    y = y + radius
    if (rx >= 0) and (ry >= 0) then
        _dxDrawRectangle(x, y, rx, ry, color)
        _dxDrawRectangle(x, y - radius, rx, radius, color)
        _dxDrawRectangle(x, y + ry, rx, radius, color)
        _dxDrawRectangle(x - radius, y, radius, ry, color)
        _dxDrawRectangle(x + rx, y, radius, ry, color)
        dxDrawCircle(x, y, radius, 180, 270, color, color, 7)
        dxDrawCircle(x + rx, y, radius, 270, 360, color, color, 7)
        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 7)
        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 7)
    end
end

function createEditbox (action, length, number)
    if action then
        if not edit then
            edit = {}
        end
        local editbox = guiCreateEdit(0, 0, 0, 0, '')
        if length then
            guiEditSetMaxLength(editbox, length)
            if number then
                guiSetProperty(editbox, 'ValidationString', '[0-9]*')
            end
        end
        edit[action] = editbox
    end
end

function removeEditbox (action)
    if action == 'all' then
        for _, v in pairs(edit) do
            if isElement(v) then
                destroyElement(v)
            end
        end
        edit = nil
    else
        if isElement(edit[action]) then
            destroyElement(edit[action])
            edit[action] = nil
        end
    end
end

function setEditboxEditing (action)
    if guiEditSetCaretIndex(edit[action], string.len(guiGetText(edit[action]))) then
        guiBringToFront(edit[action])
        guiSetInputMode('no_binds_when_editing')
        editboxSelect = action
    end
end

function getEditboxValue (action, drawing)
    if (drawing == true) then
        local editbox = guiGetText(edit[action])
        if editboxSelect == action then
            return editbox..'|'
        else
            return (editbox == '' and action or editbox)
        end
    else
        local editbox = guiGetText(edit[action])
        return editbox
    end
end

createEditbox('Valor', 10, true)

function math.round(num, decimals)
    decimals = math.pow(10, decimals or 0)
    num = num * decimals
    if num >= 0 then num = math.floor(num + 0.5) else num = math.ceil(num - 0.5) end
    return num / decimals
end

function count(table)
	if not table then return 0 end
	local counter = 0
	for i, v in pairs(table) do
		counter = counter + 1
	end
	return counter
end

function up()
    if Global.Componentes.Aba == "config.wallpaper" then
        if scroll > 0 then
            scroll = scroll - 3
        end
    end
end

function down()
    if Global.Componentes.Aba == "config.wallpaper" then
        if scroll <= counter - maxScrool + 27 then
            scroll = scroll + 3
        end
    end
end
bindKey("mouse_wheel_up", "down", up)
bindKey("mouse_wheel_down", "down", down)