local Entity = require("engine.Entity")
local Renderer = require("engine.Renderer")
local Constants = require("game.Constants")

local Pad = Entity:new()

function Pad:new(x, y, debugColor)
    x = x or (Constants.SCREEN_WIDTH - (Constants.PAD_WIDTH * Constants.PAD_LENGTH)) / 2
    y = y or Constants.SCREEN_HEIGHT - Constants.PAD_HEIGHT - Constants.PAD_MARGIN
    local o = Entity:new(x, y, Constants.PAD_WIDTH * Constants.PAD_LENGTH, Constants.PAD_HEIGHT, nil, debugColor)
    setmetatable(o, self)
    self.__index = self
    o.sleft = Sprites["pad_left"]
    o.smid = Sprites["pad_mid"]
    o.sright = Sprites["pad_right"]
    o.len = Constants.PAD_LENGTH
    o.velocity = Constants.PAD_VELOCITY
    return o
end

function Pad:getWidth(length)
    return self.width
end

function Pad:setLenght(length)
    self.width = Constants.PAD_WIDTH * lenght
    self.len = length
end

function Pad:update(dt)
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        self.x = self.x - (dt * self.velocity)
    end
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        self.x = self.x + (dt * self.velocity)
    end
    if self.x < 0 then
        self.x = 0 
    end
    if self.x > Constants.SCREEN_WIDTH - self.width then
        self.x = Constants.SCREEN_WIDTH - self.width
    end
end

function Pad:draw()
    -- Error
    if self.len < 2 then
        return
    end
    -- Draw
    Renderer.drawSprite(self.sleft, self.debugColor, self.x, self.y, Constants.PAD_WIDTH, self.height)
    local pos = self.x + Constants.PAD_WIDTH
    for i = 2, self.len - 1, 1 do
        Renderer.drawSprite(self.smid, self.debugColor, pos, self.y, Constants.PAD_WIDTH, self.height)
        pos = pos + Constants.PAD_WIDTH
    end
    Renderer.drawSprite(self.sright, self.debugColor, pos, self.y, Constants.PAD_WIDTH, self.height)
end

return Pad
