local SetLayer = class("SetLayer", function()
	return display.newColorLayer(cc.c4b(100, 100, 100, 0))
end)

function SetLayer:ctor()
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(true)
	self:init()
end

SetLayer.SLIDER_IMAGES = {
    bar = "SliderBar.png",
    button = "aaa.png",
}

SetLayer.isPlayMusic = true
SetLayer.isPlaySound = true

function SetLayer:init()
	--面板
	local bg = display.newSprite("mianban.png")
	bg:setPosition(cc.p(display.cx, display.cy))
	self:addChild(bg)

	--音乐开关
	cc.ui.UICheckBoxButton.new({on = "duihao1.png",off = "duihao2.png"})
		:setButtonLabel(cc.ui.UILabel.new({text = "音乐", size = 40,  color = display.COLOR_BLUE}))
        :setButtonLabelOffset(-130, 0)
        :pos(display.cx-70, display.cy+100)
        :setButtonSelected(SetLayer.isPlayMusic)
        :onButtonStateChanged(function(event)	
        	if event.state == "on" then
        		SetLayer.isPlayMusic = true
				audio.resumeMusic()
			elseif  event.state == "off" then
				SetLayer.isPlayMusic = false
				audio.pauseMusic()
			end
        	end)
        :addTo(self,4)

    --音效开关
	cc.ui.UICheckBoxButton.new({on = "duihao1.png",off = "duihao2.png"})
		:setButtonLabel(cc.ui.UILabel.new({text = "音效", size = 40,  color = display.COLOR_BLUE}))
        :setButtonLabelOffset(-130,0)
        :pos(display.cx+150, display.cy+100)
        :setButtonSelected(SetLayer.isPlaySound)
        :onButtonStateChanged(function(event)
        	if event.state == "on" then
        		SetLayer.isPlaySound = true
				audio.playSound("yinxiao.wav", false)
			elseif  event.state == "off" then
				SetLayer.isPlaySound = false
			end
			end)
        :addTo(self,4)

    --ok按钮
	local btn = cc.ui.UIPushButton.new({normal = "ok.png"}, {scale9 = true})
	btn:setPosition(cc.p(bg:getContentSize().width/2, 100))
	bg:addChild(btn)
	btn:onButtonClicked(function()
		self:removeFromParent()
		end)

	--音量控制滑块
	cc.ui.UISlider.new(display.LEFT_TO_RIGHT, SetLayer.SLIDER_IMAGES, {scale9 = true})
        :onSliderValueChanged(function(event)
            audio.setMusicVolume(event.value/100)
            audio.setSoundsVolume(event.value/100)
        end)
        :setSliderSize(300, 40)
        :setSliderValue(70)--默认音量70
        :align(display.LEFT_BOTTOM, 100, bg:getContentSize().height/2-50)
        :addTo(bg)
end

return SetLayer