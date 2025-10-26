local INITIAL_INPUT_OPTIONS = {
    position = {},
    size = {},
    radius = DEFAULT_RADIUS,
    padding = 10,

    name = "",
    regex = false,

    label = "",
    placeholder = "",
    value = "",
    helperText = {
        text = "",
        color = "gray"
    },

    variant = "soft",
    color = "gray",

    textVariant = "body",
    textWeight = "regular",
    maxLength = 100,

    disabled = false,

    mask = false,
}

local function fillStrToWidth(str, font, maxWidth)
    local strWidth = dxGetTextWidth(str, 1, font)

    if strWidth < maxWidth then
        return str, { str }
    end

    local strLen = utf8.len(str)

    local maxCharactersPerLine = math.floor(maxWidth / (strWidth / strLen)) - 2
    local lines = {}
    local currentLineStr = ""

    for i = 1, strLen do
        local character = utf8.sub(str, i, i)

        if utf8.len(currentLineStr) == maxCharactersPerLine then
            table.insert(lines, currentLineStr)
            currentLineStr = ""
        else
            currentLineStr = currentLineStr .. character
        end
    end

    if utf8.len(currentLineStr) > 0 then
        table.insert(lines, currentLineStr)
    end

    return table.concat(lines, "\n")
end

local function findCurrentLine(fullStr, caretIndex)
    local currentLine = 1
    local lines = exports.rl_global:split(fullStr, "\n")

    for i = 1, caretIndex do
        local character = utf8.sub(fullStr, i, i)

        if character == "\n" then
            currentLine = currentLine + 1
        end
    end

    return currentLine, lines
end

createComponent("textArea", INITIAL_INPUT_OPTIONS, function(options, store)
    local position = options.position or initialPosition
    local size = options.size or initialSize
    local radius = options.radius or INITIAL_INPUT_OPTIONS.radius
    local padding = options.padding or INITIAL_INPUT_OPTIONS.padding

    local name = options.name or ""
    local regex = options.regex or false

    local label = options.label or ""
    local placeholder = options.placeholder or ""
    local value = options.value or ""
    local helperText = options.helperText or INITIAL_INPUT_OPTIONS.helperText

    local variant = options.variant or "soft"
    local color = options.color

    local textVariant = options.textVariant
    local textWeight = options.textWeight

    local disabled = options.disabled
    local maxLength = options.maxLength

    local mask = options.mask

    if not store.get(name) then
        local guiElement = GuiMemo(position.x, position.y, size.x, size.y, value, false)

        if regex then
            guiElement:setProperty("ValidationString", regex)
        end

        if disabled then
            guiElement:setReadOnly(true)
        end

        addEventHandler("onClientGUIFocus", guiElement, function()
            store.set("currentInput", name)
        end)

        store.set(name, {
            guiElement = guiElement,
        })
    end

    local input = store.get(name).guiElement
    local currentInput = store.get("currentInput")
    local isCurrentInputThis = currentInput == name

    return {
        focus = isCurrentInputThis,
        value = input.text,
        input = input,
    }
end)

function drawTextArea(options)
    return components.textArea.render(options)
end
