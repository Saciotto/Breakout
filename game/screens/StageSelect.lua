local StageSelect = Screen:new()

function StageSelect:new()
    local o = Screen:new()
    setmetatable(o, self)
    self.__index = self
    o:load()
    return o
end

local function loadStage(button)
    GameScreen.stage = button.stage
    Game.setScreen(GameScreen)
end

local function createStageButton(stage, enabled)
    local i = (stage - 1) % 8
    local j = math.floor((stage - 1) / 8)
    local x = 134 + 20 + (i * 120)
    local y = 100 + 20 + (j * 120)
    local text = ""

    if enabled then text = tostring(stage) end

    local button = Button:new(x, y, 100, 100, text)
    button:formatText(Fonts.TOONEY_NOODLE, Colors.BLACK, 60)
    button.stage = stage

    if enabled then 
        button.click = loadStage
    else
        button:setSprites(Buttons.button_locked, Buttons.button_locked)
    end
    return button
end

function StageSelect:load()
    self.background = Graphics.newImage("assets/images/SunnyDay.png")
    window = Window:new(134, 100, Constants.SCREEN_WIDTH - 268, Constants.SCREEN_HEIGHT - 200)

    label = Label:new("Select Level", Colors.WHITE, Fonts.CHILANKA, 60, 0, 20, Constants.SCREEN_WIDTH)
    label:setAlign("center", "top")

    self.nextStage = GameData.unlockedStage
    self.widgets = {
        window,
        label
    }
    for stage = 1, Constants.MAX_STAGES, 1 do
        local button = createStageButton(stage, stage <= self.nextStage)
        table.insert(self.widgets, button)
    end
    GameData.save()
end

return StageSelect
