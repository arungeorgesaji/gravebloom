local Mob = require("mobs.mob")

local FungusBeetle = setmetatable({}, Mob)
FungusBeetle.__index = FungusBeetle

function FungusBeetle:new(world, x, y, biomeData)
    local obj = Mob:new(world, "fungus_beetle", x, y, biomeData)
    obj.width = 55
    obj.height = 40
    obj.speed = 60
    obj.fleeSpeed = 130
    obj.fleeDistance = 75
    obj.wanderRadius = 60
    obj.wanderTimer = 1.8
    obj.legTimer = 0
    setmetatable(obj, FungusBeetle)
    return obj
end

function FungusBeetle:update(dt, player)
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
    
    self.legTimer = self.legTimer + dt
    Mob.update(self, dt, player)
end

function FungusBeetle:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local legMove = math.sin(self.legTimer * 12) * 0.05
    
    love.graphics.setColor(0.4, 0.3, 0.2)
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.5 + legMove * h, w*0.1, h*0.1)
    love.graphics.rectangle("fill", dx + w*0.7, dy + h*0.5 - legMove * h, w*0.1, h*0.1)
    
    love.graphics.setColor(0.35, 0.45, 0.25)
    love.graphics.rectangle("fill", dx + w*0.25, dy + h*0.3, w*0.5, h*0.35)
    
    love.graphics.setColor(0.5, 0.6, 0.3)
    love.graphics.rectangle("fill", dx + w*0.3, dy + h*0.2, w*0.08, h*0.1)
    love.graphics.rectangle("fill", dx + w*0.62, dy + h*0.2, w*0.08, h*0.1)
    
    love.graphics.setColor(0.6, 0.3, 0.5)
    love.graphics.rectangle("fill", dx + w*0.4, dy + h*0.15, w*0.2, h*0.08)
    
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("fill", dx + w*0.4, dy + h*0.35, w*0.05, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.55, dy + h*0.35, w*0.05, h*0.05)
    
    love.graphics.setColor(1, 1, 1)
end

return FungusBeetle
