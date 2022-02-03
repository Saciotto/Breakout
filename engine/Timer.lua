local Timer = {}

function Timer:new()
    local timer = {}
    setmetatable(timer, self)
    self.__index = self
    timer.events = {}
    return timer
end

function Timer:addEvent(id, delta, callback, params)
    -- local event = table.pack(delta, callback, params)
    local event = {}
    event.delta = delta
    event.callback = callback
    event.params = params
    table.insert(self.events, event)
end

function Timer:update(dt)
    for index = #self.events, 1, -1 do
        local event = self.events[index]
        event.delta = event.delta - dt
        if event.delta < 0 then
            event.callback(event.params)
            table.remove(self.events, index)
        end
    end
end

function Timer:removeEvent(id)
    for index = #self.events, 1, -1 do
        local event = self.events[index]
        if event.id == id then
            table.remove(self.events, index)
        end
    end
end

return Timer
