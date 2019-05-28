
local Constants = require("Constants")

local Renderer = {}

function Renderer.draw(screen)
    love.graphics.setBackgroundColor(0,0,0)

    screen.camera:set()

    if (screen.background ~= nil) then
        love.graphics.draw(screen.background)
    else
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 0, 0, Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT)
    end
    love.graphics.setColor(1,1,1)

    screen.pad:draw()
    for k,brick in pairs(screen.bricks) do
        brick:draw()
    end
    love.graphics.setColor(1,1,1)
    screen.ball:draw()
    if screen.controller.winner then
        love.graphics.print("Vencedor")    
    end
    if screen.controller.loser then
        love.graphics.print("Perdedor")
    end
    screen.camera:unset()
end

return Renderer