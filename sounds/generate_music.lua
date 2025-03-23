-- Music generator script
local love = require('love')

-- Simple music generator using LÖVE's audio system
function love.load()
    -- Set up audio parameters
    local sampleRate = 44100
    local duration = 10  -- 10 seconds
    local numSamples = sampleRate * duration
    
    -- Create sound data
    local soundData = love.sound.newSoundData(numSamples, sampleRate, 16, 1)
    
    -- Generate a simple melody
    local baseFreq = 440  -- A4 note
    local notes = {1, 1.2, 1.5, 2}  -- Simple pentatonic scale
    local noteLength = sampleRate / 2  -- Half second per note
    
    for i = 0, numSamples - 1 do
        local time = i / sampleRate
        local noteIndex = math.floor(time * 2) % #notes + 1
        local freq = baseFreq * notes[noteIndex]
        
        -- Generate a simple sine wave with some variation
        local sample = math.sin(2 * math.pi * freq * time) * 0.3
        -- Add some variation
        sample = sample + math.sin(4 * math.pi * freq * time) * 0.1
        
        -- Apply envelope
        local envelope = 1 - (i % noteLength) / noteLength
        sample = sample * envelope * 0.5
        
        soundData:setSample(i, sample)
    end
    
    -- Save the sound file
    soundData:encode('mp3', 'background_music.mp3')
    
    -- Exit after generating music
    love.event.quit()
end

-- Empty draw function (required by LÖVE)
function love.draw()
end