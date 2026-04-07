local DebugRenderer = {}

function DebugRenderer.drawBiomeOverlay(world, cameraX, cameraY)
    local b = world:getActiveBiome()
    
    love.graphics.setFont(love.graphics.newFont(10))
    
    for x = 1, world.width, 4 do
        for y = 1, world.height, 4 do
            local name = world.biomeMap:getBiomeAt((x-1)*world.tileSize, (y-1)*world.tileSize)
            if name then
                local c = b.debugColor or {1, 1, 1}
                love.graphics.setColor(c[1], c[2], c[3], 0.5)
                love.graphics.rectangle("fill",
                    (x-1)*world.tileSize - cameraX, (y-1)*world.tileSize - cameraY,
                    world.tileSize*4, world.tileSize*4)
                love.graphics.setColor(1, 1, 1, 0.8)
                love.graphics.print(string.sub(name, 1, 3),
                    (x-1)*world.tileSize - cameraX + 5,
                    (y-1)*world.tileSize - cameraY + 5)
            end
        end
    end
end

return DebugRenderer
