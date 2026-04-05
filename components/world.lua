local World = {}
local biomes = require("components.biomes")
local BiomeMap = require("components.biome_map")

local function lerpN(a, b, t)
    return a + (b - a) * t
end

local function lerpColor(a, b, t)
    return {
        lerpN(a[1], b[1], t),
        lerpN(a[2], b[2], t),
        lerpN(a[3], b[3], t)
    }
end

local function easeInOut(t)
    return t < 0.5 and 2 * t * t or 1 - math.pow(-2 * t + 2, 2) / 2
end

function World:new(width, height, tileSize)
    local obj = {
        width    = width    or 100,
        height   = height   or 40,
        tileSize = tileSize or 32,
        tiles       = {},
        clouds      = {},
        skyElements = {},
        biomeMap    = nil,

        currentBiome     = biomes.grave,
        currentBiomeName = "grave",

        isTransitioning   = false,
        transitionProgress = 1,       
        transitionSpeed   = 1.0,      
        sourceBiome       = biomes.grave,
        targetBiome       = biomes.grave,
        transitionEndBiome = "grave",

        transitionStartPos = nil,
        transitionEndPos   = nil,
    }

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function World:getActiveBiome()
    if not self.isTransitioning or self.transitionProgress >= 1 then
        return self.currentBiome
    end

    local t = easeInOut(self.transitionProgress)
    local s = self.sourceBiome
    local g = self.targetBiome

    return {
        name = "transition",

        skyGradient = {
            top    = lerpColor(s.skyGradient.top,    g.skyGradient.top,    t),
            bottom = lerpColor(s.skyGradient.bottom, g.skyGradient.bottom, t),
        },

        groundColor    = lerpColor(s.groundColor, g.groundColor, t),
        groundVariation = lerpN(s.groundVariation, g.groundVariation, t),
        groundY        = math.floor(lerpN(s.groundY, g.groundY, t)),

        cloudColor  = lerpColor(s.cloudColor, g.cloudColor, t),
        cloudAlpha  = lerpN(s.cloudAlpha, g.cloudAlpha, t),
        cloudYRange = {
            lerpN(s.cloudYRange[1], g.cloudYRange[1], t),
            lerpN(s.cloudYRange[2], g.cloudYRange[2], t),
        },

        sporeColor = lerpColor(s.sporeColor, g.sporeColor, t),
        birdColor  = lerpColor(s.birdColor,  g.birdColor,  t),
        dustColor  = lerpColor(s.dustColor,  g.dustColor,  t),

        sporeCount = {
            math.floor(lerpN(s.sporeCount[1], g.sporeCount[1], t)),
            math.floor(lerpN(s.sporeCount[2], g.sporeCount[2], t)),
        },
        birdCount = {
            math.floor(lerpN(s.birdCount[1], g.birdCount[1], t)),
            math.floor(lerpN(s.birdCount[2], g.birdCount[2], t)),
        },
        dustCount = {
            math.floor(lerpN(s.dustCount[1], g.dustCount[1], t)),
            math.floor(lerpN(s.dustCount[2], g.dustCount[2], t)),
        },

        atmosphere = {
            fogDensity    = lerpN(s.atmosphere.fogDensity,    g.atmosphere.fogDensity,    t),
            fogColor      = lerpColor(s.atmosphere.fogColor,  g.atmosphere.fogColor,      t),
            windStrength  = lerpN(s.atmosphere.windStrength,  g.atmosphere.windStrength,  t),
            ambientLight  = lerpColor(s.atmosphere.ambientLight, g.atmosphere.ambientLight, t),
            particleDensity = lerpN(s.atmosphere.particleDensity, g.atmosphere.particleDensity, t),
        },

        terrain = {
            heightVariation = lerpN(s.terrain.heightVariation, g.terrain.heightVariation, t),
            caveDensity     = lerpN(s.terrain.caveDensity,     g.terrain.caveDensity,     t),
            treeDensity     = lerpN(s.terrain.treeDensity,     g.terrain.treeDensity,     t),
            grassDensity    = lerpN(s.terrain.grassDensity,    g.terrain.grassDensity,    t),
        },

        weather = {
            type        = t < 0.5 and s.weather.type or g.weather.type,
            intensity   = lerpN(s.weather.intensity,   g.weather.intensity,   t),
            frequency   = lerpN(s.weather.frequency,   g.weather.frequency,   t),
            temperature = lerpN(s.weather.temperature, g.weather.temperature, t),
            humidity    = lerpN(s.weather.humidity,    g.weather.humidity,    t),
        },

        effects = {
            screenShake   = lerpN(s.effects.screenShake, g.effects.screenShake, t),
            musicTrack    = t < 0.5 and s.effects.musicTrack    or g.effects.musicTrack,
            ambientSound  = t < 0.5 and s.effects.ambientSound  or g.effects.ambientSound,
            particleEffect = t < 0.5 and s.effects.particleEffect or g.effects.particleEffect,
        },
    }
end

function World:_beginTransition(targetBiomeName, startPos, endPos)
    self.sourceBiome       = self.currentBiome
    self.targetBiome       = biomes[targetBiomeName]
    self.transitionEndBiome = targetBiomeName
    self.isTransitioning   = true
    self.transitionProgress = 0
    self.transitionStartPos = startPos  
    self.transitionEndPos   = endPos
    print("Transition: " .. self.currentBiomeName .. " → " .. targetBiomeName)
end

function World:_completeTransition()
    self.currentBiome      = self.targetBiome
    self.currentBiomeName  = self.transitionEndBiome
    self.isTransitioning   = false
    self.transitionProgress = 1
    self.transitionStartPos = nil
    self.transitionEndPos   = nil
    self:regenerateCurrentArea()
    print("Arrived in " .. self.currentBiome.name)
end

function World:setBiome(biomeName, instant)
    if not biomes[biomeName] then
        print("Biome not found: " .. biomeName); return false
    end
    if biomeName == self.currentBiomeName then
        print("Already in biome: " .. biomeName); return false
    end

    if not instant then
        local allowed = false
        for _, n in ipairs(self.currentBiome.transitions.allowedNeighbors) do
            if n == biomeName then allowed = true; break end
        end
        if not allowed then
            print("Cannot transition directly from " .. self.currentBiomeName .. " to " .. biomeName)
            return false
        end
    end

    if instant then
        self.currentBiome     = biomes[biomeName]
        self.currentBiomeName = biomeName
        self.sourceBiome      = biomes[biomeName]
        self.targetBiome      = biomes[biomeName]
        self.isTransitioning  = false
        self.transitionProgress = 1
        self:generate()
        print("Instant-set biome: " .. self.currentBiome.name)
    else
        self:_beginTransition(biomeName, nil, nil)   
    end
    return true
end

function World:updateBiomeAt(playerX, playerY)
    local playerBiomeName = self.biomeMap:getBiomeAt(playerX, playerY)
    local transition      = self.biomeMap:getTransitionAt(playerX, playerY)

    if transition then
        if not self.isTransitioning or self.transitionEndBiome ~= transition.toBiome then
            local toBiome = transition.toBiome
            local allowed = false
            for _, n in ipairs(biomes[transition.fromBiome].transitions.allowedNeighbors) do
                if n == toBiome then allowed = true; break end
            end
            if not allowed then toBiome = "grave" end
            self:_beginTransition(toBiome, playerX, playerX + self.tileSize * 4)
        else
            local dist   = self.transitionEndPos - self.transitionStartPos
            local walked = playerX - self.transitionStartPos
            self.transitionProgress = math.min(1, math.max(0, walked / dist))
        end

    elseif self.isTransitioning and self.transitionStartPos then
        self:_completeTransition()

    elseif playerBiomeName ~= self.currentBiomeName and not self.isTransitioning then
        self.currentBiome     = biomes[playerBiomeName] or biomes.grave
        self.currentBiomeName = playerBiomeName
        self:regenerateCurrentArea()
    end
end

function World:update(dt)
    if self.isTransitioning and not self.transitionStartPos then
        self.transitionProgress = self.transitionProgress + dt / self.transitionSpeed
        if self.transitionProgress >= 1 then
            self:_completeTransition()
        end
    end

    for _, cloud in ipairs(self.clouds) do
        cloud.x = cloud.x + cloud.speed * dt * 60
        if cloud.x > self.width * self.tileSize + 200 then cloud.x = -200 end
        if cloud.x < -200 then cloud.x = self.width * self.tileSize + 200 end
    end

    for _, el in ipairs(self.skyElements) do
        if el.type == "spore" then
            el.x = el.x + el.speedX * dt * 60
            el.y = el.y + el.speedY * dt * 60
            el.rotation = el.rotation + el.rotSpeed * dt * 60
            if el.x >  self.width * self.tileSize + 50 then el.x = -50 end
            if el.x < -50 then el.x = self.width * self.tileSize + 50 end
            if el.y >  500 then el.y = -50 end
            if el.y < -50  then el.y =  500 end

        elseif el.type == "bird" then
            el.x = el.x + el.speed * dt * 60
            el.flapPhase = el.flapPhase + el.flapSpeed * dt
            if el.x > self.width * self.tileSize + 100 then el.x = -100 end

        elseif el.type == "dust" then
            el.y = el.y - el.speedY * dt * 60
            if el.y < -50 then
                el.y = 450
                el.x = math.random(0, self.width * self.tileSize)
            end
        end
    end
end

function World:generate()
    self.biomeMap = BiomeMap:new(self.width, self.height, self.tileSize)

    for x = 1, self.width do
        self.tiles[x] = {}
        for y = 1, self.height do
            local bName = self.biomeMap:getBiomeAt((x-1) * self.tileSize, (y-1) * self.tileSize)
            local biome = biomes[bName] or biomes.grave
            self.tiles[x][y] = y >= biome.groundY and "ground" or "air"
        end
    end

    self:generateClouds()
    self:generateSkyElements()
end

function World:generateClouds()
    self.clouds = {}
    local b = self:getActiveBiome()
    local yMin, yMax = b.cloudYRange[1], b.cloudYRange[2]

    for _ = 1, math.random(15, 25) do
        local cloud = {
            x = math.random(0, self.width * self.tileSize),
            y = math.random(yMin, yMax),
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
        table.insert(self.clouds, cloud)
    end
end

function World:generateSkyElements()
    self.skyElements = {}
    local b = self:getActiveBiome()

    for _ = 1, math.random(b.sporeCount[1], b.sporeCount[2]) do
        table.insert(self.skyElements, {
            type     = "spore",
            x        = math.random(0, self.width * self.tileSize),
            y        = math.random(0, 400),
            size     = math.random(2, 5),
            speedX   = math.random(-10, 10) / 100,
            speedY   = math.random(-5,  15) / 100,
            alpha    = math.random(20, 60) / 100,
            rotation = math.random(0, 360),
            rotSpeed = math.random(-50, 50) / 100,
            color    = b.sporeColor
        })
    end

    for _ = 1, math.random(b.birdCount[1], b.birdCount[2]) do
        table.insert(self.skyElements, {
            type      = "bird",
            x         = math.random(0, self.width * self.tileSize),
            y         = math.random(50, 200),
            size      = math.random(8, 15),
            speed     = math.random(20, 60) / 100,
            flapPhase = math.random(0, math.pi * 2),
            flapSpeed = math.random(3, 8),
            color     = b.birdColor
        })
    end

    for _ = 1, math.random(b.dustCount[1], b.dustCount[2]) do
        table.insert(self.skyElements, {
            type   = "dust",
            x      = math.random(0, self.width * self.tileSize),
            y      = math.random(0, 450),
            size   = math.random(1, 3),
            speedY = math.random(5, 20) / 100,
            alpha  = math.random(10, 40) / 100,
            color  = b.dustColor
        })
    end
end

function World:regenerateCurrentArea()
    self:generateClouds()
    self:generateSkyElements()
end

function World:draw(cameraX, cameraY)
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()
    local b = self:getActiveBiome()

    for i = 0, screenH do
        local p = i / screenH
        love.graphics.setColor(
            b.skyGradient.top[1] + p * (b.skyGradient.bottom[1] - b.skyGradient.top[1]),
            b.skyGradient.top[2] + p * (b.skyGradient.bottom[2] - b.skyGradient.top[2]),
            b.skyGradient.top[3] + p * (b.skyGradient.bottom[3] - b.skyGradient.top[3])
        )
        love.graphics.line(0, i, screenW, i)
    end

    for _, cloud in ipairs(self.clouds) do
        local dx = cloud.x - cameraX
        local dy = cloud.y - cameraY
        love.graphics.setColor(b.cloudColor[1], b.cloudColor[2], b.cloudColor[3], b.cloudAlpha)
        for _, seg in ipairs(cloud.segments) do
            love.graphics.circle("fill", dx + seg.x, dy + seg.y, seg.radius)
        end
    end

    for _, el in ipairs(self.skyElements) do
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

    local startX = math.max(1, math.floor(cameraX / self.tileSize) - 2)
    local endX   = math.min(self.width,  math.floor((cameraX + screenW) / self.tileSize) + 2)
    local startY = math.max(1, math.floor(cameraY / self.tileSize) - 2)
    local endY   = math.min(self.height, math.floor((cameraY + screenH) / self.tileSize) + 2)

    for x = startX, endX do
        for y = startY, endY do
            if self.tiles[x][y] == "ground" then
                local tileBiomeName = self.biomeMap:getBiomeAt((x-1) * self.tileSize, (y-1) * self.tileSize)
                local tileBiome     = biomes[tileBiomeName] or biomes.grave
                local gc  = tileBiome.groundColor
                local gv  = tileBiome.groundVariation
                local gy  = tileBiome.groundY

                if self.isTransitioning then
                    local tz = self.biomeMap:getTransitionAt((x-1) * self.tileSize, (y-1) * self.tileSize)
                    if tz then
                        local t = self.transitionProgress
                        gc = lerpColor(self.sourceBiome.groundColor, self.targetBiome.groundColor, t)
                        gv = lerpN(self.sourceBiome.groundVariation, self.targetBiome.groundVariation, t)
                        gy = math.floor(lerpN(self.sourceBiome.groundY, self.targetBiome.groundY, t))
                    end
                end

                local v = math.sin(x * 0.5) * gv
                love.graphics.setColor(gc[1] + v, gc[2] + v, gc[3] + v)
                love.graphics.rectangle("fill",
                    (x-1) * self.tileSize - cameraX,
                    (y-1) * self.tileSize - cameraY,
                    self.tileSize - 1, self.tileSize - 1)

                if y == gy then
                    love.graphics.setColor(gc[1]+0.1, gc[2]+0.08, gc[3]+0.07, 0.5)
                    love.graphics.points(
                        (x-1)*self.tileSize - cameraX + math.random(self.tileSize),
                        (y-1)*self.tileSize - cameraY)
                end
            end
        end
    end

    if b.atmosphere.fogDensity > 0 then
        local fc = b.atmosphere.fogColor
        love.graphics.setColor(fc[1], fc[2], fc[3], b.atmosphere.fogDensity)
        love.graphics.rectangle("fill", 0, 0, screenW, screenH)
    end

    if self.showDebugBiomes then
        self:drawDebugBiomeOverlay(cameraX, cameraY)
    end
end

function World:drawDebugBiomeOverlay(cameraX, cameraY)
    love.graphics.setFont(love.graphics.newFont(10))
    local colors = {
        grave={0.5,0.3,0.6}, forest={0.3,0.6,0.3}, crystal={0.4,0.4,0.8},
        ash={0.5,0.4,0.4},   dream={0.7,0.4,0.8},  decay={0.4,0.3,0.3},
        bloom={0.8,0.5,0.7}, abyss={0.2,0.2,0.3},  sunset={0.8,0.5,0.4},
        frost={0.4,0.6,0.8}, miasma={0.5,0.6,0.3}, void={0.1,0.1,0.2}
    }
    for x = 1, self.width, 4 do
        for y = 1, self.height, 4 do
            local name = self.biomeMap:getBiomeAt((x-1)*self.tileSize, (y-1)*self.tileSize)
            if name then
                local c = colors[name] or {1,1,1}
                love.graphics.setColor(c[1], c[2], c[3], 0.5)
                love.graphics.rectangle("fill",
                    (x-1)*self.tileSize - cameraX, (y-1)*self.tileSize - cameraY,
                    self.tileSize*4, self.tileSize*4)
                love.graphics.setColor(1,1,1,0.8)
                love.graphics.print(string.sub(name,1,3),
                    (x-1)*self.tileSize - cameraX + 5,
                    (y-1)*self.tileSize - cameraY + 5)
            end
        end
    end
end

function World:isGround(x, y)
    local tx = math.floor(x / self.tileSize) + 1
    local ty = math.floor(y / self.tileSize) + 1
    if tx < 1 or tx > self.width or ty < 1 or ty > self.height then return true end
    return self.tiles[tx][ty] == "ground"
end

return World
