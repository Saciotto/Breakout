
assetsManager = {}

function assetsManager.drawSprite(sprite, x, y, width, height)
    local sx, sy, sw, sh =  sprite.quad:getViewport()
    love.graphics.draw(sprite.image, sprite.quad, x, y, width/sw, height/sh)
end

function assetsManager.loadSprites(filename, datafile)
    local sprites = {}
    local image = love.graphics.newImage(filename)
    local data = dofile(datafile)
    for name,tile in pairs(data) do
        sprites[name] = {}
        sprites[name].quad = love.graphics.newQuad(tile.x, tile.y, tile.w, tile.h, image:getDimensions())
        sprites[name].image = image
        sprites[name].name = name
    end
    return sprites
end

return assetsManager