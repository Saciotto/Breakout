local Controller = {
    paused = true,
    score = 0,
    ballSpeed = 1
}

function Controller:new(screen)
    local controller = {}
    setmetatable(controller, self)
    self.__index = self
    controller.screen = screen
    return controller
end

local function checkCollisionSide(ball, x1, y1, w1, h1, x2, y2, w2, h2)
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

local function checkCollision(ball, x1, y1, w1, h1, x2, y2, w2, h2)
    if (x1 < x2 + w2) and (x1 + w1 > x2) and (y1 < y2 + h2) and (y1 + h1 > y2) then
        return true, checkCollisionSide(ball, x1, y1, w1, h1, x2, y2, w2, h2)
    end
    return false
end

local function checkCollisionWithPad(ball, pad)
    local bx, by, bw, bh = ball:getViewport()
    local px, py, pw, ph = pad:getViewport()

    local ret, side = checkCollision(ball, bx, by, bw, bh, px, py, pw, ph)
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
            ball:hit(side)
        end
    end
end

local function ballHitsBrick(ball, brick, side)
    if side == "bottom" then
        ball.y = brick.y + brick.height
        ball.dy = math.abs(ball.dy)
    elseif side == "top" then
        ball.y = brick.y - ball.height 
        ball.dy = -1 * math.abs(ball.dy)
    elseif side == "left" then
        ball.x = brick.x - ball.width 
        ball.dx = -1 * math.abs(ball.dx)
    elseif side == "right" then
        ball.x = brick.x + brick.width
        ball.dx = math.abs(ball.dx)
    end
    ball.hits = ball.hits + 1
end

local function updateBallSpeed(ball)
    local ballSpeed
    if ball.hits > 20 then 
        ballSpeed = 2
    elseif ball.hits > 10 then 
        ballSpeed = 1.5
    else
        ballSpeed = 1
    end
    ball:setVelocity(Constants.BALL_VELOCITY * ballSpeed)
end

function Controller:checkCollisionWithBricks(ball, bricks)
    local bx, by, bw, bh = ball:getViewport()
    for i = #bricks, 1, -1 do
        local brx, bry, brw, brh = bricks[i]:getViewport()
        local ret, side = checkCollision(ball, bx, by, bw, bh, brx, bry, brw, brh)
        if ret then
            ballHitsBrick(ball, bricks[i], side)
            bricks[i]:hit()
            if bricks[i].isBroken then
                GameData.score = GameData.score  + bricks[i].value
                self.screen.grid:destroyBrick(i)
            end
            break
        end
    end
end

function Controller:gameOver()
    if GameData.lives > 1 then
        self.paused = true
        self:setBallToStartPostion()
        GameData.lives = GameData.lives - 1
        self:start()
    else
        Game.setScreen(GameOverScreen)
    end
end

function Controller:checkBallCollisions(ball)
    local bricks = self.screen.grid.bricks
    local metalBricks = self.screen.grid.indestructibleBricks
    local pad = self.screen.pad

    checkCollisionWithPad(ball, pad)
    self:checkCollisionWithBricks(ball, bricks)
    self:checkCollisionWithBricks(ball, metalBricks)

    if ball.x < 0 then
        ball.x = 0
        ball:hit("left")
    end
    if ball.x > Constants.SCREEN_WIDTH - ball.width then
        ball.x =  Constants.SCREEN_WIDTH - ball.width
        ball:hit("right")
    end
    if ball.y < 0 then
        ball.y = 0
        ball:hit("top")
    end
    if ball.y > Constants.SCREEN_HEIGHT then
        return false
    end
    return true
end

function Controller:checkCollisions()
    local ballsOut = {}
    for k, ball in pairs(self.screen.balls.children) do
        local live = self:checkBallCollisions(ball)
        if not live then
            table.insert(ballsOut, k)
        end
    end
    for i, ball in pairs(ballsOut) do
        self.screen.balls:removeChild(ball)
    end

    if #self.screen.balls.children == 0 then
        self:gameOver()
    end
end

function Controller:loadStage(nextStage)
    GameScreen.stage = nextStage
    Game.setScreen(GameScreen)
end

function Controller:checkObjective()
    local bricks = self.screen.grid.bricks
    if #bricks == 0 then
        if self.screen.stage < Constants.MAX_STAGES then
            self:loadStage(self.screen.stage + 1)
        else
            Game.setScreen(GameOverScreen)
        end
    end
end

function Controller:updateEntities(dt)
    local entities = self.screen.entities
    for k, entity in pairs(entities) do
        entity:update(dt)
    end
end

function Controller:setBallToStartPostion()
    for k, ball in pairs(self.screen.balls.children) do
        ball.hits = 0
        ball.x = (Constants.SCREEN_WIDTH - (Constants.PAD_WIDTH * Constants.PAD_LENGTH)) / 2
        ball.y = Constants.SCREEN_HEIGHT - Constants.PAD_HEIGHT - Constants.PAD_MARGIN - Constants.BALL_MARGIN - Constants.BALL_RADIUS * 2
        ball:setAngle(-math.pi / 4)
        updateBallSpeed(ball)
    end
end

function Controller:update(dt)
    if not self.paused then
        self:updateEntities(dt)
        self:checkCollisions()
        self:checkObjective()
    end
    self.screen.camera:update()
end

function Controller:start()
    local ballX = (Constants.SCREEN_WIDTH - (Constants.PAD_WIDTH * Constants.PAD_LENGTH)) / 2
    local ballY = Constants.SCREEN_HEIGHT - Constants.PAD_HEIGHT - Constants.PAD_MARGIN - Constants.BALL_MARGIN - Constants.BALL_RADIUS * 2
    local ballAngle = -math.pi / 4
    local ball = Ball:new(ballX, ballY, Constants.BALL_VELOCITY, ballAngle)
    self.screen.balls:addChild(ball)
end

return Controller
