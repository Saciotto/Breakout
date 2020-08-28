local Colors = require("engine.Colors")
local Renderer = require("engine.Renderer")
local Drawable = require("engine.Drawable")

local Entity = {}

function Entity:new(x, y, width, height, drawable, debugColor)
    local entity = {}
    setmetatable(entity, self)
    self.__index = self
    entity.x = x or 0
    entity.y = y or 0
    entity.width = width or 1
    entity.height = height or 1
    entity.drawable = drawable or Drawable:new()
    entity.debugColor = debugColor or Colors.WHITE
    return entity
end

function Entity:getViewport()
    return self.x, self.y, self.width, self.height
end

function Entity:update(dt)
    self.drawable:update(dt)
end

function Entity:setArea(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end

function Entity:draw()
    self.drawable:draw(self:getViewport())
end

return Entity
