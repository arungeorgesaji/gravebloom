local SkyRenderer = require("world.render.sky")
local CloudsRenderer = require("world.render.clouds")
local SkyElementsRenderer = require("world.render.sky_elements")
local TileRenderer = require("world.render.tiles")
local GroundDecorationsRenderer = require("world.render.ground_decorations")
local DebugRenderer = require("world.debug")

local Render = {}

function Render.draw(world, cameraX, cameraY)
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()
    local biome = world:getActiveBiome()

    SkyRenderer.drawGradient(screenW, screenH, biome)
    SkyRenderer.drawAmbientLight(screenW, screenH, biome)

    TileRenderer.drawVisibleTiles(world, cameraX, cameraY, screenW, screenH)

    GroundDecorationsRenderer.draw(world.groundDecorations, cameraX, cameraY)

    
    CloudsRenderer.draw(world.clouds, cameraX, cameraY, biome)
    SkyElementsRenderer.draw(world.skyElements, cameraX, cameraY, biome.atmosphere.windStrength)
        
    SkyRenderer.drawFog(screenW, screenH, biome)
    
    if world.showDebugBiomes then
        DebugRenderer.drawBiomeOverlay(world, cameraX, cameraY)
    end
end

return Render
