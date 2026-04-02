local achievements = {}
local Background = require("components.background")
local title

function goToMenu()
    changeRoom("menu")
end

function achievements.load()
    Background.load()
    title = Text:new("Achievements", nil, 30, 40) 
    backButton = Button:new("Back", 30, 30, 120, 50, goToMenu, 20, "rounded")
end

function achievements.update(dt)
    Background.update(dt)

    if backButton and backButton.update then
        backButton:update(dt)
    end
end 

function achievements.draw()
    Background.draw()
    title:draw()

    if backButton and backButton.draw then
        backButton:draw()
    end
end 

function achievements.mousepressed(x, y, button)
    if backButton and backButton.mousepressed then
        backButton:mousepressed(x, y, button)
    end
end

function achievements.mousereleased(x, y, button)
    if backButton and backButton.mousereleased then
        if backButton.pressed and backButton.hover then
            love.audio.play(selectSound)
        end

        backButton:mousereleased(x, y, button)
    end
end

return achievements
