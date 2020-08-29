local Button = Widget:new()

function Button:new(x, y, width, height, label)
    local button = Widget:new(nil, x, y, width, height)
    setmetatable(button, self)
    self.__index = self
    button.label = label
    button.clicked = false
    button.onClick = nil
    button.label:setArea(x, y, width, height)
    button.label:setAlign("center", "middle")
    return button
end

function Button:formatText(font, color, size)
    self.label:setFont(font, size)
    self.label.color = color
end

function Button:draw()
    Widget.draw(self)
    self.label:draw()
end

function Button:mousePressed(x, y, button)
    if self:isEventInsideWidget(x, y) then
        self.clicked = true
    end
end

function Button:mouseReleased(x, y, button)
    if self:isEventInsideWidget(x, y) and self.clicked then
        self:click(button)
    end
    self.clicked = false
end

function Button:mouseMoved(x, y, dx, dy)
    if not self:isEventInsideWidget(x, y) and self.clicked then
        self.clicked = false
    end
end

function Button:click(button)
    if self.onClick then self.onClick() end
end

return Button
