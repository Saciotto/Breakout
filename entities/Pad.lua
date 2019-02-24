
require "constants"

Pad = {
    x = (Constants.SCREEN_WIDTH - Constants.PAD_WIDTH) / 2,
    y = Constants.SCREEN_HEIGHT - Constants.PAD_HEIGHT - Constants.PAD_MARGIN,
    width = Constants.PAD_WIDTH,
    height = Constants.PAD_HEIGHT,
    velocity = Constants.PAD_VELOCITY
}

function Pad:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Pad:update(dt)
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        self.x = self.x - (dt * self.velocity)
    end
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        self.x = self.x + (dt * self.velocity)
    end

    if self.x < 0 then
        self.x = 0 
    end
    if self.x > Constants.SCREEN_WIDTH - self.width then
        self.x = Constants.SCREEN_WIDTH - self.width
    end
end

function Pad:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
