local Renderer = require("engine.Renderer")
local Colors = require("engine.Colors")
local Drawable = require("engine.Drawable")

local Animation = Drawable:new()

function Animation:new(frames)
    local animation = Drawable:new()
    setmetatable(animation, self)
    self.__index = self
    animation.frames = frames
    animation.currentFrame = 1
    animation.elapsedTime = 0
    return animation
end

function Animation:getSprite()
    if #self.frames == 0 then
        return nil
    end
    while self.elapsedTime > self.frames[self.currentFrame].duration do
        self.elapsedTime = self.elapsedTime - self.frames[self.currentFrame].duration
        self.currentFrame = self.currentFrame + 1
        if (self.currentFrame > #self.frames) then self.currentFrame = 1 end
    end
    return self.frames[self.currentFrame].sprite
end

function Animation:update(dt)
    self.elapsedTime = self.elapsedTime + dt
end

function Animation:draw(x, y, width, height)
    Renderer.drawSprite(self:getSprite(), Colors.GREEN, x, y, width, height)
end

return Animation
