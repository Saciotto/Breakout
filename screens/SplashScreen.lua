
local Screen = require("Screen")
local Renderer = require("Renderer")
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
    Renderer.draw(self)
    love.graphics.print("Splash Screen (" .. _VERSION .. ")")
end

return SplashScreen
