-- Define shorthands
local pd <const> = playdate
local gfx <const> = pd.graphics

--- @class Battery : _Sprite
class("Battery").extends(gfx.sprite)

--- Initializes the battery
--- @return nil
function Battery:init()
    Battery.super.init(self)

    self.status = nil
    self:updateBattery()

    local y = 10
    local width, _ = self:getImage():getSize()
    local x = pd.display.getWidth() - width - 8

    -- Add scene
    self:setZIndex(0)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()
end

--- Updates the battery status
--- @return nil
function Battery:updateBattery()
    local battery = pd.getBatteryPercentage()
    if 60 <= battery and self.status ~= "full" then
        self.status = "full"
        self:updateImage()
    elseif (30 <= battery and battery < 60) and self.status ~= "medium" then
        self.status = "medium"
        self:updateImage()
    elseif (10 <= battery and battery < 30) and self.status ~= "low" then
        self.status = "low"
        self:updateImage()
    end
end

--- Updates the battery image
--- @return nil
function Battery:updateImage()
    local image = gfx.image.new("assets/battery/" .. self.status)
    self:setImage(image)
end

--- Updates the battery
--- @return nil
function Battery:update()
    self:updateBattery()
end
