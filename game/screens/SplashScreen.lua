local Screen = engine.Screen
local Label = engine.widget.Label

local Fonts = require("game.Fonts")
local StageSelect = require("game.screens.StageSelect")

local SplashScreen = Screen:new()

function SplashScreen:new()
    local splashScreen = Screen:new()
    setmetatable(splashScreen, self)
    self.__index = self
    local label = Label:new("Splash Screen (" .. _VERSION .. ")", {1,1,1})
    label:setFont(Fonts.CHILANKA, 50)
    widgets = {label}
    splashScreen.widgets = widgets
    return splashScreen
end

function SplashScreen:keyPressed(key, unicode)
    SetScreen(StageSelect)
end

function SplashScreen.mousePressed(x, y, button)
    SetScreen(StageSelect)
end

function SplashScreen:draw()
    Screen.draw(self)
end

return SplashScreen
