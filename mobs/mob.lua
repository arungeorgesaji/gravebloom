local Mob = {}
Mob.__index = Mob

function Mob:new(world, type, x, y, biomeData)
    local obj = {
        world = world,
        type = type,
        x = x,
        y = y,
        width = 25,
        height = 25,
        vx = 0,
        vy = 0,
        health = 10,
        maxHealth = 10,
        isHostile = false,
        agroRange = 100,
        attackCooldown = 0,
        wanderTimer = 0,
        currentState = "idle", 
        biomeData = biomeData,
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Mob:update(dt, player)
    self:applyGravity(dt)
    self:move(dt)
    self:checkWorldCollision()
    
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
end

function Mob:applyGravity(dt)
    self.vy = self.vy + 1000 * dt
end

function Mob:move(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

function Mob:checkWorldCollision()
    local ts = self.world.tileSize
    if self.x < 0 then self.x = 0 end
    if self:right() > self.world.width * ts then
        self.x = self.world.width * ts - self.width
    end
    local feet = self:bottom()
    if self.vy >= 0 and self.world:isGround(self:left() + 2, feet) then
        self.y = math.floor(feet / ts) * ts - self.height
        self.vy = 0
    end
end

function Mob:left() return self.x end
function Mob:right() return self.x + self.width - 1 end
function Mob:top() return self.y end
function Mob:bottom() return self.y + self.height - 1 end

function Mob:takeDamage(amount)
    self.health = self.health - amount
    return self.health <= 0
end

function Mob:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)
    love.graphics.setColor(0.8, 0.4, 0.4) 
    love.graphics.rectangle("fill", dx, dy, self.width, self.height)
end

return Mob
