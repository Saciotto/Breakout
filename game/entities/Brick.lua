local Brick = Entity:new()

function Brick:new(x, y, color, len)
    height = heght or Constants.BRICK_HEIGHT
    local debugColor = {math.random(), math.random(), math.random()}
    local o = Entity:new(x, y, nil, height, nil, debugColor)
    setmetatable(o, self)
    self.__index = self
    o.sleft = Sprites["brick_" .. color .. "_left"]
    o.smid = Sprites["brick_" .. color .. "_mid"]
    o.sright = Sprites["brick_" .. color .. "_right"]
    o.ssquare = Sprites["brick_" .. color]
    o.len = len or 1
    o.lives = 0
    o.isBroken = false
    o.width = o.len * Constants.BRICK_WIDTH
    o.value = o.len
    return o
end

function Brick:hit()
    if self.lives <= 0 then
        self.isBroken = true
    else
        self.lives = self.lives - 1
    end
end

function Brick:draw()
    -- Error
    if self.len < 0 then
        return
    end
    -- 1x1 brick
    if  self.len == 1 then
        Renderer.drawSprite(self.ssquare, self.debugColor, self.x, self.y, Constants.BRICK_WIDTH, self.height)
        return
    end
    -- Xx1 brick
    Renderer.drawSprite(self.sleft, self.debugColor, self.x, self.y, Constants.BRICK_WIDTH, self.height)
    local pos = self.x + Constants.BRICK_WIDTH
    for i = 2, self.len - 1, 1 do
        Renderer.drawSprite(self.smid, self.debugColor, pos, self.y, Constants.BRICK_WIDTH, self.height)
        pos = pos + Constants.BRICK_WIDTH
    end
    Renderer.drawSprite(self.sright, self.debugColor, pos, self.y, Constants.BRICK_WIDTH, self.height)
end

return Brick
