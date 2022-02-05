local BricksGrid = Entity:new()

function BricksGrid:new()
    local o = Entity:new()
    setmetatable(o, self)
    self.__index = self
    o.bricks = {}
    o.metalBricks = {}
    return o
end

function BricksGrid:addBrick(brick)
    if brick.lives > 0 then
        table.insert(self.metalBricks, brick)
    else
        table.insert(self.bricks, brick)
    end
end

function BricksGrid:destroyBrick(index)
    table.remove(self.bricks, index)
end

function BricksGrid:destroyMetalBrick(index)
    table.remove(self.metalBricks, index)
end

function BricksGrid:draw()
    for k,brick in pairs(self.bricks) do
        brick:draw()
    end
    for k,brick in pairs(self.metalBricks) do
        brick:draw()
    end
end

return BricksGrid
