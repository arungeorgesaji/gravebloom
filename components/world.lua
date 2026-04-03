local World = {}
local biomes = require("components.biomes")
local BiomeMap = require("components.biome_map")

function World:new(width, height, tileSize)
    local obj = {
        width = width or 100,
        height = height or 40,
        tileSize = tileSize or 32,
        tiles = {},
        clouds = {},
        skyElements = {},
        biomeMap = nil,
        
        currentBiome = biomes.grave,
        currentBiomeName = "grave",
        
        isTransitioning = false,
        transitionProgress = 0,
        transitionSpeed = 1.0,
        targetBiome = nil,
        sourceBiome = nil,
        transitionStartBiome = nil,
        transitionEndBiome = nil,
        transitionStartPos = nil,
        transitionEndPos = nil,
        
        lastCameraX = 0,
        lastCameraY = 0
    }
    
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function World:setBiome(biomeName, instant)
    if not biomes[biomeName] then
        print("Biome not found: " .. biomeName)
        return false
    end
    
    if biomeName == self.currentBiome.name:lower() then
        print("Already in biome: " .. biomeName)
        return false
    end
    
    local currentName = self.currentBiome.name:lower()
    local targetData = biomes[biomeName]
    local isAllowed = false
    
    for _, neighbor in ipairs(self.currentBiome.transitions.allowedNeighbors) do
        if neighbor == biomeName then
            isAllowed = true
            break
        end
    end
    
    if not isAllowed and not instant then
        print("Cannot transition directly from " .. currentName .. " to " .. biomeName)
        print("Allowed neighbors: " .. table.concat(self.currentBiome.transitions.allowedNeighbors, ", "))
        return false
    end
    
    if instant then
        self.currentBiome = biomes[biomeName]
        self:generate()
        print("Instant changed to biome: " .. self.currentBiome.name)
    else
        self:startTransition(biomeName)
    end
    
    return true
end

function World:startTransition(targetBiomeName)
    self.targetBiome = biomes[targetBiomeName]
    self.sourceBiome = self.currentBiome
    self.isTransitioning = true
    self.transitionProgress = 0
    
    self.transitionTiles = {}
    for x = 1, self.width do
        self.transitionTiles[x] = {}
        for y = 1, self.height do
            self.transitionTiles[x][y] = self.tiles[x][y]
        end
    end
    
    print("Starting transition from " .. self.sourceBiome.name .. " to " .. self.targetBiome.name)
end

function World:updateTransition(dt)
    if not self.isTransitioning then return end
    
    self.transitionProgress = self.transitionProgress + dt / self.transitionSpeed
    
    if self.transitionProgress >= 1 then
        self.currentBiome = self.targetBiome
        self.isTransitioning = false
        self.transitionProgress = 0
        self.transitionTiles = {}
        self:generate() 
        print("Transition complete! Now in " .. self.currentBiome.name)
    else
        self:updateTransitionVisuals()
    end
end

function World:updateTransitionVisuals()
    local t = self.transitionProgress
    local easeOut = 1 - math.pow(1 - t, 3) 
    
    local r = self:lerp(self.sourceBiome.skyGradient.top[1], self.targetBiome.skyGradient.top[1], easeOut)
    local g = self:lerp(self.sourceBiome.skyGradient.top[2], self.targetBiome.skyGradient.top[2], easeOut)
    local b = self:lerp(self.sourceBiome.skyGradient.top[3], self.targetBiome.skyGradient.top[3], easeOut)
    
    self.transitionBiome = {
        name = "transition",
        skyGradient = {
            top = {r, g, b},
            bottom = {
                self:lerp(self.sourceBiome.skyGradient.bottom[1], self.targetBiome.skyGradient.bottom[1], easeOut),
                self:lerp(self.sourceBiome.skyGradient.bottom[2], self.targetBiome.skyGradient.bottom[2], easeOut),
                self:lerp(self.sourceBiome.skyGradient.bottom[3], self.targetBiome.skyGradient.bottom[3], easeOut)
            }
        },
        groundColor = {
            self:lerp(self.sourceBiome.groundColor[1], self.targetBiome.groundColor[1], easeOut),
            self:lerp(self.sourceBiome.groundColor[2], self.targetBiome.groundColor[2], easeOut),
            self:lerp(self.sourceBiome.groundColor[3], self.targetBiome.groundColor[3], easeOut)
        },
        groundVariation = self:lerp(self.sourceBiome.groundVariation, self.targetBiome.groundVariation, easeOut),
        cloudColor = {
            self:lerp(self.sourceBiome.cloudColor[1], self.targetBiome.cloudColor[1], easeOut),
            self:lerp(self.sourceBiome.cloudColor[2], self.targetBiome.cloudColor[2], easeOut),
            self:lerp(self.sourceBiome.cloudColor[3], self.targetBiome.cloudColor[3], easeOut)
        },
        cloudAlpha = self:lerp(self.sourceBiome.cloudAlpha, self.targetBiome.cloudAlpha, easeOut),
        cloudYRange = {
            self:lerp(self.sourceBiome.cloudYRange[1], self.targetBiome.cloudYRange[1], easeOut),
            self:lerp(self.sourceBiome.cloudYRange[2], self.targetBiome.cloudYRange[2], easeOut)
        },
        groundY = math.floor(self:lerp(self.sourceBiome.groundY, self.targetBiome.groundY, easeOut)),
    }
end

function World:lerp(a, b, t)
    return a + (b - a) * t
end

function World:generate()
    self.biomeMap = BiomeMap:new(self.width, self.height, self.tileSize)
    
    for x = 1, self.width do
        self.tiles[x] = {}
        for y = 1, self.height do
            local biomeName = self.biomeMap:getBiomeAt((x-1) * self.tileSize, (y-1) * self.tileSize)
            local biome = biomes[biomeName] or biomes.grave
            
            if y >= biome.groundY then
                self.tiles[x][y] = "ground"
            else
                self.tiles[x][y] = "air"
            end
        end
    end
    
    self:generateClouds()
    self:generateSkyElements()
end

function World:generateClouds()
    self.clouds = {}
    
    local numClouds = math.random(15, 25)
    local cloudYMin, cloudYMax = self.currentBiome.cloudYRange[1], self.currentBiome.cloudYRange[2]
    
    for i = 1, numClouds do
        local cloud = {
            x = math.random(0, self.width * self.tileSize),
            y = math.random(cloudYMin, cloudYMax),
            width = math.random(60, 150),
            height = math.random(30, 60),
            speed = math.random(10, 30) / 100,
            alpha = self.currentBiome.cloudAlpha,
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
    
    local sporeMin, sporeMax = self.currentBiome.sporeCount[1], self.currentBiome.sporeCount[2]
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
            color = self.currentBiome.sporeColor
        })
    end
    
    local birdMin, birdMax = self.currentBiome.birdCount[1], self.currentBiome.birdCount[2]
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
            color = self.currentBiome.birdColor
        })
    end
    
    local dustMin, dustMax = self.currentBiome.dustCount[1], self.currentBiome.dustCount[2]
    local numDust = math.random(dustMin, dustMax)
    for i = 1, numDust do
        table.insert(self.skyElements, {
            type = "dust",
            x = math.random(0, self.width * self.tileSize),
            y = math.random(0, 450),
            size = math.random(1, 3),
            speedY = math.random(5, 20) / 100,
            alpha = math.random(10, 40) / 100,
            color = self.currentBiome.dustColor
        })
    end
end

function World:updateBiomeAt(playerX, playerY, cameraX, cameraY)
    local playerBiomeName = self.biomeMap:getBiomeAt(playerX, playerY)
    local playerBiome = biomes[playerBiomeName] or biomes.grave
    
    local transition = self.biomeMap:getTransitionAt(playerX, playerY)
    
    if transition then
        if not self.isTransitioning or self.targetBiome ~= biomes[transition.toBiome] then
            self:startSpatialTransition(transition.fromBiome, transition.toBiome, playerX, playerY)
        end
        
        if self.isTransitioning then
            self:updateTransitionByPosition(playerX, playerY)
        end
    elseif self.isTransitioning and not transition then
        self:completeTransition()
    elseif playerBiomeName ~= self.currentBiomeName and not self.isTransitioning then
        self.currentBiome = playerBiome
        self.currentBiomeName = playerBiomeName
        self:regenerateCurrentArea()
    end
end

function World:startSpatialTransition(fromBiomeName, toBiomeName, playerX, playerY)
    if not biomes[fromBiomeName] or not biomes[toBiomeName] then
        return
    end
    
    local fromBiome = biomes[fromBiomeName]
    local isAllowed = false
    for _, neighbor in ipairs(fromBiome.transitions.allowedNeighbors) do
        if neighbor == toBiomeName then
            isAllowed = true
            break
        end
    end
    
    if not isAllowed then
        toBiomeName = "grave" 
    end
    
    self.sourceBiome = biomes[fromBiomeName]
    self.targetBiome = biomes[toBiomeName]
    self.transitionStartBiome = fromBiomeName
    self.transitionEndBiome = toBiomeName
    self.isTransitioning = true
    self.transitionProgress = 0
    self.transitionStartPos = playerX
    self.transitionEndPos = playerX + self.tileSize * 4 
    
    print("Entering transition from " .. fromBiomeName .. " to " .. toBiomeName)
end

function World:updateTransitionByPosition(playerX)
    if not self.isTransitioning then return end
    
    local transitionDistance = self.transitionEndPos - self.transitionStartPos
    local playerDistance = playerX - self.transitionStartPos
    
    self.transitionProgress = math.min(1, math.max(0, playerDistance / transitionDistance))
end

function World:updateTransition(dt)
    if not self.isTransitioning then return end
    
    if not self.transitionStartPos then
        self.transitionProgress = self.transitionProgress + dt / self.transitionSpeed
        
        if self.transitionProgress >= 1 then
            self:completeTransition()
        end
    end
end

function World:completeTransition()
    if self.targetBiome then
        self.currentBiome = self.targetBiome
        self.currentBiomeName = self.transitionEndBiome
        print("Transition complete! Now in " .. self.currentBiome.name)
    end
    
    self.isTransitioning = false
    self.transitionProgress = 0
    self.transitionStartBiome = nil
    self.transitionEndBiome = nil
    self.sourceBiome = nil
    self.targetBiome = nil
    self.transitionStartPos = nil
    self.transitionEndPos = nil
    
    self:regenerateCurrentArea()
end

function World:regenerateCurrentArea()
    self:generateClouds()
    self:generateSkyElements()
end

function World:update(dt)
    self:updateTransition(dt)
    
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

function World:getBlendedBiomeForPosition(x, y)
    local transition = self.biomeMap:getTransitionAt(x, y)
    
    if transition and self.isTransitioning then
        local t = self.transitionProgress
        local easeInOut = t < 0.5 and 2 * t * t or 1 - math.pow(-2 * t + 2, 2) / 2
        
        local blended = {
            name = "transition",
            skyGradient = {
                top = {
                    self:lerp(self.sourceBiome.skyGradient.top[1], self.targetBiome.skyGradient.top[1], easeInOut),
                    self:lerp(self.sourceBiome.skyGradient.top[2], self.targetBiome.skyGradient.top[2], easeInOut),
                    self:lerp(self.sourceBiome.skyGradient.top[3], self.targetBiome.skyGradient.top[3], easeInOut)
                },
                bottom = {
                    self:lerp(self.sourceBiome.skyGradient.bottom[1], self.targetBiome.skyGradient.bottom[1], easeInOut),
                    self:lerp(self.sourceBiome.skyGradient.bottom[2], self.targetBiome.skyGradient.bottom[2], easeInOut),
                    self:lerp(self.sourceBiome.skyGradient.bottom[3], self.targetBiome.skyGradient.bottom[3], easeInOut)
                }
            },
            groundColor = {
                self:lerp(self.sourceBiome.groundColor[1], self.targetBiome.groundColor[1], easeInOut),
                self:lerp(self.sourceBiome.groundColor[2], self.targetBiome.groundColor[2], easeInOut),
                self:lerp(self.sourceBiome.groundColor[3], self.targetBiome.groundColor[3], easeInOut)
            },
            groundVariation = self:lerp(self.sourceBiome.groundVariation, self.targetBiome.groundVariation, easeInOut),
            cloudColor = {
                self:lerp(self.sourceBiome.cloudColor[1], self.targetBiome.cloudColor[1], easeInOut),
                self:lerp(self.sourceBiome.cloudColor[2], self.targetBiome.cloudColor[2], easeInOut),
                self:lerp(self.sourceBiome.cloudColor[3], self.targetBiome.cloudColor[3], easeInOut)
            },
            cloudAlpha = self:lerp(self.sourceBiome.cloudAlpha, self.targetBiome.cloudAlpha, easeInOut),
            groundY = math.floor(self:lerp(self.sourceBiome.groundY, self.targetBiome.groundY, easeInOut))
        }
        return blended
    end
    
    return self.currentBiome
end

function World:lerp(a, b, t)
    return a + (b - a) * t
end

function World:draw(cameraX, cameraY)
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()
    
    local renderBiome = self:getBlendedBiomeForPosition(cameraX + screenW/2, cameraY + screenH/2)
    
    for i = 0, screenH do
        local progress = i / screenH
        local r = renderBiome.skyGradient.top[1] + progress * (renderBiome.skyGradient.bottom[1] - renderBiome.skyGradient.top[1])
        local g = renderBiome.skyGradient.top[2] + progress * (renderBiome.skyGradient.bottom[2] - renderBiome.skyGradient.top[2])
        local b = renderBiome.skyGradient.top[3] + progress * (renderBiome.skyGradient.bottom[3] - renderBiome.skyGradient.top[3])
        love.graphics.setColor(r, g, b)
        love.graphics.line(0, i, screenW, i)
    end
    
    for _, cloud in ipairs(self.clouds) do
        local drawX = cloud.x - cameraX
        local drawY = cloud.y - cameraY
        
        love.graphics.setColor(renderBiome.cloudColor[1], renderBiome.cloudColor[2], renderBiome.cloudColor[3], renderBiome.cloudAlpha)
        
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
            love.graphics.line(drawX, drawY, drawX - element.size, drawY - element.size/2 - wingOffset, drawX - element.size/2, drawY, drawX, drawY)
            love.graphics.line(drawX, drawY, drawX + element.size, drawY - element.size/2 - wingOffset, drawX + element.size/2, drawY, drawX, drawY)
            
        elseif element.type == "dust" then
            love.graphics.setColor(element.color[1], element.color[2], element.color[3], element.alpha)
            love.graphics.circle("fill", drawX, drawY, element.size)
        end
    end
    
    local startX = math.max(1, math.floor(cameraX / self.tileSize) - 2)
    local endX = math.min(self.width, math.floor((cameraX + screenW) / self.tileSize) + 2)
    local startY = math.max(1, math.floor(cameraY / self.tileSize) - 2)
    local endY = math.min(self.height, math.floor((cameraY + screenH) / self.tileSize) + 2)
    
    for x = startX, endX do
        for y = startY, endY do
            if self.tiles[x][y] == "ground" then
                local tileBiomeName = self.biomeMap:getBiomeAt((x-1) * self.tileSize, (y-1) * self.tileSize)
                local tileBiome = biomes[tileBiomeName] or biomes.grave
                
                local groundColor = tileBiome.groundColor
                local groundVariation = tileBiome.groundVariation
                local groundY = tileBiome.groundY
                
                if self.isTransitioning then
                    local transition = self.biomeMap:getTransitionAt((x-1) * self.tileSize, (y-1) * self.tileSize)
                    if transition then
                        local t = self.transitionProgress
                        groundColor = {
                            self:lerp(self.sourceBiome.groundColor[1], self.targetBiome.groundColor[1], t),
                            self:lerp(self.sourceBiome.groundColor[2], self.targetBiome.groundColor[2], t),
                            self:lerp(self.sourceBiome.groundColor[3], self.targetBiome.groundColor[3], t)
                        }
                        groundVariation = self:lerp(self.sourceBiome.groundVariation, self.targetBiome.groundVariation, t)
                        groundY = math.floor(self:lerp(self.sourceBiome.groundY, self.targetBiome.groundY, t))
                    end
                end
                
                local variation = math.sin(x * 0.5) * groundVariation
                love.graphics.setColor(groundColor[1] + variation, groundColor[2] + variation, groundColor[3] + variation)
                love.graphics.rectangle("fill",
                    (x - 1) * self.tileSize - cameraX,
                    (y - 1) * self.tileSize - cameraY,
                    self.tileSize - 1,
                    self.tileSize - 1
                )
                
                if y == groundY then
                    love.graphics.setColor(groundColor[1] + 0.1, groundColor[2] + 0.08, groundColor[3] + 0.07, 0.5)
                    love.graphics.points(
                        (x - 1) * self.tileSize - cameraX + math.random(self.tileSize),
                        (y - 1) * self.tileSize - cameraY
                    )
                end
            end
        end
    end
    
    if self.showDebugBiomes then
        self:drawDebugBiomeOverlay(cameraX, cameraY)
    end
end

function World:drawDebugBiomeOverlay(cameraX, cameraY)
    love.graphics.setFont(love.graphics.newFont(10))
    
    for x = 1, self.width, 4 do
        for y = 1, self.height, 4 do
            local biomeName = self.biomeMap:getBiomeAt((x-1) * self.tileSize, (y-1) * self.tileSize)
            if biomeName then
                local color = {
                    grave = {0.5, 0.3, 0.6},
                    forest = {0.3, 0.6, 0.3},
                    crystal = {0.4, 0.4, 0.8},
                    ash = {0.5, 0.4, 0.4},
                    dream = {0.7, 0.4, 0.8},
                    decay = {0.4, 0.3, 0.3},
                    bloom = {0.8, 0.5, 0.7},
                    abyss = {0.2, 0.2, 0.3},
                    sunset = {0.8, 0.5, 0.4},
                    frost = {0.4, 0.6, 0.8},
                    miasma = {0.5, 0.6, 0.3},
                    void = {0.1, 0.1, 0.2}
                }
                local c = color[biomeName] or {1, 1, 1}
                love.graphics.setColor(c[1], c[2], c[3], 0.5)
                love.graphics.rectangle("fill",
                    (x-1) * self.tileSize - cameraX,
                    (y-1) * self.tileSize - cameraY,
                    self.tileSize * 4,
                    self.tileSize * 4
                )
                
                love.graphics.setColor(1, 1, 1, 0.8)
                love.graphics.print(string.sub(biomeName, 1, 3),
                    (x-1) * self.tileSize - cameraX + 5,
                    (y-1) * self.tileSize - cameraY + 5)
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
