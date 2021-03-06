

local SelectChapter = class("SelectChapter", function()
	return display.newScene("SelectChapter")
end)

function SelectChapter:ctor()
	self:init()
end

local scheduler = require("framework.scheduler")

function SelectChapter:init()
	--keyPad
	self:setKeypadEnabled(true)
	self:addNodeEventListener(cc.KEYPAD_EVENT , function(event)
		if event.key == "back" then
			display.replaceScene(SelectScene.new())
		elseif event.key == "menu" then
			audio.pauseMusic("backmusic.mp3")
			SetLayer.isPlayMusic = false
		end
	end)

	
	local scenenum = ModifyData.getSceneNumber()
	local chapternum = ModifyData.getChapterNumber()
	
	local chapterBtnData = Data.getChapterBtnData(scenenum)

	if #PublicData.SCENETABLE==0 then
		local docpath = cc.FileUtils:getInstance():getWritablePath().."data.txt"
		if cc.FileUtils:getInstance():isFileExist(docpath)==false then
			local str = json.encode(Data.SCENE)
			ModifyData.writeToDoc(str)
			PublicData.SCENETABLE = Data.SCENE
		else
			local str = ModifyData.readFromDoc()
			PublicData.SCENETABLE = json.decode(str)
		end
	end
	
	
	local tb = PublicData.SCENETABLE


	local wowo = display.newSprite("wowo1.png")
	local jumpto1 = cc.JumpTo:create(5, cc.p(display.right-100, display.top-150), 20, 10)
	local flip1 = cc.FlipX:create(true)
	local jumpto2 = cc.JumpTo:create(5, cc.p(display.left+100, display.top-150), 20, 10)
	local flip2 = cc.FlipX:create(false)
	local seq = cc.Sequence:create(jumpto1,flip1,jumpto2,flip2)   --getSequence({jumpto1,flip1,jumpto2,flip2})
	local rota = cc.RotateBy:create(1, 360)
	local spawn = cc.Spawn:create(rota, seq)
	wowo:setPosition(cc.p(display.left+100, display.top-100))
	self:addChild(wowo,4)
	wowo:runAction(spawn)

	--背景
	local bg = display.newSprite("bg2.png")
	local scaleX = display.width/bg:getContentSize().width
	local scaleY = display.height/bg:getContentSize().height
	bg:setScaleX(scaleX)
	bg:setScaleY(scaleY)
	bg:setPosition(cc.p(display.cx, display.cy))
	self:addChild(bg)

	--layer
	self._layer = display.newColorLayer(cc.c4b(100, 100, 250, 0))
	bg:setAnchorPoint(cc.p(0, 0))
	bg:setPosition(cc.p(0, 0))
	self._layer:setContentSize(cc.size(display.width*2,display.height*3/4))
	
	--返回按钮
	local backbtn = cc.ui.UIPushButton.new({normal = "backarrow.png"}, {scale9 = true})
	backbtn:onButtonClicked(function(event)
		display.replaceScene(SelectScene.new())
	end)
	backbtn:setPosition(cc.p(50, display.top-50))
	self:addChild(backbtn,1)

	--scrollview
	self._scroll =  cc.ScrollView:create(cc.size(display.width,display.height*3/4), self._layer)
	self._scroll:setDirection(0)
	self:addChild(self._scroll)


	for i=1,#Data.SCENE[scenenum] do
		local btn
		if tb[scenenum][i].lock==1 then
			btn = cc.ui.UIPushButton.new({normal = chapterBtnData.pic2}, {scale9 = true})
			btn:setButtonEnabled(false)
		elseif tb[scenenum][i].lock==0 then
			btn = cc.ui.UIPushButton.new({normal = chapterBtnData.pic}, {scale9 = true})
			btn:setButtonEnabled(true)
		end
		btn:setTouchSwallowEnabled(false)
		btn:setTag(i)
		btn:setScale(0.7)
		--btn:setPosition(ccp(100+(i-1)*300, 150))
		local f = (self._layer:getContentSize().width-btn:getContentSize().width-100)/6
		btn:setPosition(cc.p(100+(i-1)*f, 150))
		btn:onButtonClicked(function (event)
			if self._scroll:isTouchMoved()==false then
				ModifyData.setChapterNumber(event.target:getTag())
				display.replaceScene(GameScene.new())
			end
		end)
		self._scroll:addChild(btn)

		local sp = display.newSprite(tb[scenenum][i].star .."getstar.png")
		sp:setPosition(cc.p(btn:getPositionX()+35,btn:getPositionY()-50))
		self._scroll:addChild(sp)
		if tb[scenenum][i].lock==0 then
			local sp2 = display.newSprite(i ..".png")
			sp2:setScale(0.7)
			sp2:setPosition(cc.p(btn:getPositionX()+10, btn:getPositionY()+20))
			self._scroll:addChild(sp2)
		end
	end
	
	
	-- local touchLayer = TouchLayer.new({
	-- funcB = function(event)
	-- 	oldPoint = {x = event.x, y = event.y}
	-- end,
	-- funcM = function(event)
	-- end,
	-- funcE = function(event)
	-- 	newPoint = {x = event.x, y = event.y}
	-- end})
	-- self:addChild(touchLayer)
end


function SelectChapter:onEnter()
end

function SelectChapter:onExit()
end

return SelectChapter