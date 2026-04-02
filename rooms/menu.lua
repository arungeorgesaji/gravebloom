local menu = {}
local Background = require("components.background")

function startGame()
    changeRoom("game") 
end

function showOptions()
    changeRoom("options")
end

function showAchievements()
    changeRoom("achievements")
end

function showExtras()
    changeRoom("extras")
end

function quitGame()
    room = "quit"
    love.event.quit()
end

function menu.load()
    Background.load()

    title = Text:new("GraveBloom", nil, 30, 40) 

    startButton = Button:new("Start", nil, 100, 500, 60, startGame, 24, "neon")
    optionsButton = Button:new("Options", nil, 200, 500, 60, showOptions, 24, "neon")
    achievementsButton = Button:new("Achievements", nil, 300, 500, 60, showAchievements, 24, "neon")
    extrasButton = Button:new("Extras", nil, 400, 500, 60, showExtras, 24, "neon")
    quitButton = Button:new("Quit", nil, 500, 500, 60, quitGame, 24, "neon")

    scrollSound = love.audio.newSource("audio/menu_scroll.wav", "static")
    selectSound = love.audio.newSource("audio/menu_select.wav", "static")

    scrollSound:setPitch(love.math.random(95,105)/100)
    scrollSound:setVolume(0.01)
    selectSound:setVolume(0.1)

    buttons = {
        startButton,
        optionsButton,
        achievementsButton,
        extrasButton,
        quitButton
    }
end

function menu.update(dt)
    Background.update(dt)

    for _, b in ipairs(buttons) do
        b:update(dt)

        if b.hoverChanged then
            scrollSound:stop()
            scrollSound:play()
        end
    end
end

function menu.draw()
    Background.draw() 
    
    title:draw()
    startButton:draw()
    optionsButton:draw()
    achievementsButton:draw()
    extrasButton:draw()
    quitButton:draw()
end

function menu.mousepressed(x, y, button)
    for _, b in ipairs(buttons) do
        b:mousepressed(x, y, button)
    end
end

function menu.mousereleased(x, y, button)
    for _, b in ipairs(buttons) do
        if b.pressed and b.hover then
            love.audio.play(selectSound)
        end

        b:mousereleased(x, y, button)
    end
end

return menu
