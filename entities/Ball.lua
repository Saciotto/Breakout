--- Ball class

local Constants = require("Constants")
local Entity = require("Entity")

local Ball = Entity:new()

local function updateDeltaV(ball)
    ball.dx = ball.velocity * math.cos(ball.angle)
    ball.dy = ball.velocity * math.sin(ball.angle)
end

function Ball:new(x, y, velocity, angle)
    local side =  Constants.BALL_RADIUS * 2
    local o = Entity:new(nil, x, y, side, side, Sprites["ball"], Constants.COLOR_RED)
    setmetatable(o, self)
    self.__index = self
    o.velocity = velocity or Constants.BALL_VELOCITY
    o.angle = angle or -math.pi/4
    updateDeltaV(o)
    return o
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:setVelocity(velocity)
    self.velocity = velocity
    updateDeltaV(self)
end

function Ball:setAngle(angle)
    self.angle = angle
    updateDeltaV(self)
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
    updateDeltaV(self)
end

function Ball:draw()
    self.drawItem(self.sprite, self.debugColor, self.x, self.y, self.width, self.height)
end

return Ball
