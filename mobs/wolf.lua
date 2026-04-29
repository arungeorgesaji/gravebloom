local Mob = require("mobs.mob")

local Wolf = setmetatable({}, Mob)
Wolf.__index = Wolf

function Wolf:new(world, x, y, biomeData)
    local obj = Mob:new(world, "wolf", x, y, biomeData)
    obj.width = 75
    obj.height = 80
    obj.speed = 150
    obj.aggroRange = 150
    obj.attackRange = 30
    obj.attackDamage = 15
    obj.attackCooldown = 0
    obj.attackRate = 1.0
    obj.health = 40
    obj.maxHealth = 40
    obj.wanderRadius = 80
    obj.wanderTimer = 2
    setmetatable(obj, Wolf)
    return obj
end

function Wolf:update(dt, player)
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
            self.wanderTimer = math.random(2, 4)
        end
        self.currentState = "wander"
    end
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function Wolf:attack(player)
    player:takeDamage(self.attackDamage)
end

function Wolf:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    love.graphics.setColor(0.4, 0.35, 0.3)
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.3, w*0.6, h*0.45)
    
    love.graphics.rectangle("fill", dx + w*0.65, dy + h*0.15, w*0.25, h*0.25)
    
    love.graphics.rectangle("fill", dx + w*0.68, dy + h*0.0, w*0.08, h*0.15)
    love.graphics.rectangle("fill", dx + w*0.82, dy + h*0.0, w*0.08, h*0.15)
    
    love.graphics.setColor(0.3, 0.25, 0.2)
    love.graphics.rectangle("fill", dx + w*0.8, dy + h*0.25, w*0.12, h*0.08)
    
    love.graphics.setColor(0.8, 0.2, 0.2)
    love.graphics.rectangle("fill", dx + w*0.7, dy + h*0.2, w*0.06, h*0.06)
    love.graphics.rectangle("fill", dx + w*0.8, dy + h*0.2, w*0.06, h*0.06)
    
    love.graphics.setColor(1, 1, 1)
end

return Wolf
