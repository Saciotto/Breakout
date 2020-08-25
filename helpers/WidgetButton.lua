local Widget = require("helpers.Widget")

local WidgetButton = Widget:new()

function WidgetButton:new(x, y, width, height, text)
    local o = Widget:new(nil, x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.text = text or ""
    o.clicked = false
    o.onClick = nil
    return o
end

function WidgetButton:draw()
    Widget.draw(self)
    coloredText = {
        {0,0,0},
        self.text
    }
    love.graphics.print(coloredText, self.x, self.y)
end

function WidgetButton:mousePressed(x, y, button)
    if self:isEventInsideWidget(x, y) then
        self.clicked = true
    end
end

function WidgetButton:mouseReleased(x, y, button)
    if self:isEventInsideWidget(x, y) and self.clicked then
        self:click(button)
    end
    self.clicked = false
end

function WidgetButton:mouseMoved(x, y, dx, dy)
    if not self:isEventInsideWidget(x, y) and self.clicked then
        self.clicked = false
    end
end

function WidgetButton:click(button)
    if self.onClick then self.onClick() end
end

return WidgetButton
