local MobSpawner = {}
MobSpawner.__index = MobSpawner

local DEBUG = true

local mobRegistry = {
    rabbit = require("mobs.mobs.rabbit"), 
}

local function debugPrint(msg)
    if DEBUG then
        print("[MobSpawner] " .. msg)
    end
end

local function findGroundY(world, worldX)
    local ts = world.tileSize
    for ty = 1, world.height do
        local checkY = ty * ts
        if world:isGround(worldX, checkY) then
            return (ty - 1) * ts
        end
    end
    return nil  
end

function MobSpawner:new(world, player)
    local obj = {
        world        = world,
        mobs         = {},
        spawnTimer   = 0,
    }
    setmetatable(obj, MobSpawner)

    if player then
        obj:initialSpawn(player)
    end

    return obj
end

function MobSpawner:update(dt, player)
    if not self._initialized then
        self._initialized = true
        self:initialSpawn(player)
    end

    for i = #self.mobs, 1, -1 do
        local mob = self.mobs[i]
        mob:update(dt, player)
        if mob.health <= 0 then
            debugPrint("Mob died, removing index " .. i)
            table.remove(self.mobs, i)
        end
    end

    local activeBiome = self.world:getActiveBiome()
    local spawnRate = activeBiome.entities.mobSpawnRate
    if not spawnRate or spawnRate <= 0 then end

    local spawnCooldown = 1 / spawnRate
    self.spawnTimer = self.spawnTimer + dt

    local maxMobs = 20

    if self.spawnTimer >= spawnCooldown and #self.mobs < maxMobs then
        debugPrint("Attempting spawn. Current mob count: " .. #self.mobs)
        self:trySpawnMob(player)
        self.spawnTimer = 0
    end
end

function MobSpawner:trySpawnMob(player)
    local isPassive = math.random() < 0.7
    local activeBiome = self.world:getActiveBiome()
    local mobTypes = isPassive and activeBiome.entities.passiveMobs or activeBiome.entities.hostileMobs

    debugPrint("Trying " .. (isPassive and "passive" or "hostile") .. " spawn")

    if not mobTypes or #mobTypes == 0 then
        debugPrint("No mob types in this category, skipping")
        return
    end

    -- local mobName  = mobTypes[math.random(#mobTypes)]
    local mobName = "rabbit"
    local mobClass = mobRegistry[mobName]

    if not mobClass then
        debugPrint("ERROR: mob type '" .. mobName .. "' not in registry — add it to mobRegistry in mob_spawner.lua")
        return
    end

    local ts         = self.world.tileSize
    local worldW     = self.world.width * ts
    local side       = (math.random() < 0.5) and -1 or 1          
    local distance   = math.random(300, 600)                       
    local spawnX     = player.x + side * distance

    spawnX = math.max(ts, math.min(spawnX, worldW - ts))

    local spawnY = nil
    for attempt = 0, 4 do
        local tryX = spawnX + attempt * ts * side   
        tryX = math.max(ts, math.min(tryX, worldW - ts))
        spawnY = findGroundY(self.world, tryX)
        if spawnY then
            spawnX = tryX
            break
        end
    end

    if not spawnY then
        debugPrint("Could not find ground near x=" .. math.floor(spawnX) .. ", skipping spawn")
        return
    end

    debugPrint(string.format(
        "Spawning '%s' at (%.1f, %.1f) — side=%s dist=%d",
        mobName, spawnX, spawnY,
        side == -1 and "left" or "right",
        distance
    ))

    local newMob = mobClass:new(self.world, spawnX, spawnY, activeBiome)

    table.insert(self.mobs, newMob)
    debugPrint("Total mobs: " .. #self.mobs)
end

function MobSpawner:draw(cameraX, cameraY)
    for _, mob in ipairs(self.mobs) do
        mob:draw(cameraX, cameraY)
    end
end

function MobSpawner:initialSpawn(player)
    local targetCount = 5  

    debugPrint("Initial spawn: targeting " .. targetCount .. " mobs")
    for i = 1, targetCount do
        self:trySpawnMob(player)
    end
    debugPrint("Initial spawn complete. Mobs placed: " .. #self.mobs)
end

return MobSpawner
