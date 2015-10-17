
local LoseLayer = class("LoseLayer", function()
	return display.newColorLayer(cc.c4b(100, 100, 100, 100))
end)

function LoseLayer:ctor()
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(true)
	self:setContentSize(cc.size(display.width,display.height))
	self:init()
end

function LoseLayer:init()
	--失败面板
	local sp = display.newSprite("succeed.png")
	sp:setPosition(self:getContentSize().width/2, self:getContentSize().height/2)
	self:addChild(sp)

	--失败音效
	if SetLayer.isPlaySound then
		audio.playSound("lose.wav", false)
	end

	local label =display.newTTFLabel({
 		          text = "很遗憾，过关失败！",
                  size = 30,
                  color = cc.c3b(100, 100, 200),
                  align = cc.TEXT_ALIGNMENT_LEFT,
                  valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP
            }) 
 	label:setPosition(cc.p(display.cx, display.cy+100))
 	self:addChild(label)

	
	local function click(event)
        local tag=event.target:getTag()
		if tag == 1 then--重玩
			display.replaceScene(GameScene.new())
		elseif tag == 2 then--菜单
			display.replaceScene(SelectChapter.new())
		end
	end

    
    
    local anode=display.newNode()
    anode:pos(display.cx, display.cy-50)
    anode:addTo(self)

    local item1=cc.ui.UIPushButton.new({normal="again.png"},{scale9=true})
                :onButtonClicked(click)
                :pos(-50, 0)
                :addTo(anode)
                :setTag(1)

    local item1=cc.ui.UIPushButton.new({normal="menu.png"},{scale9=true})
                :onButtonClicked(click)
                :pos(50, 0)
                :addTo(anode)
                :setTag(2)





    --先注掉
	-- local item1 = ui.newImageMenuItem({image = "again.png", tag = 1, listener = click})
	-- local item2 = ui.newImageMenuItem({image = "menu.png", tag = 2, listener = click})
	-- local menu = ui.newMenu({item1,item2})
	-- item1:setScale(1.3)
	-- item2:setScale(1.3)
	-- menu:setPosition(ccp(display.cx, display.cy-50))
	-- menu:alignItemsHorizontallyWithPadding(25)
	-- self:addChild(menu)
end

return LoseLayer