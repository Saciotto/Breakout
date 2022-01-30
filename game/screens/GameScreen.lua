--- GameScreen class

local GameScreen = Screen:new()
GameScreen.stage = 1

local function getBackground(stage)
    local backgroundId = stage % 6
    if backgroundId == 1 then
        return Graphics.newImage("assets/images/SunnyDay.png")
    elseif backgroundId == 2 then
        return Graphics.newImage("assets/images/BlueMoon.png")
    elseif backgroundId == 3 then
        return Graphics.newImage("assets/images/CitySkyline.png")
    elseif backgroundId == 4 then
        return Graphics.newImage("assets/images/Foggy.png")
    elseif backgroundId == 5 then
        return Graphics.newImage("assets/images/Graveyard.png")
    elseif backgroundId == 0 then
        return Graphics.newImage("assets/images/SnowyMountains.png")
    end
end

function GameScreen:new()
    local o = Screen:new()
    setmetatable(o, self)
    self.__index = self
    o:load()
    return o
end

function GameScreen:load()
    self.controller = Controller:new(self)

    self.stage = GameScreen.stage
    if GameData.unlockedStage < self.stage then
        GameData.unlockedStage = self.stage
    end

    self.grid = BricksGrid:new()
    MapManager.importMap(self.grid, self.stage)

    self.balls = Entity:new()
    self.pad = Pad:new()
    self.background = getBackground(self.stage)
    self.entities = {
        self.pad,
        self.balls,
        self.grid
    }
    
    self.stageLabel = Label:new("", {1,1,1}, Fonts.DEJAVU, 20, 10, 0, Constants.SCREEN_WIDTH - 20, 0, "left", "top")
    self.scoreLabel = Label:new("", {1,1,1}, Fonts.DEJAVU, 20, 10, 0, Constants.SCREEN_WIDTH - 20, 0, "center", "top")
    self.livesLabel = Label:new("", {1,1,1}, Fonts.DEJAVU, 20, 10, 0, Constants.SCREEN_WIDTH - 20, 0, "right", "top")
    self.widgets = {
        self.stageLabel,
        self.scoreLabel,
        self.livesLabel
    }

    self.padInputProcessor = PadInputProcessor:new(self)
    self.gameInputProcessor = GameInputProcessor:new(self)

    self.inputProcessors = {
        self.padInputProcessor,
        self.gameInputProcessor
    }
    
    self.controller:start()
end

function GameScreen:update(dt)
    self.controller:update(dt)
    self.padInputProcessor:update(dt)
    self.livesLabel.text = "LIVES: " .. string.format("%.0f", GameData.lives)
    self.scoreLabel.text = "SCORE: " .. string.format("%.0f", GameData.score)
    self.stageLabel.text = "STAGE: " .. string.format("%.0f", self.stage)
end

return GameScreen
