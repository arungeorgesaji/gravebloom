local SkyElementGenerator = {}

function SkyElementGenerator.generate(world)
    local elements = {}
    local b = world:getActiveBiome()
    local particleMult = b.atmosphere.particleDensity or 1.0

    local sporeCount = math.floor(math.random(b.sporeCount[1], b.sporeCount[2]) * particleMult)
    local birdCount = math.floor(math.random(b.birdCount[1], b.birdCount[2]) * particleMult)
    local dustCount = math.floor(math.random(b.dustCount[1], b.dustCount[2]) * particleMult)

    for _ = 1, sporeCount do
        table.insert(elements, {
            type     = "spore",
            x        = math.random(0, world.width * world.tileSize),
            y        = math.random(0, 400),
            size     = math.random(2, 5),
            speedX   = math.random(-10, 10) / 100,
            speedY   = math.random(-5,  15) / 100,
            alpha    = math.random(20, 60) / 100,
            rotation = math.random(0, 360),
            rotSpeed = math.random(-50, 50) / 100,
            color    = b.sporeColor,
        })
    end

    for _ = 1, birdCount do
        table.insert(elements, {
            type      = "bird",
            x         = math.random(0, world.width * world.tileSize),
            y         = math.random(50, 200),
            size      = math.random(8, 15),
            speed     = math.random(20, 60) / 100,
            flapPhase = math.random(0, math.pi * 2),
            flapSpeed = math.random(3, 8),
            color     = b.birdColor,
        })
    end

    for _ = 1, dustCount do
        table.insert(elements, {
            type   = "dust",
            x      = math.random(0, world.width * world.tileSize),
            y      = math.random(0, 450),
            size   = math.random(1, 3),
            speedY = math.random(5, 20) / 100,
            alpha  = math.random(10, 40) / 100,
            color  = b.dustColor,
        })
    end
    
    return elements
end

return SkyElementGenerator
