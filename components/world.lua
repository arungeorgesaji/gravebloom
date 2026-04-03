local World = {}

function World:new(width, height)
    local obj = {
        width = width or 100,
        height = height or 40,
        tileSize = 32,
        tiles = {},
        clouds = {},
        skyElements = {}
    }
    
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function World:generate()
    for x = 1, self.width do
        self.tiles[x] = {}
        for y = 1, self.height do
            self.tiles[x][y] = "air"
        end
    end
    
    for x = 1, self.width do
        for y = 15, self.height do
            self.tiles[x][y] = "ground"
        end
    end
    
    self:generateClouds()
    
    self:generateSkyElements()
end

function World:generateClouds()
    self.clouds = {}
    
    local numClouds = math.random(15, 25)
    
    for i = 1, numClouds do
        local cloud = {
            x = math.random(0, self.width * self.tileSize),
            y = math.random(50, 300),  
            width = math.random(60, 150),
            height = math.random(30, 60),
            speed = math.random(10, 30) / 100,  
            alpha = math.random(30, 60) / 100,   
            segments = {}  
        }
        
        local numSegments = math.random(3, 6)
        for j = 1, numSegments do
            table.insert(cloud.segments, {
                x = math.random(-cloud.width/3, cloud.width/3),
                y = math.random(-cloud.height/4, cloud.height/4),
                radius = math.random(cloud.width/4, cloud.width/2)
            })
        end
        
        table.insert(self.clouds, cloud)
    end
end

function World:generateSkyElements()
    self.skyElements = {}
    
    local numSpores = math.random(30, 50)
    for i = 1, numSpores do
        table.insert(self.skyElements, {
            type = "spore",
            x = math.random(0, self.width * self.tileSize),
            y = math.random(0, 400),
            size = math.random(2, 5),
            speedX = math.random(-10, 10) / 100,
            speedY = math.random(-5, 15) / 100,
            alpha = math.random(20, 60) / 100,
            rotation = math.random(0, 360),
            rotSpeed = math.random(-50, 50) / 100
        })
    end
    
    local numBirds = math.random(3, 8)
    for i = 1, numBirds do
        table.insert(self.skyElements, {
            type = "bird",
            x = math.random(0, self.width * self.tileSize),
            y = math.random(50, 200),
            size = math.random(8, 15),
            speed = math.random(20, 60) / 100,
            flapPhase = math.random(0, math.pi * 2),
            flapSpeed = math.random(3, 8)
        })
    end
    
    local numDust = math.random(50, 80)
    for i = 1, numDust do
        table.insert(self.skyElements, {
            type = "dust",
            x = math.random(0, self.width * self.tileSize),
            y = math.random(0, 450),
            size = math.random(1, 3),
            speedY = math.random(5, 20) / 100,
            alpha = math.random(10, 40) / 100
        })
    end
end

function World:update(dt)
    for _, cloud in ipairs(self.clouds) do
        cloud.x = cloud.x + cloud.speed * dt * 60
        if cloud.x > self.width * self.tileSize + 200 then
            cloud.x = -200
        end
        if cloud.x < -200 then
            cloud.x = self.width * self.tileSize + 200
        end
    end
    
    for _, element in ipairs(self.skyElements) do
        if element.type == "spore" then
            element.x = element.x + element.speedX * dt * 60
            element.y = element.y + element.speedY * dt * 60
            element.rotation = element.rotation + element.rotSpeed * dt * 60
            
            if element.x > self.width * self.tileSize + 50 then
                element.x = -50
            end
            if element.x < -50 then
                element.x = self.width * self.tileSize + 50
            end
            if element.y > 500 then
                element.y = -50
            end
            if element.y < -50 then
                element.y = 500
            end
            
        elseif element.type == "bird" then
            element.x = element.x + element.speed * dt * 60
            element.flapPhase = element.flapPhase + element.flapSpeed * dt
            
            if element.x > self.width * self.tileSize + 100 then
                element.x = -100
            end
            
        elseif element.type == "dust" then
            element.y = element.y - element.speedY * dt * 60
            
            if element.y < -50 then
                element.y = 450
                element.x = math.random(0, self.width * self.tileSize)
            end
        end
    end
end

function World:draw(cameraX, cameraY)
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()
    
    for i = 0, screenH do
        local progress = i / screenH
        local r = 0.08 + progress * 0.04
        local g = 0.05 + progress * 0.03
        local b = 0.12 + progress * 0.06
        love.graphics.setColor(r, g, b)
        love.graphics.line(0, i, screenW, i)
    end
    
    for _, cloud in ipairs(self.clouds) do
        local drawX = cloud.x - cameraX
        local drawY = cloud.y - cameraY
        
        love.graphics.setColor(0.5, 0.4, 0.6, cloud.alpha)
        
        for _, segment in ipairs(cloud.segments) do
            love.graphics.circle("fill", 
                drawX + segment.x, 
                drawY + segment.y, 
                segment.radius
            )
        end
    end
    
    for _, element in ipairs(self.skyElements) do
        local drawX = element.x - cameraX
        local drawY = element.y - cameraY
        
        if element.type == "spore" then
            love.graphics.setColor(0.7, 0.4, 0.8, element.alpha)
            love.graphics.circle("fill", drawX, drawY, element.size)
            
            love.graphics.setColor(0.8, 0.5, 0.9, element.alpha * 0.5)
            love.graphics.circle("fill", drawX, drawY, element.size * 2)
            
        elseif element.type == "bird" then
            love.graphics.setColor(0.3, 0.2, 0.4, 0.6)
            local wingOffset = math.sin(element.flapPhase) * 3
            
            love.graphics.line(
                drawX, drawY,
                drawX - element.size, drawY - element.size/2 - wingOffset,
                drawX - element.size/2, drawY,
                drawX, drawY
            )
            love.graphics.line(
                drawX, drawY,
                drawX + element.size, drawY - element.size/2 - wingOffset,
                drawX + element.size/2, drawY,
                drawX, drawY
            )
            
        elseif element.type == "dust" then
            love.graphics.setColor(0.6, 0.5, 0.7, element.alpha)
            love.graphics.circle("fill", drawX, drawY, element.size)
        end
    end
    
    for x = 1, self.width do
        for y = 1, self.height do
            if self.tiles[x][y] == "ground" then
                local variation = math.sin(x * 0.5) * 0.05
                love.graphics.setColor(0.2 + variation, 0.12 + variation, 0.18 + variation)
                love.graphics.rectangle(
                    "fill",
                    (x - 1) * self.tileSize - cameraX,
                    (y - 1) * self.tileSize - cameraY,
                    self.tileSize - 1,
                    self.tileSize - 1
                )
                
                if y == 15 then  
                    love.graphics.setColor(0.3, 0.2, 0.25, 0.5)
                    love.graphics.points(
                        (x - 1) * self.tileSize - cameraX + math.random(self.tileSize),
                        (y - 1) * self.tileSize - cameraY
                    )
                end
            end
        end
    end
end

function World:isGround(x, y)
    local tileX = math.floor(x / self.tileSize) + 1
    local tileY = math.floor(y / self.tileSize) + 1
    
    if tileX < 1 or tileX > self.width or tileY < 1 or tileY > self.height then
        return true
    end
    
    return self.tiles[tileX][tileY] == "ground"
end

return World
