
package.path = package.path .. ";xml2lua/?.lua"

require "Constants"
require "entities/Brick"
require "entities/Ball"
require "entities/Pad"
require "Camera"

AssetsManager = require "AssetsManager"
Renderer = require "Renderer"

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
    for i = 2, Constants.NO_ROWS - 3, 1 do
        for j = 2, Constants.NO_COLS - 3, 1 do
            brick = Brick:new(nil, Constants.BRICK_WIDTH * j, Constants.BRICK_HEIGHT * i, nil, nil, sprites.BrickLightGreen)
            table.insert(blocks, brick)
        end
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
    if ball.x > Constants.SCREEN_WIDTH - ball.width then
        ball.x =  Constants.SCREEN_WIDTH - ball.width
        ball:hit("right")
    end

    if ball.y < 0 then
        ball.y = 0
        ball:hit("top")
    end
    if ball.y > Constants.SCREEN_HEIGHT - ball.height then
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

    sprites = AssetsManager.loadSprites("assets/breakout.png", "assets/breakout.xml")

    love.window.setMode(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT, {resizable = true})
    love.window.setTitle("Breakout")
    createBlocks()

    local ballX = (Constants.SCREEN_WIDTH - Constants.PAD_WIDTH) / 2
    local ballY = Constants.SCREEN_HEIGHT - Constants.PAD_HEIGHT - Constants.PAD_MARGIN - Constants.BALL_MARGIN - Constants.BALL_RADIUS * 2
    ball = Ball:new(nil, ballX, ballY, BALL_VELOCITY, sprites.Ball)
    
    pad = Pad:new(nil, nil, nil, nil, nil, sprites.Pad)

    camera = Camera:new(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT, "FULL_SCREEN_KEEP_ORIGINAL_ASPECT")

    
end

function love.update(dt)
    if not gameOver then
        pad:update(dt)
        updateBall(dt)
        checkObjective()
    end
    camera:update()
end

function love.draw()
    Renderer.draw()
end
