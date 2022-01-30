local Ball = Entity:new()

function Ball:new(x, y, velocity, angle)
    local side = Constants.BALL_RADIUS * 2
    local angle = angle or -math.pi/4
    local velocity = velocity or Constants.BALL_VELOCITY

    local ball = Entity:new(x, y, side, side, Sprites["ball"], Colors.RED)
    setmetatable(ball, self)
    self.__index = self

    ball.dx = velocity * math.cos(angle)
    ball.dy = velocity * math.sin(angle)
    ball.hits = 0
    return ball
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
    Entity.update(self, dt)
end

function Ball:getAngle()
    return math.atan2(self.dy, self.dx)
end

function Ball:getVelocity()
    return math.sqrt(self.dy^2 + self.dx^2)
end

function Ball:setVelocity(velocity)
    local angle = self:getAngle()
    self.dx = velocity * math.cos(angle)
    self.dy = velocity * math.sin(angle)
end

function Ball:setAngle(angle)
    local velocity = self:getVelocity()
    self.dx = velocity * math.cos(angle)
    self.dy = velocity * math.sin(angle)
end

function Ball:hit(side)
    if side == "bottom" then
        self.dy = -1 * math.abs(self.dy)
    elseif side == "top" then
        self.dy = math.abs(self.dy)
    elseif side == "left" then
        self.dx = math.abs(self.dx)
    elseif side == "right" then
        self.dx = -1 * math.abs(self.dx)
    end
    self.hits = self.hits + 1
end

function Ball:hitPad(cos)
    local angle = math.pi + math.acos(-1 * cos)
    self:setAngle(angle)
    self.hits = self.hits + 1
end

return Ball
