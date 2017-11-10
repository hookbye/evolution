--
-- Author: <wangguojun@playcrab.com>
-- Date: 2017-10-25 16:59:48
--
local SpiderScene = class("SpiderScene", function()
    return display.newScene("SpiderScene")
end)

function SpiderScene:ctor()
    local gameLy = require("app.touchToDie.GameLayer").new()
    self:addChild(gameLy)
end

return SpiderScene