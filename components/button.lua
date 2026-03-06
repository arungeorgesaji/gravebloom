Button = {}
Button.__index = Button

function Button:new(text, x, y, width, height, action, size, style)
    width = width or 200
    height = height or 60
    size = size or 24
    style = style or "modern"
    
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()
    
    if x == nil then
        x = (screenW - width) / 2
    end
    
    if y == nil then
        y = (screenH - height) / 2
    end
    
    local btn = {
        text = text,
        x = x,
        y = y,
        width = width,
        height = height,
        action = action,
        hover = false,
        pressed = false,
        style = style,
        font = love.graphics.newFont(size),
        
        bgColor = {0.3, 0.5, 0.8},      
        hoverColor = {0.4, 0.6, 0.9},    
        pressColor = {0.2, 0.3, 0.6},   
        textColor = {1, 1, 1},          
        borderColor = {0.2, 0.2, 0.2},   
        
        hoverScale = 1,
        targetScale = 1,
        animationSpeed = 5,
        
        shadowOffset = 4,
        shadowOpacity = 0.3,
        
        borderRadius = 10
    }
    
    setmetatable(btn, Button)
    return btn
end

function Button:update(dt)
    local mx, my = love.mouse.getPosition()
    
    local wasHover = self.hover
    self.hover = mx > self.x and mx < self.x + self.width and
                 my > self.y and my < self.y + self.height
    
    if self.hover then
        self.targetScale = 1.05
    else
        self.targetScale = 1
    end
    
    self.hoverScale = self.hoverScale + (self.targetScale - self.hoverScale) * self.animationSpeed * dt
    
    if not self.hover then
        self.pressed = false
    end
end

function Button:mousepressed(x, y, button)
    if button == 1 and self.hover then
        self.pressed = true
    end
end

function Button:mousereleased(x, y, button)
    if button == 1 and self.pressed and self.hover then
        self.action()
    end
    self.pressed = false
end

function Button:draw()
    local currentWidth = self.width * self.hoverScale
    local currentHeight = self.height * self.hoverScale
    local currentX = self.x + (self.width - currentWidth) / 2
    local currentY = self.y + (self.height - currentHeight) / 2
    
    if self.style == "rounded" then
        self:drawRounded(currentX, currentY, currentWidth, currentHeight)
    elseif self.style == "gradient" then
        self:drawGradient(currentX, currentY, currentWidth, currentHeight)
    elseif self.style == "outline" then
        self:drawOutline(currentX, currentY, currentWidth, currentHeight)
    elseif self.style == "neon" then
        self:drawNeon(currentX, currentY, currentWidth, currentHeight)
    else 
        self:drawModern(currentX, currentY, currentWidth, currentHeight)
    end
    
    love.graphics.setFont(self.font)
    love.graphics.setColor(self.textColor)
    
    local textY = currentY + currentHeight/3
    if self.pressed then
        textY = textY + 2
    end
    
    love.graphics.printf(self.text, currentX, textY, currentWidth, "center")
end

function Button:drawModern(x, y, w, h)
    love.graphics.setColor(0, 0, 0, self.shadowOpacity)
    love.graphics.rectangle("fill", x + 4, y + 4, w, h)
    
    if self.pressed then
        love.graphics.setColor(self.pressColor)
    elseif self.hover then
        love.graphics.setColor(self.hoverColor)
    else
        love.graphics.setColor(self.bgColor)
    end
    love.graphics.rectangle("fill", x, y, w, h)
    
    love.graphics.setColor(self.borderColor)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", x, y, w, h)
end

function Button:drawRounded(x, y, w, h)
    local radius = self.borderRadius
    
    love.graphics.setColor(0, 0, 0, self.shadowOpacity)
    love.graphics.rectangle("fill", x + 4, y + 4, w, h, radius)
    
    if self.pressed then
        love.graphics.setColor(self.pressColor)
    elseif self.hover then
        love.graphics.setColor(self.hoverColor)
    else
        love.graphics.setColor(self.bgColor)
    end
    love.graphics.rectangle("fill", x, y, w, h, radius)
    
    love.graphics.setColor(self.borderColor)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", x, y, w, h, radius)
end

function Button:drawGradient(x, y, w, h)
    if self.pressed then
        local r, g, b = unpack(self.pressColor)
        love.graphics.setColor(r, g, b)
    elseif self.hover then
        for i = 0, h, 2 do
            local progress = i / h
            local r = self.hoverColor[1] * (1 - progress) + self.bgColor[1] * progress
            local g = self.hoverColor[2] * (1 - progress) + self.bgColor[2] * progress
            local b = self.hoverColor[3] * (1 - progress) + self.bgColor[3] * progress
            love.graphics.setColor(r, g, b)
            love.graphics.rectangle("fill", x, y + i, w, 2)
        end
    else
        for i = 0, h, 2 do
            local progress = i / h
            local r = self.bgColor[1] * (1 - progress) + self.hoverColor[1] * progress * 0.5
            local g = self.bgColor[2] * (1 - progress) + self.hoverColor[2] * progress * 0.5
            local b = self.bgColor[3] * (1 - progress) + self.hoverColor[3] * progress * 0.5
            love.graphics.setColor(r, g, b)
            love.graphics.rectangle("fill", x, y + i, w, 2)
        end
    end
    
    love.graphics.setColor(1, 1, 1, 0.3)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", x, y, w, h)
end

function Button:drawOutline(x, y, w, h)
    if self.hover then
        love.graphics.setColor(self.hoverColor[1], self.hoverColor[2], self.hoverColor[3], 0.1)
        love.graphics.rectangle("fill", x, y, w, h)
    end
    
    if self.pressed then
        love.graphics.setColor(self.pressColor)
        love.graphics.setLineWidth(4)
    elseif self.hover then
        love.graphics.setColor(self.hoverColor)
        love.graphics.setLineWidth(3)
    else
        love.graphics.setColor(self.bgColor)
        love.graphics.setLineWidth(2)
    end
    love.graphics.rectangle("line", x, y, w, h)
    
    if not self.hover then
        self.textColor = self.bgColor
    else
        self.textColor = self.hoverColor
    end
end

function Button:drawNeon(x, y, w, h)
    if self.hover then
        for i = 1, 3 do
            local alpha = 0.2 - (i * 0.05)
            love.graphics.setColor(self.hoverColor[1], self.hoverColor[2], self.hoverColor[3], alpha)
            love.graphics.rectangle("fill", x - i*2, y - i*2, w + i*4, h + i*4, self.borderRadius + i)
        end
    end
    
    if self.pressed then
        love.graphics.setColor(self.pressColor)
    elseif self.hover then
        love.graphics.setColor(self.hoverColor)
    else
        love.graphics.setColor(self.bgColor)
    end
    love.graphics.rectangle("fill", x, y, w, h, self.borderRadius)
    
    love.graphics.setColor(1, 1, 1, 0.3)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", x + 2, y + 2, w - 4, h - 4, self.borderRadius - 2)
end

function Button:createStyled(text, x, y, action, style)
    return Button:new(text, x, y, nil, nil, action, nil, style)
end
