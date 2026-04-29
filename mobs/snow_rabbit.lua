local Mob = require("mobs.mob")

local SnowRabbit = setmetatable({}, Mob)
SnowRabbit.__index = SnowRabbit

function SnowRabbit:new(world, x, y, biomeData)
    local obj = Mob:new(world, "snow_rabbit", x, y, biomeData)
    obj.width = 55
    obj.height = 65
    obj.speed = 85
    obj.fleeSpeed = 160
    obj.fleeDistance = 85
    obj.wanderRadius = 55
    obj.wanderTimer = 2.2
    setmetatable(obj, SnowRabbit)
    return obj
end

function SnowRabbit:update(dt, player)
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
            self.wanderTimer = math.random(1, 3)
        end
        self.currentState = "wander"
    end
    
    Mob.update(self, dt, player)
end

function SnowRabbit:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    love.graphics.setColor(0.95, 0.95, 1.0)
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.3, w*0.6, h*0.4)
    
    love.graphics.rectangle("fill", dx + w*0.3, dy + h*0.05, w*0.1, h*0.25)
    love.graphics.rectangle("fill", dx + w*0.6, dy + h*0.05, w*0.1, h*0.25)
    
    love.graphics.setColor(0.9, 0.6, 0.7)
    love.graphics.rectangle("fill", dx + w*0.6, dy + h*0.4, w*0.08, h*0.08)
    love.graphics.rectangle("fill", dx + w*0.32, dy + h*0.4, w*0.08, h*0.08)
    
    love.graphics.setColor(1, 1, 1)
end

return SnowRabbit
