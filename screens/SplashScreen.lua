
local Screen = require("Screen")
local GameScreen = require("screens.GameScreen")

local SplashScreen = Screen:new()

function SplashScreen:new()
    local o = Screen:new()
    setmetatable(o, self)
    self.__index = self
    return o
end

function SplashScreen:keypressed(key, unicode)
    SetScreen(GameScreen)
end

function SplashScreen:draw()
    love.graphics.setBackgroundColor(0,0,0)
    love.graphics.setColor(1,1,1)
    love.graphics.print("Splash Screen")
end

return SplashScreen
