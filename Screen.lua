--- Screen super class

local Camera = require("Camera")
local Constants = require("Constants")

local Screen = {}

function Screen:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.background = love.graphics.newImage("assets/images/GreenCardboard.png")
    o.camera = Camera:new(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT, "FULL_SCREEN_KEEP_ORIGINAL_ASPECT")
    o.entities = {}
    return o
end

function Screen:update(dt)
end

function Screen:render()
end

function Screen:keypressed(key, unicode)
end

function Screen:mousemoved(x, y, dx, dy, istouch)
end

function Screen.mousepressed(x, y, button)
end

return Screen
