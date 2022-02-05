local BORDER_SIZE = 1000

local BallController = {
    borderLeft = Entity:new(-1 * BORDER_SIZE, 0, BORDER_SIZE, Constants.SCREEN_HEIGHT),
    borderRight = Entity:new(Constants.SCREEN_WIDTH, 0, BORDER_SIZE, Constants.SCREEN_HEIGHT),
    borderTop = Entity:new(0, -1 * BORDER_SIZE, Constants.SCREEN_WIDTH, BORDER_SIZE)
}

function BallController:new(gameControler)
    local controller = {}
    setmetatable(controller, self)
    self.__index = self
    controller.game = gameControler
    controller.screen = gameControler.screen
    return controller
end

local function updateBallSpeed(ball)
    local ballSpeed
    if ball.hits > 1000 then
        ballSpeed = 2.5
    elseif ball.hits > 50 then 
        ballSpeed = 2
    elseif ball.hits > 10 then 
        ballSpeed = 1.5
    else
        ballSpeed = 1
    end
    ball:setVelocity(Constants.BALL_VELOCITY * ballSpeed)
end

local function isInsideTheField(ball)
    if ball.y > Constants.SCREEN_HEIGHT then
        return false
    end
    return true
end

local function getCollisionSide(ball, x1, y1, w1, h1, x2, y2, w2, h2)
    local tx, ty
    local dx = ball.dx
    local dy = ball.dy

    if dy > 0 and dx > 0 then
        tx = (x1 + w1 - x2) / dx
        ty = (y1 + h1 - y2) / dy
        if ty <= tx then 
            return "top"
        else
            return "left"
        end
    elseif dy > 0 and dx < 0 then
        tx = (x1 - x2 - w2) / dx
        ty = (y1 + h1 - y2) / dy
        if ty <= tx then 
            return "top"
        else
            return "right"
        end
    elseif dy < 0 and dx > 0 then
        tx = (x1 + w1 - x2) / dx
        ty = (y1 - y2 - h2) / dy
        if ty <= tx then 
            return "bottom"
        else
            return "left"
        end
    elseif dy < 0 and dx < 0 then
        tx = (x1 - x2 - w2) / dx
        ty = (y1 - y2 - h2) / dy
        if ty <= tx then 
            return "bottom"
        else
            return "right"
        end
    end
    return "bottom"
end

local function testCollision(ball, x1, y1, w1, h1, x2, y2, w2, h2)
    if (x1 < x2 + w2) and (x1 + w1 > x2) and (y1 < y2 + h2) and (y1 + h1 > y2) then
        return true, getCollisionSide(ball, x1, y1, w1, h1, x2, y2, w2, h2)
    end
    return false
end

local function updateBallAfterColision(ball, entity, side)
    if side == "bottom" then
        ball.y = entity.y + entity.height
        ball.dy = math.abs(ball.dy)
    elseif side == "top" then
        ball.y = entity.y - ball.height 
        ball.dy = -1 * math.abs(ball.dy)
    elseif side == "left" then
        ball.x = entity.x - ball.width 
        ball.dx = -1 * math.abs(ball.dx)
    elseif side == "right" then
        ball.x = entity.x + entity.width
        ball.dx = math.abs(ball.dx)
    end
end

local function testCollisionWithPad(ball, pad)
    local bx, by, bw, bh = ball:getViewport()
    local px, py, pw, ph = pad:getViewport()

    local ret, side = testCollision(ball, bx, by, bw, bh, px, py, pw, ph)
    if ret then
        if side == "top" then side = "bottom" end
        if side == "bottom" then
            ball.y = pad.y - ball.height
            local cos = ((ball.x + ball.width / 2) - pad.x) / pad.width
            if (cos < 0) then cos = 0 end
            if (cos > 1) then cos = 1 end
            cos = (cos - 0.5) * 3 / 2
            ball:hitPad(cos)
        else
            updateBallAfterColision(ball, side)
        end
    end
end

local function testCollisionWithBricks(ball, bricks, heavy)
    local bx, by, bw, bh = ball:getViewport()
    for i = #bricks, 1, -1 do
        local brx, bry, brw, brh = bricks[i]:getViewport()
        local ret, side = testCollision(ball, bx, by, bw, bh, brx, bry, brw, brh)
        if ret then
            if not heavy then
                updateBallAfterColision(ball, bricks[i], side)
            end
            return i
        end
    end
    return 0
end

local function testCollisionWithBorders(ball)
    if ball.x < 0 then
        updateBallAfterColision(ball, BallController.borderLeft, "right")
    end
    if ball.x > Constants.SCREEN_WIDTH - ball.width then
        updateBallAfterColision(ball, BallController.borderRight, "left")
    end
    if ball.y < 0 then
        updateBallAfterColision(ball, BallController.borderTop, "bottom")
    end
end

function BallController:testCollisions(ball)
    local bricks = self.screen.grid.bricks
    local metalBricks = self.screen.grid.indestructibleBricks
    local pad = self.screen.pad

    testCollisionWithPad(ball, pad)
    testCollisionWithBricks(ball, metalBricks, false)
    local brick = testCollisionWithBricks(ball, bricks, ball.heavy)
    if brick > 0 then
        self.game:hitBrick(brick)
    end
    testCollisionWithBorders(ball)
end

function BallController:update()
    local lostBalls = {}

    for k, ball in pairs(self.screen.balls.children) do
        self:testCollisions(ball)
        updateBallSpeed(ball)
        if not isInsideTheField(ball) then
            table.insert(lostBalls, k)
        end
    end

    for i, ball in pairs(lostBalls) do
        self.screen.balls:removeChild(ball)
    end
end

function BallController:start()
    local ballX = (Constants.SCREEN_WIDTH - (Constants.PAD_WIDTH * Constants.PAD_LENGTH)) / 2
    local ballY = Constants.SCREEN_HEIGHT - Constants.PAD_HEIGHT - Constants.PAD_MARGIN - Constants.BALL_MARGIN - Constants.BALL_RADIUS * 2
    local ballAngle = -math.pi / 4
    local ball = Ball:new(ballX, ballY, Constants.BALL_VELOCITY, ballAngle)
    self.screen.balls:addChild(ball)
end

function BallController:setBallPostion(position)
    local ball = self.screen.balls.children[1]
    ball.x = position - ball.width / 2
end

local function avoidHorizontalAngle(ball)
    local angle = ball:getAngle()
    local diff = angle

    while diff > math.pi do
        diff = diff - 2 * math.pi
    end
    while diff < -1 * math.pi do
        diff = diff + 2 * math.pi
    end

    if diff < math.pi * 0.1 and diff > math.pi * -0.1 then
        if diff >= 0 then
            angle = math.pi * 0.1
        else
            angle = math.pi * -0.1
        end
    elseif diff > math.pi * 0.9 or diff < math.pi * -0.9 then
        if diff >= 0 then
            angle = math.pi * 0.9
        else
            angle = math.pi * -0.9
        end
    end

    ball:setAngle(angle)
end

function BallController:splitBall()
    local ball = self.screen.balls.children[1]
    newBall = ball:copy()
    local angle = ball:getAngle()
    ball:setAngle(angle + math.pi / 8)
    newBall:setAngle(angle - math.pi / 8)
    self.screen.balls:addChild(newBall)
    avoidHorizontalAngle(ball)
    avoidHorizontalAngle(newBall)
end

function BallController:setAllBallsToSpeedSlow()
    for k, ball in pairs(self.screen.balls.children) do
        ball.hits = 0
        updateBallSpeed(ball)
    end
end

function BallController:setAllBallsToSpeedFast()
    for k, ball in pairs(self.screen.balls.children) do
        ball.hits = 1001
        updateBallSpeed(ball)
    end
end

function BallController:setAllBallsToHeavy()
    for k, ball in pairs(self.screen.balls.children) do
        ball.heavy = true
    end
end

function BallController:setAllBallsToLight()
    for k, ball in pairs(self.screen.balls.children) do
        ball.heavy = false
    end
end

return BallController
