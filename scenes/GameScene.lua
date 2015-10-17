local ui=require("framework.ui")


local GameScene = class("GameScene", function()
	return display.newPhysicsScene("GameScene")
end)

local scheduler = require("framework.scheduler")

function GameScene:ctor()
	self:init()
end

local scenenum
local chapternum

function GameScene:init()
	--keyPad
	self:setKeypadEnabled(true)
	self:addNodeEventListener(cc.KEYPAD_EVENT , function(event)
		if event.key == "back" then
			display.replaceScene(SelectChapter.new())
		elseif event.key == "menu" then
			audio.pauseMusic("backmusic.mp3")
			SetLayer.isPlayMusic = false
		end
	end)

	self._screenRect = cc.rect(0,0,display.width,display.height)--屏幕范围

	self._starNumber = 0

	scenenum = ModifyData.getSceneNumber()
	chapternum = ModifyData.getChapterNumber()

	local tb = PublicData.SCENETABLE

	--背景
	local bg = display.newSprite("background"..scenenum ..".png")
	bg:setPosition(cc.p(display.cx, display.cy))
	local scaleX = display.width/bg:getContentSize().width
	local scaleY = display.height/bg:getContentSize().height
	bg:setScaleX(scaleX)
	bg:setScaleY(scaleY)
	bg:setPosition(cc.p(display.cx, display.cy))
	self:addChild(bg)

	--创建世界
	self:initWorld()

	--暂停按钮 
	local backbtn = cc.ui.UIPushButton.new({normal = "pause.png"}, {scale9 = true})
	backbtn:onButtonClicked(function(event)
		 cc.Director:getInstance():pause()--暂停
		--暂停界面
		local layer = PauseLayer.new()
		layer:setPosition(cc.p(0, 0))
		self:addChild(layer,2)
	end)
	backbtn:setPosition(cc.p(50, display.height-50))
	self:addChild(backbtn)

	--加载UI
	local widget = cc.uiloader:load("ui/Level_"..scenenum.."_"..chapternum..".ExportJson")
	widget:setPosition(cc.p(0, 0))
	self:addChild(widget,1)


	--房子
	self._fangzi =cc.uiloader:seekNodeByName(widget, "house")   --widget:getChildByName("house")
	local g = cc.ParticleGalaxy:create()
	g:setPosition(self._fangzi:getPosition())
	self:addChild(g)

	--将星星加入到表中
	self._starTb = {}
	for i=1,3 do
		local star = cc.uiloader:seekNodeByName(widget,"star"..i)
		table.insert(self._starTb, star)
	end


	local itemsTb = {}
	local itemsBodyTb = {}
	local body

	--创建刚体
	for i=1,tb[scenenum][chapternum].num do
		local item = cc.uiloader:seekNodeByName(widget,"Image_"..i)
		if item:getTag()==301 then--点击可消除
			body =cc.PhysicsBody:createEdgeBox(cc.size(item:getContentSize().width, item:getContentSize().height))
			body:getShape(0):setRestitution(0.5)  --setElasticity(0.5)
			--body:getShape(0):setMass(0)
			table.insert(itemsTb,item)
			table.insert(itemsBodyTb,body)

		elseif item:getTag()==601 then--蜗牛
			self._snail = item
			body = cc.PhysicsBody:createCircle(item:getContentSize().width/2)
			body:getShape(0):setRestitution(0.5)
			body:setMass(20)
		elseif item:getTag()==106 then--石头
			body = cc.PhysicsBody:createCircle(item:getContentSize().width/2-5)   --self._world:createCircleBody(100, item:getContentSize().width/2-5)
			body:getShape(0):setRestitution(0.5)
		elseif item:getTag()==107 then--蘑菇
			body =cc.PhysicsBody:createEdgeBox(item:getContentSize())   --self._world:createBoxBody(0, item:getContentSize().width, item:getContentSize().height)
			body:setMass(0)
			body:getShape(0):setRestitution(2.8)
		-- elseif item:getTag()==501 then--星星
		-- 	body = self._world:createBoxBody(0, item:getContentSize().width, item:getContentSize().height)
			-- body:setElasticity(0.5)
		elseif item:getTag()==401 then--刺
			body = cc.PhysicsBody:createEdgeBox(item:getContentSize())  --self._world:createBoxBody(0, item:getContentSize().width, item:getContentSize().height)
			body:getShape(0):setRestitution(0.5)
		elseif item:getTag()==109 then--三角砖
			item:setAnchorPoint(cc.p(0, 0))
            
            local width=item:getContentSize().width
            local height=item:getContentSize().height

			local arr = {cc.p(-width/2,-height/2), cc.p(-width/2,height/2),cc.p(width/2,-height/2)}
			body =cc.PhysicsBody:createEdgePolygon(arr)   --self._world:createPolygonBody(0, arr)
			body:setMass(0)
			body:getShape(0):setRestitution(0.5)
		elseif item:getTag()==108 then--椰子
			body = cc.PhysicsBody:createBox(item:getContentSize())  --self._world:createBoxBody(100, item:getContentSize().width, item:getContentSize().height)
			body:setMass(100)
			body:getShape(0):setRestitution(0.5)
		elseif item:getTag()==201 then--不可消
			body =cc.PhysicsBody:createEdgeBox(item:getContentSize())  --self._world:createBoxBody(0, item:getContentSize().width, item:getContentSize().height)
			body:getShape(0):setRestitution(0.5)		
		end

		body:getShape(0):setFriction(0.4)--摩擦力

		body:setGroup(item:getTag())--碰撞类型值
        body:setContactTestBitmask(1)
		--body:setGroup(item:getTag())
		item:setPhysicsBody(body)  --body:bind(item)--绑定
		--body:setRotation(item:getRotation())
		--body:setPosition(item:getPosition())
		--body:applyForce(force, offset)
		if item:getTag()==109 then
			--body:setPosition(ccp(item:getPositionX()-item:getContentSize().width/2, item:getPositionY()-item:getContentSize().height/2))
		end
		if item:getTag()==601 then
			self._snailbody = body
		end
		if item:getTag()==107 then
			local png = "mogu.png"
			local plist = "mogu.plist"
			display.addSpriteFrames(plist,png)
			--
			self._sp = display.newSprite("#mogu1.png")
			self._sp:setPosition(item:getPosition())
			self._sp:setRotation(item:getRotation())
			self:addChild(self._sp,1)
			local frames = display.newFrames("mogu%d.png", 1, 5)
			local animate = display.newAnimation(frames, 0.3)
			self._sp:playAnimationForever(animate, 0.1)
		end
	end

		
	--触摸 
	local isMove = false
	self._touchLayer = TouchLayer.new({
		funcB = function(event)
			isMove = false
			print("TouchBegin")
		end,
		funcM = function(event)
			isMove = true
			print("TouchMoved")
		end,
		funcE = function(event)
			if isMove==false then 
				for k,v in pairs(itemsTb) do
					print("TouchedBefore")
					local p = cc.p(event.x, event.y)
					local rect = self:newRect(v)
					if v:getTag()==301 and cc.rectContainsPoint(rect,p) then

						-- transition.moveTo(v,{time=5,x=100,y=200})
						-- itemsBodyTb[k]:unbind()
						-- self._sche = scheduler.scheduleUpdateGlobal(function()
						-- 	itemsBodyTb[k]:setPosition(ccp(v:getPositionX(), v:getPositionY()))
						-- 	print(itemsBodyTb[k]:getPositionX(),itemsBodyTb[k]:getPositionY())
						-- 	if itemsBodyTb[k]:getPositionX()==100 and itemsBodyTb[k]:getPositionY()==200 then
						-- 		print("stop")
						-- 		scheduler.unscheduleGlobal(self._sche)
						-- 	end
						-- end)
						--self._world:removeBody(itemsBodyTb[k])
						v:removeFromParent()
						table.remove(itemsTb,k)
						table.remove(itemsBodyTb,k)
						print("Touched")	
					end
				end
			end
		end
		})
	self:addChild(self._touchLayer)	

	--右上角得分星星
	self._xx = display.newSprite("0getstar.png")
	self._xx:setPosition(cc.p(display.right-self._xx:getContentSize().width/2, display.top-self._xx:getContentSize().height/2))
	self:addChild(self._xx,2)

	--label：场景数-关卡数label
   display.newTTFLabel({
      text = scenenum .."-"..chapternum,
	  color = cc.c3b(100, 100, 100),
	  size = 40,
   	}):pos(display.right-100,display.top-80)
	:addTo(self,2)

	-- ui.newTTFLabelWithOutline({
	-- 	text = scenenum .."-"..chapternum,
	-- 	color = cc.c3b(100, 100, 100),
	-- 	size = 40,
	-- 	outlineColor = cc.c3b(0, 0, 100)})
	--     :pos(display.right-100,display.top-80)
	-- 	:addTo(self,2)

	--碰撞检测:蜗牛和刺
	self:collisionListener()

	--调度update
	
	self._schedule = scheduler.scheduleGlobal(handler(self, self.update),0.1)
end

--重写一个新的rect
function GameScene:newRect(v)
	local size = v:getContentSize()
	local x = v:getPositionX()
	local y = v:getPositionY()
	local rect = cc.rect(x-size.width/2, y-size.height/2, size.width, size.height)
	return rect
end

--碰撞检测:蜗牛和刺
function GameScene:collisionListener()
   --注册碰撞监听事件
   print("Listerbegin")
   --local contactListener  = cc.EventListenerPhysicsContact:create()

    local function onContactBegin(contact)
   	    print("HAHAHAHAHA")
        local node1=contact:getShapeA():getBody():getNode()
        local node2=contact:getShapeB():getBody():getNode()
        if (node1:getTag()==601 and node2:getTag()==401) or (node1:getTag()==401 and node2:getTag()==601) then
			local loseLayer = LoseLayer.new()
	  		scheduler.unscheduleGlobal(self._schedule)
  			self._touchLayer:removeFromParent()
 			loseLayer:setPosition(cc.p(0, 200))
 			self._snail:removeSelf()
 			transition.moveTo(loseLayer,{time = 0.7, y = 0})
  			self:addChild(loseLayer,2)
        end
      return true 
    end

    --contactListener:registerScriptHandler(collisionBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
   

      local contactListener = cc.EventListenerPhysicsContact:create()
      contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN);
      local eventDispatcher = self:getEventDispatcher()
      eventDispatcher:addEventListenerWithSceneGraphPriority(contactListener, self);
    -- contactListener:registerScriptHandler(function(contact, solve)
    --     print("contactPresolve", "-----------", type(contact), type(solve))
    --     return true
    -- end, cc.Handler.EVENT_PHYSICS_CONTACT_PRESOLVE)
 
    -- contactListener:registerScriptHandler(function(contact, solve)
    --     print("contactPostsolve", "-----------", type(contact), type(solve))
    -- end, cc.Handler.EVENT_PHYSICS_CONTACT_POSTSOLVE)
 
    -- contactListener:registerScriptHandler(function(contact)
    --     print("contactSeperate", "-----------", type(contact))
    -- end, cc.Handler.EVENT_PHYSICS_CONTACT_SEPERATE)
 
    --cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(contactListener,self)--(contactListener, self)


	-- self._world:addCollisionScriptListener(function(eventType)
	-- 	if eventType=="begin" then
	-- 		self._world:removeBody(self._snailbody, true)
	-- 		self._snail:removeFromParentAndCleanup(true)
	-- 		--失败界面
	-- 		local loseLayer = LoseLayer.new()
	--  		scheduler.unscheduleGlobal(self._schedule)
 -- 			self._touchLayer:removeFromParentAndCleanup(true)
 -- 			loseLayer:setPosition(ccp(0, 200))
 -- 			transition.moveTo(loseLayer,{time = 0.7, y = 0})
 -- 			self:addChild(loseLayer,2)
	-- 	end
	-- 	return false--穿透
	-- 	end, 601, 401)
end

function GameScene:update(dt)
	
	--改变星星的数量
	local rect1 = self:newRect(self._snail)
	for k,v in pairs(self._starTb) do
		local rect2 = self:newRect(v)
		if cc.rectIntersectsRect(rect1,rect2 ) then
			print("碰到星星")
			--碰到星星时音效
			if SetLayer.isPlaySound then
			 	audio.playSound("yinxiao.wav", false)
			end 

			table.remove(self._starTb,k)
			v:removeFromParent()
			self._starNumber = self._starNumber+1

			--改变右上角得分星星的数量
			local texture =cc.Director:getInstance():getTextureCache():addImage(self._starNumber .."getstar.png")
			self._xx:setTexture(texture)
		end
	end

	
	--判断是否胜利（到达房子）
	local rect3 = self:newRect(self._fangzi)
	if cc.rectIntersectsRect(rect1,rect3 )  then
        scheduler.unscheduleGlobal(self._schedule)--停止调度
		self._snail:setPosition(cc.p(self._fangzi:getPositionX(), self._fangzi:getPositionY()))
 		ModifyData.setStarNumber(self._starNumber)--修改星星的数量

 		--胜利界面
 		self._touchLayer:removeFromParent()
 		local layer = WinLayer.new()
 		layer:setPosition(cc.p(0, 200))
 		transition.moveTo(layer,{time = 0.7, y = 0})
 		self:addChild(layer,2)

 		--修改数据
 		self:modify()
	end

	--判断是否失败（滚出屏幕）
	if cc.rectContainsPoint(self._screenRect, cc.p(self._snail:getPositionX(),self._snail:getPositionY())) == false then
		--失败界面
		scheduler.unscheduleGlobal(self._schedule)
		local loseLayer = LoseLayer.new()
 		self._touchLayer:removeFromParent()
 		loseLayer:setPosition(cc.p(0, 200))
 		transition.moveTo(loseLayer,{time = 0.7, y = 0})
 		self:addChild(loseLayer,2)
	end
end

--修改数据
function GameScene:modify()
	local tb = PublicData.SCENETABLE
	if self._starNumber>tb[scenenum][chapternum].star  then
		tb[scenenum][chapternum].star = self._starNumber
		if self._starNumber == 3 then--星星数为3时解锁下一关
			if chapternum<#Data.SCENE[scenenum] then
				tb[scenenum][chapternum+1].lock = 0
			end
		end
	end
	
	local str = json.encode(tb)
	ModifyData.writeToDoc(str)
end

--创建世界
function GameScene:initWorld()
	--世界
	self._world = self:getPhysicsWorld()
    self._world:setGravity(cc.p(0,-1000))
   -- self._world:step(0.01)
    
	--地面刚体
	local bottomsp = display.newSprite("caocong.png")
	local scaleX = display.width/bottomsp:getContentSize().width
	bottomsp:setScale(scaleX)
	self:addChild(bottomsp)

	local bottom =cc.PhysicsBody:createEdgeBox(cc.size(display.width,30))
	bottom:getShape(0):setFriction(0.9)
	bottom:getShape(0):setRestitution(0.5)
    bottom:setMass(0)
    bottomsp:pos(display.cx, 15)
	bottomsp:setPhysicsBody(bottom)

	--刚体调试
	self._world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
end

function GameScene:onEnter()
		--self._world:start()
end

function GameScene:onExit()
	scheduler.unscheduleGlobal(self._schedule)
end

return GameScene