--
-- Author: <wangguojun@playcrab.com>
-- Date: 2017-04-06 21:49:20
--
local targetPlatform = cc.Application:getInstance():getTargetPlatform()

local ControllLayer = class("ControllLayer", function( )
	local node = display.newColorLayer(cc.c4b(0, 0, 0, 0))
	return  node --cc.LayerColor:create(cc.c4b(0, 0, 0, 0),640,960)
end)

function ControllLayer:ctor( param )
	self:setMutiplyTouchEnable()
	local events = param and param.events 
	self._events = events
	self._joyPad = {}
	local offsetX,offsetY = 100,100
	local padWidth,padHeight = 80,80
	self._joyPadConfig = {
		left = {name="",pos=cc.p(-padWidth+15+offsetX,0+offsetY),imgs = {"button_left.png","button_left.png","button_left.png"},event = self._events["left"]},
		right = {name="",pos=cc.p(padWidth+15+offsetX,0+offsetY),imgs = {"button_right.png","button_right.png","button_right.png"},event = self._events["right"]},
		up = {name="",pos=cc.p(0+offsetX,padHeight+15+offsetY),imgs = {"button_up.png","button_up.png","button_up.png"},event = self._events["up"]},
		down = {name="",pos=cc.p(0+offsetX,-padHeight+15+offsetY),imgs = {"button_down.png","button_down.png","button_down.png"},event = self._events["down"]},
		
		fight = {name="fight",pos=cc.p(display.width-100,100),imgs = {"button.png","button.png","button.png"},event = self._events["fight"]},

	}
	self:initJoyPad()
	self:setTouchEnabled(true)
	self:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function( event )
		return true
	end)
end

function ControllLayer:setMutiplyTouchEnable( )
	self.cursors = {}
    self.touchIndex = 0
    local labelPoints = cc.ui.UILabel.new({text = "", size = 24})
        :align(display.CENTER_TOP, display.cx, display.top - 120)
        :addTo(self)
	local function createTouchableSprite(p)
	    local sprite = display.newScale9Sprite(p.image)
	    sprite:setContentSize(p.size)

	    local cs = sprite:getContentSize()
	    local label = cc.ui.UILabel.new({
	            UILabelType = 2,
	            text = p.label,
	            color = p.labelColor})
	    label:align(display.CENTER)
	    label:setPosition(cs.width / 2, label:getContentSize().height)
	    sprite:addChild(label)
	    sprite.label = label

	    return sprite
	end
	self.sprite = createTouchableSprite({
            image = "WhiteButton.png",
            size = cc.size(500, 600),
            label = "TOUCH ME !",
            labelColor = cc.c3b(255, 0, 0)})
        :pos(display.cx, display.cy)
        :addTo(self,0)
        self.sprite:setVisible(false)
    -- drawBoundingBox(self, self.sprite, cc.c4f(0, 1.0, 0, 1.0))
	-- 启用触摸
    self:setTouchEnabled(true)
    -- 设置触摸模式
    self:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE) -- 多点
    -- self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE) -- 单点（默认模式）
    -- 添加触摸事件处理函数
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        -- 返回 true 表示要响应该触摸事件，并继续接收该触摸事件的状态变化
        return true
    end)
end

function ControllLayer:initJoyPad( name,pos,func )
	for k,v in pairs(self._joyPadConfig) do
		self:createControllBtn(v.name,v.imgs,v.pos,v.event)
	end
end

function ControllLayer:createControllBtn( name,imgs,pos,func,upFunc )
	local btn = ccui.Button:create(unpack(imgs),1)
	btn:setPosition(pos)
	btn:setTitleText(name)
	btn:setTitleFontSize(28)
	btn:setContentSize(cc.size(50,50))
	btn:addTouchEventListener(function(sender,eventName)
		-- local args = unpack(...)
		-- dump(args)
		print("name",name,eventName)
		if eventName == 2 or eventName == 3 then
			if self._events and self._events.cancel and name == "" then
				self._events["cancel"]()
			end
		elseif eventName == 0 then
	        if func then 
	        	func()
	        end
		end
	end)
	btn:setTitleText(name)
	self:addChild(btn,10)
	btn:setSwallowTouches(false)
	btn:addNodeEventListener(cc.NODE_TOUCH_CAPTURE_EVENT, function(event)
        printf("%s %s [CAPTURING]", "button2", event.name)
        return true
    end)
end

return ControllLayer