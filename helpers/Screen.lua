local Camera = require("helpers.Camera")
local Renderer = require("helpers.Renderer")
local DefaultViewport = require("helpers.DefaultViewport")

local Screen = {}

function Screen:new(width, height)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.background = love.graphics.newImage("assets/images/GreenCardboard.png")
    o.width = width or DefaultViewport.WIDTH
    o.height = height or DefaultViewport.HEIGHT
    o.camera = Camera:new(o.width, o.height, "FULL_SCREEN_KEEP_ORIGINAL_ASPECT")
    o.entities = {}
    self.renderer = Renderer:new(o)
    return o
end

function Screen:update(dt)
end

function Screen:draw()
    self.camera:update()
    self.renderer:draw()
end

function Screen:keypressed(key, unicode)
end

function Screen:mousemoved(x, y, dx, dy, istouch)
end

function Screen.mousepressed(x, y, button)
end

return Screen
