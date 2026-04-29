local Mob = require("mobs.mob")

local Mothling = setmetatable({}, Mob)
Mothling.__index = Mothling

function Mothling:new(world, x, y, biomeData)
    local obj = Mob:new(world, "mothling", x, y, biomeData)
    obj.width = 40
    obj.height = 35
    obj.speed = 75
    obj.fleeSpeed = 170
    obj.fleeDistance = 65
    obj.wanderRadius = 85
    obj.wanderTimer = 1.5
    obj.wingTimer = 0
    obj.flying = true
    setmetatable(obj, Mothling)
    return obj
end

function Mothling:update(dt, player)
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

function Mothling:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local wingBeat = math.sin(self.wingTimer * 18) * 0.4
    
    love.graphics.setColor(0.7, 0.5, 0.8, 0.6)
    love.graphics.rectangle("fill", dx + w*0.1 + wingBeat * w*0.1, dy + h*0.2, w*0.3, h*0.35)
    love.graphics.rectangle("fill", dx + w*0.6 - wingBeat * w*0.1, dy + h*0.2, w*0.3, h*0.35)
    
    love.graphics.setColor(0.5, 0.3, 0.6)
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.3, w*0.3, h*0.3)
    
    love.graphics.setColor(0.4, 0.2, 0.5)
    love.graphics.rectangle("fill", dx + w*0.4, dy + h*0.15, w*0.05, h*0.08)
    love.graphics.rectangle("fill", dx + w*0.55, dy + h*0.15, w*0.05, h*0.08)
    
    love.graphics.setColor(0.3, 0.2, 0.4)
    love.graphics.rectangle("fill", dx + w*0.42, dy + h*0.35, w*0.05, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.53, dy + h*0.35, w*0.05, h*0.05)
    
    love.graphics.setColor(1, 1, 1)
end

return Mothling
