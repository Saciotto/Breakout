local Renderer = {}

function Renderer.beginDrawing(camera)
    camera:set()
    Graphics.setBackgroundColor(Colors.BLACK)
end

function Renderer.endDrawing(camera)
    camera:unset()
end

function Renderer.drawRect(x, y, width, height, color)
    Graphics.setColor(color)
    Graphics.rectangle("fill", x, y, width, height)
end

--- Scales and draws a image.
function Renderer.drawImage(image, x, y, width, height)
    if image == nil then
        Renderer.drawRect(x, y, width, height, Colors.BLUE)
        return
    end
    iw, ih = image:getDimensions()
    width = width or sw
    height =  height or sh
    Graphics.setColor(1, 1, 1)
    Graphics.draw(image, x, y, 0, width/iw, height/ih)
end

--- Scales and draws a sprite.
function Renderer.drawSprite(sprite, debugColor, x, y, width, height)
    if sprite == nil then 
        debugColor = debugColor or Colors.RED
        Renderer.drawRect(x, y, width, height, debugColor)
        return
    end
    local sx, sy, sw, sh = sprite.quad:getViewport()
    width = width or sw
    height =  height or sh
    Graphics.setColor(1, 1, 1)
    Graphics.draw(sprite.image, sprite.quad, x, y, 0, width/sw, height/sh)
end

return Renderer