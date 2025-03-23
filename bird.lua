-- Bird class
local Bird = {}
Bird.__index = Bird

-- Create placeholder bird graphic
local function createPlaceholderBird()
    local canvas = love.graphics.newCanvas(32, 32)
    love.graphics.setCanvas(canvas)
    -- Draw a simple bird shape
    love.graphics.clear(1, 0.8, 0.2, 1)  -- Yellow color
    love.graphics.setColor(1, 0.6, 0.1)  -- Orange color
    love.graphics.polygon('fill', 8, 16, 24, 8, 24, 24)  -- Wing
    love.graphics.setColor(1, 0.4, 0.1)  -- Dark orange for beak
    love.graphics.polygon('fill', 26, 14, 32, 16, 26, 18)  -- Beak
    love.graphics.setColor(1, 1, 1)
    love.graphics.setCanvas()
    return canvas
end

function Bird:new()
    local bird = {}
    setmetatable(bird, Bird)
    
    -- Try to load bird image or use placeholder
    local success, err = pcall(function()
        bird.image = love.graphics.newImage('assets/bird.png')
    end)
    if not success then
        bird.image = createPlaceholderBird()
    end
    
    -- Dimensions
    bird.width = bird.image:getWidth()
    bird.height = bird.image:getHeight()
    
    -- Position and physics
    bird.x = love.graphics.getWidth() / 4
    bird.y = love.graphics.getHeight() / 2
    bird.dy = 0
    bird.gravity = 500
    bird.jumpForce = -250
    bird.rotation = 0
    
    return bird
end

function Bird:update(dt)
    -- Apply gravity
    self.dy = self.dy + self.gravity * dt
    self.y = self.y + self.dy * dt
    
    -- Update rotation based on velocity
    self.rotation = math.min(math.max(-math.pi/6, self.dy * 0.0005), math.pi/4)
end

function Bird:jump()
    self.dy = self.jumpForce
end

function Bird:render()
    love.graphics.draw(
        self.image,
        self.x,
        self.y,
        self.rotation,
        1,
        1,
        self.width / 2,
        self.height / 2
    )
end

function Bird:collides(pipe)
    -- Add a small buffer to make collision more forgiving
    local COLLISION_BUFFER = 2
    
    -- Calculate bird's collision box with a slightly smaller hitbox
    local birdLeft = self.x - self.width / 2 + COLLISION_BUFFER
    local birdRight = self.x + self.width / 2 - COLLISION_BUFFER
    local birdTop = self.y - self.height / 2 + COLLISION_BUFFER
    local birdBottom = self.y + self.height / 2 - COLLISION_BUFFER
    
    -- Only check for collision if the bird is horizontally aligned with the pipe
    if birdRight > pipe.x and birdLeft < pipe.x + pipe.width then
        -- Check collision with upper pipe
        if birdTop < pipe.upperPipeBottom then
            return true
        end
        
        -- Check collision with lower pipe
        if birdBottom > pipe.lowerPipeTop then
            return true
        end
    end
    
    return false
end

return Bird