--
-- Author: <wangguojun@playcrab.com>
-- Date: 2017-05-31 21:57:01
--
Utils = {}

function Utils:limitPosInRect(pos,rect)
	
end

function Utils:createDefaultBtn( title,func  )
	local button = ccui.Button:create()
	button:loadTextures("button.png","button.png","button.png")
	button:setTitleText(title or "")
	button:addTouchEventListener(function( sender,eventName )
		if eventName == 2 then
			if func then
				func()
			end
		end
	end)
	return button
end

return Utils