local PauseLayer = class("PauseLayer", function()
	return display.newColorLayer(cc.c4b(80, 80, 80, 70))
end)

function PauseLayer:ctor()
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(true)
	self:setContentSize(cc.size(display.width,display.height))
	self:init()
end

function PauseLayer:init()
	--背景
	local bg = display.newSprite("green.jpg")
		bg:setAnchorPoint(cc.p(0, 0))
		bg:setPosition(cc.p(0, 0))		
		bg:addTo(self,0)

	local function click(event)
		local tag=event.target:getTag()

		if tag == 1 then--重玩
			cc.Director:getInstance():resume()
			cc.Director:getInstance():replaceScene(GameScene.new())
		elseif tag == 2 then --继续
			cc.Director:getInstance():resume()
			self:removeFromParent()
		elseif tag == 3 then --回到关卡选择界面
			cc.Director:getInstance():resume()
			cc.Director:getInstance():replaceScene(SelectChapter.new())
		end
	end


    local anode =display.newNode()
    anode:pos(bg:getContentSize().width/2 , bg:getContentSize().height/2)
	bg:addChild(anode)
	--local item1 = ui.newImageMenuItem({image = "again.png", tag = 1, listener = click})
	local item1=cc.ui.UIPushButton.new({normal="again.png"},{scale9=true})
	:onButtonClicked(click)
	:addTo(anode)
	:pos(0, 100)
	:setTag(1)

	--local item2 = ui.newImageMenuItem({image = "continue.png", tag = 2, listener = click})
	local item2=cc.ui.UIPushButton.new({normal="continue.png"},{scale9=true})
	:onButtonClicked(click)
	:addTo(anode)
	:pos(0, 0)
	:setTag(2)

	--local item3 = ui.newImageMenuItem({image = "menu.png", tag = 3, listener = click})
	local item3=cc.ui.UIPushButton.new({normal="menu.png"},{scale9=true})
	:onButtonClicked(click)
	:addTo(anode)
	:pos(0, -100)
	:setTag(3)

	
	

	local music = cc.ui.UICheckBoxButton.new({on = "music1.png", off = "music2.png"})
	music:setPosition(cc.p(100, 525))
	music:onButtonStateChanged(function(event)
		if event.state == "on" then
        	SetLayer.isPlayMusic = true
			audio.resumeMusic()
		elseif  event.state == "off" then
			SetLayer.isPlayMusic = false
			audio.pauseMusic()
		end
	end)
	music:setButtonSelected(SetLayer.isPlayMusic)
	self:addChild(music)
end

return PauseLayer