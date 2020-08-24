
local Screen = require("helpers.Screen")
local WidgetButton = require("helpers.WidgetButton")

local Constants = require("Constants")
local GameScreen = require("screens.GameScreen")

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
    button = WidgetButton:new(50, 50, 100, 100, "Iniciar")
    button.onClick = loadStage
    self.widgets = {button}
end

return StageSelect