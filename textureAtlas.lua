
textureAtlas = {}

function textureAtlas.load(filename, datafile)
    local o = {}
    o.image = love.graphics.newImage(filename)
    o.quads = {}
    local data = dofile(datafile)
    for name,tile in pairs(data) do
        o.quads[name] = love.graphics.newQuad(tile.x, tile.y, tile.w, tile.h, o.image:getDimensions())
    end
    return o
end

return textureAtlas
