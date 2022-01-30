local Controller = {
    gameOver = false,
    winner = false,
    paused = true,
    score = 0,
}

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

function ballHitsBrick(ball, brick, side)
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
end

local function checkCollisionWithBricks(controller, ball, bricks)
    local bx, by, bw, bh = ball:getViewport()

    for i = #bricks, 1, -1 do
        local brx, bry, brw, brh = bricks[i]:getViewport()
        local ret, side = checkCollision(ball, bx, by, bw, bh, brx, bry, brw, brh)
        if ret then
            ballHitsBrick(ball, bricks[i], side)
            bricks[i]:hit()
            if bricks[i].isBroken then
                GameData.score = GameData.score  + bricks[i].value
                controller.screen.grid:destroyBrick(i)
            end
            break
        end
    end
end

local function checkCollisions(controller)
    local ball = controller.screen.ball
    local bricks = controller.screen.grid.bricks
    local metalBricks = controller.screen.grid.indestructibleBricks
    local pad = controller.screen.pad

    checkCollisionWithPad(ball, pad)
    checkCollisionWithBricks(controller, ball, bricks)
    checkCollisionWithBricks(controller, ball, metalBricks)

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
    if ball.y > Constants.SCREEN_HEIGHT - ball.height then
        if GameData.lives > 1 then
            controller.paused = true
            controller:setBallToStartPostion()
        else
            controller.gameOver = true
            Game.setScreen(GameOverScreen)
        end
        GameData.lives = GameData.lives - 1
    end
end

local function loadStage(nextStage)
    GameScreen.stage = nextStage
    Game.setScreen(GameScreen)
end

local function checkObjective(self)
    if #self.screen.grid.bricks == 0 then
        self.winner = true
        if self.screen.stage < Constants.MAX_STAGES then
            loadStage(self.screen.stage + 1)
        else
            Game.setScreen(GameOverScreen)
        end
    end
end

local function updateEntities(dt, entities)
    for k, entity in pairs(entities) do
        entity:update(dt)
    end
end

function Controller:setBallToStartPostion()
    self.screen.ball.x = (Constants.SCREEN_WIDTH - (Constants.PAD_WIDTH * Constants.PAD_LENGTH)) / 2
    self.screen.ball.y = Constants.SCREEN_HEIGHT - Constants.PAD_HEIGHT - Constants.PAD_MARGIN - Constants.BALL_MARGIN - Constants.BALL_RADIUS * 2
    self.screen.ball:setVelocity(Constants.BALL_VELOCITY)
end

function Controller:new(screen)
    local controller = {}
    setmetatable(controller, self)
    self.__index = self
    controller.screen = screen
    return controller
end

function Controller:update(dt)
    if not self.gameOver and not self.paused then
        updateEntities(dt, self.screen.entities)
        checkCollisions(self, self.screen, dt)
        checkObjective(self)
    end
    self.screen.camera:update()
end

return Controller
