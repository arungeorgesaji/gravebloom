local biomes = require("components.biomes")

local BiomeMap = {}
BiomeMap.__index = BiomeMap

function BiomeMap:new(width, height, tileSize)
    local obj = {
        width = width,
        height = height,
        tileSize = tileSize,
        biomeGrid = {},
        transitionWidth = 8, 
        biomeTypes = {"grave", "forest", "crystal", "ash", "dream", "decay", "bloom", "abyss", "sunset", "frost", "miasma", "void"}
    }
    
    setmetatable(obj, self)
    obj:generateBiomeMap()
    return obj
end

function BiomeMap:generateBiomeMap()
    for x = 1, self.width do
        self.biomeGrid[x] = {}
        for y = 1, self.height do
            self.biomeGrid[x][y] = nil
        end
    end
    
    local numRegions = 12
    local centers = {}
    
    for i = 1, numRegions do
        centers[i] = {
            x = math.random(10, self.width - 30),
            y = math.random(5, self.height - 5),
            biome = self.biomeTypes[math.random(#self.biomeTypes)]
        }
    end
    
    for x = 1, self.width do
        for y = 1, self.height do
            local closestDist = math.huge
            local closestBiome = nil
            
            for _, center in ipairs(centers) do
                local dist = math.sqrt((x - center.x)^2 + (y - center.y)^2)
                if dist < closestDist then
                    closestDist = dist
                    closestBiome = center.biome
                end
            end
            
            self.biomeGrid[x][y] = closestBiome
        end
    end
    
    self:smoothBiomeBoundaries(3)
    
    self:createTransitionZones()
end

function BiomeMap:smoothBiomeBoundaries(iterations)
    for iter = 1, iterations do
        local newGrid = {}
        
        for x = 1, self.width do
            newGrid[x] = {}
            for y = 1, self.height do
                local biomeCounts = {}
                
                for dx = -1, 1 do
                    for dy = -1, 1 do
                        local nx, ny = x + dx, y + dy
                        if nx >= 1 and nx <= self.width and ny >= 1 and ny <= self.height then
                            local biome = self.biomeGrid[nx][ny]
                            biomeCounts[biome] = (biomeCounts[biome] or 0) + 1
                        end
                    end
                end
                
                local maxCount = 0
                local mostCommon = self.biomeGrid[x][y]
                for biome, count in pairs(biomeCounts) do
                    if count > maxCount then
                        maxCount = count
                        mostCommon = biome
                    end
                end
                
                newGrid[x][y] = mostCommon
            end
        end
        
        self.biomeGrid = newGrid
    end
end

function BiomeMap:createTransitionZones()
    self.transitionZones = {}
    
    for x = 1, self.width do
        for y = 1, self.height do
            local currentBiome = self.biomeGrid[x][y]
            
            for dx = -1, 1 do
                for dy = -1, 1 do
                    local nx, ny = x + dx, y + dy
                    if nx >= 1 and nx <= self.width and ny >= 1 and ny <= self.height then
                        local neighborBiome = self.biomeGrid[nx][ny]
                        if neighborBiome ~= currentBiome then
                            local key = currentBiome .. "->" .. neighborBiome
                            if not self.transitionZones[key] then
                                self.transitionZones[key] = {
                                    fromBiome = currentBiome,
                                    toBiome = neighborBiome,
                                    tiles = {}
                                }
                            end
                            table.insert(self.transitionZones[key].tiles, {x = x, y = y})
                        end
                    end
                end
            end
        end
    end
end

function BiomeMap:getBiomeAt(x, y)
    local tileX = math.floor(x / self.tileSize) + 1
    local tileY = math.floor(y / self.tileSize) + 1
    
    if tileX < 1 or tileX > self.width or tileY < 1 or tileY > self.height then
        return nil
    end
    
    return self.biomeGrid[tileX][tileY]
end

function BiomeMap:getTransitionAt(x, y)
    local tileX = math.floor(x / self.tileSize) + 1
    local tileY = math.floor(y / self.tileSize) + 1
    
    for _, zone in pairs(self.transitionZones) do
        for _, tile in ipairs(zone.tiles) do
            if tile.x == tileX and tile.y == tileY then
                return zone
            end
        end
    end
    
    return nil
end

return BiomeMap
