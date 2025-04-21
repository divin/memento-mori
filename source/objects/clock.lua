-- Define shorthands
local pd <const> = playdate
local gfx <const> = pd.graphics

--- @class Clock : _Sprite
class("Clock").extends(gfx.sprite)

--- Initializes the clock
--- @return nil
function Clock:init()
    Clock.super.init(self)

    self.lastTime = nil
    self:updateClock()

    local y = 8
    local width, _ = self:getImage():getSize()
    local x = pd.display.getWidth() - width - 42

    -- Add scene
    self:setZIndex(0)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()
end

--- Updates the clock
--- @return nil
function Clock:updateClock()
    local currentTime = pd.getTime()
    local hours = currentTime.hour
    local minutes = currentTime.minute

    if self.lastTime == nil then
        self.lastTime = pd.getTime()
        self:updateImage(hours, minutes)
    end

    if currentTime.hour == self.lastTime.hour and currentTime.minute == self.lastTime.minute then
        return
    end

    self:updateImage(hours, minutes)
    self.lastTime = currentTime
end

--- Updates the clock image
--- @return nil
function Clock:updateImage(hours, minutes)
    local text = string.format("%02d:%02d", hours, minutes)
    local width, height = gfx.getTextSize(text)
    local image = gfx.imageWithText(text, width, height, nil, nil, nil, kTextAlignment.center, FONT)
    self:setImage(image)
end

--- Updates the clock
--- @return nil
function Clock:update()
    self:updateClock()
end
