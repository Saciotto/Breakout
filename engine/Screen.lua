local Screen = {}

function Screen:new(config)
    local screen = {}
    setmetatable(screen, self)
    self.__index = self
    screen.config = config or {}
    screen.background = Graphics.newImage("assets/images/SunnyDay.png")
    screen.width = DefaultViewport.WIDTH
    screen.height = DefaultViewport.HEIGHT
    screen.camera = Camera:new(screen.width, screen.height, "FULL_SCREEN_KEEP_ORIGINAL_ASPECT")
    screen.entities = {}
    screen.widgets = {}
    screen.inputProcessors = {}
    return screen
end

function Screen:update(dt)
    for k, inputProcessor in pairs(self.inputProcessors) do 
        inputProcessor:update(dt)
    end
    for k, widget in pairs(self.widgets) do
        widget:update(dt)
    end
end

function Screen.drawSpriteBatch(spriteBatch)
    for k, sprite in pairs(spriteBatch) do
        sprite:draw()
    end
end

function Screen:drawSprites()
    Renderer.drawImage(self.background, 0, 0, self.width, self.height)
    self.drawSpriteBatch(self.entities)
    self.drawSpriteBatch(self.widgets)
end

function Screen:draw()
    self.camera:update()
    Renderer.beginDrawing(self.camera)
    self:drawSprites()
    Renderer.endDrawing(self.camera)
end

function Screen:keyPressed(key, unicode)
    for k, inputProcessor in pairs(self.inputProcessors) do 
        inputProcessor:keyPressed(key, unicode)
    end
    for k, widget in pairs(self.widgets) do
        widget:keyPressed(key, unicode)
    end
end

function Screen:invokeMouseMoved(x, y, dx, dy)
    local newX, newY = self.camera:transform(x, y)
    self:mouseMoved(newX, newY, dx, dy)
end

function Screen:mouseMoved(x, y, dx, dy)
    for k, inputProcessor in pairs(self.inputProcessors) do 
        inputProcessor:mouseMoved(x, y, dx, dy)
    end
    for k, widget in pairs(self.widgets) do
        widget:mouseMoved(x, y, dx, dy)
    end
end

function Screen:invokeMousePressed(x, y, dx, dy)
    local newX, newY = self.camera:transform(x, y)
    self:mousePressed(newX, newY, dx, dy)
end

function Screen:mousePressed(x, y, button)
    for k, inputProcessor in pairs(self.inputProcessors) do 
        inputProcessor:mousePressed(x, y, button)
    end
    for k, widget in pairs(self.widgets) do
        widget:mousePressed(x, y, button)
    end
end

function Screen:invokeMouseReleased(x, y, dx, dy)
    local newX, newY = self.camera:transform(x, y)
    self:mouseReleased(newX, newY, dx, dy)
end

function Screen:mouseReleased(x, y, button)
    for k, inputProcessor in pairs(self.inputProcessors) do 
        inputProcessor:mouseReleased(x, y, button)
    end
    for k, widget in pairs(self.widgets) do
        widget:mouseReleased(x, y, button)
    end
end

return Screen
