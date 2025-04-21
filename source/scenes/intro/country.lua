-- Define shorthands
local pd <const> = playdate
local gfx <const> = pd.graphics

--- @class Country : _Sprite
class("Country").extends(gfx.sprite)

--- Initializes the country selection scene
--- @param country string? The country selected (optional)
--- @return nil
function Country:init(country)
    Country.super.init(self)

    -- Default objects
    self.clock = Clock()
    self.battery = Battery()
    self.buttonLayout = ButtonLayout()

    local text = "memento mori"
    local width, height = gfx.getTextSize(text)
    self.title = playui.text(text, {
        x = 8,
        y = 8,
        width = width,
        height = height,
        font = PEDALLICA,
    })

    -- Make sure the countries are sorted
    table.sort(COUNTRIES)

    -- Show selection menu
    self.selection = playui.select({
        items = COUNTRIES,
        isVertical = true,
        cellWidth = 0,
        cellHeight = 44,
        width = 178,
        height = 48,
        x = 111,
        y = 94,
        padding = 3,
        isFocused = true,
        drawCell = function(section, row, column, selected, x, y, width, height)
            if selected then
                gfx.drawRoundRect(x, y, width, height, 8)
            else
                gfx.drawRoundRect(x, y, width, height, 8)
            end
        end,
        selection = country or nil
    })

    text = "Select your country"
    width, height = gfx.getTextSize(text)
    self.text = playui.text(text, {
        x = (pd.display.getWidth() / 2) - (width / 2),
        y = 94 - (height / 2) - 16,
        width = width,
        height = height,
        font = PEDALLICA,
    })

    -- Indicator triangles
    local image = gfx.image.new(12, 12)
    gfx.pushContext(image)
    gfx.fillTriangle(6, 0, 12, 12, 0, 12)
    gfx.popContext()
    self.upperTriangle = gfx.sprite.new(image)
    self.upperTriangle:setZIndex(1)
    self.upperTriangle:setCenter(0.5, 0)
    self.upperTriangle:moveTo(98, 98)
    self.upperTriangle:add()

    image = gfx.image.new(12, 12)
    gfx.pushContext(image)
    gfx.fillTriangle(0, 0, 12, 0, 6, 12)
    gfx.popContext()
    self.lowerTriangle = gfx.sprite.new(image)
    self.lowerTriangle:setZIndex(1)
    self.lowerTriangle:setCenter(0.5, 1)
    self.lowerTriangle:moveTo(98, 94 + 48)
    self.lowerTriangle:add()

    -- Add scene
    self:setZIndex(-1)
    self:setCenter(0, 0)
    self:moveTo(0, 0)
    self:add()
end

--- Updates the country scene
--- @return nil
function Country:update()
    -- If country is selected move to next scene
    if pd.buttonJustReleased(pd.kButtonA) then
        CONFIRM:playAt(0, 0.5)
        local _, row, _ = self.selection:getSelection()
        local country = COUNTRIES[row]
        SCENE_MANAGER:switchScene(Gender, country)
    end
end
