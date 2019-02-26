--- GameScreen class

local Screen = require("Screen")

Brick = require("entities.Brick")

local GameScreen = Screen:new()

blocks = {}

local function createBlocks()
    for i = 2, Constants.NO_ROWS - 3, 1 do
        for j = 2, Constants.NO_COLS - 3, 1 do
            brick = Brick:new(Constants.BRICK_WIDTH * j, Constants.BRICK_HEIGHT * i, nil, nil, sprites.BrickLightGreen)
            table.insert(blocks, brick)
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
    local ballX = (Constants.SCREEN_WIDTH - Constants.PAD_WIDTH) / 2
    local ballY = Constants.SCREEN_HEIGHT - Constants.PAD_HEIGHT - Constants.PAD_MARGIN - Constants.BALL_MARGIN - Constants.BALL_RADIUS * 2

    createBlocks()
    ball = Ball:new(ballX, ballY, BALL_VELOCITY, sprites.Ball)
    pad = Pad:new(nil, nil, nil, nil, sprites.Pad)
    camera = Camera:new(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT, "FULL_SCREEN_KEEP_ORIGINAL_ASPECT")
end

function GameScreen:update(dt)
    Controller.update(dt)
end

function GameScreen:draw()
    Renderer.draw()
end

return GameScreen
