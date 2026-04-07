local biomes = require("components.biomes")
local utils = require("world.utils")
local lerpN = utils.lerpN
local lerpColor = utils.lerpColor

local TileRenderer = {}

local function getTileBiomeData(world, x, y)
    local tileBiomeName = world.biomeMap:getBiomeAt((x-1)*world.tileSize, (y-1)*world.tileSize)
    local tileBiome = biomes[tileBiomeName] or biomes.grave
    
    local gc = tileBiome.groundColor
    local gv = tileBiome.groundVariation
    local gy = tileBiome.groundY

    if world.isTransitioning then
        local tz = world.biomeMap:getTransitionAt((x-1)*world.tileSize, (y-1)*world.tileSize)
        if tz then
            local t = world.transitionProgress
            gc = lerpColor(world.sourceBiome.groundColor, world.targetBiome.groundColor, t)
            gv = lerpN(world.sourceBiome.groundVariation, world.targetBiome.groundVariation, t)
            gy = math.floor(lerpN(world.sourceBiome.groundY, world.targetBiome.groundY, t))
        end
    end
    
    return gc, gv, gy
end

local function drawTile(world, x, y, cameraX, cameraY, gc, gv, gy)
    local v = math.sin(x * 0.5) * gv
    love.graphics.setColor(gc[1]+v, gc[2]+v, gc[3]+v)
    love.graphics.rectangle("fill",
        (x-1)*world.tileSize - cameraX,
        (y-1)*world.tileSize - cameraY,
        world.tileSize - 1, world.tileSize - 1)

    if y == gy then
        love.graphics.setColor(gc[1]+0.1, gc[2]+0.08, gc[3]+0.07, 0.5)
        love.graphics.points(
            (x-1)*world.tileSize - cameraX + math.random(world.tileSize),
            (y-1)*world.tileSize - cameraY)
    end
end

function TileRenderer.drawVisibleTiles(world, cameraX, cameraY, screenW, screenH)
    local startX = math.max(1, math.floor(cameraX / world.tileSize) - 2)
    local endX = math.min(world.width, math.floor((cameraX + screenW) / world.tileSize) + 2)
    local startY = math.max(1, math.floor(cameraY / world.tileSize) - 2)
    local endY = math.min(world.height, math.floor((cameraY + screenH) / world.tileSize) + 2)

    for x = startX, endX do
        for y = startY, endY do
            if world.tiles[x][y] == "ground" then
                local gc, gv, gy = getTileBiomeData(world, x, y)
                drawTile(world, x, y, cameraX, cameraY, gc, gv, gy)
            end
        end
    end
end

return TileRenderer
