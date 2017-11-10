--
-- Author: <wangguojun@playcrab.com>
-- Date: 2017-04-06 21:44:47
--
local Map = class("Map", function( )
	local node = display.newNode()
	return node
end)

function Map:ctor()
	self._baseLayer = display.newColorLayer(cc.c4b(128, 128, 0, 255))
end

function Map:loadConfig( config )
	self._size = config.size 
	self._visibleSize = config.visibleSize
	self._objects = config.objects
	self._tiles = config.tiles
end

function Map:initTiles( )
	if not self._tiles then return end
	for k,tileConfig in pairs(self._tiles) do
		self:createTileByConfig(tileConfig)
	end
end

function Map:createTileByConfig( config )
	
end

function Map:initMapObjects( )
	if not self._objects then return end
	for k,objConfig in pairs(self._objects) do
		self:createObjsByConfig(objConfig)
	end
end

function Map:createObjsByConfig( config )
	
end

function Map:move( )
	
end

function Map:convertToPos( x,y )
	
end

return Map