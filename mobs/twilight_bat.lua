local Mob = require("mobs.mob")

local TwilightBat = setmetatable({}, Mob)
TwilightBat.__index = TwilightBat

function TwilightBat:new(world, x, y, biomeData)
    local obj = Mob:new(world, "twilight_bat", x, y, biomeData)
    obj.width = 50
    obj.height = 40
    obj.speed = 180
    obj.aggroRange = 140
    obj.attackRange = 25
    obj.attackDamage = 10
    obj.attackCooldown = 0
    obj.attackRate = 0.6
    obj.health = 20
    obj.maxHealth = 20
    obj.wanderRadius = 100
    obj.wanderTimer = 1.5
    obj.wingTimer = 0
    obj.flying = true
    setmetatable(obj, TwilightBat)
    return obj
end

function TwilightBat:update(dt, player)
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
            self.vx = (math.random() - 0.5) * self.speed * 0.9
            self.wanderTimer = math.random(1, 2)
        end
        self.currentState = "wander"
    end
    
    self.wingTimer = self.wingTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function TwilightBat:attack(player)
    player:takeDamage(self.attackDamage)
end

function TwilightBat:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local wingAngle = math.sin(self.wingTimer * 20) * 0.3
    
    love.graphics.setColor(0.25, 0.2, 0.3)
    love.graphics.rectangle("fill", dx + w*0.4, dy + h*0.3, w*0.2, h*0.3)
    
    love.graphics.setColor(0.2, 0.15, 0.25)
    love.graphics.rectangle("fill", dx + w*0.1 + wingAngle * w*0.1, dy + h*0.25, w*0.3, h*0.2)
    love.graphics.rectangle("fill", dx + w*0.6 - wingAngle * w*0.1, dy + h*0.25, w*0.3, h*0.2)
    
    love.graphics.setColor(0.3, 0.25, 0.35)
    love.graphics.rectangle("fill", dx + w*0.4, dy + h*0.15, w*0.2, h*0.2)
    
    love.graphics.setColor(0.8, 0.3, 0.1)
    love.graphics.rectangle("fill", dx + w*0.45, dy + h*0.2, w*0.05, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.5, dy + h*0.2, w*0.05, h*0.05)
    
    love.graphics.setColor(1, 1, 1)
end

return TwilightBat
