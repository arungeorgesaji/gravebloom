local Mob = require("mobs.mob")

local VoidSpawn = setmetatable({}, Mob)
VoidSpawn.__index = VoidSpawn

function VoidSpawn:new(world, x, y, biomeData)
    local obj = Mob:new(world, "void_spawn", x, y, biomeData)
    obj.width = 60
    obj.height = 65
    obj.speed = 100
    obj.aggroRange = 160
    obj.attackRange = 35
    obj.attackDamage = 22
    obj.attackCooldown = 0
    obj.attackRate = 0.9
    obj.health = 50
    obj.maxHealth = 50
    obj.wanderRadius = 60
    obj.wanderTimer = 1.8
    obj.voidTimer = 0
    setmetatable(obj, VoidSpawn)
    return obj
end

function VoidSpawn:update(dt, player)
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
            self.vx = (math.random() - 0.5) * self.speed * 0.7
            self.wanderTimer = math.random(2, 3)
        end
        self.currentState = "wander"
    end
    
    self.voidTimer = self.voidTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function VoidSpawn:attack(player)
    player:takeDamage(self.attackDamage)
    if player.corruptionTimer then
        player.corruptionTimer = 4.0
        player.corruptionDamage = 4
    end
end

function VoidSpawn:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local voidPulse = (math.sin(self.voidTimer * 9) + 1) / 2
    
    love.graphics.setColor(0.12, 0.06, 0.18)
    love.graphics.rectangle("fill", dx + w*0.25, dy + h*0.3, w*0.5, h*0.45)
    
    love.graphics.setColor(0.4, 0.2, 0.6, 0.4 + voidPulse * 0.3)
    love.graphics.rectangle("fill", dx + w*0.4, dy + h*0.45, w*0.2, h*0.2)
    
    love.graphics.setColor(0.1, 0.05, 0.15)
    love.graphics.rectangle("fill", dx + w*0.15, dy + h*0.5, w*0.12, h*0.1)
    love.graphics.rectangle("fill", dx + w*0.73, dy + h*0.5, w*0.12, h*0.1)
    
    love.graphics.setColor(0.6, 0.2, 0.6, 0.8)
    love.graphics.rectangle("fill", dx + w*0.42, dy + h*0.35, w*0.04, h*0.04)
    love.graphics.rectangle("fill", dx + w*0.54, dy + h*0.35, w*0.04, h*0.04)
    love.graphics.rectangle("fill", dx + w*0.48, dy + h*0.4, w*0.04, h*0.04)
    
    love.graphics.setColor(1, 1, 1)
end

return VoidSpawn
