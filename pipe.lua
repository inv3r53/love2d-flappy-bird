-- Pipe class
local Pipe = {}
Pipe.__index = Pipe

-- Constants
local PIPE_SPEED = 45
local PIPE_WIDTH = 54
local PIPE_GAP = 160
local PIPE_HEIGHT = 320

-- Create placeholder pipe graphic
local function createPlaceholderPipe()
    local canvas = love.graphics.newCanvas(PIPE_WIDTH, PIPE_HEIGHT)
    love.graphics.setCanvas(canvas)
    -- Draw a simple pipe shape
    love.graphics.clear(0.2, 0.8, 0.2, 1)  -- Green color
    love.graphics.setColor(0.1, 0.6, 0.1)  -- Darker green for depth
    love.graphics.rectangle('fill', 0, 0, 10, PIPE_HEIGHT)  -- Left edge
    love.graphics.rectangle('fill', PIPE_WIDTH - 10, 0, 10, PIPE_HEIGHT)  -- Right edge
    love.graphics.rectangle('fill', 0, 0, PIPE_WIDTH, 20)  -- Top cap
    love.graphics.setColor(1, 1, 1)
    love.graphics.setCanvas()
    return canvas
end

local pipeImage = nil

function Pipe:new(y)
    local pipe = {}
    setmetatable(pipe, Pipe)
    
    -- Load or create pipe image (only once)
    if not pipeImage then
        local success, err = pcall(function()
            pipeImage = love.graphics.newImage('assets/pipe.png')
        end)
        if not success then
            pipeImage = createPlaceholderPipe()
        end
    end
    pipe.image = pipeImage
    
    -- Position and dimensions
    pipe.x = love.graphics.getWidth()
    pipe.width = PIPE_WIDTH
    pipe.height = PIPE_HEIGHT
    
    -- Calculate pipe positions
    -- y is the center of the gap
    pipe.gapCenter = y
    
    -- Calculate the actual positions of the pipes
    pipe.upperY = y - PIPE_GAP / 2 - PIPE_HEIGHT  -- Top pipe's top position
    pipe.lowerY = y + PIPE_GAP / 2                -- Bottom pipe's top position
    
    -- Store the actual collision boundaries
    pipe.upperPipeBottom = y - PIPE_GAP / 2       -- Where the top pipe ends
    pipe.lowerPipeTop = y + PIPE_GAP / 2         -- Where the bottom pipe starts
    
    -- Debug flag (set to true to see collision boundaries)
    pipe.debugDraw = false
    
    -- Scoring
    pipe.scored = false
    
    return pipe
end

function Pipe:update(dt)
    self.x = self.x - PIPE_SPEED * dt
end

function Pipe:render()
    -- Draw upper pipe
    love.graphics.draw(
        self.image,
        self.x,
        self.upperY
    )
    
    -- Draw lower pipe
    love.graphics.draw(
        self.image,
        self.x,
        self.lowerY
    )
    
    -- Debug visualization of collision boundaries
    if self.debugDraw then
        love.graphics.setColor(1, 0, 0, 0.5)
        -- Upper pipe collision line
        love.graphics.line(self.x, self.upperPipeBottom, self.x + self.width, self.upperPipeBottom)
        -- Lower pipe collision line
        love.graphics.line(self.x, self.lowerPipeTop, self.x + self.width, self.lowerPipeTop)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

return Pipe