-- Main game file
local Bird = require('bird')
local Pipe = require('pipe')

-- Game states
local GAME_STATE = {
    MENU = 1,
    PLAYING = 2,
    GAME_OVER = 3
}

-- Game variables
local gameState = GAME_STATE.MENU
local bird = nil
local pipes = {}
local score = 0
local highScore = 0
local pipeSpawnTimer = 0
local pipeSpawnInterval = 2.5  -- Increased from 1.5 to 2.5 seconds
local groundScroll = 0
local groundScrollSpeed = 60
local backgroundScroll = 0
local backgroundScrollSpeed = 30
local BACKGROUND_LOOPING_POINT = 413

-- Sound variables
local backgroundMusic = nil

function love.load()
    -- Set up window
    love.window.setMode(288, 512, {
        vsync = true,
        fullscreen = false,
        resizable = false
    })
    
    -- Load assets
    background = love.graphics.newImage('assets/background.png')
    ground = love.graphics.newImage('assets/ground.png')
    
    -- Load and set up background music
    backgroundMusic = love.audio.newSource('sounds/background_music.mp3', 'stream')
    backgroundMusic:setLooping(true)
    backgroundMusic:setVolume(0.5) -- Set volume to 50%
    backgroundMusic:play()
    
    -- Initialize game objects
    bird = Bird:new()
    
    -- Set up fonts
    gameFont = love.graphics.newFont(14)
    scoreFont = love.graphics.newFont(28)
    love.graphics.setFont(gameFont)
    
    -- Initialize RNG
    math.randomseed(os.time())
end

function love.update(dt)
    if gameState == GAME_STATE.PLAYING then
        -- Update bird
        bird:update(dt)
        
        -- Spawn pipes
        pipeSpawnTimer = pipeSpawnTimer + dt
        if pipeSpawnTimer > pipeSpawnInterval then
            local y = math.random(150, love.graphics.getHeight() - 150)
            table.insert(pipes, Pipe:new(y))
            pipeSpawnTimer = 0
        end
        
        -- Update pipes
        for i, pipe in ipairs(pipes) do
            pipe:update(dt)
            
            -- Check collision
            if bird:collides(pipe) then
                gameState = GAME_STATE.GAME_OVER
                if score > highScore then
                    highScore = score
                end
            end
            
            -- Check if passed pipe
            if not pipe.scored and pipe.x + pipe.width < bird.x then
                score = score + 1
                pipe.scored = true
            end
        end
        
        -- Remove pipes that are off screen
        for i = #pipes, 1, -1 do
            if pipes[i].x + pipes[i].width < 0 then
                table.remove(pipes, i)
            end
        end
        
        -- Update ground scroll
        groundScroll = (groundScroll + groundScrollSpeed * dt) % BACKGROUND_LOOPING_POINT
        backgroundScroll = (backgroundScroll + backgroundScrollSpeed * dt) % BACKGROUND_LOOPING_POINT
        
        -- Check ground collision
        if bird.y + bird.height >= love.graphics.getHeight() - 16 then
            gameState = GAME_STATE.GAME_OVER
            if score > highScore then
                highScore = score
            end
        end
    end
end

function love.draw()
    -- Draw background
    love.graphics.draw(background, -backgroundScroll, 0)
    
    -- Draw pipes
    for _, pipe in ipairs(pipes) do
        pipe:render()
    end
    
    -- Draw ground
    love.graphics.draw(ground, -groundScroll, love.graphics.getHeight() - 16)
    
    -- Draw bird
    bird:render()
    
    -- Draw score
    love.graphics.setFont(scoreFont)
    love.graphics.printf(tostring(score), 0, 20, love.graphics.getWidth(), 'center')
    
    -- Draw game state messages
    love.graphics.setFont(gameFont)
    if gameState == GAME_STATE.MENU then
        love.graphics.printf('Press Space to Start', 0, 150, love.graphics.getWidth(), 'center')
    elseif gameState == GAME_STATE.GAME_OVER then
        love.graphics.printf('Game Over!', 0, 150, love.graphics.getWidth(), 'center')
        love.graphics.printf('Score: ' .. score, 0, 180, love.graphics.getWidth(), 'center')
        love.graphics.printf('High Score: ' .. highScore, 0, 200, love.graphics.getWidth(), 'center')
        love.graphics.printf('Press Space to Restart', 0, 220, love.graphics.getWidth(), 'center')
    end
end

function love.keypressed(key)
    if key == 'space' then
        if gameState == GAME_STATE.MENU then
            gameState = GAME_STATE.PLAYING
        elseif gameState == GAME_STATE.PLAYING then
            bird:jump()
        elseif gameState == GAME_STATE.GAME_OVER then
            -- Reset game
            gameState = GAME_STATE.MENU
            bird = Bird:new()
            pipes = {}
            score = 0
            pipeSpawnTimer = 0
        end
    elseif key == 'd' then  -- Debug visualization toggle
        for _, pipe in ipairs(pipes) do
            pipe.debugDraw = not pipe.debugDraw
        end
    elseif key == 'm' then
        -- Toggle music on/off
        if backgroundMusic:isPlaying() then
            backgroundMusic:pause()
        else
            backgroundMusic:play()
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then -- Left click
        if gameState == GAME_STATE.MENU then
            gameState = GAME_STATE.PLAYING
        elseif gameState == GAME_STATE.PLAYING then
            bird:jump()
        end
    end
end