local InputProcessor = {}

function InputProcessor:new()
    local input = {}
    setmetatable(input, self)
    self.__index = self
    return input
end

function InputProcessor:keyPressed(key, unicode)
end

function InputProcessor:mouseMoved(x, y, dx, dy)
end

function InputProcessor:mousePressed(x, y, button)
end

function InputProcessor:mouseReleased(x, y, button)
end

return InputProcessor
