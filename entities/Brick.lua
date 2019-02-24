
require "Constants"
require "entities/Entity"

Brick = Entity:new()

function Brick:new(o, x, y, width, height, sprite)
    local width = width or Constants.BRICK_WIDTH
    local height = height or Constants.BRICK_HEIGHT
    local debugColor = {math.random(), math.random(), math.random()}
    local o = Entity:new(o, x, y, width, height, sprite, debugColor)
    setmetatable(o, self)
    self.__index = self
    o.isBroken = false
    return o
end

function Brick:hit()
    self.isBroken = true
end
