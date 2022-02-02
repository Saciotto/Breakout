local Drawable = {}

function Drawable:new()
    local drawable = {}
    setmetatable(drawable, self)
    self.__index = self
    drawable.color = Colors.WHITE
    return drawable
end

function Drawable:update(dt)
end

function Drawable:draw(x, y, width, height)
    Renderer.drawRect(x, y, width, height, self.color)
end

return Drawable
