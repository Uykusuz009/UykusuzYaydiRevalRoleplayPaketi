screenSize = Vector2(guiGetScreenSize())

theme = exports.rl_ui:useTheme()
fonts = exports.rl_ui:useFonts()

fonts.font1 = exports.kaisen_fonts:getFont("UbuntuRegular", 30)
fonts.font2 = exports.kaisen_fonts:getFont("FontAwesome", 12)
fonts.font3 = exports.kaisen_fonts:getFont("sf-light", 11)
fonts.font4 = exports.kaisen_fonts:getFont("sf-bold", 11)
fonts.font5 = exports.kaisen_fonts:getFont("sf-bold", 10)
fonts.font6 = exports.kaisen_fonts:getFont("sf-light", 11)
fonts.font7 = fonts.FontAwesome.h5
fonts.font8 = exports.kaisen_fonts:getFont("sf-bold", 25)
fonts.font9 = exports.kaisen_fonts:getFont("sf-bold", 20)
fonts.font10 = exports.kaisen_fonts:getFont("sf-regular", 10)
fonts.font11 = exports.kaisen_fonts:getFont("sf-regular", 17)
fonts.font12 = exports.kaisen_fonts:getFont("FontAwesome", 13)
fonts.font13 = exports.kaisen_fonts:getFont("in-bold", 10)
fonts.font14 = exports.kaisen_fonts:getFont("sf-light", 10)
fonts.font15 = exports.kaisen_fonts:getFont("sf-regular", 9)
fonts.font16 = exports.kaisen_fonts:getFont("sf-bold", 12)
fonts.font17 = exports.kaisen_fonts:getFont("sf-bold", 13)
fonts.font18 = exports.kaisen_fonts:getFont("sf-mediumitalic", 13)
fonts.font19 = exports.kaisen_fonts:getFont("sf-regular", 11)
fonts.font20 = exports.kaisen_fonts:getFont("sf-bold", 23)
fonts.font21 = exports.kaisen_fonts:getFont("sf-regular", 23)
fonts.font22 = exports.kaisen_fonts:getFont("sf-regular", 12)
fonts.font23 = exports.kaisen_fonts:getFont("BebasNeueRegular", 15)
fonts.font24 = exports.kaisen_fonts:getFont("FontAwesome", 130)

selectedPage = 1
selectedVehiclePage = 1

function restartMarket()
    selectedProduct = false
    indexPage = false
    selectedVIP = false
    selectedWeapon = {selected = 1, price = (not PRIVATE_WEAPONS[1][4].discountPrice and tonumber(PRIVATE_WEAPONS[1][4].price) or tonumber(PRIVATE_WEAPONS[1][4].discountPrice))}
    selectedVehicle = {selected = 1, price = (not PRIVATE_VEHICLES[1][4].discountPrice and tonumber(PRIVATE_VEHICLES[1][4].price) or tonumber(PRIVATE_VEHICLES[1][4].discountPrice))}
    selectedTag = {selected = 1, name = 'Etiket 1', price = (not TAG_DISCOUNT_PRICE and TAG_PRICE or TAG_DISCOUNT_PRICE)}
    windowTint = {checked = false}
    vehiclePlate = {checked = false}
	clickTick = getTickCount()
	tickCount = getTickCount()
end