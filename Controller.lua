
local Constants = require("Constants")

local Controller = {
    gameOver = false,
    winner = false,
    loser = false,
    paused = true
}

local function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    w = 0.5 * (w1 + w2)
    h = 0.5 * (h1 + h2)
    dx = (x1 + w1 / 2) - (x2 + w2 / 2)
    dy = (y1 + h1 / 2) - (y2 + h2 / 2)
    if math.abs(dx) <= w and math.abs(dy) <= h then
        wy = w * dy
        hx = h * dx
        if wy > hx then
            if wy > -hx then
                return true, "top"
            else
                return true, "right"
            end
        else
            if wy > -hx then
                return true, "left"
            else
                return true, "bottom"
            end
        end
    end

    return false
end

local function updateBall(self, screen, dt)
    screen.ball:update(dt)
    local bx, by, bw, bh = screen.ball:getViewport()
    local px, py, pw, ph = screen.pad:getViewport()

    if checkCollision(bx, by, bw, bh, px, py, pw, ph) then
        screen.ball.y = screen.pad.y - screen.ball.height
        local cos = ((screen.ball.x + screen.ball.width / 2) - screen.pad.x) / screen.pad.width
        if (cos < 0) then cos = 0 end
        if (cos > 1) then cos = 1 end
        cos = cos - 0.5
        screen.ball:hitPad(cos)
    end

    for i = #screen.bricks, 1, -1 do
        local brx, bry, brw, brh = screen.bricks[i]:getViewport()
        local ret, side = checkCollision(bx, by, bw, bh, brx, bry, brw, brh)
        if ret then
            screen.ball:hit(side)
            screen.bricks[i]:hit()
            if screen.bricks[i].isBroken then
                table.remove(screen.bricks, i)
            end
        end
    end
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
    if #self.screen.bricks == 0 then
        self.winner = true
        self.gameOver = true
    end
end

function Controller:mousemoved(x, y, dx, dy, istouch)
    local newX, newY = self.screen.camera:transform(x, y)
    self.screen.pad.x = newX - (self.screen.pad:getWidth() / 2)
end

function Controller:new(screen)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.screen = screen
    return o
end

function Controller:keypressed(key, unicode)
    self.paused = false
end

function Controller:mousepressed(x, y, button)
    self.paused = false
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
