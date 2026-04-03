local World = {}
local biomes = require("components.biomes")
function World:new(width, height, biomeName)
    local obj = {
        width = width or 100,
        height = height or 40,
        tileSize = 32,
        tiles = {},
        clouds = {},
        skyElements = {},
        biome = biomeName and biomes[biomeName] or biomes.grave
    }
    
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function World:setBiome(biomeName)
    if biomes[biomeName] then
        self.biome = biomes[biomeName]
        print("Changed biome to: " .. self.biome.name)
    else
        print("Biome not found: " .. biomeName)
    end
end

function World:generate()
    for x = 1, self.width do
        self.tiles[x] = {}
        for y = 1, self.height do
            self.tiles[x][y] = "air"
        end
    end
    
    for x = 1, self.width do
        for y = self.biome.groundY, self.height do
            self.tiles[x][y] = "ground"
        end
    end
    
    self:generateClouds()
    self:generateSkyElements()
end

function World:generateClouds()
    self.clouds = {}
    
    local numClouds = math.random(15, 25)
    local cloudYMin, cloudYMax = self.biome.cloudYRange[1], self.biome.cloudYRange[2]
    
    for i = 1, numClouds do
        local cloud = {
            x = math.random(0, self.width * self.tileSize),
            y = math.random(cloudYMin, cloudYMax),
            width = math.random(60, 150),
            height = math.random(30, 60),
            speed = math.random(10, 30) / 100,
            alpha = self.biome.cloudAlpha,
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
    
    local sporeMin, sporeMax = self.biome.sporeCount[1], self.biome.sporeCount[2]
    local numSpores = math.random(sporeMin, sporeMax)
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
            rotSpeed = math.random(-50, 50) / 100,
            color = self.biome.sporeColor
        })
    end
    
    local birdMin, birdMax = self.biome.birdCount[1], self.biome.birdCount[2]
    local numBirds = math.random(birdMin, birdMax)
    for i = 1, numBirds do
        table.insert(self.skyElements, {
            type = "bird",
            x = math.random(0, self.width * self.tileSize),
            y = math.random(50, 200),
            size = math.random(8, 15),
            speed = math.random(20, 60) / 100,
            flapPhase = math.random(0, math.pi * 2),
            flapSpeed = math.random(3, 8),
            color = self.biome.birdColor
        })
    end
    
    local dustMin, dustMax = self.biome.dustCount[1], self.biome.dustCount[2]
    local numDust = math.random(dustMin, dustMax)
    for i = 1, numDust do
        table.insert(self.skyElements, {
            type = "dust",
            x = math.random(0, self.width * self.tileSize),
            y = math.random(0, 450),
            size = math.random(1, 3),
            speedY = math.random(5, 20) / 100,
            alpha = math.random(10, 40) / 100,
            color = self.biome.dustColor
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
        local r = self.biome.skyGradient.top[1] + progress * (self.biome.skyGradient.bottom[1] - self.biome.skyGradient.top[1])
        local g = self.biome.skyGradient.top[2] + progress * (self.biome.skyGradient.bottom[2] - self.biome.skyGradient.top[2])
        local b = self.biome.skyGradient.top[3] + progress * (self.biome.skyGradient.bottom[3] - self.biome.skyGradient.top[3])
        love.graphics.setColor(r, g, b)
        love.graphics.line(0, i, screenW, i)
    end
    
    for _, cloud in ipairs(self.clouds) do
        local drawX = cloud.x - cameraX
        local drawY = cloud.y - cameraY
        
        love.graphics.setColor(self.biome.cloudColor[1], self.biome.cloudColor[2], self.biome.cloudColor[3], cloud.alpha)
        
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
            love.graphics.setColor(element.color[1], element.color[2], element.color[3], element.alpha)
            love.graphics.circle("fill", drawX, drawY, element.size)
            
            love.graphics.setColor(element.color[1], element.color[2], element.color[3], element.alpha * 0.5)
            love.graphics.circle("fill", drawX, drawY, element.size * 2)
            
        elseif element.type == "bird" then
            love.graphics.setColor(element.color[1], element.color[2], element.color[3], 0.6)
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
            love.graphics.setColor(element.color[1], element.color[2], element.color[3], element.alpha)
            love.graphics.circle("fill", drawX, drawY, element.size)
        end
    end
    
    for x = 1, self.width do
        for y = 1, self.height do
            if self.tiles[x][y] == "ground" then
                local variation = math.sin(x * 0.5) * self.biome.groundVariation
                love.graphics.setColor(
                    self.biome.groundColor[1] + variation,
                    self.biome.groundColor[2] + variation,
                    self.biome.groundColor[3] + variation
                )
                love.graphics.rectangle(
                    "fill",
                    (x - 1) * self.tileSize - cameraX,
                    (y - 1) * self.tileSize - cameraY,
                    self.tileSize - 1,
                    self.tileSize - 1
                )
                
                if y == self.biome.groundY then
                    love.graphics.setColor(
                        self.biome.groundColor[1] + 0.1,
                        self.biome.groundColor[2] + 0.08,
                        self.biome.groundColor[3] + 0.07,
                        0.5
                    )
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

function World.getBiomes()
    local biomeList = {}
    for name, biome in pairs(biomes) do
        table.insert(biomeList, name)
    end
    return biomeList
end

return World
