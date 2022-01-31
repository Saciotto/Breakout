local GameInputProcessor = InputProcessor:new()

function GameInputProcessor:new(screen)
    local processor = InputProcessor:new()
    setmetatable(processor, self)
    self.__index = self
    processor.screen = screen
    return processor
end

function GameInputProcessor:keyPressed(key, unicode)
    local game = self.screen.controller
    if key ~= 'a' and key ~= 'left' and key ~= 'd' and key ~= 'right' then
        game.paused = false
    end
    if key == 's' then
        game.ballController:splitBall()
    end
end

function GameInputProcessor:mousePressed(x, y, button)
    local game = self.screen.controller
    game.paused = false
end

return GameInputProcessor
