local Mob = require("mobs.mob")

local Zombie = setmetatable({}, Mob)
Zombie.__index = Zombie

function Zombie:new(world, x, y, biomeData)
    local obj = Mob:new(world, "zombie", x, y, biomeData)
    obj.width = 65
    obj.height = 85
    obj.speed = 70
    obj.aggroRange = 130
    obj.attackRange = 35
    obj.attackDamage = 18
    obj.attackCooldown = 0
    obj.attackRate = 1.2
    obj.health = 50
    obj.maxHealth = 50
    obj.wanderRadius = 60
    obj.wanderTimer = 2
    obj.limpTimer = 0
    setmetatable(obj, Zombie)
    return obj
end

function Zombie:update(dt, player)
    local dx = player.x - self.x
    local dist = math.abs(dx)
    
    if dist < self.aggroRange then
        if dx > 0 then
            self.vx = self.speed
        else
            self.vx = -self.speed
        end
        self.currentState = "chase"
        
        if dist < self.attackRange and self.attackCooldown <= 0 then
            self:attack(player)
            self.attackCooldown = self.attackRate
        end
    else
        self.wanderTimer = self.wanderTimer - dt
        if self.wanderTimer <= 0 then
            self.vx = (math.random() - 0.5) * self.speed * 0.7
            self.wanderTimer = math.random(2, 4)
        end
        self.currentState = "wander"
    end
    
    self.limpTimer = self.limpTimer + dt * 10
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function Zombie:attack(player)
    player:takeDamage(self.attackDamage)
end

function Zombie:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0) + math.sin(self.limpTimer) * 2
    local w = self.width
    local h = self.height
    
    love.graphics.setColor(0.3, 0.5, 0.2)
    love.graphics.rectangle("fill", dx + w*0.25, dy + h*0.3, w*0.5, h*0.45)
    
    love.graphics.rectangle("fill", dx + w*0.32, dy + h*0.1, w*0.36, h*0.25)
    
    love.graphics.setColor(0.8, 0.1, 0.1)
    love.graphics.rectangle("fill", dx + w*0.4, dy + h*0.18, w*0.08, h*0.08)
    love.graphics.rectangle("fill", dx + w*0.52, dy + h*0.18, w*0.08, h*0.08)
    
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", dx + w*0.4, dy + h*0.28, w*0.2, h*0.06)
    
    love.graphics.setColor(0.4, 0.3, 0.5)
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.5, w*0.15, h*0.2)
    love.graphics.rectangle("fill", dx + w*0.65, dy + h*0.5, w*0.15, h*0.2)
    
    love.graphics.setColor(1, 1, 1)
end

return Zombie
