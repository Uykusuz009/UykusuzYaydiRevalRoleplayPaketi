-- BABA KALİTELİ SİSTEMİN ADRESİ PUBMTA
-- Sunucuya katılmak için >>> https://guns.lol/qoztr
-- https://discord.gg/Bfne9DP8Sw

local fonts = {}

local fontsSource = {
	["Bankgothic"] = "public/fonts/Bankgothic.ttf",
	
	["Bebas"] = "public/fonts/Bebas.ttf",
	["BebasNeueBold"] = "public/fonts/BebasNeueBold.otf",
	["BebasNeueLight"] = "public/fonts/BebasNeueLight.otf",
	["BebasNeueRegular"] = "public/fonts/BebasNeueRegular.otf",
	
	["FontAwesome"] = "public/fonts/FontAwesome.ttf",
	["FontAwesomeBrand"] = "public/fonts/FontAwesomeBrand.ttf",
	["FontAwesomeRegular"] = "public/fonts/FontAwesomeRegular.otf",
	
	["in-bold"] = "public/fonts/in-bold.ttf",
	["in-elight"] = "public/fonts/in-elight.ttf",
    ["in-elightitalic"] = "public/fonts/in-elightitalic.ttf",
	["in-italic"] = "public/fonts/in-italic.ttf",
    ["in-light"] = "public/fonts/in-light.ttf",
    ["in-lightitalic"] = "public/fonts/in-lightitalic.ttf",
	["in-regular"] = "public/fonts/in-regular.ttf",
    ["in-thin"] = "public/fonts/in-thin.ttf",
    ["in-thinitalic"] = "public/fonts/in-thinitalic.ttf",
	["in-medium"] = "public/fonts/in-medium.ttf",
	
	["license"] = "public/fonts/license.ttf",
	
	["Pricedown"] = "public/fonts/Pricedown.ttf",
	
	["Roboto"] = "public/fonts/Roboto-Regular.ttf",
	["RobotoB"] = "public/fonts/Roboto-Bold.ttf",
	["RobotoL"] = "public/fonts/Roboto-Light.ttf",
	["Roboto-Black"] = "public/fonts/Roboto-Black.ttf",
	["Roboto-Bold"] = "public/fonts/Roboto-Bold.ttf",
	["Roboto-Light"] = "public/fonts/Roboto-Light.ttf",
	["Roboto-Light-Italic"] = "public/fonts/Roboto-Light-Italic.ttf",
	["Roboto-Medium"] = "public/fonts/Roboto-Medium.ttf",
	["Roboto-Regular"] = "public/fonts/Roboto-Regular.ttf",
	
	["sf-bold"] = "public/fonts/sf-bold.ttf",
	["sf-bolditalic"] = "public/fonts/sf-bolditalic.ttf",
	["sf-heavy"] = "public/fonts/sf-heavy.ttf",
	["sf-heavyitalic"] = "public/fonts/sf-heavyitalic.ttf",
	["sf-italic"] = "public/fonts/sf-italic.ttf",
	["sf-light"] = "public/fonts/sf-light.ttf",
	["sf-lightitalic"] = "public/fonts/sf-lightitalic.ttf",
	["sf-medium"] = "public/fonts/sf-medium.ttf",
	["sf-mediumitalic"] = "public/fonts/sf-mediumitalic.ttf",
	["sf-regular"] = "public/fonts/sf-regular.ttf",
	["sf-semibold"] = "public/fonts/sf-semibold.ttf",
	["sf-semibolditalic"] = "public/fonts/sf-semibolditalic.ttf",
	
	["SignPainter"] = "public/fonts/SignPainter.ttf",
	["SweetSixteen"] = "public/fonts/SweetSixteen.ttf",
	
	["UbuntuBold"] = "public/fonts/UbuntuBold.ttf",
	["UbuntuLight"] = "public/fonts/UbuntuLight.ttf",
	["UbuntuRegular"] = "public/fonts/UbuntuRegular.ttf",
	["kaifont"] = 'files/URW DIN Arabic Bold.ttf',
}

-- BABA KALİTELİ SİSTEMİN ADRESİ PUBMTA
-- Sunucuya katılmak için >>> https://guns.lol/qoztr
-- https://discord.gg/Bfne9DP8Sw

function getFont(font, size)
    if not font then return end
    if not size then return end
	
    local fontE = false
    local _font = font
    
    if font and size then
	    local subText = font .. size
	    local value = fonts[subText]
	    if value then
		    fontE = value
		end
	end
    
    if not fontE then
        local value = fontsSource[_font]
        fontE = dxCreateFont(value, size)
        local subText = font .. size
        fonts[subText] = fontE
    end
    
	return fontE
end

-- BABA KALİTELİ SİSTEMİN ADRESİ PUBMTA
-- Sunucuya katılmak için >>> https://guns.lol/qoztr
-- https://discord.gg/Bfne9DP8Sw