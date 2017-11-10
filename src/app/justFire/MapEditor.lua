--
-- Author: <wangguojun@playcrab.com>
-- Date: 2017-06-07 14:42:56
--
-- 1.0 map 格式
--[[
 {
	1,1,1,1,
	2,2,1,0,
	1,0,1,0,
	3,0,2,1
 }
--]]
require("app.dotBattle.Utils")
local MapEditor = class("MapEditor", function(  )
	local node = display.newColorLayer(cc.c4b(0, 0, 0, 255))
	node:setTouchEnabled(false)
	return node
end)

function MapEditor:ctor( )
	-- self._tileContainer = display.newColorLayer(cc.c4b(255, 255, 255, 255))
	-- self._tileContainer:setContentSize(cc.size(100,100))
	-- self:addChild(self._tileContainer)
	-- 初始化数据结构
	self._mapGrids = {}
	self._tileImgs = {}
	-- 初始化地图编辑区（缩略图）
	self._mapWidth,self._mapHeight = 960,640
	local tileSize = 60
	self._tileSize = tileSize
	self._tileCol,self._tileRow = math.floor(self._mapWidth/tileSize),math.floor(self._mapHeight/tileSize)
	self._mapScale = 0.8
	self._tileScale = self._mapScale
	self._mapPreView = ccui.Layout:create()
	self._mapPreView:setContentSize(cc.size(self._mapWidth*self._mapScale,self._mapHeight*self._mapScale))
	self._mapPreView:setPosition(0,display.cy-self._mapHeight*self._mapScale*0.5)
	self._mapPreView:setBackGroundColor(cc.c3b(252, 244, 197))
	self._mapPreView:setAnchorPoint(0,0)
	self._mapPreView:setBackGroundColorType(1)
	self:addChild(self._mapPreView,99)
	-- 初始化tile选择区
	local tileContainerSizeW = self._mapWidth*(1-self._mapScale)
	self._tileContainer = ccui.Layout:create()
	self._tileContainer:setContentSize(cc.size(tileContainerSizeW,display.cy))
	self._tileContainer:setPosition(display.width-tileContainerSizeW,display.cy/2)
	self._tileContainer:setBackGroundColor(cc.c3b(79, 68, 67))
	self._tileContainer:setBackGroundColorType(1)
	self:addChild(self._tileContainer,99)
	
	-- 关闭按钮
	local close = Utils:createDefaultBtn("quitEditor",function( )
		self:setVisible(false)
	end)
	close:setPosition(display.width-80,display.height-80)
	self:addChild(close)

	-- 关闭按钮
	local clearBtn = Utils:createDefaultBtn("clear",function( )
		self:clear()
	end)
	clearBtn:setPosition(display.width-80,display.height-120)
	self:addChild(clearBtn)

	self:initTileSelector()

	self:initMapPreView()
end

function MapEditor:clear( )
	self._mapPreView:removeAllChildren()
end

function MapEditor:initMapPreViewTouches( )
	local eventFuncMap = {
		[0] = {func = self.onPreViewTouchBegin,posFuncName = "getTouchBeganPosition"},
		[1] = {func = self.onPreViewTouchMoved,posFuncName = "getTouchMovePosition"},
		[2] = {func = self.onPreViewTouchEnd,posFuncName = "getTouchEndPosition"},
		[3] = {func = self.onPreViewTouchCancel},
	}
	self._mapPreView:setTouchEnabled(true)
	self._mapPreView:addTouchEventListener(function( sender,eventName)
		local func = eventFuncMap[eventName].func
		local posFunc = eventFuncMap[eventName].posFuncName
		local x,y = nil,nil
		if posFunc then
			local pos = self._mapPreView[posFunc](self._mapPreView)
			x,y = pos.x,pos.y
		end
		func(self,x,y)
	end)
end

function MapEditor:onPreViewTouchBegin( x,y )
	-- body
	print(x,y,"begin....")
	self._drawing = true
	self._touchBeginX,self._touchBeginY = x,y
	self:toFillGrid(x,y)
end
function MapEditor:onPreViewTouchMoved( x,y )
	self:toFillGrid(x,y)
	print("move...")
end
function MapEditor:onPreViewTouchEnd( x,y )
	print("end")
end
function MapEditor:onPreViewTouchCancel( )
	self._drawing = false
	print("cancel...")
end

function MapEditor:changePosToColRow( )
	
end

function MapEditor:changePosToGridId( x,y )
	local tileSize = self._tileSize*self._mapScale
	local row = math.floor(y/tileSize)-1
	local col = math.floor(x/tileSize)
	local id = col + row*self._tileCol
	print(self._tileCol,self._tileRow,tileSize)
	print(x,y,"changeTO",id)
	return id
end

function MapEditor:changeIdToPos( gridId )
	local tileSize = self._tileSize*self._mapScale
	local y = math.floor(gridId/self._tileCol)*tileSize
	local x = math.floor(gridId%self._tileCol)*tileSize
	return cc.p(x,y)
end

function MapEditor:initTileSelector( )
	local tileNames = {}
	self._tiles = {}
	for i=1,4 do
		local tile = ccui.ImageView:create()
		tile:loadTexture("tile_" .. i .. ".jpg")
		tile:setTag(i)
		tile:setPosition(math.floor((i-1)/2)*70+40,display.cy-((i-1)%2)*70-40)
		self._tileContainer:addChild(tile)
		table.insert(self._tiles,tile)
		tile:setTouchEnabled(true)
		tile:addTouchEventListener(function( sender,eventName )
			if eventName == 2 then
				if self._selectTile then
					self._selectTile:setColor(cc.c3b(255, 255, 255))
				end
				self._selectTile = tile
				tile:setColor(cc.c3b(180, 180, 180))
			end
		end)
	end
end

function MapEditor:initMapPreView( )
	self:drawMapGrid()
	self:initMapPreViewTouches()
end

function MapEditor:drawMapGrid()
	self._gridNode = cc.DrawNode:create()
	self._mapPreView:addChild(self._gridNode)
	local tileSize = 60
	self._tileSize = tileSize
	local tileRealSize = tileSize*self._mapScale
	self._mapGrids = {}
	for i=1,self._tileRow do
		self._gridNode:drawSegment({x=0,y=tileRealSize*i},{x=CONFIG_SCREEN_WIDTH,y=tileRealSize*i},1,cc.c4f(.6, 0.5, 0.2, 1.0))
	end

	for i=1,self._tileCol do
		self._gridNode:drawSegment({x=tileRealSize*i,y=0},{x=tileRealSize*i,y=CONFIG_SCREEN_WIDTH},1,cc.c4f(.6, 0.5, 0.2, 1.0))
	end
end

function MapEditor:toFillGrid( x,y )
	if x < 0 or 
	   x > self._mapWidth*self._mapScale or 
	   y < 0 or 
	   y > self._mapHeight*self._mapScale 
	then return end
	self._touchInGrid = self:changePosToGridId(x,y)
	self:fillGrid(self._touchInGrid)
end

function MapEditor:fillGrid( tileId,tileType )
	if not tileId then return end
	local mapPreView = self._mapPreView
	local tile = nil
	if tileType then
		tile = self._tiles[tileType] and self._tiles[tileType]:clone()
	elseif self._selectTile then
		tile = self._selectTile:clone()
	end

	if tile then
		tile:setScale(self._mapScale)
		tile:setTouchEnabled(false)
		tile:setAnchorPoint(0,0)
		local pos = self:changeIdToPos(tileId or 1)
		tile:setPosition(pos)
		mapPreView:addChild(tile)
	end
end

function MapEditor:saveMapData( )
	-- local gridPosesStr = "{\n"
	-- gridPosesStr = gridPosesStr .. "\n}"
    -- local file = io.open("adventureposes.lua","w")
    -- file:write(gridPosesStr)
    -- file:close()
end

return MapEditor 