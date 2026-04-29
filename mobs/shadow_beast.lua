local Mob = require("mobs.mob")

local ShadowBeast = setmetatable({}, Mob)
ShadowBeast.__index = ShadowBeast

function ShadowBeast:new(world, x, y, biomeData)
    local obj = Mob:new(world, "shadow_beast", x, y, biomeData)
    obj.width = 95
    obj.height = 105
    obj.speed = 120
    obj.aggroRange = 180
    obj.attackRange = 45
    obj.attackDamage = 30
    obj.attackCooldown = 0
    obj.attackRate = 1.2
    obj.health = 85
    obj.maxHealth = 85
    obj.wanderRadius = 65
    obj.wanderTimer = 2
    obj.shadowTimer = 0
    setmetatable(obj, ShadowBeast)
    return obj
end

function ShadowBeast:update(dt, player)
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
            self.wanderTimer = math.random(2, 4)
        end
        self.currentState = "wander"
    end
    
    self.shadowTimer = self.shadowTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function ShadowBeast:attack(player)
    player:takeDamage(self.attackDamage)
    if player.blindTimer then
        player.blindTimer = 2.0
    end
end

function ShadowBeast:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local shadowPulse = (math.sin(self.shadowTimer * 6) + 1) / 2
    
    love.graphics.setColor(0.08, 0.05, 0.12)
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.3, w*0.6, h*0.5)
    
    love.graphics.setColor(0.15, 0.08, 0.2, 0.3 + shadowPulse * 0.2)
    love.graphics.rectangle("fill", dx + w*0.15, dy + h*0.25, w*0.7, h*0.6)
    
    love.graphics.setColor(0.8, 0.1, 0.1, 0.6 + shadowPulse * 0.4)
    love.graphics.rectangle("fill", dx + w*0.65, dy + h*0.35, w*0.08, h*0.08)
    love.graphics.rectangle("fill", dx + w*0.77, dy + h*0.35, w*0.08, h*0.08)
    
    love.graphics.setColor(0.1, 0.05, 0.15)
    love.graphics.rectangle("fill", dx + w*0.1, dy + h*0.6, w*0.1, h*0.15)
    love.graphics.rectangle("fill", dx + w*0.8, dy + h*0.6, w*0.1, h*0.15)
    
    love.graphics.setColor(1, 1, 1)
end

return ShadowBeast
