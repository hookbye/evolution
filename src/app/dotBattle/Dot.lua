--
-- Author: <wangguojun@playcrab.com>
-- Date: 2017-05-31 21:16:46
--
local Dot = class("Dot", function( )
	local node = display.newNode()
	return node
end)

function Dot:ctor()
	
	self:initBaseInfo()
	self:initBody()
	self:initEquip()
	self:bindStateMachine()
end

function Dot:initBaseInfo( )
	self._speed = 10 --{0,0}
	self._dir = {0,0}
	self._nextPos = nil -- {x=0,y=0}
end

function Dot:initBody( )
	self._frame = cc.DrawNode:create()
	local size = 50
	self._frame:drawRect(
		{x=-size/2,y=-size/2},
		{x=size/2,y=size/2},
		cc.c4f(1, 0.0, 0.0, 0.6)
	)
	self:addChild(self._frame)

	self._hair = cc.DrawNode:create()
	self:addChild(self._hair)
	-- self:initHairArray()
	-- self:drawHairs()
end

function Dot:initEquip( )
	self._equip = cc.DrawNode:create()
	self:addChild(self._equip)
end

function Dot:doAtk( )
	gl.lineWidth(5.0)
	self._equip:drawLine({x=0,y=0},{x=0,y=100},cc.c4f(1, 0.0, 0.0, 1.0))
	self._equip:runAction(cc.Sequence:create(
		cc.RotateBy:create(0.5,360),
		cc.CallFunc:create(function( )
			self._equip:clear()
		end)
	))
end

function Dot:initHairArray( )
	self._hairsFromAr = {}
	self._hairsToAr = {
		{x=30,y=30},{x=-30,y=30},{x=30,y=-30},{x=-30,y=-30},
		{x=30,y=45},{x=-30,y=45},{x=30,y=-45},{x=-30,y=-45},
		{x=45,y=30},{x=-45,y=30},{x=45,y=-30},{x=-45,y=-30},
	}
	for i=1,10 do
		table.insert(self._hairsFromAr,{x=0,y=0})
		-- table.insert(self._hairsToAr,{x = (i-5)*20,y=(5-i)*20})
	end
end

function Dot:drawHairs( )
	for i=1,10 do
		self._hair:drawLine(self._hairsFromAr[i], self._hairsToAr[i], cc.c4f(1, 0.0, 0.0, 1.0))
	end
	dump(self._hairsToAr)
end

function Dot:bindStateMachine( )
	
end

function Dot:updateEx( dt )
	if self._dir[1] == 0 and self._dir[2] == 0 or self._speed == 0 then
		return 
	end
	if self._nextPos then
		self:setPosition(self._nextPos)
	end
	-- self._nextPos = cc.pAdd(self:getPosition(), cc.p(self._dir[1],self._dir[2]))
	local x = self:getPositionX()+self._dir[1]*self._speed
	x = cc.clampf(x,display.left,display.right)
	
	local y = self:getPositionY()+self._dir[2]*self._speed
	y = cc.clampf(y,display.top,display.bottom)

	self._nextPos = {x = x, y=y}
	-- dump(self._nextPos)
end

function Dot:setSpeed(speed)
	self._speed = speed
end

function Dot:setDir(x,y)
	self._dir = {x,y}
end

return Dot