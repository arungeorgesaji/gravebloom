local game = {}
local World = require("components.world")
local Player = require("components.player")

local world
local player
local cameraX = 0

function game.load()
    world = World:new(100, 30)
    world:generate()
    player = Player:new(world)
end

function game.update(dt)
    player:update(dt)
    world:update(dt)

    cameraX = player.x + player.width/2 - love.graphics.getWidth()/2
    cameraY = player.y + player.height/2 - love.graphics.getHeight()/2
    
    cameraX = math.max(0, math.min(cameraX, world.width * world.tileSize - love.graphics.getWidth()))
    cameraY = math.max(0, math.min(cameraY, world.height * world.tileSize - love.graphics.getHeight()))
end

function game.draw()
    world:draw(cameraX, 0)
    player:draw()
end

return game
