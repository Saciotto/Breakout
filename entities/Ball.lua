
require "constants"

Ball = {
    x,
    y,
    dx,
    dy,
    velocity,
    angle,
    width = Constants.BALL_RADIUS * 2,
    height = Constants.BALL_RADIUS * 2,
    sprite,
    image,
}

function Ball:updateDeltaV()
    self.dx = self.velocity * math.cos(self.angle)
    self.dy = self.velocity * math.sin(self.angle)
end

function Ball:new(o, x, y, velocity, sprite, image, angle)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.x = x or 0
    o.y = y or 0
    o.velocity = velocity or Constants.BALL_VELOCITY
    o.angle = angle or math.pi/4
    o.sprite = sprite
    o.image = image
    o:updateDeltaV()
    return o
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:draw()
    local sx, sy, sw, sh = self.sprite:getViewport()
    love.graphics.draw(self.image, self.sprite, self.x, self.y, self.width/sw, self.height/sh)
    -- local radius = self.width / 2
    -- love.graphics.circle("fill", self.x + radius, self.y + radius, radius)
end

function Ball:setVelocity(velocity)
    self.velocity = velocity
    self:updateDeltaV()
end

function Ball:setAngle(angle)
    self.angle = angle
    self:updateDeltaV()
end

function Ball:hit(side)
    if side == "bottom" then
        self.dy = -1 *math.abs(self.dy)
    elseif side == "top" then
        self.dy = math.abs(self.dy)
    elseif side == "left" then
        self.dx = math.abs(self.dx)
    elseif side == "right" then
        self.dx = -1 * math.abs(self.dx)
    end
end

function Ball:hitPad(cos)
    self.angle = math.pi + math.acos(-1 * cos) 
    self:updateDeltaV()
end
