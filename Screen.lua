--- Screen super class

local Screen = {}

function Screen:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Screen:update(dt)
end

function Screen:render()
end

function Screen:keypressed(key, unicode)
end

return Screen
