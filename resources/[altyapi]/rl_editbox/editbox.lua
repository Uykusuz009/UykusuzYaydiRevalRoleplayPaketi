local disabledKeys = {
    ["capslock"] = true,
    ["rctrl"] = true,
    ["lalt"] = true,
    ["ralt"] = true,
    ["home"] = true,
    [","] = true,
    ['"'] = true,
    ["*"] = true,
    ["+"] = true,
    ["//"] = true,
    [""] = true,
    ["tab"] = true,
    ["enter"] = true,
    ["lshift"] = true,
    ["rshift"] = true,
    ["mouse1"] = true,
    ["mouse2"] = true,
    ["mouse3"] = true,
    ["mouse4"] = true,
    ["mouse5"] = true,
    ["mouse6"] = true,
    ["F1"] = true, ["F2"] = true, ["F3"] = true, ["F4"] = true,
    ["F5"] = true, ["F6"] = true, ["F7"] = true, ["F8"] = true,
    ["F9"] = true, ["F10"] = true, ["F11"] = true, ["F12"] = true,
    ["num_add"] = true,
    ["num_enter"] = true,
    ["num_dec"] = true,
    ["num_sub"] = true,
    ["num_mul"] = true,
    ["num_div"] = true,
    ["arrow_u"] = true,
    ["arrow_l"] = true,
    ["arrow_r"] = true,
    ["arrow_d"] = true,
    ["mouse_wheel_down"] = true,
    ["mouse_wheel_up"] = true,
    ["pgdn"] = true,
    ["pgup"] = true,
    ["end"] = true,
    ["delete"] = true,
    ["insert"] = true,
    ["pause"] = true,
    ["scroll"] = true,
}

local keyMappings = {
    ["num_0"] = "0", ["num_1"] = "1", ["num_2"] = "2", ["num_3"] = "3", ["num_4"] = "4",
    ["num_5"] = "5", ["num_6"] = "6", ["num_7"] = "7", ["num_8"] = "8", ["num_9"] = "9",
    ["space"] = " ",
    ["SPACE"] = " ",
    -- Türkçe karakter mappings
    ["#"] = "i",
    ["i"] = "ı",
    ["ö"] = "ö",
    ["]"] = "ü",
    ["["] = "ğ",
    [";"] = "ş",
    ["/"] = "ç",
}

-- Global değişkenler
local ctrlPressed = false
local shiftPressed = false
local capsLockActive = false
local selectAllActive = false

-- EditBox verileri
local editBoxes = {}
local editTexts = {}
local activeEditBoxes = {}
local editBoxSettings = {}

-- EditBox oluşturma
function createEditBox(name)
    if not editBoxes[name] then
        table.insert(editBoxes, name)
        editTexts[name] = ""
        activeEditBoxes[name] = false
        editBoxSettings[name] = {
            maxLength = nil,
            onlyNumbers = false,
            onlyText = false,
            pasteEnabled = true,
            placeholder = ""
        }
        return true
    end
    return false
end

-- EditBox silme
function destroyEditBox(name)
    if editBoxes[name] then
        for i, v in pairs(editBoxes) do
            if v == name then
                table.remove(editBoxes, i)
                break
            end
        end
        editTexts[name] = nil
        activeEditBoxes[name] = nil
        editBoxSettings[name] = nil
        return true
    end
    return false
end

-- EditBox aktif/pasif yapma
function setEditBoxActive(name, active)
    if editTexts[name] then
        activeEditBoxes[name] = active
        return true
    end
    return false
end

-- EditBox aktif mi kontrol et
function isEditBoxActive(name)
    return activeEditBoxes[name] or false
end

-- EditBox metnini al
function getEditBoxText(name)
    return editTexts[name] or ""
end

-- EditBox metnini ayarla
function setEditBoxText(name, text)
    if editTexts[name] ~= nil then
        editTexts[name] = tostring(text)
        return true
    end
    return false
end

-- EditBox ayarları
function setEditBoxMaxLength(name, length)
    if editBoxSettings[name] then
        editBoxSettings[name].maxLength = length
        return true
    end
    return false
end

function setEditBoxNumbersOnly(name, enabled)
    if editBoxSettings[name] then
        editBoxSettings[name].onlyNumbers = enabled
        editBoxSettings[name].onlyText = false
        return true
    end
    return false
end

function setEditBoxTextOnly(name, enabled)
    if editBoxSettings[name] then
        editBoxSettings[name].onlyText = enabled
        editBoxSettings[name].onlyNumbers = false
        return true
    end
    return false
end

function setEditBoxPasteEnabled(name, enabled)
    if editBoxSettings[name] then
        editBoxSettings[name].pasteEnabled = enabled
        return true
    end
    return false
end

-- Metin temizleme
function clearEditBox(name)
    if editTexts[name] then
        editTexts[name] = ""
        return true
    end
    return false
end

-- Karakter kontrolü
local function isValidCharacter(char, settings)
    if settings.onlyNumbers then
        return tonumber(char) ~= nil
    elseif settings.onlyText then
        return tonumber(char) == nil and char ~= " "
    end
    return true
end

-- Ana key handler
local function onClientKey(key, keyState)
    -- Ctrl tuşu kontrolü
    if key == "lctrl" then
        ctrlPressed = keyState
        return
    end
    
    -- Shift tuşu kontrolü
    if key == "lshift" or key == "rshift" then
        shiftPressed = keyState
        return
    end
    
    -- Caps Lock kontrolü
    if key == "capslock" and keyState then
        capsLockActive = not capsLockActive
        return
    end
    
    -- Sadece key press olaylarını işle
    if not keyState then
        return
    end
    
    -- Aktif editbox'ları kontrol et
    for _, editBoxName in pairs(editBoxes) do
        if activeEditBoxes[editBoxName] then
            local settings = editBoxSettings[editBoxName]
            local currentText = editTexts[editBoxName]
            
            -- Ctrl kombinasyonları
            if ctrlPressed then
                if key == "a" then
                    -- Select All (şimdilik sadece flag set et)
                    selectAllActive = true
                    return
                elseif key == "c" and settings.pasteEnabled then
                    -- Copy
                    setClipboard(currentText)
                    return
                elseif key == "v" and settings.pasteEnabled then
                    -- Paste
                    local clipboardText = getClipboard()
                    if clipboardText then
                        -- Max length kontrolü
                        if settings.maxLength then
                            local remainingLength = settings.maxLength - utf8.len(currentText)
                            if remainingLength > 0 then
                                clipboardText = utf8.sub(clipboardText, 1, remainingLength)
                            else
                                return
                            end
                        end
                        
                        -- Karakter kontrolü
                        local validText = ""
                        for i = 1, utf8.len(clipboardText) do
                            local char = utf8.sub(clipboardText, i, i)
                            if isValidCharacter(char, settings) then
                                validText = validText .. char
                            end
                        end
                        
                        editTexts[editBoxName] = currentText .. validText
                    end
                    return
                elseif key == "x" and settings.pasteEnabled then
                    -- Cut
                    setClipboard(currentText)
                    editTexts[editBoxName] = ""
                    return
                end
            end
            
            -- Select All sonrası ilk tuş
            if selectAllActive then
                selectAllActive = false
                if not disabledKeys[key] then
                    editTexts[editBoxName] = ""
                    currentText = ""
                end
            end
            
            -- Backspace
            if key == "backspace" or key == "BACKSPACE" then
                if utf8.len(currentText) > 0 then
                    editTexts[editBoxName] = utf8.sub(currentText, 1, utf8.len(currentText) - 1)
                end
                return
            end
            
            -- Disabled keys kontrolü
            if disabledKeys[key] then
                return
            end
            
            -- Key mapping
            local finalKey = keyMappings[key] or key
            
            -- Shift/Caps Lock ile büyük harf
            if (shiftPressed or capsLockActive) and not (shiftPressed and capsLockActive) then
                finalKey = utf8.upper(finalKey)
            end
            
            -- Max length kontrolü
            if settings.maxLength and utf8.len(currentText) >= settings.maxLength then
                return
            end
            
            -- Karakter tipi kontrolü
            if not isValidCharacter(finalKey, settings) then
                return
            end
            
            -- Metni güncelle
            editTexts[editBoxName] = currentText .. finalKey
            break
        end
    end
end

-- Event handler'ı ekle
addEventHandler("onClientKey", root, onClientKey)

-- Eski fonksiyon isimleri için uyumluluk (backward compatibility)
editEkle = createEditBox
editRemove = destroyEditBox
editActive = setEditBoxActive
getText = getEditBoxText
isEditActive = isEditBoxActive
onlyNumber = setEditBoxNumbersOnly
onlyText = setEditBoxTextOnly
pasteActive = setEditBoxPasteEnabled
maxLenght = setEditBoxMaxLength

-- Debug fonksiyonu
function debugEditBox(name)
    if editTexts[name] then
        outputChatBox("EditBox '" .. name .. "': '" .. editTexts[name] .. "' (Active: " .. tostring(activeEditBoxes[name]) .. ")")
    else
        outputChatBox("EditBox '" .. name .. "' bulunamadı!")
    end
end

-- Tüm editbox'ları listele
function listEditBoxes()
    outputChatBox("=== EditBox Listesi ===")
    for i, name in pairs(editBoxes) do
        outputChatBox(i .. ". " .. name .. " - Text: '" .. editTexts[name] .. "' - Active: " .. tostring(activeEditBoxes[name]))
    end
end
