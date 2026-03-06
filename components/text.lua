Text = {}
Text.__index = Text

function Text:new(text, x, y, size)
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    size = size or 24

    if x == nil then
        x = screenW / 2
    end

    if y == nil then
        y = screenH / 2
    end

    local txt = {
        text = text,
        x = x,
        y = y,
        color = {1,1,1},
        font = love.graphics.newFont(size)
    }

    setmetatable(txt, Text)
    return txt
end


function Text:setColor(r,g,b)
    self.color = {r,g,b}
end


function Text:draw()
    love.graphics.setFont(self.font)
    love.graphics.setColor(self.color)
    love.graphics.printf(self.text, 0, self.y, love.graphics.getWidth(), "center")
end
