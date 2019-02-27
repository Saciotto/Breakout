--- Love2d entry point

-- Adds xml2lua to Lua path
package.path = package.path .. ";xml2lua/?.lua"

Constants = require("Constants")
Camera = require("Camera")
AssetsManager = require("AssetsManager")
Renderer = require("Renderer")
Controller = require("Controller")

GameScreen = require("screens.GameScreen")

function SetScreen(NewScreen)
    screen = NewScreen:new()
end

function love.load()
    -- Create window 
    love.window.setMode(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT, {resizable = true})
    love.window.setTitle("Breakout")

    -- Load assets
    sprites = AssetsManager.loadSprites("assets/breakout.png", "assets/breakout.xml")

    -- Set first screen
    SetScreen(GameScreen)
end

function love.update(dt)
    screen:update(dt)
end

function love.draw()
    screen:draw()
end
