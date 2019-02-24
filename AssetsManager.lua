
AssetsManager = {}

--- Scales and draws a sprite.
function AssetsManager.drawSprite(sprite, x, y, width, height)
    local sx, sy, sw, sh =  sprite.quad:getViewport()
    love.graphics.draw(sprite.image, sprite.quad, x, y, 0, width/sw, height/sh, 0, 0, 0, 0)
end

--- Loads a sprite list from a tileset.
-- @param filename Tileset image file.
-- @param datafile Lua file that contains the tileset map, each sprite must contain:
-- x (horizontal position), y (vertical position) , w (width) and h (height) fields.
function AssetsManager.loadSprites(filename, datafile)
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

return AssetsManager