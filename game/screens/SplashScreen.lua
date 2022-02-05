local SplashScreen = Screen:new()

function SplashScreen:new()
    local splashScreen = Screen:new()
    setmetatable(splashScreen, self)
    self.__index = self
    local title = Label:new("Breakout", {1,1,1}, Fonts.TOONEY_NOODLE, 100, 0, 50, Constants.SCREEN_WIDTH, 0 , "center")
    local luaVersion = Label:new("Lua Version: " .. _VERSION , {1,1,1}, Fonts.CHILANKA, 26, 0, 200, Constants.SCREEN_WIDTH, 0 , "center")
    local pressAnyKey = Label:new("Press any key to start", {1,1,1}, Fonts.CHILANKA, 46, 0, 550, Constants.SCREEN_WIDTH, 0 , "center")
    luaVersion:setFont(Fonts.CHILANKA, 26)

    widgets = {title, luaVersion, pressAnyKey}
    splashScreen.widgets = widgets
    GameData.load()
    return splashScreen
end

function SplashScreen:keyPressed(key, unicode)
    Game.setScreen(StageSelect)
end

function SplashScreen.mousePressed(x, y, button)
    Game.setScreen(StageSelect)
end

return SplashScreen
