local game = {}
local World = require("components.world")
local Player = require("components.player")

local world
local player
local cameraX = 0
local cameraY = 0
local showDebug = false

function game.load()
    world = World:new(1000, 60, 32) 
    world:generate()
    player = Player:new(world)
    
    player.x = world.width * world.tileSize / 2
    player.y = (world.currentBiome.groundY - 2) * world.tileSize
end

function game.update(dt)
    player:update(dt)

    world:updateBiomeAt(
        player.x + player.width/2,
        player.y + player.height/2,
        cameraX,
        cameraY
    )

    world:update(dt)

    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    local targetX = player.x + player.width/2 - screenW / 2
    local targetY = player.y + player.height/2 - screenH * 0.6

    targetX = targetX + (player.vx or 0) * 0.2

    local smooth = 5
    cameraX = cameraX + (targetX - cameraX) * smooth * dt
    cameraY = cameraY + (targetY - cameraY) * smooth * dt

    cameraX = math.max(0, math.min(cameraX, world.width * world.tileSize - screenW))
    cameraY = math.max(0, math.min(cameraY, world.height * world.tileSize - screenH))
end

function game.keypressed(key)
    if key == "m" then
        showDebug = not showDebug
        world.showDebugBiomes = showDebug
    end
    
    if key == "escape" then
        love.event.quit()
    end
end

function game.draw()
    world:draw(cameraX, cameraY)
    player:draw(cameraX, cameraY)
    
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.setFont(love.graphics.newFont(12))
    
    local currentBiomeName = world.currentBiome.name or world.currentBiomeName
    love.graphics.print("Current Biome: " .. currentBiomeName, 10, 10)
    
    if world.isTransitioning then
        love.graphics.setColor(1, 0.8, 0.2, 0.9)
        love.graphics.print("TRANSITIONING: " .. string.format("%.0f%%", world.transitionProgress * 100), 10, 30)
        love.graphics.print("From: " .. world.transitionStartBiome, 10, 50)
        love.graphics.print("To: " .. world.transitionEndBiome, 10, 70)
    end
    
    love.graphics.setColor(0.7, 0.9, 0.7, 0.8)
    love.graphics.print("Press M to toggle biome debug view", 10, love.graphics.getHeight() - 20)
    love.graphics.print("Explore the world to discover different biomes!", 10, love.graphics.getHeight() - 40)
end

return game
