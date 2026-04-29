local Mob = require("mobs.mob")

local Bear = setmetatable({}, Mob)
Bear.__index = Bear

function Bear:new(world, x, y, biomeData)
    local obj = Mob:new(world, "bear", x, y, biomeData)
    obj.width = 100
    obj.height = 100
    obj.speed = 100
    obj.aggroRange = 120
    obj.attackRange = 40
    obj.attackDamage = 25
    obj.attackCooldown = 0
    obj.attackRate = 1.5
    obj.health = 80
    obj.maxHealth = 80
    obj.wanderRadius = 60
    obj.wanderTimer = 2.5
    setmetatable(obj, Bear)
    return obj
end

function Bear:update(dt, player)
    local dx = player.x - self.x
    local dist = math.abs(dx)
    
    if dist < self.aggroRange then
        if dx > 0 then
            self.vx = self.speed * 0.7
        else
            self.vx = -self.speed * 0.7
        end
        self.currentState = "chase"
        
        if dist < self.attackRange and self.attackCooldown <= 0 then
            self:attack(player)
            self.attackCooldown = self.attackRate
        end
    else
        self.wanderTimer = self.wanderTimer - dt
        if self.wanderTimer <= 0 then
            self.vx = (math.random() - 0.5) * self.speed * 0.6
            self.wanderTimer = math.random(3, 5)
        end
        self.currentState = "wander"
    end
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function Bear:attack(player)
    player:takeDamage(self.attackDamage)
end

function Bear:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    love.graphics.setColor(0.5, 0.35, 0.25)
    love.graphics.rectangle("fill", dx + w*0.15, dy + h*0.3, w*0.7, h*0.5)
    
    love.graphics.rectangle("fill", dx + w*0.6, dy + h*0.15, w*0.3, h*0.25)
    
    love.graphics.rectangle("fill", dx + w*0.63, dy + h*0.02, w*0.08, h*0.13)
    love.graphics.rectangle("fill", dx + w*0.8, dy + h*0.02, w*0.08, h*0.13)
    
    love.graphics.setColor(0.4, 0.25, 0.18)
    love.graphics.rectangle("fill", dx + w*0.75, dy + h*0.25, w*0.12, h*0.08)
    
    love.graphics.setColor(0.6, 0.2, 0.2)
    love.graphics.rectangle("fill", dx + w*0.65, dy + h*0.22, w*0.07, h*0.07)
    love.graphics.rectangle("fill", dx + w*0.78, dy + h*0.22, w*0.07, h*0.07)
    
    love.graphics.setColor(1, 1, 1)
end

return Bear
