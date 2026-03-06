require("components/button")
require("components/text")
menu = require("rooms/menu")

function love.load()
    menuMusic = love.audio.newSource("audio/menu_music.mp3", "stream")

    menuMusic:setLooping(true)
    menuMusic:setVolume(0.5)
    menuMusic:play()

    gameState = "menu"
    menu.load()
end

function love.update(dt)
    if gameState == "menu" then
        menu.update(dt)
    elseif gameState == "game" then
    end
end

function love.draw()
    if gameState == "menu" then
        menu.draw()
    elseif gameState == "game" then
    end
end

function love.mousepressed(x, y, button)
    if gameState == "menu" then
        menu.mousepressed(x, y, button)
    end
end
