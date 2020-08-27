local Entity = require("engine.Entity")

local BricksGrid = Entity:new()

function BricksGrid:new()
    local o = Entity:new()
    setmetatable(o, self)
    self.__index = self
    o.bricks = {}
    o.indestructibleBricks = {}
    return o
end

function BricksGrid:addBrick(brick)
    if brick.indestrutible then
        table.insert(self.indestructibleBricks, brick)
    else
        table.insert(self.bricks, brick)
    end
end

function BricksGrid:destroyBrick(index)
    table.remove(self.bricks, index)
end

function BricksGrid:draw()
    for k,brick in pairs(self.bricks) do
        brick:draw()
    end
    for k,brick in pairs(self.indestructibleBricks) do
        brick:draw()
    end
end

return BricksGrid
