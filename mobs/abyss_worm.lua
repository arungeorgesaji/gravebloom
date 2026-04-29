local Mob = require("mobs.mob")

local AbyssWorm = setmetatable({}, Mob)
AbyssWorm.__index = AbyssWorm

function AbyssWorm:new(world, x, y, biomeData)
    local obj = Mob:new(world, "abyss_worm", x, y, biomeData)
    obj.width = 80
    obj.height = 25
    obj.speed = 50
    obj.fleeSpeed = 100
    obj.fleeDistance = 70
    obj.wanderRadius = 50
    obj.wanderTimer = 1.5
    obj.wiggleTimer = 0
    setmetatable(obj, AbyssWorm)
    return obj
end

function AbyssWorm:update(dt, player)
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
    
    self.wiggleTimer = self.wiggleTimer + dt
    Mob.update(self, dt, player)
end

function AbyssWorm:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local wiggle = math.sin(self.wiggleTimer * 12) * 0.05
    
    love.graphics.setColor(0.15, 0.1, 0.2)
    for i = 0, 5 do
        love.graphics.rectangle("fill", dx + w*0.1 + i*0.12 + wiggle * w, dy + h*0.3, w*0.12, h*0.4)
    end
    
    love.graphics.setColor(0.3, 0.2, 0.5, 0.6)
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.4, w*0.05, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.55, dy + h*0.4, w*0.05, h*0.05)
    
    love.graphics.setColor(0.3, 0.2, 0.4)
    love.graphics.rectangle("fill", dx + w*0.8, dy + h*0.35, w*0.08, h*0.1)
    
    love.graphics.setColor(1, 1, 1)
end

return AbyssWorm
