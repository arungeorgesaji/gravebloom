local Mob = require("mobs.mob")

local FireSpirit = setmetatable({}, Mob)
FireSpirit.__index = FireSpirit

function FireSpirit:new(world, x, y, biomeData)
    local obj = Mob:new(world, "fire_spirit", x, y, biomeData)
    obj.width = 45
    obj.height = 55
    obj.speed = 120
    obj.aggroRange = 140
    obj.attackRange = 40
    obj.attackDamage = 18
    obj.attackCooldown = 0
    obj.attackRate = 0.8
    obj.health = 35
    obj.maxHealth = 35
    obj.wanderRadius = 70
    obj.wanderTimer = 1.5
    obj.flickerTimer = 0
    obj.flying = true
    setmetatable(obj, FireSpirit)
    return obj
end

function FireSpirit:update(dt, player)
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
            self.wanderTimer = math.random(1, 2)
        end
        self.currentState = "wander"
    end
    
    self.flickerTimer = self.flickerTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function FireSpirit:attack(player)
    player:takeDamage(self.attackDamage)
    if player.burnTimer then
        player.burnTimer = 3.0
        player.burnDamage = 5
    end
end

function FireSpirit:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local flicker = (math.sin(self.flickerTimer * 15) + 1) / 2
    local size = 0.8 + flicker * 0.4
    
    love.graphics.setColor(0.9, 0.4, 0.2, 0.8)
    love.graphics.rectangle("fill", dx + w*0.5 - w*0.3*size, dy + h*0.3, w*0.6*size, h*0.5)
    
    love.graphics.setColor(1.0, 0.7, 0.3, 0.9)
    love.graphics.rectangle("fill", dx + w*0.5 - w*0.2*size, dy + h*0.4, w*0.4*size, h*0.3)
    
    love.graphics.setColor(1.0, 0.9, 0.2)
    love.graphics.rectangle("fill", dx + w*0.38, dy + h*0.35, w*0.08, h*0.08)
    love.graphics.rectangle("fill", dx + w*0.54, dy + h*0.35, w*0.08, h*0.08)
    
    love.graphics.setColor(1, 1, 1)
end

return FireSpirit
