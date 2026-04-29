local Mob = require("mobs.mob")

local PoisonFlower = setmetatable({}, Mob)
PoisonFlower.__index = PoisonFlower

function PoisonFlower:new(world, x, y, biomeData)
    local obj = Mob:new(world, "poison_flower", x, y, biomeData)
    obj.width = 50
    obj.height = 60
    obj.speed = 20
    obj.aggroRange = 120
    obj.attackRange = 60
    obj.attackDamage = 10
    obj.attackCooldown = 0
    obj.attackRate = 1.5
    obj.health = 35
    obj.maxHealth = 35
    obj.wanderRadius = 0
    obj.wanderTimer = 0
    obj.sporeTimer = 0
    setmetatable(obj, PoisonFlower)
    return obj
end

function PoisonFlower:update(dt, player)
    self.vx = 0
    self.currentState = "idle"
    
    local dx = player.x - self.x
    local dist = math.abs(dx)
    
    if dist < self.aggroRange and self.attackCooldown <= 0 then
        self:attack(player)
        self.attackCooldown = self.attackRate
    end
    
    self.sporeTimer = self.sporeTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function PoisonFlower:attack(player)
    player:takeDamage(self.attackDamage)
    if player.poisonTimer then
        player.poisonTimer = 6.0
        player.poisonDamage = 6
    end
end

function PoisonFlower:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local sporePulse = (math.sin(self.sporeTimer * 10) + 1) / 2
    
    love.graphics.setColor(0.4, 0.6, 0.3)
    love.graphics.rectangle("fill", dx + w*0.45, dy + h*0.4, w*0.1, h*0.5)
    
    love.graphics.setColor(0.7, 0.2, 0.7, 0.8)
    for i = 0, 5 do
        local angle = i * 60
        local offsetX = math.sin(angle) * w * 0.2
        local offsetY = math.cos(angle) * h * 0.15
        love.graphics.rectangle("fill", dx + w*0.4 + offsetX, dy + h*0.3 + offsetY, w*0.15, h*0.12)
    end
    
    love.graphics.setColor(0.8, 0.3, 0.8, 0.3 + sporePulse * 0.2)
    love.graphics.rectangle("fill", dx + w*0.3, dy + h*0.25, w*0.4, h*0.3)
    
    love.graphics.setColor(0.5, 0.1, 0.5)
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.32, w*0.3, h*0.2)
    
    love.graphics.setColor(0.9, 0.2, 0.9)
    love.graphics.rectangle("fill", dx + w*0.42, dy + h*0.38, w*0.06, h*0.06)
    love.graphics.rectangle("fill", dx + w*0.52, dy + h*0.38, w*0.06, h*0.06)
    
    love.graphics.setColor(1, 1, 1)
end

return PoisonFlower
