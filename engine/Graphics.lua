local Graphics = {
    dx = 0,
    dy = 0,
    sx = 1,
    sy = 1,
    scissorX = 0,
    scissorY = 0,
    scissorWidth = 0,
    scissorHeight = 0,
}

local function transform(x, y)
    local newX = x * Graphics.sx + Graphics.dx
    local newY = y * Graphics.sy + Graphics.dy
    return newX, newY
end

function Graphics.setScissor(x, y, width, height)
    if x == nil then 
        love.graphics.setScissor(Graphics.scissorX, Graphics.scissorY, Graphics.scissorWidth, Graphics.scissorHeight)
    else
        local newX, newY = transform(x, y)
        local newWidth = width * Graphics.sx
        local newHeight = height * Graphics.sy
        love.graphics.setScissor(newX, newY, newWidth, newHeight)
    end
end

function Graphics.setViewportScissor(x, y, width, height)
    Graphics.scissorX, Graphics.scissorY = transform(x, y)
    Graphics.scissorWidth = width * Graphics.sx
    Graphics.scissorHeight = height * Graphics.sy
    love.graphics.setScissor(Graphics.scissorX, Graphics.scissorY, Graphics.scissorWidth, Graphics.scissorHeight)
end

function Graphics.translate(dx, dy)
    Graphics.dx = dx
    Graphics.dy = dy
    love.graphics.translate(dx, dy)
end

function Graphics.scale(sx, sy)
    Graphics.sx = sx
    Graphics.sy = sy
    love.graphics.scale(sx, sy)
end

Graphics.push = love.graphics.push
Graphics.pop = love.graphics.pop
Graphics.newImage = love.graphics.newImage
Graphics.draw = love.graphics.draw
Graphics.getDimensions = love.graphics.getDimensions
Graphics.setColor = love.graphics.setColor
Graphics.rectangle = love.graphics.rectangle
Graphics.setBackgroundColor = love.graphics.setBackgroundColor
Graphics.newQuad = love.graphics.newQuad
Graphics.newFont = love.graphics.newFont
Graphics.newText = love.graphics.newText
Graphics.printf = love.graphics.printf
Graphics.print = love.graphics.print
Graphics.setFont = love.graphics.setFont

return Graphics
