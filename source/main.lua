-- Playdate SDK Core Libraries
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

-- Import libraries
import "libraries/sceneManager"
import "libraries/playui/source/playui"

-- Import objects
import "constants"
import "objects/clock"
import "objects/battery"
import "objects/overview"
import "objects/buttonLayout"

-- Import scenes
import "scenes/game"
import "scenes/intro/gender"
import "scenes/intro/country"
import "scenes/intro/birthday"

-- Define shorthands
local pd <const> = playdate
local gfx <const> = pd.graphics

-- Set font
PEDALLICA = gfx.font.new("assets/pedallica/font-pedallica")
ASHEVILLE = gfx.font.new("assets/asheville/Asheville-Rounded-24-px")
gfx.setFont(PEDALLICA)
gfx.setFontTracking(2)

-- Set refresh rate
pd.display.setRefreshRate(30)

-- Seed random number generator
math.randomseed(pd.getSecondsSinceEpoch())

-- Create menu image
local padding = 12
local text =
"This app estimates life expectancy using WHO data based on your country, gender, and birthdate.\n\nEnable 'lockscreen' mode for 1 FPS display and disabled auto-lock.\n\nImportant: This is an estimate. Lifestyle choices significantly impact lifespan."
local image = gfx.image.new(400, 240, gfx.kColorBlack)
local originalMode = gfx.getImageDrawMode()
gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
gfx.pushContext(image)
gfx.drawTextInRect(text, padding, padding, 200 - padding, 240 - padding, nil, nil, kTextAlignment.left, PEDALLICA)
gfx.popContext()
gfx.setImageDrawMode(originalMode)
pd.setMenuImage(image)

-- Sound
CONFIRM = pd.sound.sample.new("assets/sounds/confirm")
BACK = pd.sound.sample.new("assets/sounds/back")
SELECT = pd.sound.sample.new("assets/sounds/select")

-- Get settings from JSON file if it exists
SETTINGS = nil
if pd.file.exists("mmsettings.json") then
    SETTINGS = pd.datastore.read("mmsettings")
end

-- Switch to the game menu scene
SCENE_MANAGER = SceneManager()

-- Depending on the settings, switch to the appropriate scene
if SETTINGS then
    SCENE_MANAGER:switchScene(Game, SETTINGS.country, SETTINGS.gender, SETTINGS.month, SETTINGS.day, SETTINGS.year)
else
    SCENE_MANAGER:switchScene(Country)
end

-- Set the background color
pd.display.setInverted(true)

-- Simple range function
-- @param start The starting number
-- @param stop The ending number
-- @param step The step size (default is 1)
-- @return A table containing the range of numbers
function range(start, stop, step)
    local result = {}
    step = step or 1

    for i = start, stop, step do
        result[#result + 1] = i -- More efficient than table.insert
    end

    return result
end

-- Main loop
function pd.update()
    -- Update sprite & timers
    gfx.sprite.update()
    pd.timer.updateTimers()
end
