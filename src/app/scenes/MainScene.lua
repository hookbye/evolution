require("app.algorithm.QuickSortTest")
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)
local visibleRect = cc.Director:getInstance():getOpenGLView():getVisibleRect()
local centerPos   = cc.p(visibleRect.x + visibleRect.width / 2,visibleRect.y + visibleRect.height /2)

local function VideoPlayerTest()
    local layer = cc.Layer:create() --createTestLayer("VideoPlayerTest", "")
    titleLabel = cc.Label:createWithTTF("VideoPlayerTest", s_arialPath, 28)
    titleLabel:setAnchorPoint(cc.p(0.5, 0.5))
    layer:addChild(titleLabel, 1)
    
    cc.MenuItemFont:setFontSize(16)

    widget = ccs.GUIReader:getInstance():widgetFromJsonFile("cocosui/UITest/UITest.json")
    layer:addChild(widget)

    local videoStateLabel = cc.Label:createWithSystemFont("IDLE","Arial",16)
    videoStateLabel:setAnchorPoint(cc.p(1, 0.5))
    videoStateLabel:setPosition(cc.p(visibleRect.x + visibleRect.width - 10,visibleRect.y + 200))
    layer:addChild(videoStateLabel)

    local function onVideoEventCallback(sener, eventType)
        if eventType == ccexp.VideoPlayerEvent.PLAYING then
            videoStateLabel:setString("PLAYING")
        elseif eventType == ccexp.VideoPlayerEvent.PAUSED then
            videoStateLabel:setString("PAUSED")
        elseif eventType == ccexp.VideoPlayerEvent.STOPPED then
            videoStateLabel:setString("STOPPED")
        elseif eventType == ccexp.VideoPlayerEvent.COMPLETED then
            videoStateLabel:setString("COMPLETED")
        end
    end
    local widgetSize = widget:getContentSize()
    local videoPlayer = ccexp.VideoPlayer:create()
    videoPlayer:setPosition(centerPos)
    videoPlayer:setAnchorPoint(cc.p(0.5, 0.5))
    videoPlayer:setContentSize(cc.size(widgetSize.width * 0.4,widgetSize.height * 0.4))
    videoPlayer:addEventListener(onVideoEventCallback)
    layer:addChild(videoPlayer)
        
    local screenSize = cc.Director:getInstance():getWinSize()
    local rootSize = widget:getContentSize()
    layer:setPosition(cc.p((screenSize.width - rootSize.width) / 2,(screenSize.height - rootSize.height) / 2))

    local function menuFullScreenCallback(tag, sender)
        if nil  ~= videoPlayer then
            videoPlayer:setFullScreenEnabled(not videoPlayer:isFullScreenEnabled())
        end
    end
    local fullSwitch = cc.MenuItemFont:create("FullScreenSwitch")
    fullSwitch:setAnchorPoint(cc.p(0.0, 0.0))
    fullSwitch:setPosition(cc.p(visibleRect.x + 10,visibleRect.y + 50))
    fullSwitch:registerScriptTapHandler(menuFullScreenCallback)

    local function menuPauseCallback(tag, sender)
        if nil  ~= videoPlayer then
            videoPlayer:pause()
        end
    end
    local pauseItem = cc.MenuItemFont:create("Pause")
    pauseItem:setAnchorPoint(cc.p(0.0, 0.0))
    pauseItem:setPosition(cc.p(visibleRect.x + 10,visibleRect.y + 100))
    pauseItem:registerScriptTapHandler(menuPauseCallback)

    local function menuResumeCallback(tag, sender)
        if nil  ~= videoPlayer then
            videoPlayer:resume()
        end
    end
    local resumeItem = cc.MenuItemFont:create("Resume")
    resumeItem:setAnchorPoint(cc.p(0.0, 0.0))
    resumeItem:setPosition(cc.p(visibleRect.x + 10,visibleRect.y + 150))
    resumeItem:registerScriptTapHandler(menuResumeCallback)

    local function menuStopCallback(tag, sender)
        if nil  ~= videoPlayer then
            videoPlayer:stop()
        end
    end
    local stopItem = cc.MenuItemFont:create("Stop")
    stopItem:setAnchorPoint(cc.p(0.0, 0.0))
    stopItem:setPosition(cc.p(visibleRect.x + 10,visibleRect.y + 200))
    stopItem:registerScriptTapHandler(menuStopCallback)

    local function menuHintCallback(tag, sender)
        if nil  ~= videoPlayer then
            videoPlayer:setVisible(not videoPlayer:isVisible())
        end
    end
    local hintItem = cc.MenuItemFont:create("Hint")
    hintItem:setAnchorPoint(cc.p(0.0, 0.0))
    hintItem:setPosition(cc.p(visibleRect.x + 10,visibleRect.y + 250))
    hintItem:registerScriptTapHandler(menuHintCallback)

    ------------------------------------------------------------
    local function menuResourceVideoCallback(tag, sender)
        if nil ~= videoPlayer then
            local videoFullPath = cc.FileUtils:getInstance():fullPathForFilename("cocosvideo.mp4")
            videoPlayer:setFileName(videoFullPath)   
            videoPlayer:play()
        end
    end

    local resourceVideo = cc.MenuItemFont:create("Play resource video")
    resourceVideo:setAnchorPoint(cc.p(1, 0.5))
    resourceVideo:setPosition(cc.p(visibleRect.x + visibleRect.width - 10,visibleRect.y + 50))
    resourceVideo:registerScriptTapHandler(menuResourceVideoCallback)

    local function menuOnlineVideoCallback(tag, sender)
        if nil ~= videoPlayer then
            videoPlayer:setURL("https://pan.baidu.com/3b3723a8-f4b0-4e1e-8349-0e2582d242f8")
            --("http://video001.smgbb.cn/gslb/program/FDN/FDN1190949/HLSVodService.m3u8?_mdCode=6065719&_cdnCode=B2B_XL_TEST&_type=0&_rCode=TerOut_18865&_userId=020341000456068&_categoryCode=SMG_HUAYU&_categoryPath=SMG_1002,SMG_HUAYU,&_adPositionId=01001000&_adCategorySource=0&_flag=.m3u8&_enCode=m3u8&taskID=ysh_ps_002-ott_1397459105893_020341000456068&_client=103&_cms=ctv&_CDNToken=76C043FD4969501754DC19E54EC8DC2C")
            videoPlayer:play()
        end
    end
    local onlineVideo = cc.MenuItemFont:create("Play online video")
    onlineVideo:setAnchorPoint(cc.p(1, 0.5))
    onlineVideo:setPosition(cc.p(visibleRect.x + visibleRect.width - 10,visibleRect.y + 100))
    onlineVideo:registerScriptTapHandler(menuOnlineVideoCallback)

    local function menuRatioCallback(tag, sender)
        if nil ~= videoPlayer then
            videoPlayer:setKeepAspectRatioEnabled(not videoPlayer:isKeepAspectRatioEnabled())
        end
    end
    local ratioSwitch = cc.MenuItemFont:create("KeepRatioSwitch")
    ratioSwitch:setAnchorPoint(cc.p(1, 0.5))
    ratioSwitch:setPosition(cc.p(visibleRect.x + visibleRect.width - 10,visibleRect.y + 150))
    ratioSwitch:registerScriptTapHandler(menuRatioCallback)

    local menu = cc.Menu:create(fullSwitch, pauseItem, resumeItem, stopItem, hintItem, resourceVideo, onlineVideo, ratioSwitch)
    menu:setPosition(cc.p(0.0, 0.0))
    layer:addChild(menu)

    return layer
end

function MainScene:ctor()
        --调用视频接口
    if ccexp.VideoPlayer ~= nil then
        local videoPlayer = ccexp.VideoPlayer:create()
        --载入视频文件
        videoPlayer:setFileName("res/cg1.mp4")
        videoPlayer:setPosition(display.cx, display.cy)
        --播放视频时是否始终保持款高比
        videoPlayer:setKeepAspectRatioEnabled(false)
        --是否全屏
        videoPlayer:setFullScreenEnabled(true)
        --开始播放
        videoPlayer:play()
        self:addChild(videoPlayer, 9999)
        --回调监听
        videoPlayer:addEventListener(function(videoPlayer, eventType) 
            if eventType == ccexp.VideoPlayerEvent.PLAYING then
                log("PLAYING")
            elseif eventType == ccexp.VideoPlayerEvent.PAUSED then
                log("PAUSED")
            elseif eventType == ccexp.VideoPlayerEvent.STOPPED then
                log("STOPPED")
            elseif eventType == ccexp.VideoPlayerEvent.COMPLETED then
            --播放完成时处理回调
                log("COMPLETED")
                --先停止播放再延迟一段时间销毁视频。
                --若直接销毁会出现冲突问题。
                -- videoPlayer:stop()
                -- self:runAction(cc.Sequence:create(
                --     cc.DelayTime:create(0.01),
                --     cc.CallFunc:create(function() 
                --         self:removeChild(videoPlayer)
                --         self:doComplete()
                --     end)
                -- ))      
            end
        end)
    end
    -- local label = cc.ui.UILabel.new({
    --         UILabelType = 2, text = "Hello, World", size = 64})
    --     :align(display.CENTER, display.cx, display.cy)
    --     :addTo(self)
    -- self.socket = cc.WebSocket:create("ws://127.0.0.1:9085/")
    -- if self.socket then
    --     self.socket:registerScriptHandler(handler(self, self.onOpen_), cc.WEBSOCKET_OPEN)
    --     self.socket:registerScriptHandler(handler(self, self.onMessage_), cc.WEBSOCKET_MESSAGE)
    --     self.socket:registerScriptHandler(handler(self, self.onClose_), cc.WEBSOCKET_CLOSE)
    --     self.socket:registerScriptHandler(handler(self, self.onError_), cc.WEBSOCKET_ERROR)

    --     -- self.socket:sendString("guojun")
    -- end
 --    label:setTouchEnabled(true)
 --    label:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE) 
 --    label:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
 --        print("...........")
 --        self.socket:sendString("guojun")
	-- end)

    -- local imgAnim = ccui.ImageView:create()
    -- imgAnim:loadTexture("split_1.png")
    -- imgAnim:setAnchorPoint(0,0)
    -- imgAnim:setPosition(0,-400)
    -- self:addChild(imgAnim,99)
    -- local rectW = imgAnim:getContentSize().width
    -- local rectH = imgAnim:getContentSize().height/4

    -- local rects = {}
    -- for i=1,4 do
    --     local rect = cc.rect(0,(i-1)*rectH,rectW,rectH)
    --     rects[i-1] = rect
    -- end
    -- local rectIdx = 0
    -- local realIdx = 0
    -- imgAnim:runAction(cc.RepeatForever:create(
    --     cc.Sequence:create(
    --         cc.CallFunc:create(function( )
    --             local imgIdx = math.ceil((realIdx+1)/4)
    --             if imgIdx > 6 then
    --                 realIdx = 0
    --                 imgIdx = 1
    --             end
    --             imgAnim:loadTexture("split_".. imgIdx ..".png")
    --             realIdx = realIdx+1
    --             imgAnim:setTextureRect(rects[rectIdx])
    --             print("imgIdx",imgIdx,"rectIdx",rectIdx)
    --             rectIdx = (realIdx)%4
    --         end),
    --         cc.DelayTime:create(0.1)
    --     )
    -- ))
end

function MainScene:onOpen_( ... )
	print("websock is open")
end

function MainScene:onMessage_( message )
	print("websock is onMessage_",message)
end

function MainScene:onClose_( ... )
	print("websock is onClose_")
end

function MainScene:onError_( ... )
	print("websock is onError_")
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
