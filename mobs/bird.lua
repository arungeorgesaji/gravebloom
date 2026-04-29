local Mob = require("mobs.mob")

local Bird = setmetatable({}, Mob)
Bird.__index = Bird

function Bird:new(world, x, y, biomeData)
    local obj = Mob:new(world, "bird", x, y, biomeData)
    obj.width = 40
    obj.height = 35
    obj.speed = 120
    obj.fleeSpeed = 250
    obj.fleeDistance = 60
    obj.wanderRadius = 100
    obj.wanderTimer = 1.5
    obj.flying = true
    obj.flapTimer = 0
    setmetatable(obj, Bird)
    return obj
end

function Bird:update(dt, player)
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
    
    self.flapTimer = self.flapTimer + dt
    
    Mob.update(self, dt, player)
end

function Bird:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    love.graphics.setColor(0.4, 0.5, 0.6)
    love.graphics.rectangle("fill", dx + w*0.3, dy + h*0.3, w*0.4, h*0.4)
    
    love.graphics.rectangle("fill", dx + w*0.6, dy + h*0.15, w*0.25, h*0.25)
    
    love.graphics.setColor(0.8, 0.6, 0.2)
    love.graphics.rectangle("fill", dx + w*0.8, dy + h*0.25, w*0.15, h*0.08)
    
    love.graphics.setColor(0.35, 0.45, 0.55)
    local flapOffset = math.sin(self.flapTimer * 10) * 0.1
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.35 + flapOffset * h, w*0.25, h*0.15)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", dx + w*0.65, dy + h*0.2, w*0.08, h*0.08)
    
    love.graphics.setColor(1, 1, 1)
end

return Bird
