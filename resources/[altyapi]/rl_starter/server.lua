local primaryResources = {
	"rl_mysql",
	"rl_global",
	"rl_data",
	"rl_pool",
	"rl_integration",
	"rl_vehicle",
	"rl_fonts",
	"rl_ui",
	"rl_items",
}

addEventHandler("onResourceStart", resourceRoot, function()
	for _, resource in ipairs(primaryResources) do
		startResource(getResourceFromName(resource))
	end
	
	for _, resource in ipairs(getResources()) do
		startResource(resource)
	end
end)