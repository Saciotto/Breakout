
local Screen = require("engine.Screen")
local Button = require("engine.widget.Button")
local Constants = require("game.Constants")
local GameScreen = require("game.screens.GameScreen")

local StageSelect = Screen:new()

function StageSelect:new()
    local o = Screen:new()
    setmetatable(o, self)
    self.__index = self
    o:load()
    return o
end

local function loadStage()
    SetScreen(GameScreen)
end

function StageSelect:load()
    button = Button:new(50, 50, 100, 100, "Iniciar")
    button.onClick = loadStage
    self.widgets = {button}
end

return StageSelect