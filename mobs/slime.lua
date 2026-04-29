local Mob = require("mobs.mob")

local Slime = setmetatable({}, Mob)
Slime.__index = Slime

function Slime:new(world, x, y, biomeData)
    local obj = Mob:new(world, "slime", x, y, biomeData)
    obj.width = 50
    obj.height = 40
    obj.speed = 30
    obj.fleeSpeed = 60
    obj.fleeDistance = 70
    obj.wanderRadius = 40
    obj.wanderTimer = 1
    obj.bounceTimer = 0
    obj.size = 1
    setmetatable(obj, Slime)
    return obj
end

function Slime:update(dt, player)
    local dx = player.x - self.x
    local dist = math.abs(dx)
    
    if dist < self.fleeDistance then
        self.vx = dx > 0 and -self.fleeSpeed or self.fleeSpeed
        self.currentState = "flee"
    else
        self.wanderTimer = self.wanderTimer - dt
        if self.wanderTimer <= 0 then
            self.vx = (math.random() - 0.5) * self.speed * 2
            self.wanderTimer = math.random(1, 3)
        end
        self.currentState = "wander"
    end
    
    self.bounceTimer = self.bounceTimer + dt
    
    Mob.update(self, dt, player)
end

function Slime:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local squash = 1 + math.sin(self.bounceTimer * 10) * 0.1
    local stretch = 1 - math.sin(self.bounceTimer * 10) * 0.05
    
    love.graphics.setColor(0.3, 0.7, 0.3, 0.8)
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.3 * squash, w*0.6, h*0.4 * stretch)
    
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.4, w*0.08, h*0.08)
    love.graphics.rectangle("fill", dx + w*0.57, dy + h*0.4, w*0.08, h*0.08)
    
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", dx + w*0.42, dy + h*0.55, w*0.16, h*0.04)
    
    love.graphics.setColor(1, 1, 1)
end

return Slime
