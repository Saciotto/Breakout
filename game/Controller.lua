local Controller = {
    paused = true,
    score = 0,
    ballSpeed = 1
}

function Controller:new(screen)
    local controller = {}
    setmetatable(controller, self)
    self.__index = self
    controller.screen = screen
    return controller
end

local function testCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return (x1 < x2 + w2) and (x1 + w1 > x2) and (y1 < y2 + h2) and (y1 + h1 > y2)
end

function Controller:gameOver()
    if GameData.lives > 1 then
        self.paused = true
        GameData.lives = GameData.lives - 1
        self:restart()
    else
        Game.setScreen(GameOverScreen)
    end
end

function Controller:loadStage(nextStage)
    GameScreen.stage = nextStage
    Game.setScreen(GameScreen)
end

function Controller:checkObjective()
    local bricks = self.screen.grid.bricks
    if #bricks == 0 then
        if self.screen.stage < Constants.MAX_STAGES then
            self:loadStage(self.screen.stage + 1)
        else
            Game.setScreen(GameOverScreen)
        end
    end
    if #self.screen.balls.children == 0 then
        self:gameOver()
    end
end

function Controller:getPowerUpType()
    local powerUps = {
        "split",
        "raise",
        "coin",
        "life",
        "slow",
        "heavy",
        "shrink",
        "shrink",
        "fast",
        "fast",
        "invisible",
        "invisible"
    }
    local idx = math.random(1, #powerUps)
    return powerUps[idx]
end

function Controller:dropPowerUp(brick)
    local x = brick.x + (brick.width - Constants.POWER_UP_WIDTH) / 2
    local y = brick.y + (brick.height - Constants.POWER_UP_HEIGHT) / 2

    local type = self:getPowerUpType()
    local powerUp = PowerUp:new(x, y, type)
    self.screen.powerUps:addChild(powerUp)
end

function Controller:hitBrick(index)
    local brick = self.screen.grid.bricks[index]
    brick:hit()
    if brick.isBroken then
        local rand = math.random(1, 100)
        if rand <= 15 then
            self:dropPowerUp(brick)
        end
        GameData.score = GameData.score + brick.value
        self.screen.grid:destroyBrick(index)
    end
end

function Controller:hitMetalBrick(index)
    local brick = self.screen.grid.metalBricks[index]
    brick:hit()
    if brick.isBroken then
        GameData.score = GameData.score + brick.value
        self.screen.grid:destroyMetalBrick(index)
    end
end

function Controller:updateEntities(dt)
    local entities = self.screen.entities
    for k, entity in pairs(entities) do
        entity:update(dt)
    end
end

function Controller:removeOutOfBoundsPowerUps()
    for index = #self.screen.powerUps.children, 1, -1 do
        local entity = self.screen.powerUps.children[index]
        if entity.y > Constants.SCREEN_HEIGHT then
            self.screen.powerUps:removeChild(index)
        end
    end
end

function Controller:setPadTransparent()
    self.screen.pad.transparent = true
end

function Controller:setPadOpaque()
    self.screen.pad.transparent = false
end

function Controller:applyPowerUp(type)
    if type == "split" then
        self.ballController:splitBall()
    elseif type == "raise" then
        self.screen.pad:setLength(5)
    elseif type == "coin" then
        GameData.score = GameData.score + 6
    elseif type == "life" then
        GameData.lives = GameData.lives + 1
    elseif type == "shrink" then
        self.screen.pad:setLength(2)
    elseif type == "fast" then
        self.ballController:setAllBallsToSpeedFast()
    elseif type == "slow" then
        self.ballController:setAllBallsToSpeedSlow()
    elseif type == "heavy" then
        self.ballController:setAllBallsToHeavy()
        self.timer:removeEvent("heavy")
        self.timer:addEvent("heavy", 5, self.ballController.setAllBallsToLight, self.ballController)
    elseif type == "invisible" then
        self:setPadTransparent()
        self.timer:removeEvent("invisible")
        self.timer:addEvent("invisible", 5, self.setPadOpaque, self)
    end
end

function Controller:checkPowerUpAndPadColision()
    local pad = self.screen.pad

    for index = #self.screen.powerUps.children, 1, -1 do
        local powerUp = self.screen.powerUps.children[index]
        local bx, by, bw, bh = powerUp:getViewport()
        local px, py, pw, ph = pad:getViewport()

        local collision = testCollision(bx, by, bw, bh, px, py, pw, ph)
        if collision then
            self:applyPowerUp(powerUp.type)
            self.screen.powerUps:removeChild(index)
        end
    end
end

function Controller:update(dt)
    if not self.paused then
        self:updateEntities(dt)
        self.timer:update(dt)
        self.ballController:update()
        self:removeOutOfBoundsPowerUps()
        self:checkPowerUpAndPadColision()
        self:checkObjective()
    else
        local position = self.screen.pad.x + self.screen.pad.width / 2
        self.ballController:setBallPostion(position)
    end
    self.screen.camera:update()
end

function Controller:restart()
    self.ballController:start()
    self.screen.pad:setLength(Constants.PAD_LENGTH)
    self.screen.powerUps.children = {}
    self.timer.events = {}
    self:setPadOpaque()
    GameData.save()
end

function Controller:start()
    self.ballController = BallController:new(self)
    self.ballController:start()
    self.timer = Timer:new()
end

return Controller
