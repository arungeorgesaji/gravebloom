local Mob = require("mobs.mob")

local ShardSpider = setmetatable({}, Mob)
ShardSpider.__index = ShardSpider

function ShardSpider:new(world, x, y, biomeData)
    local obj = Mob:new(world, "shard_spider", x, y, biomeData)
    obj.width = 70
    obj.height = 60
    obj.speed = 130
    obj.aggroRange = 150
    obj.attackRange = 35
    obj.attackDamage = 18
    obj.attackCooldown = 0
    obj.attackRate = 0.8
    obj.health = 45
    obj.maxHealth = 45
    obj.wanderRadius = 70
    obj.wanderTimer = 1.5
    obj.legTimer = 0
    setmetatable(obj, ShardSpider)
    return obj
end

function ShardSpider:update(dt, player)
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
    
    self.legTimer = self.legTimer + dt
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function ShardSpider:attack(player)
    player:takeDamage(self.attackDamage)
end

function ShardSpider:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local legSwing = math.sin(self.legTimer * 15) * 0.1
    
    love.graphics.setColor(0.4, 0.3, 0.5)
    for i = 1, 4 do
        love.graphics.rectangle("fill", dx + w*0.1 + i*0.1, dy + h*0.4 + legSwing * h, w*0.08, h*0.2)
        love.graphics.rectangle("fill", dx + w*0.82 + i*0.1, dy + h*0.4 + legSwing * h, w*0.08, h*0.2)
    end
    
    love.graphics.setColor(0.5, 0.4, 0.6)
    love.graphics.rectangle("fill", dx + w*0.3, dy + h*0.35, w*0.4, h*0.35)
    
    love.graphics.setColor(0.6, 0.5, 0.8)
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.3, w*0.3, h*0.1)
    
    love.graphics.rectangle("fill", dx + w*0.4, dy + h*0.2, w*0.2, h*0.2)
    
    love.graphics.setColor(0.8, 0.3, 0.8)
    love.graphics.rectangle("fill", dx + w*0.44, dy + h*0.25, w*0.04, h*0.04)
    love.graphics.rectangle("fill", dx + w*0.52, dy + h*0.25, w*0.04, h*0.04)
    love.graphics.rectangle("fill", dx + w*0.48, dy + h*0.3, w*0.04, h*0.04)
    
    love.graphics.setColor(1, 1, 1)
end

return ShardSpider
