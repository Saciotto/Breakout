
Renderer = {}

function drawEntity(entity)
    if entity.sprite ~= nil then
        AssetsManager.drawSprite(entity.sprite, entity:getViewport())
    else
        -- Sprite error, show debug rectangle
        love.graphics.setColor(entity.debugColor or {1,1,1})
        love.graphics.rectangle("fill", entity:getViewport())
    end
end

function Renderer.draw()
    love.graphics.setBackgroundColor(0,0,0)

    camera:set()

    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", 0, 0, Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT)
    love.graphics.setColor(1,1,1)

    drawEntity(pad)
    -- pad:draw()
    for k,block in pairs(blocks) do
        drawEntity(block)
        --block:draw()
    end
    love.graphics.setColor(1,1,1)
    drawEntity(ball)
    -- ball:draw()
    if winner then
        love.graphics.print("Vencedor")    
    end
    if loser then
        love.graphics.print("Perdedor")
    end
    camera:unset()
end

return Renderer