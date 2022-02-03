local PowerUp = Entity:new()

local function utf8char( ... )
    local buf = {}
    for k, v in ipairs { ... } do
        if v < 0 or v > 0x10FFFF then
            error( "bad argument #" .. k .. " to char (out of range)", 2 )
        end

        local b1, b2, b3, b4 = nil, nil, nil, nil

        if v < 0x80 then -- Single-byte sequence
            table.insert( buf, string.char( v ) )
        elseif v < 0x800 then -- Two-byte sequence
            b1 = bit.bor( 0xC0, bit.band( bit.rshift( v, 6 ), 0x1F ) )
            b2 = bit.bor( 0x80, bit.band( v, 0x3F ) )
            table.insert( buf, string.char( b1, b2 ) )
        elseif v < 0x10000 then -- Three-byte sequence
            b1 = bit.bor( 0xE0, bit.band( bit.rshift( v, 12 ), 0x0F ) )
            b2 = bit.bor( 0x80, bit.band( bit.rshift( v, 6 ), 0x3F ) )
            b3 = bit.bor( 0x80, bit.band( v, 0x3F ) )
            table.insert( buf, string.char( b1, b2, b3 ) )
        else -- Four-byte sequence
            b1 = bit.bor( 0xF0, bit.band( bit.rshift( v, 18 ), 0x07 ) )
            b2 = bit.bor( 0x80, bit.band( bit.rshift( v, 12 ), 0x3F ) )
            b3 = bit.bor( 0x80, bit.band( bit.rshift( v, 6 ), 0x3F ) )
            b4 = bit.bor( 0x80, bit.band( v, 0x3F ) )
            table.insert( buf, string.char( b1, b2, b3, b4 ) )
        end
    end
    return table.concat( buf, "" )
end

local function getPowerUpIcon(type)
    local unicode = "X"
    local powerUpColor = {iconColor = Colors.BLUE, bkgrColor = Colors.GREEN}
    local powerDownColor = {iconColor = Colors.WHITE, bkgrColor = Colors.RED}
    local color = powerUpColor

    -- Power Ups
    if type == "split" then
        unicode = utf8char(0xe3bb)
        color = powerUpColor
    elseif type == "raise" then 
        unicode = utf8char(0xe89f)
        color = powerUpColor
    elseif type == "coin" then 
        unicode = utf8char(0xe263)
        color = powerUpColor
    elseif type == "life" then 
        unicode = utf8char(0xe87d)
        color = powerUpColor
    elseif type == "slow" then 
        unicode = utf8char(0xe020)
        color = powerUpColor
    elseif type == "heavy" then 
        unicode = utf8char(0xeb43)
        color = powerUpColor

    -- Power Down
    elseif type == "shrink" then 
        unicode = utf8char(0xf1cf)
        color = powerDownColor
    elseif type == "fast" then 
        unicode = utf8char(0xe01f)
        color = powerDownColor
    elseif type == "invisible" then
        unicode = utf8char(0xe663)
        color = powerDownColor
    end

    local icon = Label:new(unicode, color.iconColor, Fonts.MATERIAL_ICONS, 18, 0, 0, Constants.POWER_UP_WIDTH, Constants.POWER_UP_HEIGHT, "center", "middle")
    return icon, color.bkgrColor
end


function PowerUp:new(x, y, type)
    local powerUp = Entity:new(x, y, Constants.POWER_UP_WIDTH, Constants.POWER_UP_HEIGHT, nil, Colors.GREEN)
    setmetatable(powerUp, self)
    self.__index = self
    powerUp.type = type
    powerUp.dy = Constants.POWER_UP_VELOCITY
    powerUp.icon, powerUp.color = getPowerUpIcon(type)
    return powerUp
end

function PowerUp:update(dt)
    self.y = self.y + self.dy * dt
    Entity.update(self, dt)
end

function PowerUp:draw(dt)
    Renderer.drawSprite(nil, self.color, self.x, self.y, self.width, self.height)
    self.icon.x = self.x
    self.icon.y = self.y
    self.icon:draw()
end

return PowerUp
