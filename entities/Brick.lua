local Entity = require("helpers.Entity")
local Constants = require("Constants")

local Brick = Entity:new()

function Brick:new(x, y, color, len)
    height = heght or Constants.BRICK_HEIGHT
    local debugColor = {math.random(), math.random(), math.random()}
    local o = Entity:new(nil, x, y, nil, height, nil, debugColor)
    setmetatable(o, self)
    self.__index = self
    o.sleft = Sprites["brick_" .. color .. "_left"]
    o.smid = Sprites["brick_" .. color .. "_mid"]
    o.sright = Sprites["brick_" .. color .. "_right"]
    o.ssquare = Sprites["brick_" .. color]
    o.len = len or 1
    o.indestrutible = false
    o.isBroken = false
    o.width = o.len * Constants.BRICK_WIDTH
    return o
end

function Brick:hit()
    if not self.indestrutible then
        self.isBroken = true
    end
end

function Brick:draw()
    -- Error
    if self.len < 0 then
        return
    end
    -- 1x1 brick
    if  self.len == 1 then
        self.drawItem(self.ssquare, self.debugColor, self.x, self.y, Constants.BRICK_WIDTH, self.height)
        return
    end
    -- Xx1 brick
    self.drawItem(self.sleft, self.debugColor, self.x, self.y, Constants.BRICK_WIDTH, self.height)
    local pos = self.x + Constants.BRICK_WIDTH
    for i = 2, self.len - 1, 1 do
        self.drawItem(self.smid, self.debugColor, pos, self.y, Constants.BRICK_WIDTH, self.height)
        pos = pos + Constants.BRICK_WIDTH
    end
    self.drawItem(self.sright, self.debugColor, pos, self.y, Constants.BRICK_WIDTH, self.height)
end

return Brick
