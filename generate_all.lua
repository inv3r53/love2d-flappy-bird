-- Asset generation script
local love = require('love')

function love.load()
    -- Generate images
    print("Generating images...")
    local imageAssets = {
        {'bird', require('assets/bird')},
        {'pipe', require('assets/pipe')},
        {'background', require('assets/background')},
        {'ground', require('assets/ground')}
    }
    
    for _, asset in ipairs(imageAssets) do
        local name, canvas = asset[1], asset[2]
        local imageData = canvas:newImageData()
        local filename = 'assets/' .. name .. '.png'
        imageData:encode('png', filename)
        print("Generated " .. filename)
    end
    
    -- Generate music
    print("\nGenerating music...")
    require('sounds/generate_music')
    print("Generated sounds/background_music.mp3")
    
    print("\nAll assets generated successfully!")
    love.event.quit()
end

function love.draw()
end