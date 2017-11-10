--
-- Author: <wangguojun@playcrab.com>
-- Date: 2017-03-24 21:23:28
--
local QuardTree = class("QuardTree")

function QuardTree:ctor( param )
	param = param or {}
	self._level = param.level or 1
	self._maxLevel = param.maxLevel or 4
	self._maxObjCount = param.maxObjCount or 4

	self._rect = param.rect or {0,0,0,0}

	self._objList = {}

	self._children = {}
end

-- 插入单个对象
function QuardTree:insertObj( obj )
	self._objList[#self._objList+1] = obj
end

-- 插入对象集合 覆盖式插入
function QuardTree:insertObjs( objs )
	self._objList = objs
	if #self._objList > 4 then 
		self:split()
	end
end

-- 分裂
function QuardTree:split()
	if #self._objList <= self._maxObjCount or self._level > self._maxLevel then return end 
	local rect = self._rect
	local x,y = rect[1],rect[2]
	local w1,h1 = rect[3]/2,rect[4]/2
	local x1,y1 = x+w1,y+h1
	local childrenRects = {
		{x,y,w1,h1},
		{x,y1,w1,h1},
		{x1,y,w1,h1},
		{x1,y1,w1,h1},
	}
	for i=1,4 do
		self._children[i] = QuardTree.new({level = self._level+1,maxObjCount = self._maxObjCount,maxLevel=self._maxLevel,rect=childrenRects[i]})
	end
	self:distributeObjs()
end
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
local function objHitRect( rect1,rect2 )
	if objHit(rect1.origin.x,rect1.origin.y,rect1.size.width,rect1.size.height , rect2[1],rect2[2],rect2[3],rect2[4]) or 
		objHit(rect2[1],rect2[2],rect2[3],rect2[4] , rect1.origin.x,rect1.origin.y,rect1.size.width,rect1.size.height)
		then
		return true
	end
	return false
end
-- 分配节点到相应的tree
function QuardTree:distributeObjs( )
	for k,v in pairs(self._objList) do
		local rect = v:getCascadeBoundingBox()
		for i,child in ipairs(self._children) do
			local rectL = child:getRect()
			if objHitRect(rect,rectL) then
				child:insertObj(v)
			end
		end
	end
	for i,child in ipairs(self._children) do
		child:split()
	end
end

-- 清除
function QuardTree:clearTree()
	self._level = nil
	self._maxLevel = nil
	self._maxObjCount = nil
	self._rect = nil
	self._objList = nil
	if next(self._children) then
		for i=1,4 do
			self._children[i]:clearTree()
		end
	end
end

-- 遍历四叉树 中序
function QuardTree:walkTree( walkFunc )
	if type(walkFunc) ~= "function" then print("walkFunc is not function") return end
	walkFunc(self)
	if next(self._children) then
		for i=1,4 do
			self._children[i]:walkTree(walkFunc)
		end
	end
end

-- 获得 整个 树的 检测列表
function QuardTree:getRectObjs( )
	local objs = {}
	self:walkTree(function( quardNode )
		if not next(quardNode:getChildrenTree()) then
			table.insert(objs,quardNode:getObjList())
		end
	end)
	return objs
end

-- 获得rect
function QuardTree:getRect( )
	-- return cc.rect(self._rect[1],self._rect[2],self._rect[3],self._rect[4])
	return self._rect
end

-- 获得子节点
function QuardTree:getChildrenTree( )
	return self._children
end

function QuardTree:getObjList( )
	return self._objList
end

return QuardTree