

BLOCK_WIDTH = 24
BLOCK_HEIGHT = 20

Brick = {
    x = 0,
    y = 0,
    width = BLOCK_WIDTH,
    height = BLOCK_HEIGHT,
    color = {1,1,1},
    isBroken = false
}

function Brick:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.color = {math.random(), math.random(), math.random()}
    return o
end

function Brick:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Brick:hit()
    self.isBroken = true
end
