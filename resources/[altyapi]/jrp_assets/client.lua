local fonts = {}
local fontsSource = {
    ["AwesomeFont"] = "files/FontAwesome.ttf",
    ["FontAwesomeBrand"] = "files/FontAwesomeBrand.ttf",
    ["FontAwesomeRegular"] = "files/FontAwesomeRegular.otf",
    
	["breeze-bold"] = "files/breeze-bold.ttf",
    ["breeze-medium"] = "files/breeze-medium.ttf",
    ["breeze-regular"] = "files/breeze-regular.ttf",
    ["breeze-thin"] = "files/breeze-thin.ttf",    
	["breeze-light"] = "files/breeze-light.ttf",
	
    ["Sweet"] = "files/Sweet.ttf",
	["avalon"] = "files/avalon.ttf",
    ["avalon-bold"] = "files/avalon-bold.ttf",
    
	["ps-bold"] = "files/ps-bold.ttf",
    ["ps-bolditalic"] = "files/ps-bolditalic.ttf",
    ["ps-regular"] = "files/ps-regular.ttf",
    ["ps-italic"] = "files/ps-italic.ttf",
    ["ps-thin"] = "files/ps-thin.ttf",
    ["ps-thinitalic"] = "files/ps-thinitalic.ttf",
    ["ps-black"] = "files/ps-black.ttf",
	["ps-blackitalic"] = "files/ps-blackitalic.ttf",
    ["ps-elight"] = "files/ps-elight.ttf",
	["ps-elightitalic"] = "files/ps-elightitalic.ttf",
    ["ps-light"] = "files/ps-light.ttf",
    ["ps-lightitalic"] = "files/ps-lightitalic.ttf",
	["ps-medium"] = "files/ps-medium.ttf",
    ["ps-mediumitalic"] = "files/ps-mediumitalic.ttf",
	
	["kf-bold"] = "files/kf-bold.ttf",
    ["kf-bolditalic"] = "files/kf-bolditalic.ttf",
	["kf-regular"] = "files/kf-regular.ttf",
    ["kf-italic"] = "files/kf-italic.ttf",

	["np-bold"] = "files/np-bold.ttf",
	["np-extralight"] = "files/np-extralight.ttf",
    ["np-light"] = "files/np-light.ttf",
	["np-medium"] = "files/np-medium.ttf",
    ["np-regular"] = "files/np-regular.ttf",
	
	["in-bold"] = "files/in-bold.ttf",
	["in-elight"] = "files/in-elight.ttf",
    ["in-elightitalic"] = "files/in-elightitalic.ttf",
	["in-italic"] = "files/in-italic.ttf",
    ["in-light"] = "files/in-light.ttf",
    ["in-lightitalic"] = "files/in-lightitalic.ttf",
	["in-regular"] = "files/in-regular.ttf",
    ["in-thin"] = "files/in-thin.ttf",
    ["in-thinitalic"] = "files/in-thinitalic.ttf",
	["in-medium"] = "files/in-medium.ttf",
	
	["Bebas"] = "files/Bebas.ttf",
    ["BoldFont"] = "files/BoldFont.ttf",
	["gotham_light"] = "files/gotham_light.ttf",
	["OpenSans"] = "files/OpenSans.ttf",
	["Roboto"] = "files/Roboto.ttf",
	["RobotoB"] = "files/RobotoB.ttf",
	["RobotoL"] = "files/RobotoL.ttf",
    ["sf-black"] = "files/sf-black.ttf",
    ["sf-bold"] = "files/sf-bold.ttf",
    ["sf-medium"] = "files/sf-medium.ttf",
    ["sf-regular"] = "files/sf-regular.ttf",
	["sf-regular-italic"] = "files/sf-regular-italic.ttf",
    ["sf-thin"] = "files/sf-thin.ttf",
}


function getFont(font, size)
    if not font then return end
    if not size then return end
	
    if string.lower(font) == "fontawesome" then font = "AwesomeFont" end
    if string.lower(font) == "fontawesome2" then font = "oldfont" end
    if string.lower(font) == "awesome2" then font = "oldfont" end
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