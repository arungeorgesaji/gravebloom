local Mob = require("mobs.mob")

local ThornVine = setmetatable({}, Mob)
ThornVine.__index = ThornVine

function ThornVine:new(world, x, y, biomeData)
    local obj = Mob:new(world, "thorn_vine", x, y, biomeData)
    obj.width = 60
    obj.height = 80
    obj.speed = 30
    obj.aggroRange = 150
    obj.attackRange = 50
    obj.attackDamage = 15
    obj.attackCooldown = 0
    obj.attackRate = 0.8
    obj.health = 40
    obj.maxHealth = 40
    obj.wanderRadius = 30
    obj.wanderTimer = 2
    obj.vineTimer = 0
    setmetatable(obj, ThornVine)
    return obj
end

function ThornVine:update(dt, player)
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
            self.vx = (math.random() - 0.5) * self.speed * 1.5
            self.wanderTimer = math.random(2, 4)
        end
        self.currentState = "wander"
    end
    
    self.vineTimer = self.vineTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function ThornVine:attack(player)
    player:takeDamage(self.attackDamage)
    if player.bleedTimer then
        player.bleedTimer = 3.0
        player.bleedDamage = 3
    end
end

function ThornVine:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local sway = math.sin(self.vineTimer * 5) * 0.1
    
    love.graphics.setColor(0.3, 0.5, 0.2)
    love.graphics.rectangle("fill", dx + w*0.4 + sway * w, dy + h*0.2, w*0.2, h*0.6)
    
    love.graphics.setColor(0.4, 0.3, 0.2)
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.35, w*0.08, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.57, dy + h*0.45, w*0.08, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.55, w*0.08, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.57, dy + h*0.65, w*0.08, h*0.05)
    
    love.graphics.setColor(0.8, 0.3, 0.5)
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.15, w*0.3, h*0.12)
    
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("fill", dx + w*0.45, dy + h*0.18, w*0.05, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.52, dy + h*0.18, w*0.05, h*0.05)
    
    love.graphics.setColor(1, 1, 1)
end

return ThornVine
