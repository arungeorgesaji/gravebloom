local Mob = require("mobs.mob")

local MiasmaWraith = setmetatable({}, Mob)
MiasmaWraith.__index = MiasmaWraith

function MiasmaWraith:new(world, x, y, biomeData)
    local obj = Mob:new(world, "miasma_wraith", x, y, biomeData)
    obj.width = 70
    obj.height = 90
    obj.speed = 110
    obj.aggroRange = 190
    obj.attackRange = 40
    obj.attackDamage = 20
    obj.attackCooldown = 0
    obj.attackRate = 1.0
    obj.health = 60
    obj.maxHealth = 60
    obj.wanderRadius = 70
    obj.wanderTimer = 2
    obj.wraithTimer = 0
    obj.flying = true
    setmetatable(obj, MiasmaWraith)
    return obj
end

function MiasmaWraith:update(dt, player)
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
            self.wanderTimer = math.random(2, 3)
        end
        self.currentState = "wander"
    end
    
    self.wraithTimer = self.wraithTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function MiasmaWraith:attack(player)
    player:takeDamage(self.attackDamage)
    if player.sicknessTimer then
        player.sicknessTimer = 6.0
        player.sicknessDamage = 3
        player.speedModifier = 0.7
    end
end

function MiasmaWraith:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local wraithPulse = (math.sin(self.wraithTimer * 7) + 1) / 2
    
    love.graphics.setColor(0.4, 0.5, 0.3, 0.6)
    love.graphics.rectangle("fill", dx + w*0.25, dy + h*0.3, w*0.5, h*0.5)
    
    love.graphics.setColor(0.5, 0.6, 0.3, 0.3 + wraithPulse * 0.2)
    love.graphics.rectangle("fill", dx + w*0.15, dy + h*0.25, w*0.7, h*0.6)
    
    love.graphics.setColor(0.35, 0.45, 0.25, 0.7)
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.7, w*0.12, h*0.1)
    love.graphics.rectangle("fill", dx + w*0.68, dy + h*0.7, w*0.12, h*0.1)
    
    love.graphics.setColor(0.6, 0.8, 0.3, 0.6 + wraithPulse * 0.4)
    love.graphics.rectangle("fill", dx + w*0.65, dy + h*0.38, w*0.08, h*0.08)
    love.graphics.rectangle("fill", dx + w*0.75, dy + h*0.38, w*0.08, h*0.08)
    
    love.graphics.setColor(1, 1, 1)
end

return MiasmaWraithocal
