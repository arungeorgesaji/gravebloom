local Mob = require("mobs.mob")

local Ghost = setmetatable({}, Mob)
Ghost.__index = Ghost

function Ghost:new(world, x, y, biomeData)
    local obj = Mob:new(world, "ghost", x, y, biomeData)
    obj.width = 50
    obj.height = 60
    obj.speed = 60
    obj.fleeSpeed = 120
    obj.fleeDistance = 90
    obj.wanderRadius = 80
    obj.wanderTimer = 2
    obj.alpha = 0.7
    obj.floatOffset = 0
    setmetatable(obj, Ghost)
    return obj
end

function Ghost:update(dt, player)
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
            self.wanderTimer = math.random(2, 3)
        end
        self.currentState = "wander"
    end
    
    self.floatOffset = self.floatOffset + dt * 2
    
    Mob.update(self, dt, player)
end

function Ghost:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0) + math.sin(self.floatOffset) * 5
    local w = self.width
    local h = self.height
    
    love.graphics.setColor(0.7, 0.7, 0.9, self.alpha)
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.2, w*0.6, h*0.5)
    
    love.graphics.rectangle("fill", dx + w*0.15, dy + h*0.6, w*0.15, h*0.15)
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.65, w*0.15, h*0.12)
    love.graphics.rectangle("fill", dx + w*0.55, dy + h*0.6, w*0.15, h*0.15)
    love.graphics.rectangle("fill", dx + w*0.75, dy + h*0.65, w*0.12, h*0.12)
    
    love.graphics.setColor(0.2, 0.2, 0.3, self.alpha)
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.35, w*0.1, h*0.12)
    love.graphics.rectangle("fill", dx + w*0.55, dy + h*0.35, w*0.1, h*0.12)
    
    love.graphics.setColor(1, 1, 1)
end

return Ghost
