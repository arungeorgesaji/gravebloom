local GroundDecorations = {}

function GroundDecorations.generate(world)
    local decorations = {}
    
    for x = 1, world.width do
        for y = 1, world.height do
            if world.tiles[x][y] == "ground" then
                local b = world:getActiveBiome()
                
                if b.terrain.treeDensity and b.terrain.treeDensity > 0 then
                    if math.random() < b.terrain.treeDensity then
                        table.insert(decorations, {
                            type = "tree",
                            x = (x-1) * world.tileSize,
                            y = (y-1) * world.tileSize,
                            variant = math.random(1, 3),
                            size = math.random(20, 40)
                        })
                    end
                end
                
                if b.terrain.grassDensity and b.terrain.grassDensity > 0 then
                    local grassCount = math.floor(b.terrain.grassDensity * 3)
                    for i = 1, math.random(0, grassCount) do
                        table.insert(decorations, {
                            type = "grass",
                            x = (x-1) * world.tileSize + math.random(0, world.tileSize),
                            y = (y-1) * world.tileSize,
                            height = math.random(5, 15),
                            rotation = math.random() * math.pi * 2
                        })
                    end
                end
            end
        end
    end
    
    return decorations
end

return GroundDecorations
