local xml2lua = require("xml2lua.xml2lua")
local handler = require("xml2lua.xmlhandler.tree")

local Sprite = require("helpers.Sprite")

local AssetsManager = {}

--- Loads a sprite list from a tileset.
-- @param atlas XML file that contains the tileset map
function AssetsManager.loadSprites(atlas)
    local sprites = {}
    local xml = xml2lua.loadFile(atlas)
    local parser = xml2lua.parser(handler)
    parser:parse(xml)
    local imagePath = atlas:match(".+/") .. handler.root.TextureAtlas._attr.imagePath
    local image = love.graphics.newImage(imagePath)
    for i, xmlSprite in pairs(handler.root.TextureAtlas.sprite) do
        local name = xmlSprite._attr.n and xmlSprite._attr.n:match("(.+)%..+")
        if (name ~= nil) then
            sprites[name] = Sprite:new(xmlSprite._attr.x, xmlSprite._attr.y, xmlSprite._attr.w, xmlSprite._attr.h, image)
        end
    end
    return sprites
end

return AssetsManager