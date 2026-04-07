local SkyRenderer = {}

function SkyRenderer.drawGradient(screenW, screenH, biome)
    for i = 0, screenH do
        local p = i / screenH
        love.graphics.setColor(
            biome.skyGradient.top[1] + p * (biome.skyGradient.bottom[1] - biome.skyGradient.top[1]),
            biome.skyGradient.top[2] + p * (biome.skyGradient.bottom[2] - biome.skyGradient.top[2]),
            biome.skyGradient.top[3] + p * (biome.skyGradient.bottom[3] - biome.skyGradient.top[3])
        )
        love.graphics.line(0, i, screenW, i)
    end
end

function SkyRenderer.drawAmbientLight(screenW, screenH, biome)
    if not biome.atmosphere.ambientLight then return end
    
    local originalBlend = love.graphics.getBlendMode()
    love.graphics.setBlendMode("multiply", "premultiplied")
    
    love.graphics.setColor(
        biome.atmosphere.ambientLight[1],
        biome.atmosphere.ambientLight[2],
        biome.atmosphere.ambientLight[3],
        1.0
    )
    love.graphics.rectangle("fill", 0, 0, screenW, screenH)
    
    love.graphics.setBlendMode(originalBlend)
end

function SkyRenderer.drawFog(screenW, screenH, biome)
    if biome.atmosphere.fogDensity <= 0 then return end
    
    local fc = biome.atmosphere.fogColor
    love.graphics.setColor(fc[1], fc[2], fc[3], biome.atmosphere.fogDensity)
    love.graphics.rectangle("fill", 0, 0, screenW, screenH)
end

return SkyRenderer
