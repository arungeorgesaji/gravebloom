local Mob = require("mobs.mob")

local Abomination = setmetatable({}, Mob)
Abomination.__index = Abomination

function Abomination:new(world, x, y, biomeData)
    local obj = Mob:new(world, "abomination", x, y, biomeData)
    obj.width = 130
    obj.height = 140
    obj.speed = 55
    obj.aggroRange = 200
    obj.attackRange = 60
    obj.attackDamage = 40
    obj.attackCooldown = 0
    obj.attackRate = 1.6
    obj.health = 150
    obj.maxHealth = 150
    obj.wanderRadius = 50
    obj.wanderTimer = 3
    obj.abominationTimer = 0
    setmetatable(obj, Abomination)
    return obj
end

function Abomination:update(dt, player)
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
            self.wanderTimer = math.random(4, 6)
        end
        self.currentState = "wander"
    end
    
    self.abominationTimer = self.abominationTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function Abomination:attack(player)
    player:takeDamage(self.attackDamage)
    local direction = player.x - self.x > 0 and 1 or -1
    player.vx = direction * 300
    if player.stunTimer then
        player.stunTimer = 1.0
    end
end

function Abomination:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local abomPulse = (math.sin(self.abominationTimer * 3) + 1) / 2
    
    love.graphics.setColor(0.12, 0.08, 0.18)
    love.graphics.rectangle("fill", dx + w*0.15, dy + h*0.25, w*0.7, h*0.6)
    
    love.graphics.setColor(0.25, 0.1, 0.35, 0.2 + abomPulse * 0.2)
    love.graphics.rectangle("fill", dx + w*0.1, dy + h*0.2, w*0.8, h*0.7)
    
    love.graphics.setColor(0.1, 0.06, 0.15)
    love.graphics.rectangle("fill", dx + w*0.05, dy + h*0.5, w*0.12, h*0.2)
    love.graphics.rectangle("fill", dx + w*0.83, dy + h*0.5, w*0.12, h*0.2)
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.7, w*0.1, h*0.15)
    love.graphics.rectangle("fill", dx + w*0.7, dy + h*0.7, w*0.1, h*0.15)
    
    love.graphics.setColor(0.18, 0.1, 0.25)
    love.graphics.rectangle("fill", dx + w*0.3, dy + h*0.15, w*0.15, h*0.15)
    love.graphics.rectangle("fill", dx + w*0.55, dy + h*0.15, w*0.15, h*0.15)
    
    love.graphics.setColor(0.8, 0.2, 0.8, 0.6 + abomPulse * 0.4)
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.2, w*0.05, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.42, dy + h*0.2, w*0.05, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.6, dy + h*0.2, w*0.05, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.67, dy + h*0.2, w*0.05, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.48, dy + h*0.45, w*0.08, h*0.08)
    
    love.graphics.setColor(1, 1, 1)
end

return Abomination
