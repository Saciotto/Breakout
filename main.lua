
require "brick"
require "ball"

SCREEN_WIDTH  = 480
SCREEN_HEIGHT = 320

PAD_WIDTH = 60
PAD_HEIGHT = 10
PAD_MARGIN = 10
PAD_VELOCITY = 300

NO_COLS = 20
NO_ROWS = 10

BALL_MARGIN = 5
BALL_VELOCITY = 100

pad = {
    x = (SCREEN_WIDTH - PAD_WIDTH) / 2,
    y = SCREEN_HEIGHT - PAD_HEIGHT - PAD_MARGIN,
    width = PAD_WIDTH,
    height = PAD_HEIGHT,
    velocity = PAD_VELOCITY
}

blocks = {}

gameOver = false

function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
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

function createBlocks()
    for i = 2, NO_ROWS - 3, 1 do
        for j = 2, NO_COLS - 3, 1 do
            brick = Brick:new{
                x = BLOCK_WIDTH * j,
                y = BLOCK_HEIGHT * i
            }
            table.insert(blocks, brick)
        end
    end
end

function updatePad(dt)
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        pad.x = pad.x - (dt * pad.velocity)
    end
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        pad.x = pad.x + (dt * pad.velocity)
    end

    if pad.x < 0 then
        pad.x = 0 
    end
    if pad.x > SCREEN_WIDTH - pad.width then
        pad.x = SCREEN_WIDTH - pad.width
    end
end

function updateBall(dt)

    ball:update(dt)

    if checkCollision(ball.x, ball.y, ball.width, ball.height, 
                      pad.x, pad.y, pad.width, pad.height) then
        ball.y = pad.y - ball.height
        local cos = ((ball.x + ball.width / 2) - pad.x) / pad.width
        if (cos < 0) then cos = 0 end
        if (cos > 1) then cos = 1 end
        cos = cos - 0.5
        ball:hitPad(cos)
    end

    for i = #blocks, 1, -1 do
        ret, side =  checkCollision(ball.x, ball.y, ball.width, ball.height, blocks[i].x, blocks[i].y, blocks[i].width, blocks[i].height)
        if ret then
            ball:hit(side)
            blocks[i]:hit()
            if blocks[i].isBroken then
                table.remove(blocks, i)
            end
        end
    end

    if ball.x < 0 then
        ball.x = 0
        ball:hit("left")
    end
    if ball.x > SCREEN_WIDTH - ball.width then
        ball.x =  SCREEN_WIDTH - ball.width
        ball:hit("right")
    end

    if ball.y < 0 then
        ball.y = 0
        ball:hit("top")
    end
    if ball.y > SCREEN_HEIGHT - ball.height then
        loser = true
        gameOver = true
    end

end

function checkObjective()
    if #blocks == 0 then
        winner = true
        gameOver = true
    end
end

function love.load()
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, {resizable = false})
    love.window.setTitle("Breakout")
    createBlocks()

    local ballX = (SCREEN_WIDTH - PAD_WIDTH) / 2
    local ballY = SCREEN_HEIGHT - PAD_HEIGHT - PAD_MARGIN - BALL_MARGIN - BALL_RADIUS * 2
    ball = Ball:new(nil, ballX, ballY, BALL_VELOCITY)
end

function love.update(dt)

    if not gameOver then
        updatePad(dt)
        updateBall(dt)
        checkObjective()
    end
end

function love.draw()
    love.graphics.rectangle("fill", pad.x, pad.y, pad.width, pad.height)

    for k,block in pairs(blocks) do
        block:draw()
    end
    love.graphics.setColor(255,255,255)

    ball:draw()

    if winner then
        love.graphics.print("Vencedor")    
    end

    if loser then
        love.graphics.print("Perdedor")
    end
end
