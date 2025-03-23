-- Ground asset generator
local width, height = 400, 112
local canvas = love.graphics.newCanvas(width, height)

love.graphics.setCanvas(canvas)

-- Base ground color
love.graphics.setColor(0.8, 0.6, 0.3, 1)
love.graphics.rectangle('fill', 0, 0, width, height)

-- Add texture
love.graphics.setColor(0.7, 0.5, 0.2, 1)
for i = 0, width, 20 do
    love.graphics.rectangle('fill', i, 0, 10, height)
end

-- Add grass tufts
love.graphics.setColor(0.4, 0.8, 0.3, 1)
for i = 0, width, 15 do
    local height_var = math.random(5, 10)
    love.graphics.polygon('fill', 
        i, 0,
        i + 5, -height_var,
        i + 10, 0
    )
end

love.graphics.setCanvas()
love.graphics.setColor(1, 1, 1, 1)

return canvas