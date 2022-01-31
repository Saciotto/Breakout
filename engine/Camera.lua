local Camera = {
    sceneWidth,
    sceneHeight,
    scaleMethod,
    scaleX = 1,
    scaleY = 1,
    offsetX = 0,
    offsetY = 0
}

function Camera:new(width, height, scaleMethod)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.sceneWidth = width or DefaultViewport.WIDTH
    o.sceneHeight = height or DefaultViewport.HEIGHT
    o.scaleMethod = scaleMethod or "ORIGINAL"
    return o
end

function Camera:update()
    local windowWidth, windowHeight = Graphics.getDimensions()

    if self.scaleMethod == "FULL_SCREEN" then
        self.scaleX = windowWidth / self.sceneWidth
        self.scaleY = windowHeight / self.sceneHeight
    elseif self.scaleMethod == "FULL_SCREEN_KEEP_ORIGINAL_ASPECT" then
        self.scaleX = windowWidth / self.sceneWidth
        self.scaleY = windowHeight / self.sceneHeight
        if self.scaleX > self.scaleY then self.scaleX = self.scaleY end
        if self.scaleY > self.scaleX then self.scaleY = self.scaleX end
    else -- ORIGINAL
        self.scaleX = 1
        self.scaleY = 1
    end
    self.offsetX = (windowWidth - (self.sceneWidth * self.scaleX)) / 2
    self.offsetY = (windowHeight - (self.sceneHeight * self.scaleY)) / 2
end

function Camera:transform(x, y)
    local newX = (x - self.offsetX) / self.scaleX
    local newY = (y - self.offsetY) / self.scaleY
    return newX, newY
end

function Camera:set()
    Graphics.push()
    Graphics.translate(self.offsetX, self.offsetY)
    Graphics.scale(self.scaleX, self.scaleY)
    Graphics.setViewportScissor(0, 0, self.sceneWidth, self.sceneHeight)
end

function Camera:unset()
    Graphics.pop()
end

return Camera
