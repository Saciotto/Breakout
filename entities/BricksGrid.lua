local Entity = require("helpers.Entity")

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
    table.insert(self.bricks, brick)
end

function BricksGrid:destroyBrick(index)
    table.remove(self.bricks, index)
end

function BricksGrid:addIndestrutibleBrick(brick)
    table.insert(self.indestructibleBricks, brick)
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
