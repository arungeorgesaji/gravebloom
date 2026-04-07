local CloudsRenderer = {}

function CloudsRenderer.draw(clouds, cameraX, cameraY, biome)
    local windStrength = biome.atmosphere.windStrength or 0
    local windOffset = windStrength * love.timer.getTime() * 10
    
    for _, cloud in ipairs(clouds) do
        local dx = cloud.x - cameraX + windOffset
        local dy = cloud.y - cameraY
        
        love.graphics.setColor(biome.cloudColor[1], biome.cloudColor[2], biome.cloudColor[3], biome.cloudAlpha)
        
        for _, seg in ipairs(cloud.segments) do
            love.graphics.circle("fill", dx + seg.x, dy + seg.y, seg.radius)
        end
    end
end

return CloudsRenderer
