local Mob = require("mobs.mob")

local DreamEater = setmetatable({}, Mob)
DreamEater.__index = DreamEater

function DreamEater:new(world, x, y, biomeData)
    local obj = Mob:new(world, "dream_eater", x, y, biomeData)
    obj.width = 75
    obj.height = 80
    obj.speed = 110
    obj.aggroRange = 160
    obj.attackRange = 40
    obj.attackDamage = 20
    obj.attackCooldown = 0
    obj.attackRate = 0.9
    obj.health = 55
    obj.maxHealth = 55
    obj.wanderRadius = 65
    obj.wanderTimer = 2
    obj.mouthTimer = 0
    setmetatable(obj, DreamEater)
    return obj
end

function DreamEater:update(dt, player)
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
            self.wanderTimer = math.random(2, 3)
        end
        self.currentState = "wander"
    end
    
    self.mouthTimer = self.mouthTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function DreamEater:attack(player)
    player:takeDamage(self.attackDamage)
    if player.mana then
        player.mana = math.max(0, player.mana - 15)
    end
end

function DreamEater:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local mouthOpen = math.sin(self.mouthTimer * 10) * 0.1 + 0.8
    
    love.graphics.setColor(0.4, 0.2, 0.5)
    love.graphics.rectangle("fill", dx + w*0.25, dy + h*0.3, w*0.5, h*0.45)
    
    love.graphics.setColor(0.3, 0.1, 0.4)
    love.graphics.rectangle("fill", dx + w*0.4, dy + h*0.45, w*0.2, h*0.12 * mouthOpen)
    
    love.graphics.setColor(0.7, 0.7, 0.8)
    love.graphics.rectangle("fill", dx + w*0.42, dy + h*0.48, w*0.04, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.48, dy + h*0.48, w*0.04, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.54, dy + h*0.48, w*0.04, h*0.05)
    
    love.graphics.setColor(0.6, 0.3, 0.8)
    love.graphics.rectangle("fill", dx + w*0.45, dy + h*0.32, w*0.06, h*0.06)
    love.graphics.rectangle("fill", dx + w*0.55, dy + h*0.32, w*0.06, h*0.06)
    
    love.graphics.setColor(1, 1, 1)
end

return DreamEater
