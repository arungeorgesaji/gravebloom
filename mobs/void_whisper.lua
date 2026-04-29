local Mob = require("mobs.mob")

local VoidWhisper = setmetatable({}, Mob)
VoidWhisper.__index = VoidWhisper

function VoidWhisper:new(world, x, y, biomeData)
    local obj = Mob:new(world, "void_whisper", x, y, biomeData)
    obj.width = 40
    obj.height = 40
    obj.speed = 60
    obj.fleeSpeed = 140
    obj.fleeDistance = 100
    obj.wanderRadius = 80
    obj.wanderTimer = 1.8
    obj.whisperTimer = 0
    obj.flying = true
    setmetatable(obj, VoidWhisper)
    return obj
end

function VoidWhisper:update(dt, player)
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
    
    self.whisperTimer = self.whisperTimer + dt
    Mob.update(self, dt, player)
end

function VoidWhisper:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local whisperPulse = (math.sin(self.whisperTimer * 8) + 1) / 2
    
    love.graphics.setColor(0.15, 0.08, 0.25, 0.5 + whisperPulse * 0.2)
    love.graphics.rectangle("fill", dx + w*0.25, dy + h*0.25, w*0.5, h*0.5)
    
    love.graphics.setColor(0.4, 0.2, 0.6, 0.6)
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.35, w*0.05, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.6, dy + h*0.4, w*0.05, h*0.05)
    
    love.graphics.setColor(0.6, 0.3, 0.8, 0.7 + whisperPulse * 0.3)
    love.graphics.rectangle("fill", dx + w*0.45, dy + h*0.4, w*0.1, h*0.1)
    
    love.graphics.setColor(1, 1, 1)
end

return VoidWhisper
