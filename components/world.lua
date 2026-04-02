local World = {}

function World:new(width, height)
    local obj = {
        width = width or 100,
        height = height or 40,
        tileSize = 32,
        tiles = {},
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
end

function World:draw(cameraX, cameraY)
    for x = 1, self.width do
        for y = 1, self.height do
            if self.tiles[x][y] == "ground" then
                love.graphics.setColor(0.2, 0.12, 0.18)
                love.graphics.rectangle(
                    "fill",
                    (x - 1) * self.tileSize - cameraX,
                    (y - 1) * self.tileSize - cameraY,
                    self.tileSize - 1,
                    self.tileSize - 1
                )
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
