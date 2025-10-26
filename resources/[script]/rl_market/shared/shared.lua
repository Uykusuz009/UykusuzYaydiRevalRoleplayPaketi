developerMode = false

DUPONT_PRICE = 200

CONVERT_MONEY_MULTIPLIER = 2000 -- 1 TL = 5000$ (Para Çevirme)

TAG_PRICE = 100

-- Etiketlere indirimli fiyat yapmak için örnek: TAG_DISCOUNT_PRICE = 50 (Bütün etiketler için geçerlidir)

--TAG_DISCOUNT_PRICE = 50 -- etiket indirimli fiyat

TAG_COUNT = 27 -- Nametagında kaç tane etiket olduğunu gir

bakiyedagitUsernames = {
	["hakocxn"] = true,
}

CATEGORIES = {
	"Genel",
	"VIP",
	"Araç",
	"Silah",
	"Kıyafet",
	"Para",
	"Etiket",
	"",
	""
}

VEHICLE_CATEGORIES = {
	"Araçlar",
	"Araç Özellikleri"
}

-- indirim yapmak için {price = xx} yazan yerleri şu şekilde düzenle {price = xx, discountPrice = indirimliFiyat}
PERSONAL_FEATURES = {
	{"starter-package", "Başlangıç Paketi", {price = 280, discountPrice = 99}, "market.buyStarterPackage"},
	{"character-name-change", "İsim Değişikliği", {price = 70}},
	{"username-change", "Kullanıcı Adı Değişikliği", {price = 70}},
	{"character-slot", "Ek Karakter Slotu (+1)", {price = 25}, "market.buyCharacterSlot"},
	{"car-slot", "Ek Araç Slotu (+1)", {price = 25}, "market.buyVehicleSlot"},
	{"home-slot", "Ek Ev Slotu (+1)", {price = 25}, "market.buyPropertySlot"},
	{"history-clear", "History Sildirme (1 adet)", {price = 5}, "market.buyRemoveHistory"},
	{"faction-name-change", "Birlik İsim Değişikliği", {price = 40}},
	{"book", "Dövüş Kitabı", {price = 100}}
}

starterPackPrizes = {
	{"Para", 75000},
	{"VIP", 7, 4},
	{"BMW i8", 527, 1106, 'vehicle'}
}

EXTRA_VEHICLE_WINDOW_TINT = 20 -- Araç satın alırken cam filmi seçeneğini seçerse ekstra ne kadar ödeyeceğini buradan ayarla
EXTRA_VEHICLE_PLATE = 15 -- Araç satın alırken plaka seçeneğini seçerse ekstra ne kadar ödeyeceğini buradan ayarla

-- indirim yapmak için {price = xx} yazan yerleri şu şekilde düzenle {price = xx, discountPrice = indirimliFiyat}
VEHICLE_FEATURES = {
	-- {"car-shield", "Araç Çakar", {price = 100}, "market.buyShield"},
	{"change-plate-texture", "Plaka Tasarımı", {price = 30}, "plateDesign.showList"},
	{"change-plate", "Plaka Değişikliği", {price = 30}},
	{"car-tint", "Cam Filmi", {price = 40}},
	{"car-neon", "Neon Sistemi", {price = 60}, "neon.showList"},
	{"vehicle-texture", "Kaplama Sistemi", {price = 100}},
	{"car-butterfly", "Kelebek Kapı", {price = 35}}
}

-- indirim yapmak için {price = xx} yazan yerleri şu şekilde düzenle {price = xx, discountPrice = indirimliFiyat}
PRIVATE_VEHICLES = {
    {"Rolls Royce Wraith [Zırthlı]", 580, 24, {price = 1500}},
    {"Nuckingkam Maverick", 487, 89, {price = 1000}},
    {"Koenigsegg Agera ONE:1", 411, 7, {price = 700}},
    {"McLaren P1", 503, 8, {price = 700}},
    {"Ferrari LaFerrari", 494, 9, {price = 700}},
    {"Lamborghini Aventador", 506, 12, {price = 500}},
    {"Ferrari 488", 401, 11, {price = 500}},
    {"Nissan GT-R R35 NISMO", 541, 10, {price = 300}},
    {"Lamborghini Huracan", 502, 68, {price = 300}},
    {"BMW M4 F82 Cabrio", 603, 19, {price = 300}},
    {"Audi R8 GT Spyder", 415, 28, {price = 300}},
    {"Mercedes-benz AMG GT63s", 412, 20, {price = 200}},
    {"Lamborghini Urus", 579, 15, {price = 150}},
    {"Range Rover Evoque", 495, 16, {price = 150}},
    {"Chery Tiggo 8 Pro", 561, 14, {price = 120}},
    {"Ford Mustang GT", 602, 18, {price = 120}},
    {"Ninja H2r", 522, 143, {price = 100}}
}


-- indirim yapmak için {price = xx} yazan yerleri şu şekilde düzenle {price = xx, discountPrice = indirimliFiyat}
PRIVATE_WEAPONS = {
	{"M4", 356, 31, {price = 450}},
	{"AK-47", 355, 30, {price = 275}},
	{"Shotgun", 349, 25, {price = 175}},
	{"MP-5", 353, 29, {price = 150}},
	{"Tec-9", 372, 32, {price = 100}},
	{"Uzi", 352, 28, {price = 100}},
	{"Deagle", 348, 24, {price = 70}},
	{"Colt-45", 346, 22, {price = 60}}
}

VIPS = {
	1,
	2,
	3,
	4
}

vipFeatures = {
	{"Tüm mesleklerden daha fazla para kazanır", 1},
	{"AFK bölgesinde dakika başı 400₺ alır", 1},
	{"PM kapatma özelliği (/pmkapat)", 1},
	{"Maske kullanabilme özelliği", 1},
	{"Tüm mesleklerden daha fazla para kazanır", 2},
	-- {"AK47 markalı silahı kullanabilir", 2},
	{"AFK bölgesinde dakika başı 450₺ alır", 2},
	{"PM kapatma özelliği (/pmkapat)", 2},
	{"Maske kullanabilme özelliği", 2},
	{"Tüm mesleklerden daha fazla para kazanır", 3},
	{"M4 markalı silahı kullanabilir", 3},
	{"AFK bölgesinde dakika başı 500₺ alır", 3},
	{"PM kapatma özelliği (/pmkapat)", 3},
	{"Maske kullanabilme özelliği", 3},
	{"Tüm mesleklerden daha fazla para kazanır", 4},
	-- {"AK47 markalı silahı kullanabilir", 4},
	{"M4 markalı silahı kullanabilir", 4},
	{"AFK bölgesinde dakika başı 600₺ alır", 4},
	{"PM kapatma özelliği (/pmkapat)", 4},
	{"Maske kullanabilme özelliği", 4},
}

VIPsEnums = {
	VIP1 = 1,
	VIP2 = 2,
	VIP3 = 3,
	VIP4 = 4
}


FACTIONTYPE = {
	1,
	2
}

FACTIONTYPEsEnums = {
	GANG = 1,
	MAFIA = 2
}

LUCK_BOXES = {
	{351, "Bronz Şans Kutusu", 20},
	{352, "Gümüş Şans Kutusu", 40},
	{353, "Altın Şans Kutusu", 60},
	{354, "Elmas Şans Kutusu", 80}
}

LuckBoxesEnums = {
	BRONZE = 1,
	SILVER = 2,
	GOLD = 3,
	DIAMOND = 4
}

FIGHT_BOOK = {
	{20, "Normal Dövüş Kitabı", 100},
	{24, "Tekme Dövüş Kitabı", 100},
	{21, "Box Dövüş Kitabı", 100},
	{25, "Dirsek DÖvüş Kitabı", 100},
	{22, "Kung-Fu Dövüş Kitabı", 100},
	{23, "Diz Dövüş Kitabı", 100}
}

fightBookEnums = {
	STANDART = 1,
	GRABKICK = 2,
	BOX = 3,
	ELBOW = 4,
	KUNGFU = 5,
	KNEEHEAD = 6
}

function isPrivateVehicle(model)
    for _, vehicle in ipairs(PRIVATE_VEHICLES) do
        if model == vehicle[2] then
            return true
        end
    end
    return false
end

function getJailPrice(player)
    local jailTime = tonumber(getElementData(player, "jailtime")) or 0
    return calculateOOCJailPrice(jailTime)
end

function calculateOOCJailPrice(jailTime)
    local pricePerMinute = 1
    local maxPrice = 300

    local price = jailTime * pricePerMinute
    return math.min(price, maxPrice)
end