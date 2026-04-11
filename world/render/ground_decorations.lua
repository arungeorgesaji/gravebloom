local GroundDecorationsRenderer = {}

function GroundDecorationsRenderer.draw(decorations, cameraX, cameraY)
    for _, dec in ipairs(decorations) do
        local dx = dec.x - cameraX
        local dy = dec.y - cameraY
        
        if dec.type == "tree" then
            love.graphics.setColor(0.4, 0.3, 0.2)  
            love.graphics.rectangle("fill", dx + 5, dy - dec.size, 6, dec.size)
            
            love.graphics.setColor(0.2, 0.6, 0.2)  
            love.graphics.circle("fill", dx + 8, dy - dec.size - 5, dec.size * 0.6)
            love.graphics.circle("fill", dx, dy - dec.size - 2, dec.size * 0.4)
            love.graphics.circle("fill", dx + 16, dy - dec.size - 2, dec.size * 0.4)
            
        elseif dec.type == "grass" then
            love.graphics.setColor(0.3, 0.7, 0.2, 0.8)
            love.graphics.line(dx, dy, 
                             dx + math.sin(dec.rotation) * dec.height,
                             dy - dec.height)
        end
    end
end

return GroundDecorationsRenderer
