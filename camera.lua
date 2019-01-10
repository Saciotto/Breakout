
require "constants"

Camera = {
    sceneWidth,
    sceneHeight,
    scaleMethod,
    scaleX = 1,
    scaleY = 1,
    offsetX = 0,
    offsetY = 0
}

function Camera:new(width, height, scaleMethod)
    o = {}
    setmetatable(o, self)
    self.__index = self
    o.sceneWidth = width or Constants.SCREEN_WIDTH
    o.sceneHeight = height or Constants.SCREEN_HEIGHT
    o.scaleMethod = scaleMethod or "ORIGINAL"
    return o
end

function Camera:update()
    local windowWidth, windowHeight = love.graphics.getDimensions()

    if self.scaleMethod == "FULL_SCEEN" then
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

function Camera:set()
    love.graphics.push()
    love.graphics.translate(self.offsetX, self.offsetY)
    love.graphics.scale(self.scaleX, self.scaleY)
end

function Camera:unset()
    love.graphics.pop()
end
