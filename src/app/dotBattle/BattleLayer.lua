--
-- Author: <wangguojun@playcrab.com>
-- Date: 2017-05-31 21:15:31
--
local BattleLayer = class("BattleLayer", function( )
	return cc.LayerColor:create(cc.c4b(255, 255, 255, 255),960,640)
end)

function BattleLayer:ctor( )
	
end

return BattleLayer