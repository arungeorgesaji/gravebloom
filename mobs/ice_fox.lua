local Mob = require("mobs.mob")

local IceFox = setmetatable({}, Mob)
IceFox.__index = IceFox

function IceFox:new(world, x, y, biomeData)
    local obj = Mob:new(world, "ice_fox", x, y, biomeData)
    obj.width = 70
    obj.height = 75
    obj.speed = 110
    obj.fleeSpeed = 220
    obj.fleeDistance = 95
    obj.wanderRadius = 65
    obj.wanderTimer = 2
    setmetatable(obj, IceFox)
    return obj
end

function IceFox:update(dt, player)
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

function IceFox:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    love.graphics.setColor(0.85, 0.9, 1.0)
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.3, w*0.6, h*0.45)
    
    love.graphics.rectangle("fill", dx + w*0.05, dy + h*0.4, w*0.2, h*0.25)
    
    love.graphics.rectangle("fill", dx + w*0.65, dy + h*0.15, w*0.25, h*0.25)
    
    love.graphics.rectangle("fill", dx + w*0.68, dy + h*0.0, w*0.08, h*0.15)
    love.graphics.rectangle("fill", dx + w*0.82, dy + h*0.0, w*0.08, h*0.15)
    
    love.graphics.setColor(0.5, 0.7, 1.0)
    love.graphics.rectangle("fill", dx + w*0.7, dy + h*0.22, w*0.06, h*0.06)
    love.graphics.rectangle("fill", dx + w*0.8, dy + h*0.22, w*0.06, h*0.06)
    
    love.graphics.setColor(1, 1, 1)
end

return IceFox
