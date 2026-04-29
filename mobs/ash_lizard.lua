local Mob = require("mobs.mob")

local AshLizard = setmetatable({}, Mob)
AshLizard.__index = AshLizard

function AshLizard:new(world, x, y, biomeData)
    local obj = Mob:new(world, "ash_lizard", x, y, biomeData)
    obj.width = 65
    obj.height = 45
    obj.speed = 90
    obj.fleeSpeed = 180
    obj.fleeDistance = 85
    obj.wanderRadius = 65
    obj.wanderTimer = 2
    obj.tailTimer = 0
    setmetatable(obj, AshLizard)
    return obj
end

function AshLizard:update(dt, player)
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

function AshLizard:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local tailWag = math.sin(self.tailTimer * 8) * 0.1
    
    love.graphics.setColor(0.4, 0.35, 0.3)
    love.graphics.rectangle("fill", dx + w*0.3, dy + h*0.3, w*0.5, h*0.4)
    
    love.graphics.rectangle("fill", dx + w*0.15 + tailWag * w, dy + h*0.45, w*0.2, h*0.08)
    
    love.graphics.rectangle("fill", dx + w*0.7, dy + h*0.25, w*0.2, h*0.25)
    
    love.graphics.setColor(0.5, 0.45, 0.4)
    love.graphics.rectangle("fill", dx + w*0.4, dy + h*0.35, w*0.05, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.5, dy + h*0.35, w*0.05, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.6, dy + h*0.35, w*0.05, h*0.05)
    
    love.graphics.setColor(0.8, 0.5, 0.2)
    love.graphics.rectangle("fill", dx + w*0.75, dy + h*0.32, w*0.05, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.83, dy + h*0.32, w*0.05, h*0.05)
    
    love.graphics.setColor(1, 1, 1)
end

return AshLizard
