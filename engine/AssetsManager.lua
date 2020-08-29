local xml2lua = require("engine.xml2lua.xml2lua")

local AssetsManager = {}

--- Loads a sprite list from a tileset.
-- @param atlas XML file that contains the tileset map
function AssetsManager.loadSprites(atlas)
    local sprites = {}
    local xml = xml2lua.loadFile(atlas)
    local handler = require("engine.xml2lua.xmlhandler.tree")
    handler.options.noreduce.sprite = true
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

--- Loads a animations list from xml.
-- @param atlas XML file that contains the animation map
function AssetsManager.loadAnimations(atlas, spriteBatch)
    local animations = {}
    local xml = xml2lua.loadFile(atlas)
    local handler = require("engine.xml2lua.xmlhandler.tree")
    handler.options.noreduce.animation = true
    handler.options.noreduce.frame = true
    local parser = xml2lua.parser(handler)
    parser:parse(xml)
    if (handler.root.AnimationAtlas.animation ~= nil) then 
        for i, xmlAnimation in pairs(handler.root.AnimationAtlas.animation) do
            local name = xmlAnimation._attr.n
            if (name ~= nil) then
                local frames = {}
                for idx, xmlFrame in pairs(xmlAnimation.frame) do
                    frames[idx] = {}
                    frames[idx].sprite = spriteBatch[xmlFrame._attr.s]
                    frames[idx].duration = tonumber(xmlFrame._attr.d)
                end
                animations[name] = Animation:new(frames)
            end
        end
    end
    return animations
end

return AssetsManager