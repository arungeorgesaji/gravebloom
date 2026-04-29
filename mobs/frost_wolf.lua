local Mob = require("mobs.mob")

local FrostWolf = setmetatable({}, Mob)
FrostWolf.__index = FrostWolf

function FrostWolf:new(world, x, y, biomeData)
    local obj = Mob:new(world, "frost_wolf", x, y, biomeData)
    obj.width = 80
    obj.height = 85
    obj.speed = 160
    obj.aggroRange = 160
    obj.attackRange = 35
    obj.attackDamage = 22
    obj.attackCooldown = 0
    obj.attackRate = 0.9
    obj.health = 50
    obj.maxHealth = 50
    obj.wanderRadius = 85
    obj.wanderTimer = 2
    obj.frostTimer = 0
    setmetatable(obj, FrostWolf)
    return obj
end

function FrostWolf:update(dt, player)
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
    
    self.frostTimer = self.frostTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function FrostWolf:attack(player)
    player:takeDamage(self.attackDamage)
    if player.speedModifier then
        player.speedModifier = 0.5
        player.slowTimer = 1.0
    end
end

function FrostWolf:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local frost = (math.sin(self.frostTimer * 5) + 1) / 2
    
    love.graphics.setColor(0.5, 0.7, 0.9)
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.3, w*0.6, h*0.45)
    
    love.graphics.setColor(0.6, 0.8, 1.0, 0.3 + frost * 0.2)
    love.graphics.rectangle("fill", dx + w*0.15, dy + h*0.25, w*0.7, h*0.55)
    
    love.graphics.setColor(0.45, 0.65, 0.85)
    love.graphics.rectangle("fill", dx + w*0.65, dy + h*0.15, w*0.25, h*0.25)
    
    love.graphics.setColor(0.2, 0.5, 0.8)
    love.graphics.rectangle("fill", dx + w*0.7, dy + h*0.22, w*0.06, h*0.06)
    love.graphics.rectangle("fill", dx + w*0.8, dy + h*0.22, w*0.06, h*0.06)
    
    love.graphics.setColor(1, 1, 1)
end

return FrostWolf
