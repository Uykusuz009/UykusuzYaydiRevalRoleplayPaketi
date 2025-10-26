local containerSize = {
	x = 300,
	y = 155
}

local fonts = exports.rl_ui:useFonts()
local theme = exports.rl_ui:useTheme()

local helperTextValue = ""

local ped = createPed(299, 648.951171875, -1357.1279296875, 13.567345619202)
setElementDimension(ped, 0)
setElementInterior(ped, 0)
setElementFrozen(ped, true)
setElementData(ped, "name", "Haberci")
setElementData(ped, "talk", 1)

function renderTrt()
	if getElementData(localPlayer, "logged") then
	    if not isTimer(renderTimer) then
	        showCursor(true)
	        renderTimer = setTimer(function()
				local window = exports.rl_ui:drawWindow({
					position = {
						x = 0,
						y = 0,
					},
					size = containerSize,

					centered = true,

					header = {
						title = "Reklam Arayüzü",
						close = true
					},

					postGUI = false,
				})

				if window.clickedClose then
					killTimer(renderTimer)
					showCursor(false)
				end
				
				local input = exports.rl_ui:drawInput({
					position = {
						x = window.x,
						y = window.y + 10
					},
					size = {
						x = containerSize.x - 25,
						y = 30,
					},

					variant = "solid",
					color = "green",
					disabled = false,

					name = "trt_reklam_text",
					placeholder = "Villam İlandadır.",
					helperText = {
						text = helperTextValue,
						color = theme.RED[800]
					},

					postGUI = false
				})
				
				local button = exports.rl_ui:drawButton {
					position = {
						x = window.x,
						y = window.y + 60
					},
					size = {
						x = containerSize.x - 25,
						y = 30,
					},

					radius = DEFAULT_RADIUS,
					variant = "rounded",
					alpha = 300,

					color = "green",
					disabled = false,

					text = "Gönder",

					postGUI = false
				}
				
				if button.pressed then
					helperTextValue = ""
					
					if input.value == "" then
						helperTextValue = "Text bölümü boş bırakılamaz."
						return
					end
					
					triggerServerEvent("adverts:receive", localPlayer, localPlayer, input.value)

				end
	        end, 0, 0)
	    else
	        killTimer(renderTimer)
	        showCursor(false)
	    end
	end
end

addEvent("trt", true)
addEventHandler("trt", root, function()
	renderTrt()
end)

function onVip()
    if getElementData(localPlayer, 'vip') >= -1 then
        triggerEvent("trt", localPlayer)
    end
end
addCommandHandler('reklam', onVip)

function onClick()
    if getElementData(localPlayer, 'logged') then
        triggerEvent("trt", localPlayer)
    end
end
addCommandHandler('hidiribidiribubua', onClick)