
local Renderer = {}

local function drawEntity(entity)
    if entity.sprite ~= nil then
        AssetsManager.drawSprite(entity.sprite, entity:getViewport())
    else
        -- Sprite error, show debug rectangle
        love.graphics.setColor(entity.debugColor or {1,1,1})
        love.graphics.rectangle("fill", entity:getViewport())
    end
end

function Renderer.draw(screen)
    love.graphics.setBackgroundColor(0,0,0)

    screen.camera:set()
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", 0, 0, Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT)
    love.graphics.setColor(1,1,1)

    drawEntity(screen.pad)
    for k,brick in pairs(screen.bricks) do
        drawEntity(brick)
    end
    love.graphics.setColor(1,1,1)
    drawEntity(screen.ball)
    if screen.controller.winner then
        love.graphics.print("Vencedor")    
    end
    if screen.controller.loser then
        love.graphics.print("Perdedor")
    end
    screen.camera:unset()
end

return Renderer