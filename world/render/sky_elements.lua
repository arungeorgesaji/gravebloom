local SkyElementsRenderer = {}

local function drawSpore(el, dx, dy, windStrength)
    if windStrength then
        dx = dx + windStrength * love.timer.getTime() * 20
    end
    
    love.graphics.setColor(el.color[1], el.color[2], el.color[3], el.alpha)
    love.graphics.circle("fill", dx, dy, el.size)
    love.graphics.setColor(el.color[1], el.color[2], el.color[3], el.alpha * 0.5)
    love.graphics.circle("fill", dx, dy, el.size * 2)
end

local function drawBird(el, dx, dy)
    love.graphics.setColor(el.color[1], el.color[2], el.color[3], 0.6)
    local wo = math.sin(el.flapPhase) * 3
    love.graphics.line(dx, dy, dx - el.size, dy - el.size/2 - wo, dx - el.size/2, dy, dx, dy)
    love.graphics.line(dx, dy, dx + el.size, dy - el.size/2 - wo, dx + el.size/2, dy, dx, dy)
end

local function drawDust(el, dx, dy)
    love.graphics.setColor(el.color[1], el.color[2], el.color[3], el.alpha)
    love.graphics.circle("fill", dx, dy, el.size)
end

function SkyElementsRenderer.draw(elements, cameraX, cameraY, windStrength)
    for _, el in ipairs(elements) do
        local dx = el.x - cameraX
        local dy = el.y - cameraY

        if el.type == "spore" then
            drawSpore(el, dx, dy, windStrength)
        elseif el.type == "bird" then
            drawBird(el, dx, dy)
        elseif el.type == "dust" then
            drawDust(el, dx, dy)
        end
    end
end

return SkyElementsRenderer
