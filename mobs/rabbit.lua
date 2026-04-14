local Mob = require("mobs.mob")

local Rabbit = setmetatable({}, Mob)
Rabbit.__index = Rabbit

function Rabbit:new(world, x, y, biomeData)
    local obj = Mob:new(world, "rabbit", x, y, biomeData)
    obj.width = 20
    obj.height = 18
    obj.speed = 80
    obj.fleeSpeed = 150
    obj.fleeDistance = 80
    obj.wanderRadius = 50
    obj.wanderTimer = 2
    setmetatable(obj, Rabbit)
    return obj
end

function Rabbit:update(dt, player)
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
            self.wanderTimer = math.random(1, 3)
        end
        self.currentState = "wander"
    end
    
    Mob.update(self, dt, player)
end

function Rabbit:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    love.graphics.setColor(0.7, 0.5, 0.4) 
    love.graphics.ellipse("fill", dx + self.width/2, dy + self.height/2, 10, 8)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", dx + 14, dy + 8, 2)
    love.graphics.circle("fill", dx + 6, dy + 8, 2)
end

return Rabbit
