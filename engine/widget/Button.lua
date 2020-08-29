local Button = Widget:new()
Button.defualtSpriteUp = nil
Button.defualtSpriteDown = nil

function Button:new(x, y, width, height, label)
    local button = Widget:new(nil, x, y, width, height)
    setmetatable(button, self)
    self.__index = self
    button.label = label or ""
    if type(button.label) == "string" then
        button.label = Label:new(button.label)
    end
    button.clicked = false
    button.onClick = nil
    button.label:setArea(x, y, width, height)
    button.label:setAlign("center", "middle")
    button.spriteUp = Button.defualtSpriteUp
    button.spriteDown = Button.defualtSpriteDown
    button.drawable = button.spriteUp
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
        self.drawable = self.spriteDown
    end
end

function Button:mouseReleased(x, y, button)
    if self:isEventInsideWidget(x, y) and self.clicked then
        self:click(button)
    end
    self.clicked = false
    self.drawable = self.spriteUp
end

function Button:mouseMoved(x, y, dx, dy)
    if not self:isEventInsideWidget(x, y) and self.clicked then
        self.clicked = false
        self.drawable = self.spriteUp
    end
end

function Button:click(button)
end

function Button:setSprites(up, down)
    self.spriteUp = up
    self.spriteDown = down
end

function Button.setDefualtSprites(up, down)
    Button.defualtSpriteUp = up
    Button.defualtSpriteDown = down
end

return Button
