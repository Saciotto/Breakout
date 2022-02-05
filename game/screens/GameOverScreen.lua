local GameOverScreen = Screen:new()

function GameOverScreen:new()
    local o = Screen:new()
    setmetatable(o, self)
    self.__index = self
    o:load()
    return o
end

local function goStageSelect()
    GameData.lives = 3
    GameData.score = 0
    Game.setScreen(StageSelect)
end

function GameOverScreen:keyPressed(key, unicode)
    goStageSelect()
end

function GameOverScreen:mousePressed(x, y, button)
    goStageSelect()
end

function GameOverScreen:load()
    self.background = Graphics.newImage("assets/images/SunnyDay.png")

    local x = 134
    local y = 200
    local window = Window:new(x, y, Constants.SCREEN_WIDTH - 2 * x, Constants.SCREEN_HEIGHT - 2 * y)

    if GameData.score > GameData.maxScore then
        GameData.maxScore = GameData.score
    end

    local gameOverLabel = Label:new("Game Over", Colors.WHITE, Fonts.CHILANKA, 60, 0, 80, Constants.SCREEN_WIDTH)
    gameOverLabel:setAlign("center", "top")

    local text  = "Final score: " .. GameData.score .. "\n"
    text = text .. "Max. score: " .. GameData.maxScore

    local label = Label:new(text, Colors.BLUE, Fonts.CHILANKA, 60, 0, 0, window.width, window.height)
    label:setAlign("center", "middle")

    window:addChild(label)

    self.nextStage = 30
    self.widgets = {
        gameOverLabel,
        window
    }

    GameData.save()
end

return GameOverScreen
