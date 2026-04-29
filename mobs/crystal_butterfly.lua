local Mob = require("mobs.mob")

local CrystalButterfly = setmetatable({}, Mob)
CrystalButterfly.__index = CrystalButterfly

function CrystalButterfly:new(world, x, y, biomeData)
    local obj = Mob:new(world, "crystal_butterfly", x, y, biomeData)
    obj.width = 35
    obj.height = 30
    obj.speed = 70
    obj.fleeSpeed = 180
    obj.fleeDistance = 60
    obj.wanderRadius = 90
    obj.wanderTimer = 1.5
    obj.wingTimer = 0
    obj.flying = true
    obj.glowTimer = 0
    setmetatable(obj, CrystalButterfly)
    return obj
end

function CrystalButterfly:update(dt, player)
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
    
    self.wingTimer = self.wingTimer + dt
    self.glowTimer = self.glowTimer + dt
    
    Mob.update(self, dt, player)
end

function CrystalButterfly:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local wingAngle = math.sin(self.wingTimer * 15) * 0.5
    local glow = (math.sin(self.glowTimer * 8) + 1) / 2
    
    love.graphics.setColor(0.5, 0.6, 1.0, 0.3 + glow * 0.2)
    love.graphics.rectangle("fill", dx + w*0.5 - w*0.5, dy + h*0.5 - h*0.5, w, h)
    
    love.graphics.setColor(0.4, 0.5, 0.9, 0.7)
    love.graphics.rectangle("fill", dx + w*0.1 + wingAngle * w*0.1, dy + h*0.2, w*0.3, h*0.3)
    love.graphics.rectangle("fill", dx + w*0.6 - wingAngle * w*0.1, dy + h*0.2, w*0.3, h*0.3)
    
    love.graphics.setColor(0.6, 0.7, 1.0)
    love.graphics.rectangle("fill", dx + w*0.4, dy + h*0.4, w*0.2, h*0.2)
    
    love.graphics.setColor(0.8, 0.9, 1.0, 0.8)
    love.graphics.rectangle("fill", dx + w*0.45, dy + h*0.45, w*0.03, h*0.03)
    love.graphics.rectangle("fill", dx + w*0.55, dy + h*0.5, w*0.03, h*0.03)
    
    love.graphics.setColor(1, 1, 1)
end

return CrystalButterfly
