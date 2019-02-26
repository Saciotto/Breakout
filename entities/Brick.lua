--- Brick class

Entity = require("entities.Entity")

local Brick = Entity:new()

function Brick:new(x, y, width, height, sprite)
    width = width or Constants.BRICK_WIDTH
    height = height or Constants.BRICK_HEIGHT
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

return Brick
