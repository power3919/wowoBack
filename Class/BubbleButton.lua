--local ui=require("framework.ui")


local BubbleButton = {}

function BubbleButton.new(params)
    local listener = params.listener
    local button

    params.listener = function(sender)
        if params.prepare then
            params.prepare()
        end

        local function zoom1(offset, time, onComplete)
            local x, y = button:getPosition()
            local size = button:getContentSize()

            local scaleX = button:getScaleX() * (size.width + offset) / size.width
            local scaleY = button:getScaleY() * (size.height - offset) / size.height

            transition.moveTo(button, {y = y - offset, time = time})
            transition.scaleTo(button, {
                scaleX     = scaleX,
                scaleY     = scaleY,
                time       = time,
                onComplete = onComplete,
            })
        end

        local function zoom2(offset, time, onComplete)
            local x, y = button:getPosition()
            local size = button:getContentSize()

            transition.moveTo(button, {y = y + offset, time = time / 2})
            transition.scaleTo(button, {
                scaleX     = 1.0,
                scaleY     = 1.0,
                time       = time,
                onComplete = onComplete,
            })
        end

        button:getParent():setEnabled(false)

        zoom1(20, 0.08, function()
            zoom2(20, 0.09, function()
                zoom1(10, 0.10, function()
                    zoom2(10, 0.11, function()
                        button:getParent():setEnabled(true)
                        local tag=button:getTag()
                        listener(tag)
                    end)
                end)
            end)
        end)
    end


    local normalSpr=display.newSprite(params.image)
    local pressSpr=display.newSprite(params.image)

    button=cc.MenuItemSprite:create(normalSpr,pressSpr)
    button:registerScriptTapHandler(params.listener)
    return button
end

return BubbleButton
