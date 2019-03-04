--- Brick class

local Constants = require("Constants")
local AssetsManager = require("AssetsManager")
local Entity = require("Entity")

local Brick = Entity:new()

function Brick:new(x, y, color, len)
    height = heght or Constants.BRICK_HEIGHT
    local debugColor = {math.random(), math.random(), math.random()}
    local o = Entity:new(o, x, y, nil, height, nil, debugColor)
    setmetatable(o, self)
    self.__index = self
    o.sleft = Sprites["barHorizontal_" .. color .. "_left"]
    o.smid = Sprites["barHorizontal_" .. color .. "_mid"]
    o.sright = Sprites["barHorizontal_" .. color .. "_right"]
    if (o.smid ~= nil) then
        local x, y, w, h = o.smid.quad:getViewport()
        o.smidl = AssetsManager.newSprite(x + Constants.BRICK_LEFT_WIDTH, y, w - Constants.BRICK_LEFT_WIDTH, h, o.smid.image)
        o.smidr = AssetsManager.newSprite(x, y, w - Constants.BRICK_LEFT_WIDTH, h, o.smid.image)
        o.smidlr = AssetsManager.newSprite(x + Constants.BRICK_LEFT_WIDTH, y, w - 2 * Constants.BRICK_LEFT_WIDTH, h, o.smid.image)
    end
    o.len = len or 1
    o.isBroken = false
    o.width = o.len * Constants.BRICK_WIDTH
    return o
end

function Brick:hit()
    self.isBroken = true
end

function Brick:draw()
    local pos = self.x
    self.drawItem(self.sleft, self.debugColor, self.x, self.y, Constants.BRICK_LEFT_WIDTH, self.height)
    pos = pos + Constants.BRICK_LEFT_WIDTH
    for i = 1, self.len, 1 do
        local smid = self.smid
        local width = Constants.BRICK_WIDTH
        if i == 1 and i == self.len then
            smid = self.smidlr
            width = width - Constants.BRICK_LEFT_WIDTH - Constants.BRICK_RIGHT_WIDTH
        elseif i == 1 then
            smid = self.smidl
            width = width - Constants.BRICK_LEFT_WIDTH
        elseif i == self.len then
            smid = self.smidr
            width = width - Constants.BRICK_RIGHT_WIDTH
        end 
        self.drawItem(smid, self.debugColor,pos, self.y, width, self.height)
        pos = pos + width
    end
    self.drawItem(self.sright, self.debugColor, pos, self.y, Constants.BRICK_LEFT_WIDTH, self.height)
end

return Brick
