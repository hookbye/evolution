--
-- Author: <wangguojun@playcrab.com>
-- Date: 2017-03-22 22:23:54
--
local sharedScheduler = cc.Director:getInstance():getScheduler()
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local QuardTree = require("app.object.QuardTree")
local CollisionObj = require("app.object.CollisionObj")
local CollisionScene = class("CollisionScene", function( )
	return display.newScene("CollisionScene")
end)

local objsConfig = {
	{speed={1,1},acc={0,0},pos={100,100}},
	{speed={1,2},acc={0,0},pos={200,100}},
	{speed={2,2},acc={0,0},pos={100,100}},
	{speed={1,3},acc={0,0},pos={100,100}},
	{speed={2,1},acc={0,0},pos={110,100}},
	{speed={1,2},acc={0,0},pos={100,110}},
	{speed={3,1},acc={0,0},pos={123,120}},
	{speed={1,2},acc={0,0},pos={200,200}},
	
	{speed={1,2},acc={0,0},pos={200,300}},
	{speed={1,2},acc={0,0},pos={200,400}},
	{speed={3,2},acc={0,0},pos={200,200}},
	{speed={3,1},acc={0,0},pos={200,300}},

	-- {speed={1,1},acc={0,0},pos={200,100}},
	-- {speed={1,2},acc={0,0},pos={300,100}},
	-- {speed={2,2},acc={0,0},pos={200,100}},
	-- {speed={1,3},acc={0,0},pos={200,100}},
	-- {speed={2,1},acc={0,0},pos={210,100}},
	-- {speed={1,2},acc={0,0},pos={200,110}},
	-- {speed={3,1},acc={0,0},pos={223,120}},
	-- {speed={1,2},acc={0,0},pos={300,200}},
	
	-- {speed={1,2},acc={0,0},pos={300,300}},
	-- {speed={1,2},acc={0,0},pos={240,400}},
	-- {speed={3,2},acc={0,0},pos={240,200}},
	-- {speed={3,1},acc={0,0},pos={260,300}},



}

local pos = {100,200,300,400}
local speed = {1,2,3,4}
local UniqueCombine = function( tab1, tab2 )
	local result = {}
	for k,v in pairs(tab1) do
		for _,v1 in pairs(tab2) do
			local temp = {v,v1}
			table.insert(result,temp)
		end
	end
	return result
end
local function comBine( tab )
	return UniqueCombine(tab,tab)
end

local speedZuhe = comBine(speed)
local posZuhe = comBine(pos)
-- dump(posZuhe)
for i,speed in ipairs(speedZuhe) do
	for i1,pos in ipairs(posZuhe) do
		local objConfig = {pos = {pos[1],pos[2]},speed={speed[1],speed[2]}}
		table.insert(objsConfig,objConfig)
	end
end
-- dump(objsConfig,"",10)
print("碰撞个数",#objsConfig)


function CollisionScene:ctor( )
	self._ly = cc.LayerColor:create(cc.c4b(59, 111, 222, 150),640,960)
	self:addChild(self._ly)
	-- 指标label
	for i=1,4 do
		self["_label" .. i] = cc.ui.UILabel.new({
            UILabelType = 2, text = "", size = 24})
        :align(display.CENTER_LEFT, 10, display.top-i*30)
        :addTo(self)
	end
	self._label4:setString("对象个数" .. #objsConfig)
	-- local lyColor
	self._objs = {}
	-- local this = self
	-- sharedScheduler:scheduleScriptFunc(function( dt )
	-- 	if this and this.updateEx then 
	-- 		this:updateEx(dt)
	-- 	end
	-- end, 1, false)
	-- self:scheduleUpdate()
	-- self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT,function( dt )
	-- 	print("·········in frame...")
	-- end)
	self._drawNode = cc.DrawNode:create()
	-- self._drawNode:setPosition(100,100)
	self:addChild(self._drawNode)
	for i,v in ipairs(objsConfig) do
		self:addNewObjs(v)
	end
	local count = 0
	scheduler.scheduleGlobal(function( dt )
		count  = count + 1
		self:updateEx(dt)
	end,0.01)
	self:initGrids()
end

function CollisionScene:addNewObjs(objArg)
	local obj =  require("app.object.CollisionObj").new(objArg) --CollisionObj.new()
	self._ly:addChild(obj)
	self._objs[#self._objs+1] = obj
end

local bubbleOnce = true
local gridOnce = true
local quadOnce = true
local deltTime = 0
function CollisionScene:updateEx( dt )
	for i=1,#self._objs do
		self._objs[i]:updateEx(dt)
		self._objs[i]:setVisible(false)
		-- self._objs[i]:setColor(cc.c3b(255, 255, 255))
		self._objs[i].dirty = false
	end
	deltTime = deltTime+dt
	if deltTime < 1 then
		return 
	else
		deltTime = 0
	end
	-- -- 普通遍历
	local t1 = os.clock()
	local count = self:checkAllCollision(self._objs)
	local t2 = os.clock()
	if t2-t1 > 0.00001 then
		if not self._allMaxTime then self._allMaxTime = t2-t1 end
		if (t2-t1) > self._allMaxTime then self._allMaxTime = t2-t1 end
		if not self._allMaxCount then self._allMaxCount = count end
		if count > self._allMaxCount then self._allMaxCount = count end
		local str = string.format("遍历 耗时:%0.4f 次数 %d",t2-t1,count)
		self._label1:setString(str)
	end

	for i=1,#self._objs do
		self._objs[i].dirty = false
	end
	-- 网格法
	local t1 = os.clock()
	count = self:checkCollistionByGrids()
	local t2 = os.clock()
	if t2-t1 > 0.00001 then
		if not self._gridMaxTime then self._gridMaxTime = t2-t1 end
		if (t2-t1) > self._gridMaxTime then self._gridMaxTime = t2-t1 end
		if not self._gridMaxCount then self._gridMaxCount = count end
		if count > self._gridMaxCount then self._gridMaxCount = count end
		local str = string.format("grid  耗时:%0.4f 次数 %d",t2-t1,count)
		self._label2:setString(str)
	end

	for i=1,#self._objs do
		self._objs[i].dirty = false
	end
	-- 四叉树法
	local t1 = os.clock()
	count = self:checkQuardCollision(dt)
	local t2 = os.clock()
	if t2-t1 > 0.00001 then
		if not self._quardMaxTime then self._quardMaxTime = t2-t1 end
		if (t2-t1) > self._quardMaxTime then self._quardMaxTime = t2-t1 end
		if not self._quardMaxCount then self._quardMaxCount = count end
		if count > self._quardMaxCount then self._quardMaxCount = count end
		local str = string.format("quad耗时:%0.4f 次数 %d",t2-t1,count)
		self._label3:setString(str)
	end
end

-- 网格法 检查碰撞
function CollisionScene:initGrids( )
	self._grids = {} -- 一维数组
	self._col = 4
	self._row = 4
	self._gridW = CONFIG_SCREEN_WIDTH/self._col
	self._gridH = CONFIG_SCREEN_HEIGHT/self._row
	-- 画格子
	
	--画横线
	-- for i=1,4 do
	-- 	self._drawNode:drawSegment({x=0,y=self._gridH*i},{x=CONFIG_SCREEN_WIDTH,y=self._gridH*i},1,cc.c4f(.6, 0.5, 0.2, 1.0))
	-- end

	-- for i=1,4 do
	-- 	self._drawNode:drawSegment({x=self._gridW*i,y=0},{x=self._gridW*i,y=CONFIG_SCREEN_HEIGHT},1,cc.c4f(.6, 0.5, 0.2, 1.0))
	-- end
end

function CollisionScene:drawRect( x,y,width,height )
	local points = {
		{x=x,y=y},
		{x=x+width,y=y},
		{x=x+width,y=y+height},
		{x=x,y=y+height},
	}
	-- self._drawNode:drawPolygon(points,1,cc.c4f(.6, 0.5, 0.2, 1.0))
	self._drawNode:drawPolygon( points, {fillColor=cc.c4f(.6, 0.5, 0.2, 0.0), borderWidth=1, borderColor=cc.c4f(.6, 0.5, 0.2, 1.0)})
end

-- 画四叉树区域
function CollisionScene:drawQuardTreeRect( )
	self._drawNode:clear()
	self._quardTree:walkTree(function( quardTree )
		local rect = quardTree:getRect()
		self:drawRect(rect[1], rect[2], rect[3], rect[4])
	end)
end

function CollisionScene:clearGrids()
	self._grids = {}
end

-- 生成网格对象
function CollisionScene:fillGrids( objs )
	for k,v in pairs(objs) do
		local x = v:getPositionX()
		local y = v:getPositionY()
		local gridX = math.floor(x/self._gridW)
		local gridY = math.floor(y/self._gridH)
		local gridId = gridY*self._col+gridX
		if not self._grids[gridId] then self._grids[gridId] = {} end
		table.insert(self._grids[gridId],v)
		local gridXC = math.ceil(x/self._gridW)
		local gridYC = math.ceil(y/self._gridH)
		-- 跨界处理 并不完全
		if gridXC ~= gridX or gridYC ~= gridY then
			gridId = gridYC*self._col+gridXC
			if not self._grids[gridId] then self._grids[gridId] = {} end
			table.insert(self._grids[gridId],v)
		end
	end
	-- dump(self._grids)
end

function CollisionScene:checkCollistionByGrids( )
	local count = 0
	self:clearGrids()
	self:fillGrids(self._objs)
	for _,grids in pairs(self._grids) do
		for i=1,#grids do
			for k=i+1,#grids do
				if i ~= k then --and not grids[i].dirty and not grids[k].dirty then
					local isCollistion = self:checkCollision(grids[i],grids[k])
					count = count + 1
					if isCollistion then
						grids[i].dirty = true 
						grids[k].dirty = true 
					end
				end
			end
		end
	end
	return count
	-- print("检查碰撞次数",count)
end

-- 遍历法
function CollisionScene:checkAllCollision( objs )
	local count = 0
	for i=1,#objs do
		for k=i+1,#objs do
			if i ~= k then --and not objs[i].dirty and not objs[k].dirty then
				count = count + 1
				local isCollistion = self:checkCollision(objs[i],objs[k])
				if isCollistion then
					objs[i].dirty = true 
					objs[k].dirty = true 
				end
			end
		end
	end
	
	return count 
end
local dtCount = 0
local preCount = 0
-- 四叉树 检查碰撞
function CollisionScene:checkQuardCollision( dt )
	self._quardTree = QuardTree.new({level=1,rect = {0,0,CONFIG_SCREEN_WIDTH,CONFIG_SCREEN_HEIGHT}})
	self._quardTree:insertObjs(self._objs)
	-- self:drawQuardTreeRect()
	
	local objs = self._quardTree:getRectObjs()
	-- local rectNum = #objs 
	-- if rectNum ~=preCount then
	-- 	preCount = rectNum 
	-- 	self:drawQuardTreeRect()
	-- else
	-- 	dtCount = dtCount+dt
	-- 	if dtCount >= 2 then
	-- 		self:drawQuardTreeRect()
	-- 		dtCount = 0
	-- 	end
	-- end
	local count = 0
	for _,group in ipairs(objs) do
		count = count + self:checkAllCollision(group)
	end
	-- print("检查碰撞次数",count)
	self:clearQuadCollision()
	return count
end

function CollisionScene:clearQuadCollision( )
	-- self._drawNode:clear()
	self._quardTree:clearTree()
end

--- 两物体碰撞检查
--]-- 检查碰撞
local function objHit( x1,y1,w1,h1, x2,y2,w2,h2 )
	-- 不相交 判断
	local isLeft = x1 > x2+w2 
	local isRight = x1+w1< x2 
	local isTop = y1 > y2+h2
	local isBottom = y1+h1 < y2
	if (isLeft or isRight or isTop or isBottom) then 
		return false
	end
	return true
end
function CollisionScene:checkCollision( obj1, obj2 )
	local x1,y1,w1,h1 = obj1:getPositionX(),obj1:getPositionY(),obj1:getContentSize().width,obj1:getContentSize().height
	local x2,y2,w2,h2 = obj2:getPositionX(),obj2:getPositionY(),obj2:getContentSize().width,obj2:getContentSize().height
	if objHit(x1,y1,w1,h1, x2,y2,w2,h2) or objHit(x2,y2,w2,h2, x1,y1,w1,h1) then
		-- 碰撞
		obj1:setColor(cc.c3b(255, 0, 0))
		obj2:setColor(cc.c3b(255, 0, 0))
		return true
	else
		obj1:setColor(cc.c3b(255, 255, 255))
		obj2:setColor(cc.c3b(255, 255, 255))
		return false
	end
end

return CollisionScene