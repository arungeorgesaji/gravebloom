local Mob = require("mobs.mob")

local EveningBird = setmetatable({}, Mob)
EveningBird.__index = EveningBird

function EveningBird:new(world, x, y, biomeData)
    local obj = Mob:new(world, "evening_bird", x, y, biomeData)
    obj.width = 45
    obj.height = 40
    obj.speed = 130
    obj.fleeSpeed = 260
    obj.fleeDistance = 65
    obj.wanderRadius = 110
    obj.wanderTimer = 1.5
    obj.flapTimer = 0
    obj.flying = true
    setmetatable(obj, EveningBird)
    return obj
end

function EveningBird:update(dt, player)
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

function EveningBird:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    love.graphics.setColor(0.35, 0.3, 0.4)
    love.graphics.rectangle("fill", dx + w*0.3, dy + h*0.3, w*0.4, h*0.4)
    
    love.graphics.rectangle("fill", dx + w*0.6, dy + h*0.15, w*0.25, h*0.25)
    
    love.graphics.setColor(0.6, 0.4, 0.2)
    love.graphics.rectangle("fill", dx + w*0.8, dy + h*0.25, w*0.15, h*0.08)
    
    love.graphics.setColor(0.25, 0.2, 0.3)
    local flapOffset = math.sin(self.flapTimer * 12) * 0.08
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.35 + flapOffset * h, w*0.25, h*0.15)
    
    love.graphics.setColor(1.0, 0.7, 0.3, 0.8)
    love.graphics.rectangle("fill", dx + w*0.65, dy + h*0.2, w*0.08, h*0.08)
    
    love.graphics.setColor(1, 1, 1)
end

return EveningBird
