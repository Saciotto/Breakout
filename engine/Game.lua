local Game = {
    screen = nil,
    fps = 0
}

function Game.setScreen(screen, config)
    Game.screen = screen:new(config)
end

function Game.load(screen)
    Game.setScreen(screen)
end

function Game.update(dt)
    Game.fps = FramesCounter.getFPS(dt)
    Game.screen:update(dt)
end

function Game.draw()
    Game.screen:draw()
end

return Game