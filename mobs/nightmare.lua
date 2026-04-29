local Mob = require("mobs.mob")

local Nightmare = setmetatable({}, Mob)
Nightmare.__index = Nightmare

function Nightmare:new(world, x, y, biomeData)
    local obj = Mob:new(world, "nightmare", x, y, biomeData)
    obj.width = 90
    obj.height = 100
    obj.speed = 140
    obj.aggroRange = 180
    obj.attackRange = 45
    obj.attackDamage = 28
    obj.attackCooldown = 0
    obj.attackRate = 1.1
    obj.health = 70
    obj.maxHealth = 70
    obj.wanderRadius = 70
    obj.wanderTimer = 2
    obj.nightmareTimer = 0
    setmetatable(obj, Nightmare)
    return obj
end

function Nightmare:update(dt, player)
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
    
    self.nightmareTimer = self.nightmareTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function Nightmare:attack(player)
    player:takeDamage(self.attackDamage)
    if player.fearTimer then
        player.fearTimer = 3.0
        player.speedModifier = 0.6
    end
end

function Nightmare:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local nightmarePulse = (math.sin(self.nightmareTimer * 5) + 1) / 2
    
    love.graphics.setColor(0.15, 0.08, 0.2)
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.3, w*0.6, h*0.5)
    
    love.graphics.setColor(0.3, 0.1, 0.4, 0.3 + nightmarePulse * 0.2)
    love.graphics.rectangle("fill", dx + w*0.15, dy + h*0.25, w*0.7, h*0.6)
    
    love.graphics.setColor(0.2, 0.1, 0.3)
    love.graphics.rectangle("fill", dx + w*0.3, dy + h*0.15, w*0.4, h*0.2)
    
    love.graphics.setColor(0.8, 0.1, 0.1, 0.7 + nightmarePulse * 0.3)
    love.graphics.rectangle("fill", dx + w*0.65, dy + h*0.35, w*0.08, h*0.08)
    love.graphics.rectangle("fill", dx + w*0.77, dy + h*0.35, w*0.08, h*0.08)
    
    love.graphics.setColor(1, 1, 1)
end

return Nightmare
