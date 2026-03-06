require("components.button")
require("components.text")

menu = require("rooms.menu")
options = require("rooms.options")

function love.load()
    menuMusic = love.audio.newSource("audio/menu_music.mp3", "stream")

    menuMusic:setLooping(true)
    menuMusic:setVolume(0.5)
    menuMusic:play()

    room = "menu"
    menu.load()
end

function love.update(dt)
    if room == "menu" then
        menu.update(dt)
    elseif room == "options" then
        options.update(dt)
    end
end

function love.draw()
    if room == "menu" then
        menu.draw()
    elseif room == "options" then
        options.draw()
    end
end

function love.mousepressed(x, y, button)
    if room == "menu" then
        menu.mousepressed(x, y, button)
    elseif room == "options" then
        options.mousepressed(x, y, button)
    end
end

function love.mousereleased(x, y, button)
    if room == "menu" then
        menu.mousereleased(x, y, button)
    elseif room == "options" then
        options.mousereleased(x, y, button)
    end
end
