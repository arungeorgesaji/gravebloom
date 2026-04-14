local biomes = require("components.biomes")
local utils  = require("world.utils")

local lerpN      = utils.lerpN
local lerpColor  = utils.lerpColor
local easeInOut  = utils.easeInOut

local Transition = {}

function Transition.getActiveBiome(world)
    if not world.isTransitioning or world.transitionProgress >= 1 then
        return world.currentBiome
    end

    local t = easeInOut(world.transitionProgress)
    local s = world.sourceBiome
    local g = world.targetBiome

    return {
        name = "transition",

        skyGradient = {
            top    = lerpColor(s.skyGradient.top,    g.skyGradient.top,    t),
            bottom = lerpColor(s.skyGradient.bottom, g.skyGradient.bottom, t),
        },

        groundColor     = lerpColor(s.groundColor, g.groundColor, t),
        groundVariation = lerpN(s.groundVariation, g.groundVariation, t),
        groundY         = math.floor(lerpN(s.groundY, g.groundY, t)),
        cloudColor  = lerpColor(s.cloudColor, g.cloudColor, t),
        cloudAlpha  = lerpN(s.cloudAlpha, g.cloudAlpha, t),

        cloudYRange = {
            lerpN(s.cloudYRange[1], g.cloudYRange[1], t),
            lerpN(s.cloudYRange[2], g.cloudYRange[2], t),
        },

        sporeColor = lerpColor(s.sporeColor, g.sporeColor, t),
        birdColor  = lerpColor(s.birdColor,  g.birdColor,  t),
        dustColor  = lerpColor(s.dustColor,  g.dustColor,  t),
        debugColor = lerpColor(s.debugColor, g.debugColor, t),

        sporeCount = {
            math.floor(lerpN(s.sporeCount[1], g.sporeCount[1], t)),
            math.floor(lerpN(s.sporeCount[2], g.sporeCount[2], t)),
        },

        birdCount = {
            math.floor(lerpN(s.birdCount[1], g.birdCount[1], t)),
            math.floor(lerpN(s.birdCount[2], g.birdCount[2], t)),
        },

        dustCount = {
            math.floor(lerpN(s.dustCount[1], g.dustCount[1], t)),
            math.floor(lerpN(s.dustCount[2], g.dustCount[2], t)),
        },

        atmosphere = {
            fogDensity      = lerpN(s.atmosphere.fogDensity,      g.atmosphere.fogDensity,      t),
            fogColor        = lerpColor(s.atmosphere.fogColor,     g.atmosphere.fogColor,        t),
            windStrength    = lerpN(s.atmosphere.windStrength,    g.atmosphere.windStrength,    t),
            ambientLight    = lerpColor(s.atmosphere.ambientLight, g.atmosphere.ambientLight,   t),
            particleDensity = lerpN(s.atmosphere.particleDensity, g.atmosphere.particleDensity, t),
        },

        terrain = {
            heightVariation = lerpN(s.terrain.heightVariation, g.terrain.heightVariation, t),
            caveDensity     = lerpN(s.terrain.caveDensity,     g.terrain.caveDensity,     t),
            treeDensity     = lerpN(s.terrain.treeDensity,     g.terrain.treeDensity,     t),
            grassDensity    = lerpN(s.terrain.grassDensity,    g.terrain.grassDensity,    t),
            oreRarity = {
                stone   = lerpN(s.terrain.oreRarity.stone,   g.terrain.oreRarity.stone,   t),
                iron    = lerpN(s.terrain.oreRarity.iron,    g.terrain.oreRarity.iron,    t),
                gold    = lerpN(s.terrain.oreRarity.gold,    g.terrain.oreRarity.gold,    t),
                crystal = lerpN(s.terrain.oreRarity.crystal, g.terrain.oreRarity.crystal, t),
            },
        },

        weather = {
            type        = t < 0.5 and s.weather.type or g.weather.type,
            intensity   = lerpN(s.weather.intensity,   g.weather.intensity,   t),
            frequency   = lerpN(s.weather.frequency,   g.weather.frequency,   t),
            temperature = lerpN(s.weather.temperature, g.weather.temperature, t),
            humidity    = lerpN(s.weather.humidity,    g.weather.humidity,    t),
        },

        entities = {
            mobSpawnRate = lerpN(s.entities.mobSpawnRate, g.entities.mobSpawnRate, t),
            passiveMobs  = t < 0.5 and s.entities.passiveMobs or g.entities.passiveMobs,
            hostileMobs  = t < 0.5 and s.entities.hostileMobs or g.entities.hostileMobs,
            plantLife    = t < 0.5 and s.entities.plantLife   or g.entities.plantLife,
        },

        effects = {
            screenShake    = lerpN(s.effects.screenShake, g.effects.screenShake, t),
            musicTrack     = t < 0.5 and s.effects.musicTrack     or g.effects.musicTrack,
            ambientSound   = t < 0.5 and s.effects.ambientSound   or g.effects.ambientSound,
            particleEffect = t < 0.5 and s.effects.particleEffect or g.effects.particleEffect,
        },

        transitions = {
            allowedNeighbors = t < 0.5 and s.transitions.allowedNeighbors or g.transitions.allowedNeighbors,
            transitionWidth  = lerpN(s.transitions.transitionWidth, g.transitions.transitionWidth, t),
            blendMode        = t < 0.5 and s.transitions.blendMode or g.transitions.blendMode,
        },
    }
end

function Transition.begin(world, targetBiomeName, startPos, endPos)
    world.sourceBiome        = world.currentBiome
    world.targetBiome        = biomes[targetBiomeName]
    world.transitionEndBiome = targetBiomeName
    world.isTransitioning    = true
    world.transitionProgress = 0
    world.transitionStartPos = startPos
    world.transitionEndPos   = endPos
    print("Transition: " .. world.currentBiomeName .. " → " .. targetBiomeName)
end

function Transition.complete(world)
    world.currentBiome       = world.targetBiome
    world.currentBiomeName   = world.transitionEndBiome
    world.isTransitioning    = false
    world.transitionProgress = 1
    world.transitionStartPos = nil
    world.transitionEndPos   = nil
    print("Arrived in " .. world.currentBiome.name)
end

function Transition.updateBiomeAt(world, playerX, playerY)
    local playerBiomeName = world.biomeMap:getBiomeAt(playerX, playerY)
    local transition      = world.biomeMap:getTransitionAt(playerX, playerY)

    if transition then
        if not world.isTransitioning or world.transitionEndBiome ~= transition.toBiome then
            local toBiome = transition.toBiome
            local allowed = false
            for _, n in ipairs(biomes[transition.fromBiome].transitions.allowedNeighbors) do
                if n == toBiome then allowed = true; break end
            end
            if not allowed then toBiome = "grave" end
            Transition.begin(world, toBiome, playerX, playerX + world.tileSize * 4)
        else
            local dist   = world.transitionEndPos - world.transitionStartPos
            local walked = playerX - world.transitionStartPos
            world.transitionProgress = math.min(1, math.max(0, walked / dist))
        end

    elseif world.isTransitioning and world.transitionStartPos then
        Transition.complete(world)
        world:regenerateCurrentArea()

    elseif playerBiomeName ~= world.currentBiomeName and not world.isTransitioning then
        world.currentBiome     = biomes[playerBiomeName] or biomes.grave
        world.currentBiomeName = playerBiomeName
        world:regenerateCurrentArea()
    end
end

function Transition.updateTimeBased(world, dt)
    if world.isTransitioning and not world.transitionStartPos then
        world.transitionProgress = world.transitionProgress + dt / world.transitionSpeed
        if world.transitionProgress >= 1 then
            Transition.complete(world)
            world:regenerateCurrentArea()
        end
    end
end

return Transition
