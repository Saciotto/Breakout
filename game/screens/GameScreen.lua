--- GameScreen class

local Screen = require("engine.Screen")
local Label = require("engine.widget.Label")
local FramesCounter = require("engine.FramesCounter")
local Constants = require("game.Constants")
local Controller = require("game.Controller")
local Brick = require("game.entities.Brick")
local BricksGrid = require("game.entities.BricksGrid")
local Ball = require("game.entities.Ball")
local Pad = require("game.entities.Pad")
local Fonts = require("game.Fonts")

local GameScreen = Screen:new()

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
    local filename = "./assets/maps/stage1.txt"
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
    self.ball = Ball:new(ballX, ballY, BALL_VELOCITY)
    self.pad = Pad:new()
    self.background = love.graphics.newImage("assets/images/SunnyDay.png")
    self.entities = {
        self.pad,
        self.ball,
        self.grid
    }
    self.fps = Label:new("", {1,1,1})
    self.fps:setFont(Fonts.DEJAVU, 20)
    self.widgets = {
        self.fps
    }
end

function GameScreen:update(dt)
    self.controller:update(dt)
    self.fps.text = "FPS: " .. string.format("%.0f", FramesCounter:getFPS(dt))
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
