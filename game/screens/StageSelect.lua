local StageSelect = Screen:new()

function StageSelect:new()
    local o = Screen:new()
    setmetatable(o, self)
    self.__index = self
    o:load()
    return o
end

local function loadStage()
    SetScreen(GameScreen)
end

function StageSelect:load()
    button = Button:new(50, 50, 100, 100, Label:new("Iniciar", Colors.BLACK, Fonts.DEJAVU))
    button.onClick = loadStage
    self.widgets = {button}
end

return StageSelect
