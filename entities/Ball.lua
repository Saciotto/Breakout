
require "constants"
require "entities/Entity"

Ball = Entity:new()

function Ball:updateDeltaV()
    self.dx = self.velocity * math.cos(self.angle)
    self.dy = self.velocity * math.sin(self.angle)
end

function Ball:new(o, x, y, velocity, sprite, angle)
    local o = Entity:new(o, x, y, Constants.BALL_RADIUS * 2, Constants.BALL_RADIUS * 2, sprite, Constants.COLOR_RED)
    setmetatable(o, self)
    self.__index = self
    o.velocity = velocity or Constants.BALL_VELOCITY
    o.angle = angle or math.pi/4
    o:updateDeltaV()
    return o
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
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
