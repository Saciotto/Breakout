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

local function getColor(c)
    if c == 'b' or c == 'B' then
        return "blue"
    elseif c == 'g' or c == 'G' then
        return 'green'
    elseif c == 'o' or c == 'O' then
        return 'orange'
    elseif c == 'w' or c == 'W' then
        return 'white'
    elseif c == 'y' or c == 'Y' then
        return 'yellow'
    elseif c == 'x' or c == 'X' then
        return 'metal'
    else
        return 'white'
    end
end

local function createBlock(c, i, j, lenght)
    local color = getColor(c)
    local brick = {}
    if color == "metal" then
        brick = Brick:new(Constants.BRICK_WIDTH * j, Constants.BRICK_HEIGHT * i, "white", lenght)
        brick.indestrutible = true
    else
        brick = Brick:new(Constants.BRICK_WIDTH * j, Constants.BRICK_HEIGHT * i, color, lenght)
    end
    return brick
end

local function readMap(self)
    local filename = "./assets/maps/stage" .. self.stage .. ".txt"
    local i = 0
    for line in io.lines(filename) do
        local c = '.'
        local j1, j2 = 0
        for j = 1, line:len(), 1 do
            if c ~= '.' then
                if c ~= line:sub(j,j) then
                    j2 = j - 1
                    local brick = createBlock(c, i, j1, j2 - j1)
                    self.grid:addBrick(brick)
                    c = '.'
                end
            end
            if c == '.' and line:sub(j,j) ~= '.' then
                c = line:sub(j,j)
                j1 = j - 1
            end
        end
        if c ~= '.' then
            print(j, j1)
            local brick = createBlock(c, i, j1, line:len() - j1)
            self.grid:addBrick(brick)
        end
        i = i + 1
    end
end

local function createBlocks(self)
    self.grid = BricksGrid:new()
    readMap(self)
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

    local ballX = (Constants.SCREEN_WIDTH - (Constants.PAD_WIDTH * Constants.PAD_LENGTH)) / 2
    local ballY = Constants.SCREEN_HEIGHT - Constants.PAD_HEIGHT - Constants.PAD_MARGIN - Constants.BALL_MARGIN - Constants.BALL_RADIUS * 2

    createBlocks(self)
    self.stage = GameScreen.stage
    if GameData.unlockedStage < self.stage then
        GameData.unlockedStage = self.stage
    end

    self.ball = Ball:new(ballX, ballY, BALL_VELOCITY)
    self.pad = Pad:new()
    self.background = getBackground(self.stage)
    self.entities = {
        self.pad,
        self.ball,
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
end

function GameScreen:update(dt)
    self.controller:update(dt)
    self.padInputProcessor:update(dt)
    self.livesLabel.text = "LIVES: " .. string.format("%.0f", GameData.lives)
    self.scoreLabel.text = "SCORE: " .. string.format("%.0f", GameData.score)
    self.stageLabel.text = "STAGE: " .. string.format("%.0f", self.stage)
end

return GameScreen
