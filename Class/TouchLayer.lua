local TouchLayer = class("TouchLayer", function()
	return display.newLayer()
end)

function TouchLayer:ctor(params)
	self._funcB = params.funcB
	self._funcM = params.funcM
	self._funcE = params.funcE
	self:init()
end

function TouchLayer:init()
	self:setTouchSwallowEnabled(false)
	self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
	self:setTouchEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		if event.name == "began" then 
			--print("began")
			if self._funcB then
				(self._funcB)(event)
			end
			return true
		elseif event.name == "moved" then
			--print("moved")
			if self._funcM then
				(self._funcM)(event)
			end
		elseif event.name == "ended" then
			--print("ended")
			if self._funcE then
				(self._funcE)(event)
			end
		end
	end)
end

function TouchLayer:onEnter()
end

function TouchLayer:onExit()
end

return TouchLayer