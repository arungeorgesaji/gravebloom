local biomes = require("components.biomes")
local utils  = require("world.utils")

local lerpN     = utils.lerpN
local lerpColor = utils.lerpColor

local Render = {}

local DEBUG_COLORS = {
    grave  = {0.5, 0.3, 0.6}, forest  = {0.3, 0.6, 0.3},
    crystal= {0.4, 0.4, 0.8}, ash     = {0.5, 0.4, 0.4},
    dream  = {0.7, 0.4, 0.8}, decay   = {0.4, 0.3, 0.3},
    bloom  = {0.8, 0.5, 0.7}, abyss   = {0.2, 0.2, 0.3},
    sunset = {0.8, 0.5, 0.4}, frost   = {0.4, 0.6, 0.8},
    miasma = {0.5, 0.6, 0.3}, void    = {0.1, 0.1, 0.2},
}

function Render.generateClouds(world)
    world.clouds = {}
    local b = world:getActiveBiome()
    local yMin, yMax = b.cloudYRange[1], b.cloudYRange[2]

    for _ = 1, math.random(15, 25) do
        local cloud = {
            x      = math.random(0, world.width * world.tileSize),
            y      = math.random(yMin, yMax),
            width  = math.random(60, 150),
            height = math.random(30, 60),
            speed  = math.random(10, 30) / 100,
            alpha  = b.cloudAlpha,
            segments = {}
        }
        for _ = 1, math.random(3, 6) do
            table.insert(cloud.segments, {
                x      = math.random(-cloud.width/3,  cloud.width/3),
                y      = math.random(-cloud.height/4, cloud.height/4),
                radius = math.random(cloud.width/4,   cloud.width/2)
            })
        end
        table.insert(world.clouds, cloud)
    end
end

function Render.generateSkyElements(world)
    world.skyElements = {}
    local b = world:getActiveBiome()

    for _ = 1, math.random(b.sporeCount[1], b.sporeCount[2]) do
        table.insert(world.skyElements, {
            type     = "spore",
            x        = math.random(0, world.width * world.tileSize),
            y        = math.random(0, 400),
            size     = math.random(2, 5),
            speedX   = math.random(-10, 10) / 100,
            speedY   = math.random(-5,  15) / 100,
            alpha    = math.random(20, 60) / 100,
            rotation = math.random(0, 360),
            rotSpeed = math.random(-50, 50) / 100,
            color    = b.sporeColor,
        })
    end

    for _ = 1, math.random(b.birdCount[1], b.birdCount[2]) do
        table.insert(world.skyElements, {
            type      = "bird",
            x         = math.random(0, world.width * world.tileSize),
            y         = math.random(50, 200),
            size      = math.random(8, 15),
            speed     = math.random(20, 60) / 100,
            flapPhase = math.random(0, math.pi * 2),
            flapSpeed = math.random(3, 8),
            color     = b.birdColor,
        })
    end

    for _ = 1, math.random(b.dustCount[1], b.dustCount[2]) do
        table.insert(world.skyElements, {
            type   = "dust",
            x      = math.random(0, world.width * world.tileSize),
            y      = math.random(0, 450),
            size   = math.random(1, 3),
            speedY = math.random(5, 20) / 100,
            alpha  = math.random(10, 40) / 100,
            color  = b.dustColor,
        })
    end
end

function Render.draw(world, cameraX, cameraY)
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()
    local b = world:getActiveBiome()

    for i = 0, screenH do
        local p = i / screenH
        love.graphics.setColor(
            b.skyGradient.top[1] + p * (b.skyGradient.bottom[1] - b.skyGradient.top[1]),
            b.skyGradient.top[2] + p * (b.skyGradient.bottom[2] - b.skyGradient.top[2]),
            b.skyGradient.top[3] + p * (b.skyGradient.bottom[3] - b.skyGradient.top[3])
        )
        love.graphics.line(0, i, screenW, i)
    end

    for _, cloud in ipairs(world.clouds) do
        local dx = cloud.x - cameraX
        local dy = cloud.y - cameraY
        love.graphics.setColor(b.cloudColor[1], b.cloudColor[2], b.cloudColor[3], b.cloudAlpha)
        for _, seg in ipairs(cloud.segments) do
            love.graphics.circle("fill", dx + seg.x, dy + seg.y, seg.radius)
        end
    end

    for _, el in ipairs(world.skyElements) do
        local dx = el.x - cameraX
        local dy = el.y - cameraY

        if el.type == "spore" then
            love.graphics.setColor(el.color[1], el.color[2], el.color[3], el.alpha)
            love.graphics.circle("fill", dx, dy, el.size)
            love.graphics.setColor(el.color[1], el.color[2], el.color[3], el.alpha * 0.5)
            love.graphics.circle("fill", dx, dy, el.size * 2)

        elseif el.type == "bird" then
            love.graphics.setColor(el.color[1], el.color[2], el.color[3], 0.6)
            local wo = math.sin(el.flapPhase) * 3
            love.graphics.line(dx, dy, dx - el.size, dy - el.size/2 - wo, dx - el.size/2, dy, dx, dy)
            love.graphics.line(dx, dy, dx + el.size, dy - el.size/2 - wo, dx + el.size/2, dy, dx, dy)

        elseif el.type == "dust" then
            love.graphics.setColor(el.color[1], el.color[2], el.color[3], el.alpha)
            love.graphics.circle("fill", dx, dy, el.size)
        end
    end

    local startX = math.max(1, math.floor(cameraX / world.tileSize) - 2)
    local endX   = math.min(world.width,  math.floor((cameraX + screenW) / world.tileSize) + 2)
    local startY = math.max(1, math.floor(cameraY / world.tileSize) - 2)
    local endY   = math.min(world.height, math.floor((cameraY + screenH) / world.tileSize) + 2)

    for x = startX, endX do
        for y = startY, endY do
            if world.tiles[x][y] == "ground" then
                local tileBiomeName = world.biomeMap:getBiomeAt((x-1)*world.tileSize, (y-1)*world.tileSize)
                local tileBiome     = biomes[tileBiomeName] or biomes.grave
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
        end
    end

    if b.atmosphere.fogDensity > 0 then
        local fc = b.atmosphere.fogColor
        love.graphics.setColor(fc[1], fc[2], fc[3], b.atmosphere.fogDensity)
        love.graphics.rectangle("fill", 0, 0, screenW, screenH)
    end

    if world.showDebugBiomes then
        Render.drawDebugOverlay(world, cameraX, cameraY)
    end
end

function Render.drawDebugOverlay(world, cameraX, cameraY)
    love.graphics.setFont(love.graphics.newFont(10))
    for x = 1, world.width, 4 do
        for y = 1, world.height, 4 do
            local name = world.biomeMap:getBiomeAt((x-1)*world.tileSize, (y-1)*world.tileSize)
            if name then
                local c = DEBUG_COLORS[name] or {1, 1, 1}
                love.graphics.setColor(c[1], c[2], c[3], 0.5)
                love.graphics.rectangle("fill",
                    (x-1)*world.tileSize - cameraX, (y-1)*world.tileSize - cameraY,
                    world.tileSize*4, world.tileSize*4)
                love.graphics.setColor(1, 1, 1, 0.8)
                love.graphics.print(string.sub(name, 1, 3),
                    (x-1)*world.tileSize - cameraX + 5,
                    (y-1)*world.tileSize - cameraY + 5)
            end
        end
    end
end

return Render
