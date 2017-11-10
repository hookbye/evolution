--
-- Author: <wangguojun@playcrab.com>
-- Date: 2017-06-07 11:54:22
--
local Map = require("app.justFire.Map")
local DotMap = class("DotMap",Map)

function DotMap:ctor()
	self.super.ctor(self)
end

function DotMap:initDotMap( )
	local config = {}
	config.size = cc.size(960,640)
	config.tiles = {
		-- {tileSize = ,tilePos = }
	}
	local tileSize = cc.size(60,60)
	local tilePos
	
	-- for
	
end

function DotMap:createTileByConfig( config )
end

function DotMap:createObjsByConfig( config )
	
end

function DotMap:move( )
	
end

function DotMap:convertToPos( x,y )
	
end

return DotMap