--- GameScreen class

local GameScreen = Screen:new()
GameScreen.stage = 1

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
    self.ball = Ball:new(ballX, ballY, BALL_VELOCITY)
    self.pad = Pad:new()
    self.background = Graphics.newImage("assets/images/SunnyDay.png")
    self.entities = {
        self.pad,
        self.ball,
        self.grid
    }
    
    self.stageLabel = Label:new("", {1,1,1}, Fonts.DEJAVU, 20, 0, 0, Constants.SCREEN_WIDTH, 0, "left", "top")
    self.scoreLabel = Label:new("", {1,1,1}, Fonts.DEJAVU, 20, 0, 0, Constants.SCREEN_WIDTH, 0, "center", "top")
    self.fpsLabel = Label:new("", {1,1,1}, Fonts.DEJAVU, 20, 0, 0, Constants.SCREEN_WIDTH, 0, "right", "top")
    self.widgets = {
        self.stageLabel,
        self.scoreLabel,
        self.fpsLabel
    }
end

function GameScreen:update(dt)
    self.controller:update(dt)
    self.fpsLabel.text = "FPS: " .. string.format("%.0f", Game.fps)
    self.scoreLabel.text = "SCORE: " .. string.format("%.0f", self.controller.score)
    self.stageLabel.text = "STAGE: " .. string.format("%.0f", self.stage)
end

function GameScreen:mouseMoved(x, y, dx, dy)
    self.controller:mouseMoved(x, y, dx, dy)
end

function GameScreen:mousePressed(x, y, button)
    self.controller:mousePressed(x, y, button)
end

function GameScreen:keyPressed(key, unicode)
    self.controller:keyPressed(key, unicode)
end

return GameScreen
