local Sprite = Drawable:new()

function Sprite:new(x, y, width, height, image)
    local sprite = Drawable:new()
    setmetatable(sprite, self)
    self.__index = self
    sprite.quad = Graphics.newQuad(x, y, width, height, image:getDimensions())
    sprite.image = image
    return sprite
end

function Sprite:draw(x, y, width, height)
    Renderer.drawSprite(self, Colors.RED, x, y, width, height)
end

return Sprite
