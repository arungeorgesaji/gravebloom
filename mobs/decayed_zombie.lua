local Mob = require("mobs.mob")

local DecayedZombie = setmetatable({}, Mob)
DecayedZombie.__index = DecayedZombie

function DecayedZombie:new(world, x, y, biomeData)
    local obj = Mob:new(world, "decayed_zombie", x, y, biomeData)
    obj.width = 65
    obj.height = 85
    obj.speed = 60
    obj.aggroRange = 140
    obj.attackRange = 35
    obj.attackDamage = 20
    obj.attackCooldown = 0
    obj.attackRate = 1.3
    obj.health = 55
    obj.maxHealth = 55
    obj.wanderRadius = 60
    obj.wanderTimer = 2
    obj.decayTimer = 0
    setmetatable(obj, DecayedZombie)
    return obj
end

function DecayedZombie:update(dt, player)
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
    
    self.decayTimer = self.decayTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function DecayedZombie:attack(player)
    player:takeDamage(self.attackDamage)
    if player.poisonTimer then
        player.poisonTimer = 4.0
        player.poisonDamage = 5
    end
end

function DecayedZombie:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    love.graphics.setColor(0.35, 0.4, 0.2)
    love.graphics.rectangle("fill", dx + w*0.25, dy + h*0.3, w*0.5, h*0.45)
    
    love.graphics.setColor(0.3, 0.35, 0.18)
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.5, w*0.08, h*0.1)
    love.graphics.rectangle("fill", dx + w*0.55, dy + h*0.45, w*0.08, h*0.12)
    
    love.graphics.rectangle("fill", dx + w*0.32, dy + h*0.1, w*0.36, h*0.25)
    
    love.graphics.setColor(0.5, 0.4, 0.1)
    love.graphics.rectangle("fill", dx + w*0.4, dy + h*0.18, w*0.08, h*0.08)
    love.graphics.rectangle("fill", dx + w*0.52, dy + h*0.18, w*0.08, h*0.08)
    
    love.graphics.setColor(0.2, 0.3, 0.1)
    love.graphics.rectangle("fill", dx + w*0.42, dy + h*0.28, w*0.16, h*0.06)
    
    love.graphics.setColor(1, 1, 1)
end

return DecayedZombie
