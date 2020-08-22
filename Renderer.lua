
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

    for k,entity in pairs(screen.entities) do
        entity:draw()
    end

    screen.camera:unset()
end

return Renderer