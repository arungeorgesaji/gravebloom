local MobSpawner = {}
MobSpawner.__index = MobSpawner

local mobRegistry = {
    rabbit = require("mobs.rabbit"),
}

function MobSpawner:new(world, currentBiome)
    local obj = {
        world = world,
        currentBiome = currentBiome,
        mobs = {},
        spawnTimer = 0,
    }
    setmetatable(obj, MobSpawner)
    return obj
end

function MobSpawner:update(dt, player)
    for i = #self.mobs, 1, -1 do
        local mob = self.mobs[i]
        mob:update(dt, player)
        if mob.health <= 0 then
            table.remove(self.mobs, i)
        end
    end
    
    local spawnRate = self.currentBiome.entities.mobSpawnRate
    self.spawnTimer = self.spawnTimer + dt
    
    local maxMobs = 20 
    if self.spawnTimer > (1 / spawnRate) and #self.mobs < maxMobs then
        self:trySpawnMob(player)
        self.spawnTimer = 0
    end
end

function MobSpawner:trySpawnMob(player)
    local mobTypes = {}
    
    if math.random() < 0.7 then 
        mobTypes = self.currentBiome.entities.passiveMobs
    else
        mobTypes = self.currentBiome.entities.hostileMobs
    end
    
    if #mobTypes == 0 then return end
    
    local mobName = mobTypes[math.random(#mobTypes)]
    local mobClass = mobRegistry[mobName]
    
    if not mobClass then
        print("Warning: Unknown mob type: " .. mobName)
        return
    end
    
    local angle = math.random() * math.pi * 2
    local distance = math.random(200, 400)
    local spawnX = player.x + math.cos(angle) * distance
    local spawnY = player.y - 50
    
    local ts = self.world.tileSize
    spawnX = math.max(10, math.min(spawnX, self.world.width * ts - 50))
    
    local newMob = mobClass:new(self.world, spawnX, spawnY, self.currentBiome)
    table.insert(self.mobs, newMob)
end

function MobSpawner:setBiome(newBiome)
    self.currentBiome = newBiome
end

function MobSpawner:draw(cameraX, cameraY)
    for _, mob in ipairs(self.mobs) do
        mob:draw(cameraX, cameraY)
    end
end

return MobSpawner
