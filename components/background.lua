local Background = {}

local effects = {
    stars = {},
    spores = {},
    mist = {}
}

local function drawBackground(r, g, b)
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle(
        "fill",
        0,
        0,
        love.graphics.getWidth(),
        love.graphics.getHeight()
    )
end

function Background.load()
    effects = {
        stars = {},
        spores = {},
        mist = {}
    }
    
    for i = 1, 150 do
        table.insert(effects.stars, {
            x = math.random(0, love.graphics.getWidth()),
            y = math.random(0, love.graphics.getHeight()),
            size = math.random(1, 2),
            brightness = math.random(0.3, 1.0),
            flicker = math.random(0.02, 0.08)
        })
    end

    for i = 1, 30 do
        table.insert(effects.spores, {
            x = math.random(0, love.graphics.getWidth()),
            y = math.random(0, love.graphics.getHeight()),
            radius = math.random(3, 8),
            speedX = math.random(-15, 15) / 100,
            speedY = math.random(-15, 15) / 100,
            pulseSpeed = math.random(1, 3) / 10,
            pulsePhase = math.random(0, 2 * math.pi),
            color = {0.8, 0.4, 0.8}
        })
    end

    for i = 1, 3 do
        table.insert(effects.mist, {
            y = love.graphics.getHeight() * 0.7 + math.random(-50, 50),
            speed = math.random(5, 15) / 100,
            offset = math.random(0, 100)
        })
    end
end

function Background.update(dt)
    for _, spore in ipairs(effects.spores) do
        spore.x = spore.x + spore.speedX * dt * 60
        spore.y = spore.y + spore.speedY * dt * 60
        spore.pulsePhase = spore.pulsePhase + spore.pulseSpeed * dt

        if spore.x < -50 then spore.x = love.graphics.getWidth() + 50 end
        if spore.x > love.graphics.getWidth() + 50 then spore.x = -50 end
        if spore.y < -50 then spore.y = love.graphics.getHeight() + 50 end
        if spore.y > love.graphics.getHeight() + 50 then spore.y = -50 end
    end
end

function Background.draw()
    drawBackground(0.12, 0.08, 0.18)

    for _, star in ipairs(effects.stars) do
        local flicker = star.brightness + math.sin(love.timer.getTime() * star.flicker * 10) * 0.2
        love.graphics.setColor(1, 1, 1, flicker)
        love.graphics.circle("fill", star.x, star.y, star.size)
    end

    love.graphics.setColor(0.3, 0.2, 0.3, 0.1)
    for _, layer in ipairs(effects.mist) do
        local xOffset = math.sin(love.timer.getTime() * layer.speed + layer.offset) * 50
        love.graphics.rectangle("fill", xOffset, layer.y, love.graphics.getWidth(), 100)
    end

    for _, spore in ipairs(effects.spores) do
        local pulse = 0.8 + math.sin(spore.pulsePhase) * 0.3
        love.graphics.setColor(spore.color[1], spore.color[2], spore.color[3], 0.4 * pulse)
        love.graphics.circle("fill", spore.x, spore.y, spore.radius * pulse)
    end
end

return Background
