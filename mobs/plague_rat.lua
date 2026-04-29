local Mob = require("mobs.mob")

local PlagueRat = setmetatable({}, Mob)
PlagueRat.__index = PlagueRat

function PlagueRat:new(world, x, y, biomeData)
    local obj = Mob:new(world, "plague_rat", x, y, biomeData)
    obj.width = 45
    obj.height = 35
    obj.speed = 130
    obj.aggroRange = 120
    obj.attackRange = 25
    obj.attackDamage = 12
    obj.attackCooldown = 0
    obj.attackRate = 0.7
    obj.health = 25
    obj.maxHealth = 25
    obj.wanderRadius = 80
    obj.wanderTimer = 1.5
    obj.tailTimer = 0
    setmetatable(obj, PlagueRat)
    return obj
end

function PlagueRat:update(dt, player)
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
            self.vx = (math.random() - 0.5) * self.speed * 0.8
            self.wanderTimer = math.random(1, 2)
        end
        self.currentState = "wander"
    end
    
    self.tailTimer = self.tailTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function PlagueRat:attack(player)
    player:takeDamage(self.attackDamage)
    if player.plagueTimer then
        player.plagueTimer = 5.0
        player.plagueDamage = 4
    end
end

function PlagueRat:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local tailWhip = math.sin(self.tailTimer * 20) * 0.1
    
    love.graphics.setColor(0.5, 0.4, 0.3)
    love.graphics.rectangle("fill", dx + w*0.3, dy + h*0.3, w*0.5, h*0.4)
    
    love.graphics.rectangle("fill", dx + w*0.15 + tailWhip * w, dy + h*0.45, w*0.2, h*0.05)
    
    love.graphics.rectangle("fill", dx + w*0.7, dy + h*0.25, w*0.2, h*0.25)
    
    love.graphics.setColor(0.8, 0.2, 0.2)
    love.graphics.rectangle("fill", dx + w*0.75, dy + h*0.32, w*0.05, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.83, dy + h*0.32, w*0.05, h*0.05)
    
    love.graphics.setColor(1, 1, 1)
end

return PlagueRat
