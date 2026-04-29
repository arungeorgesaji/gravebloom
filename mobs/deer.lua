local Mob = require("mobs.mob")

local Deer = setmetatable({}, Mob)
Deer.__index = Deer

function Deer:new(world, x, y, biomeData)
    local obj = Mob:new(world, "deer", x, y, biomeData)
    obj.width = 80
    obj.height = 90
    obj.speed = 100
    obj.fleeSpeed = 200
    obj.fleeDistance = 100
    obj.wanderRadius = 70
    obj.wanderTimer = 2.5
    setmetatable(obj, Deer)
    return obj
end

function Deer:update(dt, player)
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
            self.wanderTimer = math.random(2, 4)
        end
        self.currentState = "wander"
    end
    
    Mob.update(self, dt, player)
end

function Deer:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    love.graphics.setColor(0.55, 0.4, 0.3)
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.3, w*0.6, h*0.45)
    
    love.graphics.rectangle("fill", dx + w*0.6, dy + h*0.15, w*0.2, h*0.3)
    
    love.graphics.rectangle("fill", dx + w*0.7, dy + h*0.05, w*0.2, h*0.2)
    
    love.graphics.setColor(0.4, 0.3, 0.2)
    love.graphics.rectangle("fill", dx + w*0.75, dy + h*0.0, w*0.05, h*0.1)
    love.graphics.rectangle("fill", dx + w*0.85, dy + h*0.0, w*0.05, h*0.1)
    
    -- Eyes
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", dx + w*0.72, dy + h*0.1, w*0.06, h*0.06)
    love.graphics.rectangle("fill", dx + w*0.82, dy + h*0.1, w*0.06, h*0.06)
    
    love.graphics.setColor(1, 1, 1)
end

return Deer
