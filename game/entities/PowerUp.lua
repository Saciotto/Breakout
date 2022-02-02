local PowerUp = Entity:new()

function PowerUp:new(x, y, type)
    local powerUp = Entity:new(x, y, Constants.POWER_UP_WIDTH, Constants.POWER_UP_HEIGHT, nil, Colors.GREEN)
    setmetatable(powerUp, self)
    self.__index = self
    powerUp.type = type
    powerUp.dy = Constants.POWER_UP_VELOCITY
    return powerUp
end

function PowerUp:update(dt)
    self.y = self.y + self.dy * dt
    Entity.update(self, dt)
end

return PowerUp
