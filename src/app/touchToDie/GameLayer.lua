--
-- Author: <wangguojun@playcrab.com>
-- Date: 2017-10-25 16:54:56
--
local GameLayer = class("GameLayer",function( )
	local layer = display.newLayer()
	layer:setContentSize(cc.size(display.width,display.height))
	return layer
end)

function GameLayer:ctor()
	self:initTarget()
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT,function( dt )
		self:updateTick(dt)
	end)
	self:scheduleUpdate()
	self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
	self:setTouchEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function( event )
		return true
	end)
	self._spiders = {}
	self._unUseSpiders = {}
	self:start()
end

function GameLayer:initTarget( )
	local hole = cc.LayerColor:create(cc.c4b(255,255,255,255),100,100)
	hole:setContentSize(cc.size(100, 100))
	hole:setPosition(cc.p(display.cx-50,display.cy-50))
	self._hole = hole
	self:addChild(hole)
	self._holeRect = hole:getBoundingBox()
end

function GameLayer:start( )
	-- self:generateSpider()
end

function GameLayer:ended( )
	
end

function GameLayer:generateSpider( )
	print("spider 个数",#self._spiders)
	local spider = self:getUnusedSpider()
	spider:setTarget(cc.p(display.cx,display.cy))
	spider:active()
	-- spider:setPosition(200,100)
end

function GameLayer:getUnusedSpider( )
	local spiderId,spider = next(self._unUseSpiders)
	if spiderId and spider then
		if not spider:isAlive() then
			self._unUseSpiders[spiderId] = nil
			return spider
		else
			return self:getUnusedSpider()
		end
	else
		local spider = require("app.touchToDie.Spider").new({container = self,id = #self._spiders})
		spider.id = #self._spiders
		self:addChild(spider)
		table.insert(self._spiders,spider)
		return spider
	end
end

function GameLayer:isInHole( spider )
	local inHole = false
	local point  = cc.p(spider:getPositionX(),spider:getPositionY())
	if cc.rectContainsPoint( self._holeRect, point ) then
		inHole = true
	end
	return inHole
end

local totalDt = 0
function GameLayer:updateTick( dt )
	for k,v in pairs(self._spiders) do
		if v:isAlive() then
			if not self:isInHole(v) then
				v:updateTick()
			else
				v:die()
			end
		else
			self._unUseSpiders[k] = v 
		end
	end
	totalDt = totalDt+dt
	if totalDt > 2 then
		totalDt = 0
		self:generateSpider()
	end
end

return GameLayer