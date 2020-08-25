local Colors = require("helpers.Colors")
local Renderer = require("helpers.Renderer")

local Entity = {}

function Entity:new(o, x, y, width, height, sprite, debugColor)
    local o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.x = x or 0
    o.y = y or 0
    o.width = width or 1
    o.height = height or 1
    o.sprite = sprite
    o.debugColor = debugColor or Colors.WHITE
    return o
end

function Entity:getViewport()
    return self.x, self.y, self.width, self.height
end

function Entity:update(dt)
end

function Entity.drawItem(sprite, debugColor, x, y, w, h)
    Renderer.drawSprite(sprite, debugColor, x, y, w, h)
end

function Entity:draw()
    self.drawItem(self.sprite, self.debugColor, self:getViewport())
end

return Entity
