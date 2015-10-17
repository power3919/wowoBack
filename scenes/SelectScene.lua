local SelectScene = class("SelectScene", function ()
	return display.newScene("SelectScene")
end)

function SelectScene:ctor()
	self:init()
end

function SelectScene:init()
	--keyPad
	self:setKeypadEnabled(true)
	self:addNodeEventListener(cc.KEYPAD_EVENT , function(event)
		if event.key == "back" then
			cc.Director:getInstance():replaceScene(StartScene.new())
		elseif event.key == "menu" then
			audio.pauseMusic("backmusic.mp3")
			SetLayer.isPlayMusic = false
		end
	end)
	
	--背景
	local bg = display.newSprite("bg2.png")
	bg:setPosition(cc.p(display.cx, display.cy))
	local scaleX = display.width/bg:getContentSize().width
	local scaleY = display.height/bg:getContentSize().height
	bg:setScaleX(scaleX)
	bg:setScaleY(scaleY)
	bg:setPosition(cc.p(display.cx, display.cy))
	self:addChild(bg)

	--返回按钮
	local backbtn = cc.ui.UIPushButton.new({normal = "backarrow.png"}, {scale9 = true})
	backbtn:onButtonClicked(function(event)
		display.replaceScene(StartScene.new())  --:replaceScene(StartScene.new())
	end)
	backbtn:setPosition(cc.p(50, display.top-50))
	self:addChild(backbtn,1)

	-- local function toSceneSelect(tag)
	-- 	print("ToSceneSelect")
	-- 	--ModifyData.setSceneNumber(tag)
	-- 	--local selectScene = SelectChapter.new()
	-- 	--CCDirector:sharedDirector():replaceScene(selectScene)
	-- end

	--场景选择
	--local item1 = cc.ui.newImageMenuItem({image = "scene11.png", tag = 1, listener = toSceneSelect})
	
    --local item1=cc.MenuItemImage:create("scene11.png","scene11.png")
    --item1:addNodeEventListener(cc.MENU_ITEM_CLICKED_EVENT,toSceneSelect)
   
    local anode=display.newNode()
    anode:addTo(self)

    

    local item1=cc.ui.UIPushButton.new({normal="scene11.png",pressed="scene11.png"},{scale9=true})
                     :onButtonClicked(function (event)
                         print("ToSceneSelect11")
		                 ModifyData.setSceneNumber(1)
		                 local selectScene = SelectChapter.new()
		                 display.replaceScene(selectScene)
                     end)
                     :pos(-250,0)
                     :addTo(anode)

    local item2=cc.ui.UIPushButton.new({normal="scene22.png",pressed="scene22.png"},{scale9=true})
                     :onButtonClicked(function (event)
                         print("ToSceneSelect22")
		                 ModifyData.setSceneNumber(2)
		                 local selectScene = SelectChapter.new()
		                 display.replaceScene(selectScene)
                     end)
                     :pos(0,0)
                     :addTo(anode)

    local item3=cc.ui.UIPushButton.new({normal="scene33.png",pressed="scene33.png"},{scale9=true})
                     :onButtonClicked(function (event)
                         print("ToSceneSelect33")
		                 ModifyData.setSceneNumber(3)
		                 local selectScene = SelectChapter.new()
		                 display.replaceScene(selectScene)
                     end)
                     :pos(250,0)
                     :addTo(anode)




	local to1 = cc.JumpTo:create(1, cc.p(display.cx, display.cy-20), 50, 2)
	anode:pos(display.cx, display.cy)
	anode:runAction(to1)

end


function SelectScene:onEnter()
end

function SelectScene:onExit()
end

return SelectScene