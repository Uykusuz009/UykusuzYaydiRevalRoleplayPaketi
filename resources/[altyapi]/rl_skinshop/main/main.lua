screen = Vector2(guiGetScreenSize())
local w, h = 350, 500
local x, y = (screen.x / w), (screen.y - h) / 2
local sx, sy = guiGetScreenSize()
local awesome = exports["kaisen_fonts"]:getFont("FontAwesome", 15)
local awesome2 = exports["kaisen_fonts"]:getFont("FontAwesome", 8)
local awesome4 = exports["kaisen_fonts"]:getFont("FontAwesome",12)
local montB2 = exports["kaisen_fonts"]:getFont("Roboto", 10)
local montB = exports["kaisen_fonts"]:getFont("Roboto", 22)
local tabasselected = 1
local controls = {"walk", "enter_exit", "forwards", "next_weapon", "previous_weapon", "backwards", "left", "right", "sprint", "jump", "crouch", "fire"}
local scroll = 0
local maxVisibleSkins = 14 
local skins = {
    ["Man"] = {

        {1, "Skin 1", 250},
        {2, "Skin 2", 250},
        {3, "Skin 3", 250},
        {4, "Skin 4", 250},
        {5, "Skin 5", 250},
        {6, "Skin 6", 250},
        {7, "Skin 7", 250},
        {8, "Skin 8", 250},
        {9, "Skin 9", 250},
        {10, "Skin 10", 250},
        {11, "Skin 11", 250},
        {12, "Skin 12", 250},
        {13, "Skin 13", 250},
        {14, "Skin 14", 250},
        {15, "Skin 15", 250},
        {16, "Skin 16", 250},
        {17, "Skin 17", 250},
        {18, "Skin 18", 250},
        {19, "Skin 19", 250},
        {20, "Skin 20", 250},
        {21, "Skin 21", 250},
        {22, "Skin 22", 250},
        {23, "Skin 23", 250},
        {24, "Skin 24", 250},
        {25, "Skin 25", 250},
        {26, "Skin 26", 250},
        {27, "Skin 27", 250},
        {28, "Skin 28", 250},
        {29, "Skin 29", 250},
        {30, "Skin 30", 250},
        {31, "Skin 31", 250},
        {32, "Skin 32", 250},
        {33, "Skin 33", 250},
        {34, "Skin 34", 250},
        {35, "Skin 35", 250},
        {36, "Skin 36", 250},
        {37, "Skin 37", 250},
        {38, "Skin 38", 250},
        {39, "Skin 39", 250},
        {40, "Skin 40", 250},
        {41, "Skin 41", 250},
        {42, "Skin 42", 250},
        {43, "Skin 43", 250},
        {44, "Skin 44", 250},
        {45, "Skin 45", 250},
        {46, "Skin 46", 250},
        {47, "Skin 47", 250},
        {48, "Skin 48", 250},
        {49, "Skin 49", 250},
        {50, "Skin 50", 250},
        {51, "Skin 51", 250},
        {52, "Skin 52", 250},
        {53, "Skin 53", 250},
        {54, "Skin 54", 250},
        {55, "Skin 55", 250},
        {56, "Skin 56", 250},
        {57, "Skin 57", 250},
        {58, "Skin 58", 250},
        {59, "Skin 59", 250},
        {60, "Skin 60", 250},
        {61, "Skin 61", 250},
        {62, "Skin 62", 250},
        {63, "Skin 63", 250},
        {64, "Skin 64", 250},
        {65, "Skin 65", 250},
        {66, "Skin 66", 250},
        {67, "Skin 67", 250},
        {68, "Skin 68", 250},
        {69, "Skin 69", 250},
        {70, "Skin 70", 250},
        {71, "Skin 71", 250},
        {72, "Skin 72", 250},
        {73, "Skin 73", 250},
        {74, "Skin 74", 250},
        {75, "Skin 75", 250},
        {76, "Skin 76", 250},
        {77, "Skin 77", 250},
        {78, "Skin 78", 250},
        {79, "Skin 79", 250},
        {80, "Skin 80", 250},
        {81, "Skin 81", 250},
        {82, "Skin 82", 250},
        {83, "Skin 83", 250},
        {84, "Skin 84", 250},
        {85, "Skin 85", 250},
        {86, "Skin 86", 250},
        {87, "Skin 87", 250},
        {88, "Skin 88", 250},
        {89, "Skin 89", 250},
        {90, "Skin 90", 250},
        {91, "Skin 91", 250},
        {92, "Skin 92", 250},
        {93, "Skin 93", 250},
        {94, "Skin 94", 250},
        {95, "Skin 95", 250},
        {96, "Skin 96", 250},
        {97, "Skin 97", 250},
        {98, "Skin 98", 250},
        {99, "Skin 99", 250},
        {100, "Skin 100", 250},
        {101, "Skin 101", 250},
        {102, "Skin 102", 250},
        {103, "Skin 103", 250},
        {104, "Skin 104", 250},
        {105, "Skin 105", 250},
        {106, "Skin 106", 250},
        {107, "Skin 107", 250},
        {108, "Skin 108", 250},
        {109, "Skin 109", 250},
        {110, "Skin 110", 250},
        {111, "Skin 111", 250},
        {112, "Skin 112", 250},
        {113, "Skin 113", 250},
        {114, "Skin 114", 250},
        {115, "Skin 115", 250},
        {116, "Skin 116", 250},
        {117, "Skin 117", 250},
        {118, "Skin 118", 250},
        {119, "Skin 119", 250},
        {120, "Skin 120", 250},
        {121, "Skin 121", 250},
        {122, "Skin 122", 250},
        {123, "Skin 123", 250},
        {124, "Skin 124", 250},
        {125, "Skin 125", 250},
        {126, "Skin 126", 250},
        {127, "Skin 127", 250},
        {128, "Skin 128", 250},
        {129, "Skin 129", 250},
        {130, "Skin 130", 250},
        {131, "Skin 131", 250},
        {132, "Skin 132", 250},
        {133, "Skin 133", 250},
        {134, "Skin 134", 250},
        {135, "Skin 135", 250},
        {136, "Skin 136", 250},
        {137, "Skin 137", 250},
        {138, "Skin 138", 250},
        {139, "Skin 139", 250},
        {140, "Skin 140", 250},
        {141, "Skin 141", 250},
        {142, "Skin 142", 250},
        {143, "Skin 143", 250},
        {144, "Skin 144", 250},
        {145, "Skin 145", 250},
        {146, "Skin 146", 250},
        {147, "Skin 147", 250},
        {148, "Skin 148", 250},
        {149, "Skin 149", 250},
        {150, "Skin 150", 250},
        {151, "Skin 151", 250},
        {152, "Skin 152", 250},
        {153, "Skin 153", 250},
        {154, "Skin 154", 250},
        {155, "Skin 155", 250},
        {156, "Skin 156", 250},
        {157, "Skin 157", 250},
        {158, "Skin 158", 250},
        {159, "Skin 159", 250},
        {160, "Skin 160", 250},
        {161, "Skin 161", 250},
        {162, "Skin 162", 250},
        {163, "Skin 163", 250},
        {164, "Skin 164", 250},
        {165, "Skin 165", 250},
        {166, "Skin 166", 250},
        {167, "Skin 167", 250},
        {168, "Skin 168", 250},
        {169, "Skin 169", 250},
        {170, "Skin 170", 250},
        {171, "Skin 171", 250},
        {172, "Skin 172", 250},
        {173, "Skin 173", 250},
        {174, "Skin 174", 250},
        {175, "Skin 175", 250},
        {176, "Skin 176", 250},
        {177, "Skin 177", 250},
        {178, "Skin 178", 250},
        {179, "Skin 179", 250},
        {180, "Skin 180", 250},
        {181, "Skin 181", 250},
        {182, "Skin 182", 250},
        {183, "Skin 183", 250},
        {184, "Skin 184", 250},
        {185, "Skin 185", 250},
        {186, "Skin 186", 250},
        {187, "Skin 187", 250},
        {188, "Skin 188", 250},
        {189, "Skin 189", 250},
        {190, "Skin 190", 250},
        {191, "Skin 191", 250},
        {192, "Skin 192", 250},
        {193, "Skin 193", 250},
        {194, "Skin 194", 250},
        {195, "Skin 195", 250},
        {196, "Skin 196", 250},
        {197, "Skin 197", 250},
        {198, "Skin 198", 250},
        {199, "Skin 199", 250},
        {200, "Skin 200", 250},
        {201, "Skin 201", 250},
        {202, "Skin 202", 250},
        {203, "Skin 203", 250},
        {204, "Skin 204", 250},
        {205, "Skin 205", 250},
        {206, "Skin 206", 250},
        {207, "Skin 207", 250},
        {208, "Skin 208", 250},
        {209, "Skin 209", 250},
        {210, "Skin 210", 250},
        {211, "Skin 211", 250},
        {212, "Skin 212", 250},
        {213, "Skin 213", 250},
        {214, "Skin 214", 250},
        {215, "Skin 215", 250},
        {216, "Skin 216", 250},
        {217, "Skin 217", 250},
        {218, "Skin 218", 250},
        {219, "Skin 219", 250},
        {220, "Skin 220", 250},
        {221, "Skin 221", 250},
        {222, "Skin 222", 250},
        {223, "Skin 223", 250},
        {224, "Skin 224", 250},
        {225, "Skin 225", 250},
        {226, "Skin 226", 250},
        {227, "Skin 227", 250},
        {228, "Skin 228", 250},
        {229, "Skin 229", 250},
        {230, "Skin 230", 250},
        {231, "Skin 231", 250},
        {232, "Skin 232", 250},
        {233, "Skin 233", 250},
        {234, "Skin 234", 250},
        {235, "Skin 235", 250},
        {236, "Skin 236", 250},
        {237, "Skin 237", 250},
        {238, "Skin 238", 250},
        {239, "Skin 239", 250},
        {240, "Skin 240", 250},
        {241, "Skin 241", 250},
        {242, "Skin 242", 250},
        {243, "Skin 243", 250},
        {244, "Skin 244", 250},
        {245, "Skin 245", 250},
        {246, "Skin 246", 250},
        {247, "Skin 247", 250},
        {248, "Skin 248", 250},
        {249, "Skin 249", 250},
        {250, "Skin 250", 250},
        {251, "Skin 251", 250},
        {252, "Skin 252", 250},
        {253, "Skin 253", 250},
        {254, "Skin 254", 250},
        {255, "Skin 255", 250},
        {256, "Skin 256", 250},
        {257, "Skin 257", 250},
        {258, "Skin 258", 250},
        {259, "Skin 259", 250},
        {260, "Skin 260", 250},
        {261, "Skin 261", 250},
        {262, "Skin 262", 250},
        {263, "Skin 263", 250},
        {264, "Skin 264", 250},
        {265, "Skin 265", 250},
        {266, "Skin 266", 250},
        {267, "Skin 267", 250},
        {268, "Skin 268", 250},
        {269, "Skin 269", 250},
        {270, "Skin 270", 250},
        {271, "Skin 271", 250},
        {272, "Skin 272", 250},
        {273, "Skin 273", 250},
        {274, "Skin 274", 250},
        {275, "Skin 275", 250},
        {276, "Skin 276", 250},
        {277, "Skin 277", 250},
        {278, "Skin 278", 250},
        {279, "Skin 279", 250},
        {280, "Skin 280", 250},
        {281, "Skin 281", 250},
        {282, "Skin 282", 250},
        {283, "Skin 283", 250},
        {284, "Skin 284", 250},
        {285, "Skin 285", 250},
        {286, "Skin 286", 250},
        {287, "Skin 287", 250},
        {288, "Skin 288", 250},
        {289, "Skin 289", 250},
        {290, "Skin 290", 250},
        {291, "Skin 291", 250},
        {292, "Skin 292", 250},
        {293, "Skin 293", 250},
        {294, "Skin 294", 250},
        {295, "Skin 295", 250},
        {296, "Skin 296", 250},
        {297, "Skin 297", 250},
        {298, "Skin 298", 250},
        {299, "Skin 299", 250},
        {300, "Skin 300", 250},
        {301, "Skin 301", 250},
        {302, "Skin 302", 250},
        {303, "Skin 303", 250},
        {304, "Skin 304", 250},
        {305, "Skin 305", 250},
        -- {306, "Skin 306", 250},
        {307, "Skin 307", 250},
        -- {308, "Skin 308", 250},
        {309, "Skin 309", 250},
        {310, "Skin 310", 250},
        {311, "Skin 311", 250},
        {312, "Skin 312", 250}

    }
    
    -- ["Woman"] = {
    --     {63, "Kadın Skin 1", 1500},
    --     {64, "Kadın Skin 2", 1500},
    --     {73, "Kadın Skin 3", 1500},
    --     {66, "Kadın Skin 4", 1500},
    --     {67, "Kadın Skin 5", 1500},
    --     {68, "Kadın Skin 6", 1500},
    --     {69, "Kadın Skin 7", 1500},
    --     {70, "Kadın Skin 8", 1500},
    --     {71, "Kadın Skin 9", 1500},
    --     {72, "Kadın Skin 10", 1500},
    --     {91, "Kadın Skin 11", 1500},
    --     {169, "Kadın Skin 12", 1500},
    --     {90, "Kadın Skin 13", 1500},
    --     {231, "Kadın Skin 14", 1500},
    --     {237, "Kadın Skin 16", 1500},
    --     {10, "Kadın Skin 17", 1500}
    -- }
}
local allSkins = {
    ["Erkek Skinler"] = skins["Man"]
}
local pages = {
    {"Erkek Skinler", "M"}
}

local enablorp_cam = false
local last_cam_pos = 1
local cam_pos = {}
local animPed
local renderSkins = false
local menu = "skinchooser"  
local skintype = "Man"     
local valt = 1              
local current = 1   
local purchaseCooldown = false
local click = 0
local selectedSkin = skins["Man"][1] 
local ped = createPed(11, 162.3017578125, -80.681640625, 1001.8046875)
setElementData(ped, "skinPanelNPC", true)
setElementDimension(ped, 6)
setElementInterior(ped, 18)
setElementRotation(ped, 0, 0, 178.64318847656)

function realSkinPanel()
    if not isTimer(render) then
        renderSkins = true
        menu = "skinchooser" -- Doğrudan "skinchooser" moduna geçiş
        setElementData(localPlayer, "skinPanelActi", true)
        page, selected, scroll = 0, 1, 0
        skintype = "Man"
        valt = 1
        current = 1
        selectedSkin = skins["Man"][1] -- İlk skin varsayılan olarak seçiliyor

        -- İlk skinin modelini ped'e atama

        showChat(false)
        setCameraPos(1)
        setElementData(localPlayer, "galeride", true)
		setElementData(localPlayer,"hudkapa",true)
        if isElement(animPed) then
            destroyElement(animPed)
        end
        animPed = createPed(selectedSkin[1], 161.333984375, -71.2236328125, 1001.8046875)
        setElementRotation(animPed, 0, 0, 176.69854736328)
        setElementInterior(animPed, 18)
        setElementDimension(animPed, 103)

        render = setTimer(function()
            for _, control in ipairs(controls) do
                toggleControl(control, false)
            end
            dxDrawImage(0, 0, screen.x, screen.y, ":rl_main/arkaplanisikmor.png", 0, 0, 0, tocolor(0, 0, 0, 220))
            roundedRectangle(x + 20, y, w, h, 8, tocolor(100, 100, 100, 100))
			 -- roundedRectangle(x + 24, y +83, w - 10, h-110, 8, tocolor(100, 100, 100, 100))
            roundedRectangle(x + 30, y + 10, w - 20, 35, 8, tocolor(100, 100, 100, 100))
           
            dxDrawText("Skin Panel", x + 40, y + 5, nil, nil, tocolor(220, 220, 220, 220), 1, montB)
            dxDrawImage(x + 40, y +500, 45, 45, ":rl_main/enter.png", 0, 0, 0, tocolor(220, 220, 220, 220))
			 dxDrawText("Satın almak için Enter tuşuna basınız.", x + 87, y + 515, nil, nil, tocolor(220, 220, 220, 220), 1, montB2)
            dxDrawImage(x + 40, y +535, 45,45, ":rl_main/esc.png", 0, 0, 0, tocolor(220, 220, 220, 220))
         
			 dxDrawText("Çıkmak için Backspace tuşuna basınız.", x + 87, y + 548, nil, nil, tocolor(220, 220, 220, 220), 1, montB2)

            drawTabMenu()
            drawSkinList()
        end, 0, 0)
    else
        closeSkinPanel()
    end
end
function drawSkinList()
    local addY, counter = 0, 0
    local skinList = allSkins[pages[tabasselected][1]]

    if not skinList then return end

    createScrollBar(x + w - 10, y + 85, 10, h - 110, #skinList, maxVisibleSkins, scroll, tocolor(100, 100, 100, 150), tocolor(200, 200, 200, 150))

    for index, value in ipairs(skinList) do
        if index > scroll and counter < maxVisibleSkins then
            local isHovered = isMousePosition(x + 30, y + 85 + addY, w - 35, 25)
            local bgColor = isHovered and tocolor(125, 125, 125, 125) or tocolor(100, 100, 100, 100)
            local textColor = isHovered and tocolor(220, 220, 220, 220) or tocolor(175, 175, 175, 175)

            roundedRectangle(x + 30, y + 85 + addY, w - 35, 25, 4, bgColor)
            dxDrawText(value[2] .. " - ID: " .. value[1] .. " - Fiyat: " .. value[3] .. " ₺", x + 40, y + 90 + addY, nil, nil, textColor, 1, montB2)

            -- Tıklama kontrolü
            if isHovered and isClicked(x + 30, y + 85 + addY, w - 35, 25) then
                if isElement(animPed) then
                    destroyElement(animPed)
                end
                animPed = createPed(value[1], 161.333984375, -71.2236328125, 1001.8046875)
                setElementRotation(animPed, 0, 0, 176.69854736328)
                setElementInterior(animPed, 18)
                setElementDimension(animPed, 103)

                -- Seçilen skin'i güncelle
                selectedSkin = value
                current = index -- seçilen skin index'i
            end

            addY = addY + 29.5
            counter = counter + 1
        end
    end
end

function down()
    local skinList = allSkins[pages[tabasselected][1]]
    if isTimer(render) then
        if scroll < #skinList - maxVisibleSkins then
            scroll = scroll + 1
        end
    end
end

function up()
    if isTimer(render) then
        if scroll > 0 then
            scroll = scroll - 1
        end
    end
end

bindKey("mouse_wheel_up", "down", up)
bindKey("mouse_wheel_down", "down", down)



function onBackspacePress()
    if isTimer(render) then
        closeSkinPanel()
    end
end
bindKey("backspace", "down", onBackspacePress)

function onEnterPress()
    if purchaseCooldown then
        return
    end

    if renderSkins and menu == "skinchooser" and selectedSkin then
        local cost = selectedSkin[3]
        local skinID = selectedSkin[1]

        if tonumber(getElementData(localPlayer, "money")) >= cost then
            purchaseCooldown = true
            setTimer(function() purchaseCooldown = false end, 1000, 1)

            -- Seçilen skin verisini sunucuya gönder
            triggerServerEvent("onSkinBuy", localPlayer, skinID, cost)
        else
            outputChatBox("[!] Yeterli paranız yok!", 255, 0, 0, true)
        end
    end
end
bindKey("enter", "down", onEnterPress)

addEvent("moneyUpdateFX", true)
addEventHandler("moneyUpdateFX", root, function()
end)

function getTabContent(index)
    if pages[index] and allSkins[pages[index][1]] then
        return allSkins[pages[index][1]]
    else
        return {}
    end
end

function closeSkinPanel()
    if isTimer(render) then killTimer(render) end
    for _, control in ipairs(controls) do toggleControl(control, true) end
    showChat(true)
	
	setElementData(localPlayer, "galeride", false)
	setElementData(localPlayer,"hudkapa",false)
    setElementData(localPlayer, "skinPanelActi", false)
    managePed("destroy")  
    setCameraTarget(localPlayer) 
end
function handleSkinPanelNPCClick(button, state, _, _, _, _, _, clickedElement)
    if clickedElement and getElementData(clickedElement, "skinPanelNPC") then
        if button == "right" and state == "down" then
            renderSkins = true
            menu = "typechooser"
            realSkinPanel()
        end
    end
end
addEventHandler("onClientClick", root, handleSkinPanelNPCClick)

function drawTabMenu()
    local addX = 0
    for index, value in ipairs(pages) do
        if isMousePosition(x + 30 + addX, y + 55, 25, 25) then
            roundedRectangle(x + 30 + addX, y + 55, 25, 25, 4, tocolor(125, 125, 125, 125))
            dxDrawText(value[2], x + 30 + 12.5 + addX, y + 55 + 5, nil, nil, tocolor(225, 225, 225, 225), 1, awesome2, "center", "top")
            if isClicked(x + 30 + addX, y + 55, 25, 25) then
                tabasselected, page, scroll = index, 1, 0
                panelsecti = getTabContent(index)
            end
        else
            roundedRectangle(x + 30 + addX, y + 55, 25, 25, 4, tocolor(100, 100, 100, 100))
            dxDrawText(value[2], x + 30 + 12.5 + addX, y + 55 + 5, nil, nil, tocolor(175, 175, 175, 175), 1, awesome2, "center", "top")
        end
        addX = addX + 30
    end
end


function up()
    if isTimer(render) then
        if scroll > 0 then
            scroll = scroll - 1
        end
    end
end
bindKey("mouse_wheel_up", "down", up)

function isMousePosition(x, y, width, height)
    if not isCursorShowing() then return false end
    local sx, sy = guiGetScreenSize()
    local cx, cy = getCursorPosition()
    local cx, cy = (cx * sx), (cy * sy)
    return (cx >= x and cx <= x + width) and (cy >= y and cy <= y + height)
end

function createScrollBar(x, y, w, h, total, maxShow, currentShow, color, color2)
    if total > maxShow then
      
        roundedRectangle(x + 10, y, w, h + 20, 4, color or tocolor(100, 100, 100, 100))

       
        roundedRectangle(x + 10,y + ((currentShow) * ((h + 20) / total)),w,(h + 20) / math.max((total / maxShow), 1),4,color2 or tocolor(100, 100, 100, 100))
    end
end
function updateCamPosition()
    if enablorp_cam and cam_pos[last_cam_pos] then
        local cTick = getTickCount()
        local delay = cTick - lastCamTick
        local duration = cam_pos[last_cam_pos][13]
        local progress = delay / duration

        if progress < 1 then
            local cx, cy, cz = interpolateBetween(
                cam_pos[last_cam_pos][1], cam_pos[last_cam_pos][2], cam_pos[last_cam_pos][3],
                cam_pos[last_cam_pos][7], cam_pos[last_cam_pos][8], cam_pos[last_cam_pos][9],
                progress, "Linear"
            )
            local tx, ty, tz = interpolateBetween(
                cam_pos[last_cam_pos][4], cam_pos[last_cam_pos][5], cam_pos[last_cam_pos][6],
                cam_pos[last_cam_pos][10], cam_pos[last_cam_pos][11], cam_pos[last_cam_pos][12],
                progress, "Linear"
            )
            setCameraMatrix(cx, cy, cz, tx, ty, tz)
        else
            enablorp_cam = false
        end
    end
end
addEventHandler("onClientRender", root, updateCamPosition)

function setCameraPos(id)
    lastCamTick = getTickCount()
    last_cam_pos = id
    -- Kamera başlangıç ve hedef noktalarını yeni koordinatlara ayarla
    cam_pos = {
        {
            159.4873046875, -74.8251953125, 1001.8046875, -- Kamera pozisyonu
            161.5966796875, -62.4609375, 1001.8046875,    -- Bakış noktası (önizleme pedinin pozisyonu)
            161.4873046875, -74.8251953125, 1001.8046875, -- Interpolasyon için başlangıç (gerekiyorsa)
            161.5966796875, -60.4609375, 1001.8046875,    -- Interpolasyon için hedef (gerekiyorsa)
            5000
        }
    }
    -- Kamera hemen yeni pozisyona geçsin
    setCameraMatrix(161.4873046875, -74.8251953125, 1001.8046875, 161.5966796875, -71.4609375, 1001.8046875)
    setElementInterior(localPlayer, 18)
    setElementDimension(localPlayer, 6)
    enablorp_cam = false
end
function isClicked(x, y, w, h)
    if isMousePosition(x, y, w, h) and getKeyState("mouse1") and click + 600 <= getTickCount() then
        click = getTickCount()
        return true
    end
    return false
end


function managePed(action)
    if action == "create" then
        if not isElement(animPed) then
            -- animPed = createPed(11, 218.2265625, -98.4796875, 1005.2578125)
            -- setElementInterior(animPed, 15)
            -- setElementDimension(animPed, 6)
            -- setElementRotation(animPed, 0, 0, 180.95008850098)
        end
    elseif action == "destroy" then
        if isElement(animPed) then
            destroyElement(animPed)
        end
    end
end

function roundedRectangle(x, y, width, height, radius, color)
    local diameter = radius * 2
    dxDrawCircle(x + radius, y + radius, radius, 180, 270, color)
    dxDrawCircle(x + width - radius, y + radius, radius, 270, 360, color)
    dxDrawCircle(x + radius, y + height - radius, radius, 90, 180, color)
    dxDrawCircle(x + width - radius, y + height - radius, radius, 0, 90, color)
    dxDrawRectangle(x + radius, y, width - diameter, height, color)
    dxDrawRectangle(x, y + radius, radius, height - diameter, color)
    dxDrawRectangle(x + width - radius, y + radius, radius, height - diameter, color)
    dxDrawRectangle(x + radius, y + radius, width - diameter, height - diameter, tocolor(0, 0, 0, 0))
end
