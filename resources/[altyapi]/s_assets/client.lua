local fonts = {}
local fontsSource = {
    ["AwesomeFont"] = "files/FontAwesome.ttf",
    ["AwesomeFont2"] = "files/FontAwesome2.ttf",
    ["FontAwesomeBrand"] = "files/FontAwesomeBrand.ttf",
    ["FontAwesomeRegular"] = "files/FontAwesomeRegular.otf",
	["in-bold"] = "files/in-bold.ttf",
    ["in-light"] = "files/in-light.ttf",
	["in-regular"] = "files/in-regular.ttf",
	["in-medium"] = "files/in-medium.ttf",
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