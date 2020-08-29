local Drawable = {}

function Drawable:new()
    local drawable = {}
    setmetatable(drawable, self)
    self.__index = self
    return drawable
end

function Drawable:update(dt)
end

function Drawable:draw(x, y, width, height)
    engine.Renderer.drawRect(x, y, width, height, engine.Colors.WHITE)
end

return Drawable
