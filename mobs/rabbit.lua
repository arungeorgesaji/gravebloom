local Mob = require("mobs.mob")

local Rabbit = setmetatable({}, Mob)
Rabbit.__index = Rabbit

function Rabbit:new(world, x, y, biomeData)
    local obj = Mob:new(world, "rabbit", x, y, biomeData)
    obj.width = 60
    obj.height = 70
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

    local w = self.width
    local h = self.height

    -- Body (square)
    love.graphics.setColor(0.7, 0.5, 0.4)
    love.graphics.rectangle("fill", dx + w*0.2, dy + h*0.3, w*0.6, h*0.4)

    -- Ears (rectangular)
    love.graphics.rectangle("fill", dx + w*0.3, dy + h*0.05, w*0.1, h*0.25)
    love.graphics.rectangle("fill", dx + w*0.6, dy + h*0.05, w*0.1, h*0.25)

    -- Eyes
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", dx + w*0.6, dy + h*0.4, w*0.08, h*0.08)
    love.graphics.rectangle("fill", dx + w*0.32, dy + h*0.4, w*0.08, h*0.08)

    -- Mouth
    love.graphics.setColor(0.4, 0.2, 0.2)
    love.graphics.rectangle("fill", dx + w*0.45, dy + h*0.55, w*0.1, h*0.05)

    love.graphics.setColor(1, 1, 1)
end

return Rabbit
