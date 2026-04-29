local Mob = require("mobs.mob")

local ToxicSpitter = setmetatable({}, Mob)
ToxicSpitter.__index = ToxicSpitter

function ToxicSpitter:new(world, x, y, biomeData)
    local obj = Mob:new(world, "toxic_spitter", x, y, biomeData)
    obj.width = 60
    obj.height = 55
    obj.speed = 80
    obj.aggroRange = 180
    obj.attackRange = 100
    obj.attackDamage = 12
    obj.attackCooldown = 0
    obj.attackRate = 1.2
    obj.health = 40
    obj.maxHealth = 40
    obj.wanderRadius = 65
    obj.wanderTimer = 1.8
    obj.spitTimer = 0
    setmetatable(obj, ToxicSpitter)
    return obj
end

function ToxicSpitter:update(dt, player)
    local dx = player.x - self.x
    local dist = math.abs(dx)
    
    if dist < self.aggroRange then
        if dist < 60 then
            self.vx = dx > 0 and -self.speed * 0.8 or self.speed * 0.8
        else
            self.vx = dx > 0 and self.speed * 0.5 or -self.speed * 0.5
        end
        self.currentState = "chase"
        
        if dist < self.attackRange and self.attackCooldown <= 0 then
            self:attack(player)
            self.attackCooldown = self.attackRate
        end
    else
        self.wanderTimer = self.wanderTimer - dt
        if self.wanderTimer <= 0 then
            self.vx = (math.random() - 0.5) * self.speed
            self.wanderTimer = math.random(2, 3)
        end
        self.currentState = "wander"
    end
    
    self.spitTimer = self.spitTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function ToxicSpitter:attack(player)
    player:takeDamage(self.attackDamage)
    if player.poisonTimer then
        player.poisonTimer = 5.0
        player.poisonDamage = 6
    end
end

function ToxicSpitter:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local spitCharge = (math.sin(self.spitTimer * 15) + 1) / 2
    
    love.graphics.setColor(0.4, 0.55, 0.25)
    love.graphics.rectangle("fill", dx + w*0.25, dy + h*0.3, w*0.5, h*0.45)
    
    love.graphics.setColor(0.6, 0.7, 0.3, 0.7)
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.5, w*0.08, h*0.08)
    love.graphics.rectangle("fill", dx + w*0.57, dy + h*0.5, w*0.08, h*0.08)
    
    love.graphics.setColor(0.5, 0.4, 0.2, 0.5 + spitCharge * 0.3)
    love.graphics.rectangle("fill", dx + w*0.65, dy + h*0.4, w*0.15, h*0.12)
    
    love.graphics.setColor(0.7, 0.5, 0.1)
    love.graphics.rectangle("fill", dx + w*0.45, dy + h*0.35, w*0.06, h*0.06)
    love.graphics.rectangle("fill", dx + w*0.55, dy + h*0.35, w*0.06, h*0.06)
    
    love.graphics.setColor(1, 1, 1)
end

return ToxicSpitter
