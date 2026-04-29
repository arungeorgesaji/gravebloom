local Mob = require("mobs.mob")

local Skeleton = setmetatable({}, Mob)
Skeleton.__index = Skeleton

function Skeleton:new(world, x, y, biomeData)
    local obj = Mob:new(world, "skeleton", x, y, biomeData)
    obj.width = 60
    obj.height = 85
    obj.speed = 90
    obj.aggroRange = 180
    obj.attackRange = 80
    obj.attackDamage = 12
    obj.attackCooldown = 0
    obj.attackRate = 0.8
    obj.health = 30
    obj.maxHealth = 30
    obj.wanderRadius = 70
    obj.wanderTimer = 2
    obj.projectileSpeed = 300
    setmetatable(obj, Skeleton)
    return obj
end

function Skeleton:update(dt, player)
    local dx = player.x - self.x
    local dist = math.abs(dx)
    
    if dist < self.aggroRange then
        if dist < self.attackRange then
            if dx > 0 then
                self.vx = -self.speed * 0.8
            else
                self.vx = self.speed * 0.8
            end
        else
            if dx > 0 then
                self.vx = self.speed * 0.5
            else
                self.vx = -self.speed * 0.5
            end
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
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
    
    Mob.update(self, dt, player)
end

function Skeleton:attack(player)
    local direction = player.x - self.x > 0 and 1 or -1
    local projectile = {
        x = self.x + self.width/2,
        y = self.y + self.height/2,
        vx = direction * self.projectileSpeed,
        vy = 0,
        damage = self.attackDamage,
        width = 10,
        height = 5,
        active = true
    }
    self.world:addProjectile(projectile)
end

function Skeleton:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    love.graphics.setColor(0.85, 0.8, 0.7)
    love.graphics.rectangle("fill", dx + w*0.3, dy + h*0.3, w*0.4, h*0.4)
    
    love.graphics.setColor(0.7, 0.65, 0.55)
    for i = 1, 3 do
        love.graphics.rectangle("fill", dx + w*0.25 + i*0.05, dy + h*0.35, w*0.05, h*0.15)
        love.graphics.rectangle("fill", dx + w*0.7 + i*0.05, dy + h*0.35, w*0.05, h*0.15)
    end
    
    love.graphics.setColor(0.85, 0.8, 0.7)
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.1, w*0.3, h*0.25)
    
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", dx + w*0.42, dy + h*0.15, w*0.08, h*0.08)
    love.graphics.rectangle("fill", dx + w*0.52, dy + h*0.15, w*0.08, h*0.08)
    
    love.graphics.setColor(0.5, 0.35, 0.2)
    love.graphics.rectangle("fill", dx + w*0.7, dy + h*0.4, w*0.2, h*0.08)
    
    love.graphics.setColor(1, 1, 1)
end

return Skeleton
