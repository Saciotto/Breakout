--- Debuger
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

--- Love2d entry point
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

    -- Setup defaults
    math.randomseed(os.time())
    Label.setDefaultFont(Fonts.DEJAVU, 20)
    Button.setDefualtSprites(Buttons.round_button_blue, Buttons.round_button_blue)

    -- Starts the game
    Game.load(SplashScreen)
end

function love.update(dt)
    if dt > 0.1 then dt = 0.1 end
    Game.update(dt)
end

function love.draw()
    Game.draw()
end

function love.keypressed(key, unicode)
    Game.screen:keyPressed(key, unicode)
end

function love.mousemoved(x, y, dx, dy, istouch)
    Game.screen:invokeMouseMoved(x, y, dx, dy)
end

function love.mousepressed(x, y, button)
    Game.screen:invokeMousePressed(x, y, button)
end

function love.mousereleased(x, y, button)
    Game.screen:invokeMouseReleased(x, y, button)
end
