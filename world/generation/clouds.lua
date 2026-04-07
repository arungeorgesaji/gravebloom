local CloudGenerator = {}

function CloudGenerator.generate(world)
    local clouds = {}
    local b = world:getActiveBiome()
    local yMin, yMax = b.cloudYRange[1], b.cloudYRange[2]

    for _ = 1, math.random(15, 25) do
        local cloud = {
            x      = math.random(0, world.width * world.tileSize),
            y      = math.random(yMin, yMax),
            width  = math.random(60, 150),
            height = math.random(30, 60),
            speed  = math.random(10, 30) / 100,
            alpha  = b.cloudAlpha,
            segments = {}
        }
        for _ = 1, math.random(3, 6) do
            table.insert(cloud.segments, {
                x      = math.random(-cloud.width/3,  cloud.width/3),
                y      = math.random(-cloud.height/4, cloud.height/4),
                radius = math.random(cloud.width/4,   cloud.width/2)
            })
        end
        table.insert(clouds, cloud)
    end
    
    return clouds
end

return CloudGenerator
