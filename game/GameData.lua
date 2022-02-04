local GameData = {
    score = 0,
    maxScore = 0,
    lives = 3,
    unlockedStage = 1
}

local function basicSerialize (o)
    if type(o) == "number" then
        return tostring(o)
    else
        return string.format("%q", o)
    end
end

local function save(fd, name, value, saved)
    saved = saved or {}
    fd:write(name, " = ")
    if type(value) == "number" or type(value) == "string" then
        fd:write(basicSerialize(value), "\n")
    elseif type(value) == "table" then
        if saved[value] then
            fd:write(saved[value], "\n")
        else
            saved[value] = name
            fd:write("{}\n")
            for k,v in pairs(value) do
                local fieldname = string.format("%s[%s]", name, basicSerialize(k))
                save(fd, fieldname, v, saved)
            end
        end
    else
        error("cannot save a " .. type(value))
    end
end

local function exists(filename)
    local fd = io.open(filename,"r")
    if fd ~= nil then 
        fd:close() 
        return true 
    else 
        return false 
    end
 end
 
function GameData.save()
    local data = {
        unlockedStage = GameData.unlockedStage,
        maxScore = GameData.maxScore
    }
    local fd = io.open("SavedData.lua", "w")
    save(fd, "SavedData", data)
    fd:close()
end

function GameData.load()
    if exists("SavedData.lua") then
        require("SavedData")
        GameData.maxScore = SavedData.maxScore
        GameData.unlockedStage = SavedData.unlockedStage
    end
end

return GameData
