local World      = {}
local biomes     = require("components.biomes")
local BiomeMap   = require("components.biome_map")
local Transition = require("world.transition")
local Render     = require("world.render.core")
local CloudGenerator = require("world.generation.clouds")
local SkyElementGenerator = require("world.generation.sky_elements")
local GroundDecorations = require("world.generation.ground_decorations")
local MobSpawner = require("mobs.mob_spawner")

function World:new(width, height, tileSize)
    local obj = {
        width    = width    or 100,
        height   = height   or 40,
        tileSize = tileSize or 32,

        tiles       = {},
        groundDecorations = {},
        clouds      = {},
        skyElements = {},
        biomeMap    = nil,

        currentBiome     = biomes.grave,
        currentBiomeName = "grave",

        mobSpawner = nil,

        isTransitioning    = false,
        transitionProgress = 1,
        transitionSpeed    = 1.0,
        sourceBiome        = biomes.grave,
        targetBiome        = biomes.grave,
        transitionEndBiome = "grave",
        transitionStartPos = nil,
        transitionEndPos   = nil,

        showDebugBiomes = false,
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function World:getActiveBiome()
    return Transition.getActiveBiome(self)
end

function World:generate()
    self.biomeMap = BiomeMap:new(self.width, self.height, self.tileSize, { startBiome = "forest" })

    spawnX = self.width * self.tileSize / 2
    spawnY = (self.currentBiome.groundY - 2) * self.tileSize

    local bName = self.biomeMap:getBiomeAt(spawnX, spawnY)

    self.currentBiomeName = bName
    self.currentBiome = biomes[bName] or biomes.grave

    for x = 1, self.width do
        self.tiles[x] = {}
        for y = 1, self.height do
            local bName = self.biomeMap:getBiomeAt((x-1)*self.tileSize, (y-1)*self.tileSize)
            local biome = biomes[bName] or biomes.grave
            self.tiles[x][y] = y >= biome.groundY and "ground" or "air"
        end
    end

    self.mobSpawner = MobSpawner:new(self, self.player)

    -- self:generateGroundDecorations()
    self:generateClouds()
    self:generateSkyElements()
end

function World:generateGroundDecorations() self.groundDecorations = GroundDecorations.generate(self) end
function World:generateClouds()        self.clouds = CloudGenerator.generate(self)      end
function World:generateSkyElements()   self.skyElements = SkyElementGenerator.generate(self) end
function World:regenerateCurrentArea() self:generateClouds(); self:generateSkyElements() end

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
        self.currentBiome      = biomes[biomeName]
        self.currentBiomeName  = biomeName
        self.sourceBiome       = biomes[biomeName]
        self.targetBiome       = biomes[biomeName]
        self.isTransitioning   = false
        self.transitionProgress = 1

        if self.mobSpawner then
            self.mobSpawner:setBiome(self.currentBiome)
        end

        self:generate()
        print("Instant-set biome: " .. self.currentBiome.name)
    else
        Transition.begin(self, biomeName, nil, nil)
    end
    return true
end

function World:updateBiomeAt(playerX, playerY)
    Transition.updateBiomeAt(self, playerX, playerY)
end

function World:update(dt, player)
    Transition.updateTimeBased(self, dt)

    if self.mobSpawner then
        self.mobSpawner:update(dt, self.player)
    end

    for _, cloud in ipairs(self.clouds) do
        cloud.x = cloud.x + cloud.speed * dt * 60
        if cloud.x >  self.width * self.tileSize + 200 then cloud.x = -200 end
        if cloud.x < -200 then cloud.x = self.width * self.tileSize + 200 end
    end

    for _, el in ipairs(self.skyElements) do
        if el.type == "spore" then
            el.x = el.x + el.speedX * dt * 60
            el.y = el.y + el.speedY * dt * 60
            el.rotation = el.rotation + el.rotSpeed * dt * 60
            if el.x >  self.width * self.tileSize + 50 then el.x = -50 end
            if el.x < -50  then el.x = self.width * self.tileSize + 50 end
            if el.y >  500  then el.y = -50 end
            if el.y < -50   then el.y =  500 end

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

function World:draw(cameraX, cameraY)
    Render.draw(self, cameraX, cameraY)

    if self.mobSpawner then
        self.mobSpawner:draw(cameraX, cameraY)
    end
end

function World:isGround(x, y)
    local tx = math.floor(x / self.tileSize) + 1
    local ty = math.floor(y / self.tileSize) + 1
    if tx < 1 or tx > self.width or ty < 1 or ty > self.height then return true end

    local tileBiomeName = self.biomeMap:getBiomeAt((tx-1)*self.tileSize, (ty-1)*self.tileSize)
    local tileBiome = biomes[tileBiomeName] or biomes.grave
    local heightVariation = tileBiome.terrain.heightVariation

    local noiseVal = math.sin(tx * 0.15) * 0.5 + math.sin(tx * 0.37) * 0.3
    local heightOffset = (heightVariation > 0) and math.floor(noiseVal * heightVariation) or 0

    local lookupTy = ty - heightOffset
    if lookupTy < 1 or lookupTy > self.height then return true end

    return self.tiles[tx][lookupTy] == "ground"
end

return World
