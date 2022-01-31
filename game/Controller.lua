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

function Controller:hitBrick(index)
    local brick = self.screen.grid.bricks[index]
    brick:hit()
    if brick.isBroken then
        GameData.score = GameData.score  + brick.value
        self.screen.grid:destroyBrick(index)
    end
end

function Controller:updateEntities(dt)
    local entities = self.screen.entities
    for k, entity in pairs(entities) do
        entity:update(dt)
    end
end

function Controller:update(dt)
    if not self.paused then
        self:updateEntities(dt)
        self.ballController:update()
        self:checkObjective()
    else
        local position = self.screen.pad.x + self.screen.pad.width / 2
        self.ballController:setBallPostion(position)
    end
    self.screen.camera:update()
end

function Controller:restart()
    self.ballController:start()
end

function Controller:start()
    self.ballController = BallController:new(self)
    self.ballController:start()
end

return Controller
