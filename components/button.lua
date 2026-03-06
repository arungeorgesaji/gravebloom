Button = {}
Button.__index = Button

function Button:new(text, x, y, width, height, action, size)
    width = width or 200
    height = height or 60

    size = size or 24

    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

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
        font = love.graphics.newFont(size)
    }
    setmetatable(btn, Button)
    return btn
end

function Button:update(dt)
    local mx, my = love.mouse.getPosition()

    self.hover =
        mx > self.x and mx < self.x + self.width and
        my > self.y and my < self.y + self.height
end

function Button:mousepressed(x, y, button)
    if button == 1 and self.hover then
        self.action()
    end
end

function Button:draw()
    if self.hover then
        love.graphics.setColor(0.8, 0.8, 0.8)
    else
        love.graphics.setColor(0.5, 0.5, 0.5)
    end

    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    love.graphics.setColor(0, 0, 0)

    love.graphics.setFont(self.font)
    love.graphics.printf(self.text, self.x, self.y + self.height/3, self.width, "center")
end
