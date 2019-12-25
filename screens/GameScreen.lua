--- GameScreen class

local Constants = require("Constants")
local Controller = require("Controller")
local Camera = require("Camera")
local Renderer = require("Renderer")
local Screen = require("Screen")
local Brick = require("entities.Brick")
local Ball = require("entities.Ball")
local Pad = require("entities.Pad")

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
    else
        return 'white'
    end
end

local function createBlock(c, i, j, lenght)
    local color = getColor(c)
    local brick = Brick:new(Constants.BRICK_WIDTH * j, Constants.BRICK_HEIGHT * i, color, lenght)
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
                    table.insert(self.bricks, brick)
                    c = '.'
                end
            end
            if c == '.' and line:sub(j,j) ~= '.' then
                c = line:sub(j,j)
                j1 = j - 1
            end
        end
        i = i + 1
    end
end

local function createBlocks(self)
    self.bricks = {}
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
    self.background = love.graphics.newImage("assets/images/background.png")
    self.camera = Camera:new(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT, "FULL_SCREEN_KEEP_ORIGINAL_ASPECT")
end

function GameScreen:update(dt)
    self.controller:update(dt)
end

function GameScreen:mousemoved(x, y, dx, dy, istouch)
    self.controller:mousemoved(x, y, dx, dy, istouch)
end

function GameScreen:draw()
    Renderer.draw(self)
end

return GameScreen
