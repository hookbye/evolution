--
-- Author: <wangguojun@playcrab.com>
-- Date: 2017-03-22 22:14:53
--
local CollisionObj = class("CollisionObj", function( )
	return cc.LayerColor:create(cc.c4b(250, 141, 42, 255),20,20)
end)

function CollisionObj:ctor( param )
	param = param or {}
	param.speed = param.speed or {}
	param.acc = param.acc or {}
	param.pos = param.pos or {0,0}
	-- self:drawEx()
	self._speed = param.speed or {0,0}
	self:setPosition(param.pos[1],param.pos[2])
	self._acc = param.acc or {0,0}
	self._limitSqure = param.limitSqure or {0,CONFIG_SCREEN_WIDTH,0,CONFIG_SCREEN_HEIGHT}
	self._initialPos = { x = self:getPositionX(),y = self:getPositionY()}
	self:initial()
	-- self:addEventListenner(self,function( ... )
	-- 	local args = unpack(...)
	-- 	dump(args)
	-- end)
end

function CollisionObj:initial( )
	
end

function CollisionObj:updateEx( dt )
	local spH = self._speed[1] or 0
	local spV = self._speed[2] or 0
	local acH = self._acc[1] or 0
	local acV = self._acc[2] or 0
	local limitS = self._limitSqure
	local x = self:getPositionX()
	local y = self:getPositionY()

	if x <= limitS[1] or x >= limitS[2] then
		spH = -spH
	end
	if y <= limitS[3] or y >= limitS[4] then
		spV = -spV
	end
	spH = spH+acH
	spV = spV+acV
	x = x+spH
	y = y+spV
	-- print(x,y)
	self:setPosition(x,y)
	self._speed[1] = spH
	self._speed[2] = spV
	self._acc[1] = acH
	self._acc[2] = acV
end

function CollisionObj:changeStatus( status )
	if status == "collicted" then 
		self:setColor(cc.c3b(255, 0, 0))
	else
		self:setColor(cc.c3b(255, 255, 255))
	end
end



function CollisionObj:drawEx( )
	-- body
end

return CollisionObj