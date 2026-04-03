local game = {}
local World = require("components.world")
local Player = require("components.player")

local world
local player
local cameraX = 0

function game.load()
    world = World:new(100, 30, "grave")
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

function game.keypressed(key)
    if key == "b" then
        local biomes = {"grave", "forest", "crystal", "ash"}
        local biomes = {"grave", "forest", "crystal", "ash", "dream", "decay", "bloom", "abyss", "sunset", "frost", "miasma", "void"}
        local currentIndex = 1
        for i, name in ipairs(biomes) do
            if name == world.biome.name:lower() then
                currentIndex = i
                break
            end
        end
        local nextBiome = biomes[(currentIndex % #biomes) + 1]
        world:setBiome(nextBiome)
        world:generate()  
    end
end

function game.draw()
    world:draw(cameraX, 0)
    player:draw()
end

return game
