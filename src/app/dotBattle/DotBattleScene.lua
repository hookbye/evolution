--
-- Author: <wangguojun@playcrab.com>
-- Date: 2017-05-31 21:14:47
--
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
require("app.dotBattle.Utils")
local Dot = require("app.dotBattle.Dot")
local DotBattleScene = class("DotBattleScene", function( )
	return display.newScene("DotBattleScene")
end)

function DotBattleScene:ctor( )
	self._enemys = {}
	self._player = Dot.new()
	print(self._player,"init self._player")
	self._player:setPosition(200,200)
	self:addChild(self._player,1)
	-- self._joyPad = 
	local mapEditor = require("app.justFire.MapEditor").new()
	self:addControllLayer(mapEditor,999)
	mapEditor:setVisible(false)
	
	local editorBtn = Utils:createDefaultBtn("editorMap",function(  )
		local isEditorVisible = mapEditor:isVisible()
		mapEditor:setVisible(not isEditorVisible)
	end)
	editorBtn:setPosition(display.width-80,display.height-80)
	self:addChild(editorBtn,99)

	local battleLayer = require("app.dotBattle.BattleLayer").new()
	self:addControllLayer(battleLayer,0)
	
	local dotMap = require("app.dotBattle.DotMap").new()
	self:addControllLayer(dotMap,0)
	self._dotMap = dotMap

	local joyPadLayer = require("app.justFire.ControllLayer").new({events = {
		up = function(  )
			self:joyPadUp()
		end,
		down = function(  )
			self:joyPadDown()
		end,
		left = function(  )
			self:joyPadLeft()
		end,
		right = function(  )
			self:joyPadRight()
		end,
		cancel = function(  )
			self:joyPadCancel()
		end,
		fight = function( )
			self:joyPadFight()
		end
		}})
	self:addControllLayer(joyPadLayer,100)

	scheduler.scheduleGlobal(function( dt )
		self:updateEx(dt)
	end,0.01)
end

function DotBattleScene:addControllLayer( layer, priority )
	self:addChild(layer,priority)
end

function DotBattleScene:updateEx( dt )
	-- print("self:checkPlayer()",self:checkPlayer())
	if self:checkPlayer() then
		self._player:updateEx(dt)
	end
end

-- 控制player
function DotBattleScene:checkPlayer( )
	-- print(self._player)
	if not self._player then return end
	return true
end

function DotBattleScene:joyPadUp( )
	if not self:checkPlayer() then return end
	self._player:setDir(0,1)
end

function DotBattleScene:joyPadDown( )
	if not self:checkPlayer() then return end
	self._player:setDir(0,-1)
end

function DotBattleScene:joyPadLeft( )
	if not self:checkPlayer() then return end
	self._player:setDir(-1,0)
end

function DotBattleScene:joyPadRight( )
	if not self:checkPlayer() then return end
	self._player:setDir(1,0)
end

function DotBattleScene:joyPadCancel( )
	if not self:checkPlayer() then return end
	self._player:setDir(0,0)
end

function DotBattleScene:joyPadFight( )
	if not self:checkPlayer() then return end
	self._player:doAtk()
end

return DotBattleScene