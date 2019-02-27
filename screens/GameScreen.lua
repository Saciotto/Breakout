--- GameScreen class

local Controller = require("Controller")
local Renderer = require("Renderer")
local Screen = require("Screen")
local Brick = require("entities.Brick")
local Ball = require("entities.Ball")
local Pad = require("entities.Pad")

local GameScreen = Screen:new()

local function createBlocks(self)
    self.bricks = {}
    for i = 2, Constants.NO_ROWS - 3, 1 do
        for j = 2, Constants.NO_COLS - 3, 1 do
            local brick = Brick:new(Constants.BRICK_WIDTH * j, Constants.BRICK_HEIGHT * i, nil, nil, sprites.BrickLightGreen)
            table.insert(self.bricks, brick)
        end
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

    local ballX = (Constants.SCREEN_WIDTH - Constants.PAD_WIDTH) / 2
    local ballY = Constants.SCREEN_HEIGHT - Constants.PAD_HEIGHT - Constants.PAD_MARGIN - Constants.BALL_MARGIN - Constants.BALL_RADIUS * 2

    createBlocks(self)
    self.ball = Ball:new(ballX, ballY, BALL_VELOCITY, sprites.Ball)
    self.pad = Pad:new(nil, nil, nil, nil, sprites.Pad)
    self.camera = Camera:new(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT, "FULL_SCREEN_KEEP_ORIGINAL_ASPECT")
end

function GameScreen:update(dt)
    self.controller:update(dt)
end

function GameScreen:draw()
    Renderer.draw(self)
end

return GameScreen
