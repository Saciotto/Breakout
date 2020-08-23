
local Constants = require("Constants")
local Screen = require("helpers.Screen")
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

return StageSelect