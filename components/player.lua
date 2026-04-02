local Player = {}

function Player:new(world)
    local obj = {
        x = 400,
        y = 100,
        vx = 0,
        vy = 0,
        width = 35,
        height = 35,
        speed = 400,
        jumpPower = -500,
        grounded = false,
        world = world,
    }
    
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Player:update(dt)
    if love.keyboard.isDown("a") then
        self.vx = -self.speed
    elseif love.keyboard.isDown("d") then
        self.vx = self.speed
    else
        self.vx = self.vx * 0.9
    end
    
    if love.keyboard.isDown("w") and self.grounded then
        self.vy = self.jumpPower
        self.grounded = false
    end
    
    self.vy = self.vy + 1000 * dt
    
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
    
    local feetY = self.y + self.height
    if self.world:isGround(self.x, feetY) or self.world:isGround(self.x + self.width, feetY) then
        self.y = math.floor(feetY / 32) * 32 - self.height
        self.vy = 0
        self.grounded = true
    else
        self.grounded = false
    end
    
    if self.x < 0 then self.x = 0 end
    if self.x + self.width > self.world.width * 32 then
        self.x = self.world.width * 32 - self.width
    end
end

function Player:draw()
    love.graphics.setColor(0.9, 0.6, 0.4)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.x + self.width * 0.7, self.y + self.height * 0.3, 4)
    love.graphics.circle("fill", self.x + self.width * 0.3, self.y + self.height * 0.3, 4)
end

return Player
