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
    SetScreen(GameScreen)
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
    self.background = love.graphics.newImage("assets/images/SunnyDay.png")
    window = Window:new(134, 100, Constants.SCREEN_WIDTH - 268, Constants.SCREEN_HEIGHT - 200)

    label = Label:new("Level Select", Colors.WHITE, Fonts.CHILANKA, 60, 0, 20, Constants.SCREEN_WIDTH)
    label:setAlign("center", "top")

    self.nextStage = 1
    self.widgets = {
        window,
        label
    }
    for stage = 1, 32, 1 do
        local button = createStageButton(stage, stage <= self.nextStage)
        table.insert(self.widgets, button)
    end
end

return StageSelect
