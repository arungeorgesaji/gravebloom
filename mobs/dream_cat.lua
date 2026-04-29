local Mob = require("mobs.mob")

local DreamCat = setmetatable({}, Mob)
DreamCat.__index = DreamCat

function DreamCat:new(world, x, y, biomeData)
    local obj = Mob:new(world, "dream_cat", x, y, biomeData)
    obj.width = 55
    obj.height = 50
    obj.speed = 100
    obj.fleeSpeed = 200
    obj.fleeDistance = 90
    obj.wanderRadius = 75
    obj.wanderTimer = 2
    obj.tailTimer = 0
    setmetatable(obj, DreamCat)
    return obj
end

function DreamCat:update(dt, player)
    local dx = player.x - self.x
    local dist = math.abs(dx)
    
    if dist < self.fleeDistance then
        self.vx = dx > 0 and -self.fleeSpeed or self.fleeSpeed
        self.currentState = "flee"
    else
        self.wanderTimer = self.wanderTimer - dt
        if self.wanderTimer <= 0 then
            self.vx = (math.random() - 0.5) * self.speed * 2
            self.wanderTimer = math.random(2, 3)
        end
        self.currentState = "wander"
    end
    
    self.tailTimer = self.tailTimer + dt
    Mob.update(self, dt, player)
end

function DreamCat:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local tailSway = math.sin(self.tailTimer * 6) * 0.1
    
    love.graphics.setColor(0.6, 0.4, 0.8, 0.85)
    love.graphics.rectangle("fill", dx + w*0.25, dy + h*0.3, w*0.5, h*0.45)
    
    love.graphics.rectangle("fill", dx + w*0.15 + tailSway * w, dy + h*0.5, w*0.15, h*0.08)
    
    love.graphics.rectangle("fill", dx + w*0.65, dy + h*0.15, w*0.25, h*0.25)
    
    love.graphics.rectangle("fill", dx + w*0.68, dy + h*0.02, w*0.07, h*0.13)
    love.graphics.rectangle("fill", dx + w*0.8, dy + h*0.02, w*0.07, h*0.13)
    
    love.graphics.setColor(0.7, 0.5, 1.0)
    love.graphics.rectangle("fill", dx + w*0.72, dy + h*0.22, w*0.05, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.82, dy + h*0.22, w*0.05, h*0.05)
    
    love.graphics.setColor(1, 1, 1)
end

return DreamCat
