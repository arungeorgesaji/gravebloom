local options = {}
local Background = require("components.background")

function options.load()
    Background.load()
end

function options.update(dt)
    Background.update(dt)
end 

function options.draw()
    Background.draw()
end 

function options.draw()
    Background.draw()
    title:draw()
end 

function options.mousepressed(x, y, button)
end

function options.mousereleased(x, y, button)
end

return options
