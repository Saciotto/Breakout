local Entity = {}

function Entity:new(x, y, width, height, drawable, debugColor)
    local entity = {}
    setmetatable(entity, self)
    self.__index = self
    entity.x = x or 0
    entity.y = y or 0
    entity.width = width or 1
    entity.height = height or 1
    entity.drawable = drawable or Drawable:new()
    entity.debugColor = debugColor or Colors.WHITE
    entity.children = {}
    return entity
end

function Entity:getViewport()
    return self.x, self.y, self.width, self.height
end

function Entity:update(dt)
    self.drawable:update(dt)
    for k, child in pairs(self.children) do
        child:update(dt)
    end
end

function Entity:setArea(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end

function Entity:draw()
    self.drawable.color = self.debugColor
    self.drawable:draw(self:getViewport())
    for k, child in pairs(self.children) do
        child:draw()
    end
end

function Entity:addChild(child)
    table.insert(self.children, child)
end

function Entity:removeChild(idx)
    table.remove(self.children, idx)
end

return Entity
