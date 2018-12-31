
SCREEN_WIDTH  = 480
SCREEN_HEIGHT = 320

PAD_WIDTH = 60
PAD_HEIGHT = 10
PAD_MARGIN = 10
PAD_VELOCITY = 300

BLOCK_WIDTH = 24
BLOCK_HEIGHT = 20
NO_COLS = 20
NO_ROWS = 10

BALL_RADIUS = 5
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

ball = {
    x = (SCREEN_WIDTH) / 2 - BALL_RADIUS,
    y = SCREEN_HEIGHT - PAD_HEIGHT - PAD_MARGIN - BALL_MARGIN - BALL_RADIUS * 2,
    radius = BALL_RADIUS,
    velocity = { 
        x = BALL_VELOCITY, 
        y = BALL_VELOCITY 
    }
}

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
            block = {
                x = BLOCK_WIDTH * j,
                y = BLOCK_HEIGHT * i,
                width = BLOCK_WIDTH,
                height = BLOCK_HEIGHT,
                color = {math.random(), math.random(), math.random()}
            }
            table.insert(blocks, block)
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
    ball.x = ball.x + ball.velocity.x * dt
    ball.y = ball.y + ball.velocity.y * dt

    if checkCollision(ball.x, ball.y, ball.radius * 2, ball.radius * 2, 
                     pad.x, pad.y, pad.width, pad.height) then
        ball.y = pad.y - ball.radius * 2
        ball.velocity.y = -1 * math.abs(ball.velocity.y)
        newVelocity = ball.x - pad.x
        if newVelocity > pad.width then newVelocity = pad.width end
        if newVelocity < 0 then newVelocity = 0 end
        newVelocity = (newVelocity - pad.width/2) * 2 / pad.width
        ball.velocity.x = newVelocity * BALL_VELOCITY
    end

    for i = #blocks, 1, -1 do
        ret, side =  checkCollision(blocks[i].x, blocks[i].y, blocks[i].width, blocks[i].height,ball.x, ball.y, ball.radius * 2, ball.radius * 2)
        if ret then
            table.remove(blocks, i)
            if side == "bottom" then
                ball.velocity.y = math.abs(ball.velocity.y)
            elseif side == "top" then
                ball.velocity.y = -1 * math.abs(ball.velocity.y)
            elseif side == "right" then
                ball.velocity.x = math.abs(ball.velocity.x)
            else
                ball.velocity.x = -1 * math.abs(ball.velocity.x)
            end
        end
    end

    if ball.x < 0 then
        ball.x = 0
        ball.velocity.x = -ball.velocity.x
    end
    if ball.x > SCREEN_WIDTH - ball.radius * 2 then
        ball.x =  SCREEN_WIDTH - ball.radius * 2
        ball.velocity.x = -ball.velocity.x
    end

    if ball.y < 0 then
        ball.y = 0
        ball.velocity.y = -ball.velocity.y
    end
    if ball.y > SCREEN_HEIGHT - ball.radius * 2 then
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
        love.graphics.setColor(block.color)
        love.graphics.rectangle("fill", block.x, block.y, block.width, block.height)
    end
    love.graphics.setColor(255,255,255)

    love.graphics.circle("fill", ball.x + ball.radius, ball.y + ball.radius, ball.radius)

    if winner then
        love.graphics.print("Vencedor")    
    end

    if loser then
        love.graphics.print("Perdedor")
    end
end
