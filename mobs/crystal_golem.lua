local Mob = require("mobs.mob")

local CrystalGolem = setmetatable({}, Mob)
CrystalGolem.__index = CrystalGolem

function CrystalGolem:new(world, x, y, biomeData)
    local obj = Mob:new(world, "crystal_golem", x, y, biomeData)
    obj.width = 120
    obj.height = 130
    obj.speed = 50
    obj.aggroRange = 150
    obj.attackRange = 50
    obj.attackDamage = 35
    obj.attackCooldown = 0
    obj.attackRate = 2.0
    obj.health = 120
    obj.maxHealth = 120
    obj.wanderRadius = 50
    obj.wanderTimer = 3
    obj.glowTimer = 0
    setmetatable(obj, CrystalGolem)
    return obj
end

function CrystalGolem:update(dt, player)
    local dx = player.x - self.x
    local dist = math.abs(dx)
    
    if dist < self.aggroRange then
        self.vx = dx > 0 and self.speed or -self.speed
        self.currentState = "chase"
        
        if dist < self.attackRange and self.attackCooldown <= 0 then
            self:attack(player)
            self.attackCooldown = self.attackRate
        end
    else
        self.wanderTimer = self.wanderTimer - dt
        if self.wanderTimer <= 0 then
            self.vx = (math.random() - 0.5) * self.speed * 0.8
            self.wanderTimer = math.random(3, 5)
        end
        self.currentState = "wander"
    end
    
    self.glowTimer = self.glowTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function CrystalGolem:attack(player)
    player:takeDamage(self.attackDamage)
    local direction = player.x - self.x > 0 and 1 or -1
    player.vx = direction * 200
end

function CrystalGolem:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local glow = (math.sin(self.glowTimer * 3) + 1) / 2
    
    love.graphics.setColor(0.3, 0.4, 0.7)
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.3, w*0.6, h*0.5)
    
    love.graphics.setColor(0.4, 0.5, 0.8)
    love.graphics.rectangle("fill", dx + w*0.15, dy + h*0.4, w*0.08, h*0.2)
    love.graphics.rectangle("fill", dx + w*0.77, dy + h*0.4, w*0.08, h*0.2)
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.25, w*0.08, h*0.15)
    love.graphics.rectangle("fill", dx + w*0.57, dy + h*0.25, w*0.08, h*0.15)
    
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.1, w*0.3, h*0.25)
    
    love.graphics.setColor(0.6, 0.7, 1.0, 0.5 + glow * 0.3)
    love.graphics.rectangle("fill", dx + w*0.45, dy + h*0.5, w*0.1, h*0.15)
    
    love.graphics.setColor(0.8, 0.9, 1.0, 0.8)
    love.graphics.rectangle("fill", dx + w*0.42, dy + h*0.18, w*0.06, h*0.06)
    love.graphics.rectangle("fill", dx + w*0.52, dy + h*0.18, w*0.06, h*0.06)
    
    love.graphics.setColor(1, 1, 1)
end

return CrystalGolem
