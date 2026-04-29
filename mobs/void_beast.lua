local Mob = require("mobs.mob")

local VoidBeast = setmetatable({}, Mob)
VoidBeast.__index = VoidBeast

function VoidBeast:new(world, x, y, biomeData)
    local obj = Mob:new(world, "void_beast", x, y, biomeData)
    obj.width = 100
    obj.height = 110
    obj.speed = 80
    obj.aggroRange = 200
    obj.attackRange = 45
    obj.attackDamage = 30
    obj.attackCooldown = 0
    obj.attackRate = 1.3
    obj.health = 100
    obj.maxHealth = 100
    obj.wanderRadius = 60
    obj.wanderTimer = 2.5
    obj.pulseTimer = 0
    setmetatable(obj, VoidBeast)
    return obj
end

function VoidBeast:update(dt, player)
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
            self.vx = (math.random() - 0.5) * self.speed * 0.6
            self.wanderTimer = math.random(3, 5)
        end
        self.currentState = "wander"
    end
    
    self.pulseTimer = self.pulseTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function VoidBeast:attack(player)
    player:takeDamage(self.attackDamage)
    player:addDebuff("corruption", 5.0, 10)
end

function VoidBeast:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local pulse = (math.sin(self.pulseTimer * 4) + 1) / 2
    
    love.graphics.setColor(0.1, 0.05, 0.15)
    love.graphics.rectangle("fill", dx + w*0.15, dy + h*0.3, w*0.7, h*0.5)
    
    love.graphics.setColor(0.3, 0.1, 0.4, 0.3 + pulse * 0.2)
    love.graphics.rectangle("fill", dx + w*0.1, dy + h*0.25, w*0.8, h*0.6)
    
    love.graphics.setColor(0.8, 0.2, 0.8, 0.7 + pulse * 0.3)
    love.graphics.rectangle("fill", dx + w*0.4, dy + h*0.35, w*0.08, h*0.08)
    love.graphics.rectangle("fill", dx + w*0.52, dy + h*0.35, w*0.08, h*0.08)
    love.graphics.rectangle("fill", dx + w*0.46, dy + h*0.45, w*0.08, h*0.08)
    
    love.graphics.setColor(0.15, 0.08, 0.2)
    love.graphics.rectangle("fill", dx + w*0.1, dy + h*0.7, w*0.1, h*0.15)
    love.graphics.rectangle("fill", dx + w*0.8, dy + h*0.7, w*0.1, h*0.15)
    love.graphics.rectangle("fill", dx + w*0.45, dy + h*0.75, w*0.1, h*0.12)
    
    love.graphics.setColor(1, 1, 1)
end

return VoidBeast
