local Mob = require("mobs.mob")

local Butterfly = setmetatable({}, Mob)
Butterfly.__index = Butterfly

function Butterfly:new(world, x, y, biomeData)
    local obj = Mob:new(world, "butterfly", x, y, biomeData)
    obj.width = 35
    obj.height = 30
    obj.speed = 65
    obj.fleeSpeed = 160
    obj.fleeDistance = 60
    obj.wanderRadius = 85
    obj.wanderTimer = 1.5
    obj.wingTimer = 0
    obj.flying = true
    setmetatable(obj, Butterfly)
    return obj
end

function Butterfly:update(dt, player)
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
    Mob.update(self, dt, player)
end

function Butterfly:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local wingBeat = math.sin(self.wingTimer * 14) * 0.4
    
    love.graphics.setColor(0.9, 0.5, 0.7, 0.7)
    love.graphics.rectangle("fill", dx + w*0.1 + wingBeat * w*0.1, dy + h*0.2, w*0.3, h*0.35)
    love.graphics.rectangle("fill", dx + w*0.6 - wingBeat * w*0.1, dy + h*0.2, w*0.3, h*0.35)
    
    love.graphics.setColor(0.3, 0.2, 0.4)
    love.graphics.rectangle("fill", dx + w*0.4, dy + h*0.3, w*0.2, h*0.3)
    
    love.graphics.setColor(0.2, 0.15, 0.3)
    love.graphics.rectangle("fill", dx + w*0.45, dy + h*0.15, w*0.03, h*0.08)
    love.graphics.rectangle("fill", dx + w*0.52, dy + h*0.15, w*0.03, h*0.08)
    
    love.graphics.setColor(1, 1, 1)
end

return Butterfly
