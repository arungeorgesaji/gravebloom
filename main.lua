require("components.button")
require("components.text")

menu = require("rooms.menu")
options = require("rooms.options")
achievements = require("rooms.achievements")
extras = require("rooms.extras")

rooms = {
    game = game,
    menu = menu,
    options = options,
    achievements = achievements,
    extras = extras
}

function love.load()
    menuMusic = love.audio.newSource("audio/menu_music.mp3", "stream")

    menuMusic:setLooping(true)
    menuMusic:setVolume(0.5)
    menuMusic:play()

    currentRoom = "menu"
    
    for name, room in pairs(rooms) do
        if room.load then
            room.load()
        end
    end
end

function love.update(dt)
    local room = rooms[currentRoom]
    if room and room.update then
        room.update(dt)
    end
end

function love.draw()
    local room = rooms[currentRoom]
    if room and room.draw then
        room.draw()
    end
end

function love.mousepressed(x, y, button)
    local room = rooms[currentRoom]
    if room and room.mousepressed then
        room.mousepressed(x, y, button)
    end
end

function love.mousereleased(x, y, button)
    local room = rooms[currentRoom]
    if room and room.mousereleased then
        room.mousereleased(x, y, button)
    end
end

function changeRoom(newRoom)
    if rooms[newRoom] then
        local current = rooms[currentRoom]
        if current and current.exit then
            current.exit()
        end
        
        currentRoom = newRoom
        
        local nextRoom = rooms[currentRoom]
        if nextRoom and nextRoom.enter then
            nextRoom.enter()
        end
    else
        print("Warning: Room '" .. newRoom .. "' does not exist!")
    end
end
