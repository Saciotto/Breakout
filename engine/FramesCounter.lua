local FramesCounter = {
    frames = 0.0,
    next = 0.0,
    time = 0.0,
    fps = 0.0
}

function FramesCounter.getFPS(dt)
    FramesCounter.frames = FramesCounter.frames + 1
    FramesCounter.time = FramesCounter.time + dt
    if FramesCounter.time > FramesCounter.next then
        FramesCounter.fps =  FramesCounter.frames / FramesCounter.time
        FramesCounter.time = 0.0
        FramesCounter.frames = 0.0
        FramesCounter.next = 0.25
    end
    if FramesCounter.fps == 0 then
        FramesCounter.fps = 1 / dt
    end
    return FramesCounter.fps
end

return FramesCounter
