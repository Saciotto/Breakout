--- Love2d entry point



function SetScreen(NewScreen)
    screen = NewScreen:new()
end

function love.load()
    require("engine.init")
    require("game.init")

    -- Create window 
    love.window.setMode(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT, {resizable = true})
    love.window.setTitle("Breakout")

    -- Load assets
    Buttons = AssetsManager.loadSprites("assets/images/Buttons.xml")
    Sprites = AssetsManager.loadSprites("assets/images/Tiles.xml")
    Animations = AssetsManager.loadAnimations("assets/images/Animations.xml", Sprites)

    Label.setDefaultFont(Fonts.DEJAVU, 20)
    Button.setDefualtSprites(Buttons.round_button_blue, Buttons.round_button_blue)

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
    screen:keyPressed(key, unicode)
end

function love.mousemoved(x, y, dx, dy, istouch)
    screen:invokeMouseMoved(x, y, dx, dy)
end

function love.mousepressed(x, y, button)
    screen:invokeMousePressed(x, y, button)
end

function love.mousereleased(x, y, button)
    screen:invokeMouseReleased(x, y, button)
end
