local Mob = require("mobs.mob")

local Shardling = setmetatable({}, Mob)
Shardling.__index = Shardling

function Shardling:new(world, x, y, biomeData)
    local obj = Mob:new(world, "shardling", x, y, biomeData)
    obj.width = 40
    obj.height = 45
    obj.speed = 65
    obj.fleeSpeed = 150
    obj.fleeDistance = 75
    obj.wanderRadius = 60
    obj.wanderTimer = 1.8
    obj.shimmerTimer = 0
    setmetatable(obj, Shardling)
    return obj
end

function Shardling:update(dt, player)
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
    
    self.shimmerTimer = self.shimmerTimer + dt
    Mob.update(self, dt, player)
end

function Shardling:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local shimmer = (math.sin(self.shimmerTimer * 10) + 1) / 2
    
    love.graphics.setColor(0.5, 0.6, 0.9, 0.7 + shimmer * 0.3)
    love.graphics.rectangle("fill", dx + w*0.25, dy + h*0.3, w*0.5, h*0.4)
    
    love.graphics.setColor(0.6, 0.7, 1.0)
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.35, w*0.08, h*0.15)
    love.graphics.rectangle("fill", dx + w*0.72, dy + h*0.35, w*0.08, h*0.15)
    love.graphics.rectangle("fill", dx + w*0.4, dy + h*0.25, w*0.08, h*0.12)
    love.graphics.rectangle("fill", dx + w*0.52, dy + h*0.25, w*0.08, h*0.12)
    
    love.graphics.setColor(0.2, 0.3, 0.5)
    love.graphics.rectangle("fill", dx + w*0.4, dy + h*0.4, w*0.06, h*0.06)
    love.graphics.rectangle("fill", dx + w*0.54, dy + h*0.4, w*0.06, h*0.06)
    
    love.graphics.setColor(1, 1, 1)
end

return Shardling
