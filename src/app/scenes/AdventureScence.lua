--
-- Author: <wangguojun@playcrab.com>
-- Date: 2017-04-06 21:30:49
--
local AdventureScence = class("AdventureScence", function( )
	return display.newScene("AdventureScence")
end)

function AdventureScence:ctor( )
	self._map = nil
	self._objsLy = nil
	self._controllLy = nil
	local joyPadLayer = require("app.justFire.ControllLayer").new()
	self:addControllLayer(joyPadLayer,100)
end

function AdventureScence:addControllLayer( layer, priority )
	self:addChild(layer,priority)
end

return AdventureScence