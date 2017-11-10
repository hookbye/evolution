--
-- Author: <wangguojun@playcrab.com>
-- Date: 2017-10-25 16:48:40
--
local Spider = class("Spider",function( )
	return display.newNode()
end)

function Spider:ctor()
	local body = cc.LayerColor:create(cc.c4b(250,230,120,255),30,30) --display.newColorLayer()
	self:addChild(body)
	self:setContentSize(cc.size(50,50))
	self._alive = true

	local touchEvents = {
		[0] = "touchBegin",
		"touchMove",
		"touchUp",
		"touchCancel",
	}
	self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
	self:setTouchEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function( event )
		print("event",self._alive)
		if self._alive then
			self:die()
		end
	end)
	self:setPosition(cc.p(100,100))
end

function Spider:die( )
	self._alive = nil
	self:setVisible(false)
end

function Spider:active( )
	self._alive = true
	local x,y = self:randomPos()
	print(x,y,"x,y...")
	self:setPosition(cc.p(x,y))
	self:changeDir()
	self:setVisible(true)
end

function Spider:isAlive( )
	return self._alive
end

function Spider:randomPos( )
	local seed = tostring(os.time()):reverse():sub(1,7)
	math.randomseed(seed)
	local rand = math.random(20)
	local x,y = -10,-10
	print(rand,"rand-------",seed,os.time())
	if rand%2 == 1 then
		x = rand*50
		if rand > 9 then
			y = display.height+10
		end
	else
		y = rand*50
		if rand > 9 then
			x = display.width+10
		end
	end
	return x,y
end

function Spider:setTarget( pos )
	self._target = pos 
end

function Spider:changeDir( )
	if self._target then
		local tx,ty = self._target.x,self._target.y 
		local x,y = self:getPositionX(),self:getPositionY()
		local vecY = math.abs((ty-y)/(tx-x))
		local yDir = math.abs(ty-y)/(ty-y)
		local vecX = math.abs(tx-x)/(tx-x)
		self._vecY = vecY*yDir
		self._vecX = vecX
	end
end

function Spider:updateTick( )
	local x,y = self:getPositionX()+(self._vecX or 1),self:getPositionY()+(self._vecY or 1)
 	self:setPosition(cc.p(x,y))
 	if x<-100 
 	   or x-display.width > 100 
 	   or y < -100
 	   or y-display.height > 100
    then
    	self:die()
	end
end


return Spider