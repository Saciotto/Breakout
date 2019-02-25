
local xml2lua = require("xml2lua")
local handler = require("xmlhandler.tree")

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
    local xml = xml2lua.loadFile(datafile)
    local parser = xml2lua.parser(handler)
    parser:parse(xml)
    for i, xmlSprite in pairs(handler.root.TextureAtlas.sprite) do
        local name = xmlSprite._attr.n:match("(.+)%..+")
        if (name ~= nil) then
            sprites[name] = {}
            sprites[name].quad = love.graphics.newQuad(xmlSprite._attr.x, xmlSprite._attr.y, xmlSprite._attr.w, xmlSprite._attr.h, image:getDimensions())
            sprites[name].image = image
        end
    end
    return sprites
end

return AssetsManager