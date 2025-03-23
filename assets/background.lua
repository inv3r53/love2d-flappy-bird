-- Background asset generator
local width, height = 400, 512
local canvas = love.graphics.newCanvas(width, height)

love.graphics.setCanvas(canvas)

-- Sky gradient
local function drawGradient()
    for y = 0, height do
        local factor = y / height
        local r = 0.4 + factor * 0.2
        local g = 0.6 + factor * 0.1
        local b = 1.0 - factor * 0.3
        love.graphics.setColor(r, g, b, 1)
        love.graphics.line(0, y, width, y)
    end
end

-- Draw sky
drawGradient()

-- Draw clouds
love.graphics.setColor(1, 1, 1, 0.7)
for i = 1, 5 do
    local x = math.random(0, width)
    local y = math.random(0, height/2)
    local size = math.random(30, 60)
    for j = 1, 3 do
        love.graphics.circle('fill', x + j*20, y, size/2)
    end
end

love.graphics.setCanvas()
love.graphics.setColor(1, 1, 1, 1)

return canvas