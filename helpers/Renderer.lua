local AssetsManager = require("helpers.AssetsManager")

local Renderer = {}

function Renderer:new(screen)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self.screen = screen
    return o
end

function Renderer:drawBackground()
    AssetsManager.drawImage(self.screen.background, 0, 0, self.screen.width, self.screen.height)
end

function Renderer:draw()
    love.graphics.setBackgroundColor(0, 0, 0)

    self.screen.camera:set()

    if (screen.background ~= nil) then
        self:drawBackground()
    else
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 0, 0, self.screen.width, self.screen.height)
    end

    love.graphics.setColor(1, 1, 1)

    for k, entity in pairs(self.screen.entities) do
        entity:draw()
    end

    for k, widget in pairs(self.screen.widgets) do
        widget:draw()
    end

    screen.camera:unset()
end

return Renderer