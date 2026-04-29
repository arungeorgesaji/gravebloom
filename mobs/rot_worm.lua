local Mob = require("mobs.mob")

local RotWorm = setmetatable({}, Mob)
RotWorm.__index = RotWorm

function RotWorm:new(world, x, y, biomeData)
    local obj = Mob:new(world, "rot_worm", x, y, biomeData)
    obj.width = 70
    obj.height = 30
    obj.speed = 40
    obj.fleeSpeed = 80
    obj.fleeDistance = 60
    obj.wanderRadius = 40
    obj.wanderTimer = 1.5
    obj.squirmTimer = 0
    setmetatable(obj, RotWorm)
    return obj
end

function RotWorm:update(dt, player)
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
    
    self.squirmTimer = self.squirmTimer + dt
    Mob.update(self, dt, player)
end

function RotWorm:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local squirm = math.sin(self.squirmTimer * 15) * 0.05
    
    love.graphics.setColor(0.4, 0.3, 0.25)
    for i = 0, 4 do
        love.graphics.rectangle("fill", dx + w*0.1 + i*0.12, dy + h*0.3 + squirm * h, w*0.12, h*0.4)
    end
    
    love.graphics.setColor(0.45, 0.35, 0.3)
    love.graphics.rectangle("fill", dx + w*0.7, dy + h*0.3, w*0.15, h*0.4)
    
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("fill", dx + w*0.75, dy + h*0.4, w*0.03, h*0.03)
    love.graphics.rectangle("fill", dx + w*0.8, dy + h*0.4, w*0.03, h*0.03)
    
    love.graphics.setColor(1, 1, 1)
end

return RotWorm
