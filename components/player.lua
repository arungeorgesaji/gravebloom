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
    obj:findSafeSpawn()
    return obj
end

function Player:left() return self.x end
function Player:right() return self.x + self.width - 1 end
function Player:top() return self.y end
function Player:bottom() return self.y + self.height - 1 end

function Player:findSafeSpawn()
    local ts = self.world.tileSize

    for ty = 0, self.world.height * ts, ts do
        local feetY = ty + self.height - 1

        local onGround =
            self.world:isGround(self:left(), feetY) or
            self.world:isGround(self:right(), feetY)

        local bodyBlocked =
            self.world:isGround(self:left(), ty) or
            self.world:isGround(self:right(), ty)

        if onGround and not bodyBlocked then
            self.y = ty
            return
        end
    end
end

function Player:update(dt)
    local ts = self.world.tileSize

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

    local checkYs = {
        self:top() + 2,
        self:top() + self.height * 0.5,
        self:bottom() - 2
    }

    if self.vx > 0 then
        for _, cy in ipairs(checkYs) do
            if self.world:isGround(self:right(), cy) then
                self.x = math.floor(self:right() / ts) * ts - self.width
                self.vx = 0
                break
            end
        end
    elseif self.vx < 0 then
        for _, cy in ipairs(checkYs) do
            if self.world:isGround(self:left(), cy) then
                self.x = math.ceil(self:left() / ts) * ts
                self.vx = 0
                break
            end
        end
    end

    if self.x < 0 then
        self.x = 0
        self.vx = 0
    end

    if self:right() > self.world.width * ts then
        self.x = self.world.width * ts - self.width
        self.vx = 0
    end

    self.y = self.y + self.vy * dt

    local feet = self:bottom()

    if self.vy >= 0 then
        if self.world:isGround(self:left() + 2, feet) or
           self.world:isGround(self:right() - 2, feet) then

            self.y = math.floor(feet / ts) * ts - self.height
            self.vy = 0
            self.grounded = true
        else
            self.grounded = false
        end
    else
        if self.world:isGround(self:left() + 2, self:top()) or
           self.world:isGround(self:right() - 2, self:top()) then

            self.y = math.ceil(self:top() / ts) * ts
            self.vy = 0
        end
    end
end

function Player:draw(cameraX, cameraY)
    local dx = self.x - (cameraX or 0)
    local dy = self.y - (cameraY or 0)

    love.graphics.setColor(0.9, 0.6, 0.4)
    love.graphics.rectangle("fill", dx, dy, self.width, self.height)

    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", dx + self.width * 0.7, dy + self.height * 0.3, 4)
    love.graphics.circle("fill", dx + self.width * 0.3, dy + self.height * 0.3, 4)
end

return Player
