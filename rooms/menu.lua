local menu = {}

function startGame()
    gameState = "game"
end

function menu.load()
  startButton = Button:new("Start", nil, 200, 500, 60, startGame)
end

function menu.update(dt)
    startButton:update(dt)
end

function menu.draw()
    startButton:draw()
end

function menu.mousepressed(x, y, button)
    startButton:mousepressed(x, y, button)
end

return menu
