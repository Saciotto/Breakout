local FramesCounter = {
    frames = 0.0,
    next = 0.0,
    time = 0.0,
    fps = 0.0
}

function FramesCounter:getFPS(dt)
    self.frames = self.frames + 1
    self.time = self.time + dt
    if self.time > self.next then
        self.fps =  self.frames / self.time
        self.time = 0.0
        self.frames = 0.0
        self.next = 0.25
    end
    if self.fps == 0 then
        self.fps = 1 / dt
    end
    return self.fps
end

return FramesCounter
