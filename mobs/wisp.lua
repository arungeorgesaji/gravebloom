local Mob = require("mobs.mob")

local Wisp = setmetatable({}, Mob)
Wisp.__index = Wisp

function Wisp:new(world, x, y, biomeData)
    local obj = Mob:new(world, "wisp", x, y, biomeData)
    obj.width = 30
    obj.height = 30
    obj.speed = 40
    obj.fleeSpeed = 80
    obj.fleeDistance = 70
    obj.wanderRadius = 60
    obj.wanderTimer = 1.8
    obj.pulseTimer = 0
    setmetatable(obj, Wisp)
    return obj
end

function Wisp:update(dt, player)
    local dx = player.x - self.x
    local dist = math.abs(dx)
    
    if dist < self.fleeDistance then
        if dx > 0 then
            self.vx = -self.fleeSpeed
        else
            self.vx = self.fleeSpeed
        end
        self.currentState = "flee"
    else
        self.wanderTimer = self.wanderTimer - dt
        if self.wanderTimer <= 0 then
            self.vx = (math.random() - 0.5) * self.speed * 2
            self.wanderTimer = math.random(1, 2)
        end
        self.currentState = "wander"
    end
    
    self.pulseTimer = self.pulseTimer + dt
    
    Mob.update(self, dt, player)
end

function Wisp:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local pulse = (math.sin(self.pulseTimer * 5) + 1) / 2
    local alpha = 0.5 + pulse * 0.3
    local size = 1 + pulse * 0.2
    
    love.graphics.setColor(0.5, 0.8, 1.0, alpha * 0.5)
    love.graphics.rectangle("fill", dx + w*0.5 - w*0.3*size, dy + h*0.5 - h*0.3*size, 
                           w*0.6*size, h*0.6*size)
    
    love.graphics.setColor(0.6, 0.9, 1.0, alpha)
    love.graphics.rectangle("fill", dx + w*0.3, dy + h*0.3, w*0.4, h*0.4)
    
    love.graphics.setColor(1, 1, 1)
end

return Wisp
