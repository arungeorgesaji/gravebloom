local Mob = require("mobs.mob")

local Fairy = setmetatable({}, Mob)
Fairy.__index = Fairy

function Fairy:new(world, x, y, biomeData)
    local obj = Mob:new(world, "fairy", x, y, biomeData)
    obj.width = 30
    obj.height = 35
    obj.speed = 90
    obj.fleeSpeed = 200
    obj.fleeDistance = 80
    obj.wanderRadius = 100
    obj.wanderTimer = 1.5
    obj.wingTimer = 0
    obj.sparkleTimer = 0
    obj.flying = true
    setmetatable(obj, Fairy)
    return obj
end

function Fairy:update(dt, player)
    local dx = player.x - self.x
    local dist = math.abs(dx)
    
    if dist < self.fleeDistance then
        self.vx = dx > 0 and -self.fleeSpeed or self.fleeSpeed
        self.currentState = "flee"
    else
        self.wanderTimer = self.wanderTimer - dt
        if self.wanderTimer <= 0 then
            self.vx = (math.random() - 0.5) * self.speed * 2
            self.wanderTimer = math.random(1, 2)
        end
        self.currentState = "wander"
    end
    
    self.wingTimer = self.wingTimer + dt
    self.sparkleTimer = self.sparkleTimer + dt
    
    Mob.update(self, dt, player)
end

function Fairy:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local wingAngle = math.sin(self.wingTimer * 12) * 0.4
    local sparkle = math.sin(self.sparkleTimer * 20) > 0
    
    love.graphics.setColor(0.8, 0.6, 1.0, 0.5)
    love.graphics.rectangle("fill", dx + w*0.1 + wingAngle * w*0.1, dy + h*0.2, w*0.25, h*0.3)
    love.graphics.rectangle("fill", dx + w*0.65 - wingAngle * w*0.1, dy + h*0.2, w*0.25, h*0.3)
    
    love.graphics.setColor(0.9, 0.7, 1.0)
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.3, w*0.3, h*0.3)
    
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.1, w*0.3, h*0.25)
    
    if sparkle then
        love.graphics.setColor(1.0, 0.9, 0.4, 0.8)
        love.graphics.rectangle("fill", dx + w*0.45, dy + h*0.45, w*0.03, h*0.03)
    end
    
    love.graphics.setColor(0.2, 0.2, 0.3)
    love.graphics.rectangle("fill", dx + w*0.42, dy + h*0.18, w*0.05, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.53, dy + h*0.18, w*0.05, h*0.05)
    
    love.graphics.setColor(1, 1, 1)
end

return Fairy
