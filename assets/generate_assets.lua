-- Asset generator script
local love = require('love')

-- Initialize LÖVE
function love.load()
    -- Create assets directory if it doesn't exist
    os.execute('mkdir -p assets')
    
    -- Generate and save all assets
    local assets = {
        {'bird', require('bird')},
        {'pipe', require('pipe')},
        {'background', require('background')},
        {'ground', require('ground')}
    }
    
    for _, asset in ipairs(assets) do
        local name, canvas = asset[1], asset[2]
        local imageData = canvas:newImageData()
        imageData:encode('png', 'assets/' .. name .. '.png')
    end
    
    -- Exit after generating assets
    love.event.quit()
end

-- Empty draw function (required by LÖVE)
function love.draw()
end