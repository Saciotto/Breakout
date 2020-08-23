local Screen = require("helpers.Screen")
local StageSelect = require("screens.StageSelect")

local SplashScreen = Screen:new()

function SplashScreen:new()
    local o = Screen:new()
    setmetatable(o, self)
    self.__index = self
    return o
end

function SplashScreen:keypressed(key, unicode)
    SetScreen(StageSelect)
end

function SplashScreen.mousepressed(x, y, button)
    SetScreen(StageSelect)
end

function SplashScreen:draw()
    Screen.draw(self)
    love.graphics.print("Splash Screen (" .. _VERSION .. ")")
end

return SplashScreen
