Spinner = {}
Spinner.alias = "spinner"
Spinner.initialOptions = {
    position = { x = 0, y = 0 },
    size = 64,

    speed = 2,

    label = "",
	
	postGUI = false
}
Spinner.rotation = 0
Spinner.tickCount = getTickCount()

Spinner.svgPath = svgCreate(128, 128, [[
<svg width="110" height="110" viewBox="0 0 110 110" fill="none" xmlns="http://www.w3.org/2000/svg">
	<path d="M55 101.425C55 106.161 58.8623 110.068 63.5407 109.333C74.9642 107.537 85.6115 102.17 93.8909 93.8909C102.17 85.6115 107.537 74.9642 109.333 63.5407C110.068 58.8623 106.161 55 101.425 55V55C96.6892 55 92.9468 58.8873 91.883 63.5021C90.3013 70.3628 86.8225 76.7056 81.764 81.764C76.7056 86.8225 70.3628 90.3013 63.5021 91.883C58.8873 92.9468 55 96.6892 55 101.425V101.425Z" fill="white"/>
	<path opacity="0.3" d="M110 55C110 85.3757 85.3757 110 55 110C24.6243 110 0 85.3757 0 55C0 24.6243 24.6243 0 55 0C85.3757 0 110 24.6243 110 55ZM17.1499 55C17.1499 75.904 34.096 92.8501 55 92.8501C75.904 92.8501 92.8501 75.904 92.8501 55C92.8501 34.096 75.904 17.1499 55 17.1499C34.096 17.1499 17.1499 34.096 17.1499 55Z" fill="white" fill-opacity="0.63"/>
</svg>
]])

Spinner.render = function(options)
    local position = options.position or Spinner.initialOptions.position
    local size = options.size or Spinner.initialOptions.size

    local speed = options.speed or Spinner.initialOptions.speed

    local label = options.label or Spinner.initialOptions.label
	
	local postGUI = options.postGUI or Spinner.initialOptions.postGUI

    if Spinner.tickCount + speed < getTickCount() then
        Spinner.tickCount = getTickCount()
        Spinner.rotation = Spinner.rotation + 5
        if Spinner.rotation > 360 then
            Spinner.rotation = 0
        end
    end

    dxDrawImage(position.x, position.y, size, size, Spinner.svgPath, Spinner.rotation, 0, 0, tocolor(255, 255, 255, 255), postGUI)
    if label then
        dxDrawText(label, position.x, position.y + size + 10, position.x + size, position.y + size + 10, rgba(GRAY[50], 0.7), 1, fontElements.UbuntuRegular.caption, "center", "top", false, false, postGUI)
    end
end
createComponent(Spinner.alias, Spinner.initialOptions, Spinner.render)

function drawSpinner(options)
    return components[Spinner.alias].render(options)
end