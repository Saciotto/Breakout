
local Constants = require("Constants")
local Screen = require("Screen")
local Camera = require("Camera")
local Renderer = require("Renderer")
local GameScreen = require("screens.GameScreen")

local StageSelect = Screen:new()

function StageSelect:new()
    local o = Screen:new()
    setmetatable(o, self)
    self.__index = self
    return o
end

function StageSelect.mousepressed(x, y, button)
    SetScreen(GameScreen)
end

function StageSelect:draw()
    Renderer.draw(self)
end

return StageSelect