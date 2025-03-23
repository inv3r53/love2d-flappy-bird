-- Bird asset generator
local width, height = 32, 32
local canvas = love.graphics.newCanvas(width, height)

love.graphics.setCanvas(canvas)

-- Clear canvas with transparency
love.graphics.clear(0, 0, 0, 0)

-- Draw bird body (yellow circle)
love.graphics.setColor(1, 0.8, 0.2, 1)
love.graphics.circle('fill', width/2, height/2, width/3)

-- Draw wing (darker yellow)
love.graphics.setColor(0.9, 0.7, 0.1, 1)
love.graphics.polygon('fill', width/2, height/2, width*0.8, height*0.3, width*0.8, height*0.7)

-- Draw eye (black)
love.graphics.setColor(0, 0, 0, 1)
love.graphics.circle('fill', width*0.7, height*0.4, width/10)

-- Draw beak (orange)
love.graphics.setColor(1, 0.5, 0, 1)
love.graphics.polygon('fill', width*0.8, height/2, width, height*0.4, width, height*0.6)

love.graphics.setCanvas()
love.graphics.setColor(1, 1, 1, 1)

return canvas