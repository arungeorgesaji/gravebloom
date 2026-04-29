local Mob = require("mobs.mob")

local MagmaCrawler = setmetatable({}, Mob)
MagmaCrawler.__index = MagmaCrawler

function MagmaCrawler:new(world, x, y, biomeData)
    local obj = Mob:new(world, "magma_crawler", x, y, biomeData)
    obj.width = 85
    obj.height = 55
    obj.speed = 100
    obj.aggroRange = 140
    obj.attackRange = 40
    obj.attackDamage = 25
    obj.attackCooldown = 0
    obj.attackRate = 1.0
    obj.health = 60
    obj.maxHealth = 60
    obj.wanderRadius = 60
    obj.wanderTimer = 2
    obj.magmaTimer = 0
    setmetatable(obj, MagmaCrawler)
    return obj
end

function MagmaCrawler:update(dt, player)
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
            self.wanderTimer = math.random(2, 4)
        end
        self.currentState = "wander"
    end
    
    self.magmaTimer = self.magmaTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function MagmaCrawler:attack(player)
    player:takeDamage(self.attackDamage)
    if player.burnTimer then
        player.burnTimer = 2.0
        player.burnDamage = 8
    end
end

function MagmaCrawler:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local magmaGlow = (math.sin(self.magmaTimer * 8) + 1) / 2
    
    love.graphics.setColor(0.5, 0.2, 0.1)
    love.graphics.rectangle("fill", dx + w*0.25, dy + h*0.3, w*0.5, h*0.4)
    
    love.graphics.setColor(0.9, 0.4, 0.1, 0.5 + magmaGlow * 0.3)
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.4, w*0.1, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.5, dy + h*0.38, w*0.08, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.45, dy + h*0.5, w*0.1, h*0.05)
    
    love.graphics.setColor(0.4, 0.15, 0.1)
    love.graphics.rectangle("fill", dx + w*0.15, dy + h*0.5, w*0.12, h*0.08)
    love.graphics.rectangle("fill", dx + w*0.73, dy + h*0.5, w*0.12, h*0.08)
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.6, w*0.1, h*0.08)
    love.graphics.rectangle("fill", dx + w*0.7, dy + h*0.6, w*0.1, h*0.08)
    
    love.graphics.setColor(0.9, 0.3, 0.1)
    love.graphics.rectangle("fill", dx + w*0.45, dy + h*0.32, w*0.06, h*0.06)
    love.graphics.rectangle("fill", dx + w*0.55, dy + h*0.32, w*0.06, h*0.06)
    
    love.graphics.setColor(1, 1, 1)
end

return MagmaCrawler
