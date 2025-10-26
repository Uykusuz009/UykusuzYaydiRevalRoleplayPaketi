----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
--
--	To switch on:
--			triggerEvent( "switchCarPaintRefLite", root, true )
--
--	To switch off:
--			triggerEvent( "switchCarPaintRefLite", root, false )
--
----------------------------------------------------------------
----------------------------------------------------------------

--------------------------------
-- onClientResourceStart
--		Auto switch on at start
--------------------------------
local theTikGap = 0.5
local getLastTick = getTickCount()
addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource()),
	function()
		triggerEvent( "switchCarPaintRefLite", resourceRoot, true )
		bindKey ( theHitKey, "down", function(key, keyState)
				if (getTickCount ( ) - getLastTick < theTikGap*1000) then
					outputChatBox('Shader-switch: Wait '..theTikGap..' sec.',255,0,0)
					return
				end
				triggerEvent( "switchCarPaintRefLite", resourceRoot, not cpRLEffectEnabled )
				getLastTick = getTickCount()
			end
		)
	end
)


--------------------------------
-- Switch effect on or off
--------------------------------
function switchCarPaintRefLite( isCPRefOn )
	outputDebugString( "switchCarPaintRefLite: " .. tostring(isCPRefOn) )
	if isCPRefOn then
		startCarPaintRefLite()
	else
		stopCarPaintRefLite()
	end
end

addEvent( "switchCarPaintRefLite", true )
addEventHandler( "switchCarPaintRefLite", resourceRoot, switchCarPaintRefLite )