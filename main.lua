
SCREEN_WIDTH  = 480
SCREEH_HEIGHT = 320
PAD_WIDTH = 50
PAD_HEIGHT = 10
PAD_MARGIN = 10
PAD_VELOCITY = 300

pad = {
    x = (SCREEN_WIDTH - PAD_WIDTH) / 2,
    y = SCREEH_HEIGHT - PAD_HEIGHT - PAD_MARGIN,
    width = PAD_WIDTH,
    height = PAD_HEIGHT,
    velocity = PAD_VELOCITY
}

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
end

function love.update(dt)
    updatePad(dt)
end

function love.draw()
    love.graphics.rectangle("fill", pad.x, pad.y, pad.width, pad.height)
end
