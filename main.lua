
SCREEN_WIDTH  = 480
SCREEH_HEIGHT = 320
PAD_WIDTH = 60
PAD_HEIGHT = 10
PAD_MARGIN = 10
PAD_VELOCITY = 300

BLOCK_WIDTH = 24
BLOCK_HEIGHT = 10
NO_COLS = 20
NO_ROWS = 10
pad = {
    x = (SCREEN_WIDTH - PAD_WIDTH) / 2,
    y = SCREEH_HEIGHT - PAD_HEIGHT - PAD_MARGIN,
    width = PAD_WIDTH,
    height = PAD_HEIGHT,
    velocity = PAD_VELOCITY
}

blocks = {}


function createBlocks()
    for i = 0, NO_ROWS - 1, 1 do
        for j = 0, NO_COLS - 1, 1 do
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

function love.load()
    love.window.setMode(SCREEN_WIDTH, SCREEH_HEIGHT, {resizable = false})
    love.window.setTitle("Breakout")
    createBlocks()
end

function love.update(dt)
    updatePad(dt)
end

function love.draw()

    love.graphics.setColor(255,0,0)
    love.graphics.rectangle("fill", pad.x, pad.y, pad.width, pad.height)

    for k,block in pairs(blocks) do
        love.graphics.setColor(block.color)
        love.graphics.rectangle("fill", block.x, block.y, block.width, block.height)
    end
    love.graphics.setColor(255,255,255)
end
