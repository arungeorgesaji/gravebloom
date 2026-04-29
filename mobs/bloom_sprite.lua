local Mob = require("mobs.mob")

local BloomSprite = setmetatable({}, Mob)
BloomSprite.__index = BloomSprite

function BloomSprite:new(world, x, y, biomeData)
    local obj = Mob:new(world, "bloom_sprite", x, y, biomeData)
    obj.width = 30
    obj.height = 35
    obj.speed = 85
    obj.fleeSpeed = 190
    obj.fleeDistance = 70
    obj.wanderRadius = 90
    obj.wanderTimer = 1.5
    obj.petalTimer = 0
    obj.flying = true
    setmetatable(obj, BloomSprite)
    return obj
end

function BloomSprite:update(dt, player)
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
    
    self.petalTimer = self.petalTimer + dt
    Mob.update(self, dt, player)
end

function BloomSprite:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    local w = self.width
    local h = self.height
    
    local bloom = (math.sin(self.petalTimer * 8) + 1) / 2
    
    love.graphics.setColor(0.9, 0.5, 0.7, 0.7)
    for i = 0, 4 do
        local angle = i * 72 + self.petalTimer * 50
        local offsetX = math.sin(angle) * w * 0.2
        local offsetY = math.cos(angle) * h * 0.2
        love.graphics.rectangle("fill", dx + w*0.4 + offsetX, dy + h*0.4 + offsetY, w*0.15, h*0.15)
    end
    
    love.graphics.setColor(0.9, 0.6, 0.8)
    love.graphics.rectangle("fill", dx + w*0.35, dy + h*0.3, w*0.3, h*0.3)
    
    love.graphics.setColor(1.0, 0.8, 0.4, 0.5 + bloom * 0.3)
    love.graphics.rectangle("fill", dx + w*0.45, dy + h*0.4, w*0.1, h*0.1)
    
    love.graphics.setColor(0.3, 0.2, 0.4)
    love.graphics.rectangle("fill", dx + w*0.42, dy + h*0.35, w*0.05, h*0.05)
    love.graphics.rectangle("fill", dx + w*0.53, dy + h*0.35, w*0.05, h*0.05)
    
    love.graphics.setColor(1, 1, 1)
end

return BloomSprite
