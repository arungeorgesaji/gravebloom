local Mob = require("mobs.mob")

local DuskWolf = setmetatable({}, Mob)
DuskWolf.__index = DuskWolf

function DuskWolf:new(world, x, y, biomeData)
    local obj = Mob:new(world, "dusk_wolf", x, y, biomeData)
    obj.width = 80
    obj.height = 85
    obj.speed = 170
    obj.aggroRange = 160
    obj.attackRange = 35
    obj.attackDamage = 20
    obj.attackCooldown = 0
    obj.attackRate = 0.9
    obj.health = 45
    obj.maxHealth = 45
    obj.wanderRadius = 85
    obj.wanderTimer = 2
    obj.glowTimer = 0
    setmetatable(obj, DuskWolf)
    return obj
end

function DuskWolf:update(dt, player)
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
            self.vx = (math.random() - 0.5) * self.speed * 0.8
            self.wanderTimer = math.random(2, 3)
        end
        self.currentState = "wander"
    end
    
    self.glowTimer = self.glowTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function DuskWolf:attack(player)
    player:takeDamage(self.attackDamage)
end

function DuskWolf:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local glow = (math.sin(self.glowTimer * 8) + 1) / 2
    
    love.graphics.setColor(0.3, 0.2, 0.4)
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.3, w*0.6, h*0.45)
    
    love.graphics.setColor(1.0, 0.5, 0.2, 0.5 + glow * 0.3)
    love.graphics.rectangle("fill", dx + w*0.7, dy + h*0.2, w*0.07, h*0.07)
    love.graphics.rectangle("fill", dx + w*0.8, dy + h*0.2, w*0.07, h*0.07)
    
    love.graphics.setColor(0.25, 0.15, 0.35)
    love.graphics.rectangle("fill", dx + w*0.65, dy + h*0.15, w*0.25, h*0.25)
    
    love.graphics.setColor(1, 1, 1)
end

return DuskWolf
