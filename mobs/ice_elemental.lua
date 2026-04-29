local Mob = require("mobs.mob")

local IceElemental = setmetatable({}, Mob)
IceElemental.__index = IceElemental

function IceElemental:new(world, x, y, biomeData)
    local obj = Mob:new(world, "ice_elemental", x, y, biomeData)
    obj.width = 85
    obj.height = 110
    obj.speed = 70
    obj.aggroRange = 170
    obj.attackRange = 50
    obj.attackDamage = 25
    obj.attackCooldown = 0
    obj.attackRate = 1.4
    obj.health = 90
    obj.maxHealth = 90
    obj.wanderRadius = 55
    obj.wanderTimer = 2.5
    obj.iceTimer = 0
    setmetatable(obj, IceElemental)
    return obj
end

function IceElemental:update(dt, player)
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
            self.wanderTimer = math.random(3, 5)
        end
        self.currentState = "wander"
    end
    
    self.iceTimer = self.iceTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function IceElemental:attack(player)
    player:takeDamage(self.attackDamage)
    if player.freezeTimer then
        player.freezeTimer = 1.5
        player.speedModifier = 0.3
    end
end

function IceElemental:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local iceGlow = (math.sin(self.iceTimer * 4) + 1) / 2
    
    love.graphics.setColor(0.5, 0.7, 0.9, 0.85)
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.3, w*0.6, h*0.5)
    
    love.graphics.setColor(0.6, 0.8, 1.0)
    love.graphics.rectangle("fill", dx + w*0.25, dy + h*0.25, w*0.08, h*0.15)
    love.graphics.rectangle("fill", dx + w*0.67, dy + h*0.25, w*0.08, h*0.15)
    love.graphics.rectangle("fill", dx + w*0.4, dy + h*0.2, w*0.08, h*0.12)
    love.graphics.rectangle("fill", dx + w*0.52, dy + h*0.2, w*0.08, h*0.12)
    
    love.graphics.setColor(0.7, 0.9, 1.0, 0.4 + iceGlow * 0.3)
    love.graphics.rectangle("fill", dx + w*0.4, dy + h*0.5, w*0.2, h*0.2)
    
    love.graphics.setColor(0.3, 0.6, 1.0)
    love.graphics.rectangle("fill", dx + w*0.65, dy + h*0.38, w*0.06, h*0.06)
    love.graphics.rectangle("fill", dx + w*0.75, dy + h*0.38, w*0.06, h*0.06)
    
    love.graphics.setColor(1, 1, 1)
end

return IceElemental
