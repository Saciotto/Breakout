local Screen = {}

function Screen:new(o, width, height)
    local o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.background = love.graphics.newImage("assets/images/GreenCardboard.png")
    o.width = width or DefaultViewport.WIDTH
    o.height = height or DefaultViewport.HEIGHT
    o.camera = Camera:new(o.width, o.height, "FULL_SCREEN_KEEP_ORIGINAL_ASPECT")
    o.entities = {}
    o.widgets = {}
    return o
end

function Screen:update(dt)
    for k, widget in pairs(self.widgets) do
        widget:update(dt)
    end
end

function Screen.drawSpriteBatch(spriteBatch)
    for k, sprite in pairs(spriteBatch) do
        sprite:draw()
    end
end

function Screen:draw()
    self.camera:update()
    Renderer.beginDrawing(self.camera)
    Renderer.drawImage(self.background, 0, 0, self.width, self.height)
    self.drawSpriteBatch(self.entities)
    self.drawSpriteBatch(self.widgets)
    Renderer.endDrawing(self.camera)
end

function Screen:keyPressed(key, unicode)
    for k, widget in pairs(self.widgets) do
        widget:keyPressed(key, unicode)
    end
end

function Screen:invokeMouseMoved(x, y, dx, dy)
    local newX, newY = self.camera:transform(x, y)
    self:mouseMoved(newX, newY, dx, dy)
end

function Screen:mouseMoved(x, y, dx, dy)
    for k, widget in pairs(self.widgets) do
        widget:mouseMoved(x, y, dx, dy)
    end
end

function Screen:invokeMousePressed(x, y, dx, dy)
    local newX, newY = self.camera:transform(x, y)
    self:mousePressed(newX, newY, dx, dy)
end

function Screen:mousePressed(x, y, button)
    for k, widget in pairs(self.widgets) do
        widget:mousePressed(x, y, button)
    end
end

function Screen:invokeMouseReleased(x, y, dx, dy)
    local newX, newY = self.camera:transform(x, y)
    self:mouseReleased(newX, newY, dx, dy)
end

function Screen:mouseReleased(x, y, button)
    for k, widget in pairs(self.widgets) do
        widget:mouseReleased(x, y, button)
    end
end

return Screen
