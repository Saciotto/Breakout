local Controller = {
    gameOver = false,
    winner = false,
    loser = false,
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

local function checkCollisionWithPad(screen)
    local bx, by, bw, bh = screen.ball:getViewport()
    local px, py, pw, ph = screen.pad:getViewport()

    local ret, side = checkCollision(screen.ball, bx, by, bw, bh, px, py, pw, ph)
    if ret then
        if side == "top" then side = "bottom" end
        if side == "bottom" then
            screen.ball.y = screen.pad.y - screen.ball.height
            local cos = ((screen.ball.x + screen.ball.width / 2) - screen.pad.x) / screen.pad.width
            if (cos < 0) then cos = 0 end
            if (cos > 1) then cos = 1 end
            cos = cos - 0.5
            screen.ball:hitPad(cos)
        else
            screen.ball:hit(side)
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

local function checkCollisionWithBricks(self, screen, bricks)
    local bx, by, bw, bh = screen.ball:getViewport()

    for i = #bricks, 1, -1 do
        local brx, bry, brw, brh = bricks[i]:getViewport()
        local ret, side = checkCollision(screen.ball, bx, by, bw, bh, brx, bry, brw, brh)
        if ret then
            ballHitsBrick(screen.ball, bricks[i], side)
            bricks[i]:hit()
            if bricks[i].isBroken then
                self.score = self.score + bricks[i].value
                screen.grid:destroyBrick(i)
            end
            break
        end
    end
end

local function updateBall(self, screen, dt)
    screen.ball:update(dt)
    
    checkCollisionWithPad(screen)
    checkCollisionWithBricks(self, screen, screen.grid.bricks)
    checkCollisionWithBricks(self, screen, screen.grid.indestructibleBricks)

    if screen.ball.x < 0 then
        screen.ball.x = 0
        screen.ball:hit("left")
    end
    if screen.ball.x > Constants.SCREEN_WIDTH - screen.ball.width then
        screen.ball.x =  Constants.SCREEN_WIDTH - screen.ball.width
        screen.ball:hit("right")
    end
    if screen.ball.y < 0 then
        screen.ball.y = 0
        screen.ball:hit("top")
    end
    if screen.ball.y > Constants.SCREEN_HEIGHT - screen.ball.height then
        self.loser = true
        self.gameOver = true
    end
end

local function checkObjective(self)
    if #self.screen.grid.bricks == 0 then
        self.winner = true
        self.gameOver = true
    end
end

function Controller:mouseMoved(x, y, dx, dy)
    self.screen.pad.x = x - (self.screen.pad:getWidth() / 2)
end

function Controller:new(screen)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.screen = screen
    return o
end

function Controller:keyPressed(key, unicode)
    self.paused = false
end

function Controller:mousePressed(x, y, button)
    self.paused = false
    if self.winner or self.gameOver then
        Game.setScreen(StageSelect)
    end
end

function Controller:update(dt)
    if not self.gameOver and not self.paused then
        self.screen.pad:update(dt)
        updateBall(self, self.screen, dt)
        checkObjective(self)
    else
        self.screen.pad:update(dt)
    end
    self.screen.camera:update()
end

return Controller
