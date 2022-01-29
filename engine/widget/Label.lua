local Label = Widget:new()

Label.defaultFont = nil
Label.defualtSize = 20

function Label:new(text, color, font, size, x, y, width, height, alignX, alignY)
    width = width or 0
    height = height or 0
    local label = Widget:new(nil, x, y, width, height)
    setmetatable(label, self)
    self.__index = self
    label.text = text or ""
    label.color = color or Colors.BLACK
    label.font = font or Label.defaultFont
    label.size = size or Label.defualtSize
    if label.font ~= nil then
        label:setFont(label.font, label.size)
    end
    label.alignX = alignX or "left"
    label.alignY = alignY or "middle"
    return label
end

function Label:setFont(font, size)
    size = size or Label.defualtSize
    self.font = Graphics.newFont(font, size)
end

function Label:setAlign(alignX, alignY)
    self.alignX = alignX
    self.alignY = alignY
end

function Label:drawLimitedXY(coloredText)

    local drawableText = Graphics.newText(self.font)
    drawableText:setf(coloredText, self.width, self.alignX)

    local y
    if self.alignY == "middle" then
        y =  self.y + (self.height - drawableText:getHeight()) / 2
    elseif self.alignY == "bottom" then
        y =  self.y + (self.height - drawableText:getHeight())
    else
        y = self.y
    end
    
    Graphics.setScissor(self.x, self.y, self.width, self.height)
    Graphics.draw(drawableText, self.x, y)
    Graphics.setScissor()
end

function Label:drawLimitedX(coloredText)
    Graphics.printf(coloredText, self.x, self.y, self.width, self.alignX)
end

function Label:drawUnlimited(coloredText)
    Graphics.print(coloredText, self.x, self.y)
end

function Label:draw()
    if self.font == nil then
        return
    end

    Graphics.setColor(Colors.WHITE)

    local coloredText = {
        self.color,
        self.text
    }
    Graphics.setFont(self.font)

    if self.width and self.width > 0 and self.height and self.height > 0 then
        self:drawLimitedXY(coloredText)
    elseif self.width and self.width > 0 then
        self:drawLimitedX(coloredText)
    else
        self:drawUnlimited(coloredText)
    end
end

function Label.setDefaultFont(font, size)
    Label.defaultFont = font
    Label.defualtSize = size
end

return Label
