--- Love2d entry point

local Constants = require("Constants")
local Camera = require("Camera")
local AssetsManager = require("AssetsManager")
local SplashScreen = require("screens.SplashScreen")

function SetScreen(NewScreen)
    screen = NewScreen:new()
end

function love.load()
    -- Create window 
    love.window.setMode(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT, {resizable = true})
    love.window.setTitle("Breakout")

    -- Load assets
    Sprites = AssetsManager.loadSprites("assets/images/breakout.xml")

    -- Set first screen
    SetScreen(SplashScreen)
end

function love.update(dt)
    screen:update(dt)
end

function love.draw()
    screen:draw()
end

function love.keypressed(key, unicode)
    screen:keypressed(key, unicode)
end

function love.mousemoved(x, y, dx, dy, istouch)
    screen:mousemoved(x, y, dx, dy, istouch)
end

function love.mousepressed(x, y, button)
    screen:mousepressed(x, y, button)
end