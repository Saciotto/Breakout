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
    self.alignX = alignX or "left"
    self.alignY = alignY or "middle"
    return label
end

function Label:setFont(font, size)
    size = size or Label.defualtSize
    self.font = love.graphics.newFont(font, size)
end

function Label:setAlign(alignX, alignY)
    self.alignX = alignX
    self.alignY = alignY
end

function Label:drawLimitedXY(coloredText)

    local drawableText = love.graphics.newText(self.font)
    drawableText:setf(coloredText, self.width, self.alignX)

    local y
    if self.alignY == "middle" then
        y =  self.y + (self.height - drawableText:getHeight()) / 2
    elseif self.alignY == "bottom" then
        y =  self.y + (self.height - drawableText:getHeight())
    else
        y = self.y
    end
    
    --love.graphics.setScissor(self.x, self.y, self.width, self.height)
    love.graphics.printf(coloredText, self.x, y, self.width, self.alignX)
    --love.graphics.setScissor()
end

function Label:drawLimitedX(coloredText)
    love.graphics.printf(coloredText, self.x, self.y, self.width, self.alignX)
end

function Label:drawUnlimited(coloredText)
    love.graphics.print(coloredText, self.x, self.y)
end

function Label:draw()
    if self.font == nil then
        return
    end

    local coloredText = {
        self.color,
        self.text
    }
    love.graphics.setFont(self.font)

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
