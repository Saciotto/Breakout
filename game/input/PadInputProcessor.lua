local PadInputProcessor = InputProcessor:new()

function PadInputProcessor:new(screen)
    local processor = InputProcessor:new()
    setmetatable(processor, self)
    self.__index = self
    processor.screen = screen
    return processor
end

function PadInputProcessor:mouseMoved(x, y, dx, dy)
    local pad = self.screen.pad
    pad.x = x - (pad:getWidth() / 2)
end

function PadInputProcessor:update(dt)
    local pad = self.screen.pad
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        pad.x = pad.x - (dt * pad.velocity)
    end
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        pad.x = pad.x + (dt * pad.velocity)
    end
    if pad.x < 0 then
        pad.x = 0 
    end
    if pad.x > Constants.SCREEN_WIDTH - pad.width then
        pad.x = Constants.SCREEN_WIDTH - pad.width
    end
end

return PadInputProcessor
