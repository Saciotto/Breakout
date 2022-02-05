local Window = Widget:new()

function Window:new(x, y, width, height)
    local window = Widget:new(nil, x, y, width, height)
    setmetatable(window, self)
    self.__index = self
    window.children = {}
    return window
end

function Widget:update(dt)
    for k, child in pairs(self.children) do
        child:update(dt)
    end
end

function Window:draw()
    local border = 10
    Graphics.setColor(Colors.YELLOW_DARK)
    Graphics.rectangle("fill", self.x, self.y, self.width, self.height, 10, 10)
    Graphics.setColor( Colors.YELLOW_LIGHT)
    Graphics.rectangle("fill", self.x + border, self.y + border, self.width - 2 *border, self.height - 2* border, 10, 10)
    Graphics.setColor(Colors.WHITE)

    for k, child in pairs(self.children) do
        child.x = child.originalX + self.x
        child.y = child.originalY + self.y
        Graphics.setScissor(self.x, self.y, self.width, self.height)
        child:draw()
        Graphics.setScissor()
    end
end

function Window:addChild(child)
    child.originalX = child.x
    child.originalY = child.y
    table.insert(self.children, child)
end

function Window:removeChild(idx)
    table.remove(self.children, idx)
end

return Window
