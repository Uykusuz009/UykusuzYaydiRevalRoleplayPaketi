local fonts = {}
local fontsSource = {
    --["fontName"] = "source"
    ["PantonB"] = "files/Panton-BlackCaps.otf",
    ["Panton"] = "files/Panton-LightCaps.otf",
    ["MontserratB"] = "files/Montserrat-Bold.otf",
    ["MontserratM"] = "files/Montserrat-Medium.otf",
    ["MontserratR"] = "files/Montserrat-Regular.otf",
    ["MontserratS"] = "files/Montserrat-SemiBold.otf",
    ["bebasB"] = "files/BebasNeue-Regular.ttf",
    ["bebas"] = "files/BebasNeue-Regular.otf",
    ["Roboto"] = "files/Roboto.ttf",
    ["RobotoB"] = "files/RobotoB.ttf", 
    ["RobotoL"] = "files/RobotoL.ttf",
    ["AwesomeFont"] = "files/FontAwesome.ttf",
    ["AwesomeFont2"] = "files/FontAwesome2.ttf",
    ["FontAwesomeSolid"] = "files/FontAwesomeSolid.otf",
    ["FontAwesomeBrand"] = "files/FontAwesomeBrand.ttf",
    ["FontAwesomeLight"] = "files/FontAwesomeLight.ttf",
    ["FontAwesomeRegular"] = "files/FontAwesomeRegular.ttf",
    ["FontAwesomeRegular6"] = "files/FontAwesomeRegular6.ttf",
    ["Poppins"] = "files/Poppins.ttf",
    ["Condensed"] = "files/Condensed.ttf",
    ["FontB"] = "files/regularFont.ttf",
    ["sf-medium"] = 'files/sf-medium.ttf',
    ["sf-bold"] = 'files/sf-bold.ttf',
    ["SweetSixteen"] = 'files/SweetSixteen.ttf',
    ["ramofont1"] = 'files/franklin-gothic-atf-bold.otf',
    ["ramofont2"] = 'files/Familiar Pro-Bold.otf',
    ["ramofont3"] = 'files/URW DIN Arabic Bold.ttf',
    ["trojfont1"] = 'files/LinikSans-Medium.ttf',
    ["qozpurna"] = 'files/qozpurna.ttf',
}

function getFont(font, size)
    if not font then return end
    if not size then return end
	
    if string.lower(font) == "fontawesome" then font = "AwesomeFont" end
    if string.lower(font) == "fontawesome2" then font = "AwesomeFont2" end
    if string.lower(font) == "awesome2" then font = "AwesomeFont2" end
    if string.lower(font) == "awesomefont" then font = "AwesomeFont" end
	
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
        local v = fontsSource[_font]
        fontE = DxFont(v, size, bold, quality)
        local subText = font .. size
        fonts[subText] = fontE
    end
    
	return fontE
end