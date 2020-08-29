local Window = Widget:new()

function Window:new(x, y, width, height)
    local window = Widget:new(nil, x, y, width, height)
    setmetatable(window, self)
    self.__index = self
    return window
end

function Window:draw()
    local border = 10
    love.graphics.setColor(Colors.YELLOW_DARK)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 10, 10)
    love.graphics.setColor( Colors.YELLOW_LIGHT)
    love.graphics.rectangle("fill", self.x + border, self.y + border, self.width - 2 *border, self.height - 2* border, 10, 10)
end

return Window
