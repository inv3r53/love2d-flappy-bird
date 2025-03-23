-- Pipe asset generator
local width, height = 54, 320
local canvas = love.graphics.newCanvas(width, height)

love.graphics.setCanvas(canvas)

-- Clear canvas with transparency
love.graphics.clear(0, 0, 0, 0)

-- Main pipe body (green)
love.graphics.setColor(0.2, 0.8, 0.2, 1)
love.graphics.rectangle('fill', 0, 0, width, height)

-- Darker edges for depth
love.graphics.setColor(0.1, 0.6, 0.1, 1)
love.graphics.rectangle('fill', 0, 0, 5, height)  -- Left edge
love.graphics.rectangle('fill', width-5, 0, 5, height)  -- Right edge

-- Pipe cap
love.graphics.rectangle('fill', -2, 0, width+4, 20)
love.graphics.setColor(0.15, 0.7, 0.15, 1)
love.graphics.rectangle('fill', -2, 0, width+4, 5)

love.graphics.setCanvas()
love.graphics.setColor(1, 1, 1, 1)

return canvas