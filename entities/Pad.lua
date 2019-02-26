--- Pad class

local Entity = require("Entity")

local Pad = Entity:new()

function Pad:new(x, y, width, height, sprite, debugColor)
    x = x or (Constants.SCREEN_WIDTH - Constants.PAD_WIDTH) / 2
    y = y or Constants.SCREEN_HEIGHT - Constants.PAD_HEIGHT - Constants.PAD_MARGIN
    width = width or Constants.PAD_WIDTH
    height = height or Constants.PAD_HEIGHT
    local o = Entity:new(nil, x, y, width, height, sprite, debugColor)
    setmetatable(o, self)
    self.__index = self
    o.velocity = Constants.PAD_VELOCITY
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

return Pad
