local Entity = require("engine.Entity")

local Widget = Entity:new()

function Widget:new(o, x, y, width, height)
    local o = o or  {}
    o = Entity:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    return o
end

function Widget:isEventInsideWidget(x, y)
    local x1 = self.x
    local x2 = self.x + self.width
    local y1 = self.y
    local y2 = self.y + self.height
    if x >= x1 and y >= y1 and x <= x2 and y <= y2 then return true end
    return false
end

function Widget:update(dt)
end

function Widget:keyPressed(key, unicode)
end

function Widget:mouseMoved(x, y, dx, dy)
end

function Widget:mousePressed(x, y, button)
end

function Widget:mouseReleased(x, y, button)
end

return Widget