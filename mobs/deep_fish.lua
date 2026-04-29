local Mob = require("mobs.mob")

local DeepFish = setmetatable({}, Mob)
DeepFish.__index = DeepFish

function DeepFish:new(world, x, y, biomeData)
    local obj = Mob:new(world, "deep_fish", x, y, biomeData)
    obj.width = 50
    obj.height = 30
    obj.speed = 70
    obj.fleeSpeed = 160
    obj.fleeDistance = 80
    obj.wanderRadius = 70
    obj.wanderTimer = 1.5
    obj.finTimer = 0
    setmetatable(obj, DeepFish)
    return obj
end

function DeepFish:update(dt, player)
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
    
    self.finTimer = self.finTimer + dt
    Mob.update(self, dt, player)
end

function DeepFish:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local finSway = math.sin(self.finTimer * 10) * 0.1
    
    love.graphics.setColor(0.2, 0.3, 0.5, 0.9)
    love.graphics.rectangle("fill", dx + w*0.3, dy + h*0.3, w*0.5, h*0.4)
    
    love.graphics.rectangle("fill", dx + w*0.15 + finSway * w, dy + h*0.4, w*0.2, h*0.1)
    
    love.graphics.rectangle("fill", dx + w*0.45, dy + h*0.2, w*0.15, h*0.1)
    
    love.graphics.setColor(0.3, 0.5, 0.8, 0.7)
    love.graphics.rectangle("fill", dx + w*0.75, dy + h*0.35, w*0.05, h*0.05)
    
    love.graphics.setColor(0.7, 0.8, 1.0)
    love.graphics.rectangle("fill", dx + w*0.65, dy + h*0.35, w*0.05, h*0.05)
    
    love.graphics.setColor(1, 1, 1)
end

return DeepFish
