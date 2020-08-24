local Camera = require("helpers.Camera")
local Renderer = require("helpers.Renderer")
local DefaultViewport = require("helpers.DefaultViewport")

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
    self.renderer = Renderer:new(o)
    return o
end

function Screen:update(dt)
    for k, widget in pairs(self.widgets) do
        widget:update(dt)
    end
end

function Screen:draw()
    self.camera:update()
    self.renderer:draw()
end

function Screen:keyPressed(key, unicode)
    for k, widget in pairs(self.widgets) do
        widget:keyPressed(key, unicode)
    end
end

function Screen:mouseMoved(x, y, dx, dy, istouch)
    for k, widget in pairs(self.widgets) do
        widget:mouseMoved(x, y, dx, dy, istouch)
    end
end

function Screen:mousePressed(x, y, button)
    for k, widget in pairs(self.widgets) do
        widget:mousePressed(x, y, button)
    end
end

function Screen:mouseReleased(x, y, button)
    for k, widget in pairs(self.widgets) do
        widget:mouseReleased(x, y, button)
    end
end

return Screen
