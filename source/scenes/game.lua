-- Define shorthands
local pd <const> = playdate
local gfx <const> = pd.graphics

--- @class Game : _Sprite
class("Game").extends(gfx.sprite)

--- Initializes the game scene
--- @return nil
function Game:init(country, gender, month, day, year)
    Game.super.init(self)

    -- Default objects
    self.clock = Clock()
    self.battery = Battery()

    local text = "memento mori"
    local width, height = gfx.getTextSize(text)
    self.title = playui.text(text, {
        x = 8,
        y = 8,
        width = width,
        height = height,
        font = FONT,
    })

    -- Indicators
    local image = gfx.image.new(12, 12)
    gfx.pushContext(image)
    gfx.fillTriangle(0, 6, 12, 0, 12, 12)
    gfx.popContext()
    self.leftTriangle = gfx.sprite.new(image)
    self.leftTriangle:setZIndex(1)
    self.leftTriangle:setCenter(0, 0.5)
    self.leftTriangle:moveTo(8, pd.display.getHeight() / 2)
    self.leftTriangle:add()

    image = gfx.image.new(12, 12)
    gfx.pushContext(image)
    gfx.fillTriangle(0, 0, 0, 12, 12, 6)
    gfx.popContext()
    self.rightTriangle = gfx.sprite.new(image)
    self.rightTriangle:setZIndex(1)
    self.rightTriangle:setCenter(0, 0.5)
    self.rightTriangle:moveTo(pd.display.getWidth() - 12 - 8, pd.display.getHeight() / 2)
    self.rightTriangle:add()

    -- Get life expectancy
    local lifeExpectancy = LIFE_EXPECTANCY[country][year][gender]

    -- Life expectancy text
    text = "Life Expectancy: " .. string.format(math.floor(lifeExpectancy)) .. " Years"
    width, height = gfx.getTextSize(text)
    self.title = playui.text(text, {
        x = (pd.display.getWidth() / 2) - (width / 2),
        y = pd.display.getHeight() - height - 8,
        width = width,
        height = height,
        font = FONT,
    })

    -- Create birthday table
    local birthday = {
        month = month,
        day = day,
        year = year
    }

    -- Create gridview overview
    self.overview = Overview(birthday, lifeExpectancy)

    -- Add menu items
    local menu = pd.getSystemMenu()
    menu:addMenuItem("Reset Options", function()
        pd.display.setRefreshRate(30)
        SCENE_MANAGER:switchScene(Country)
    end)
    menu:addCheckmarkMenuItem("Lockscreen", false, function(value)
        if value then
            pd.display.setRefreshRate(1)
            pd.setAutoLockDisabled(true)
        else
            pd.display.setRefreshRate(30)
            pd.setAutoLockDisabled(false)
        end
    end)

    -- Add scene
    self:setZIndex(-1)
    self:setCenter(0, 0)
    self:moveTo(0, 0)
    self:add()
end
