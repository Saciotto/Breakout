local MapManager = {}

local function getColor(c)
    if c == 'b' or c == 'B' then
        return "blue"
    elseif c == 'g' or c == 'G' then
        return 'green'
    elseif c == 'o' or c == 'O' then
        return 'orange'
    elseif c == 'w' or c == 'W' then
        return 'white'
    elseif c == 'y' or c == 'Y' then
        return 'yellow'
    elseif c == 'x' or c == 'X' then
        return 'metal'
    else
        return 'white'
    end
end

local function createBrick(c, i, j, lenght)
    local color = getColor(c)
    local brick = {}
    if color == "metal" then
        brick = Brick:new(Constants.BRICK_WIDTH * j, Constants.BRICK_HEIGHT * i, color, lenght)
        brick.lives = 9
    else
        brick = Brick:new(Constants.BRICK_WIDTH * j, Constants.BRICK_HEIGHT * i, color, lenght)
    end
    return brick
end

function MapManager.importMap(grid, stage)
    local filename = "./assets/maps/stage" .. stage .. ".txt"
    local i = 0
    for line in io.lines(filename) do
        local c = '.'
        local j1, j2 = 0
        for j = 1, line:len(), 1 do
            if c ~= '.' then
                if c ~= line:sub(j,j) then
                    j2 = j - 1
                    local brick = createBrick(c, i, j1, j2 - j1)
                    grid:addBrick(brick)
                    c = '.'
                end
            end
            if c == '.' and line:sub(j,j) ~= '.' then
                c = line:sub(j,j)
                j1 = j - 1
            end
        end
        if c ~= '.' then
            local brick = createBrick(c, i, j1, line:len() - j1)
            grid:addBrick(brick)
        end
        i = i + 1
    end
end

return MapManager
