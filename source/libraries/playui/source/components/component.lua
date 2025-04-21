-- Define shorthands
local pd <const> = playdate
local gfx <const> = pd.graphics

--- @class Component : _Sprite
class("Component").extends(gfx.sprite)

--- Initializes the component
--- @param properties table A table of arguments to configure the component
--- @param defaults table A table of default values for the component
function Component:init(properties, defaults)
    Component.super.init(self)

    -- Store parameters with sensible defaults
    self.properties = properties or {}

    -- Merge properties with defaults
    for key, value in pairs(defaults) do
        if self.properties[key] == nil then
            self.properties[key] = value
        end
    end

    self.parent = self.properties.parent or nil                                -- Parent component
    self:setSize(self.properties.width or 0, self.properties.height or 0)      -- Set the size of the sprite
    self:setCenter(self.properties.centerX or 0, self.properties.centerY or 0) -- Set anchor point
    self:setZIndex(self.properties.zIndex or 0)                                -- Set the z-index of the sprite
    self:moveTo(self.properties.x or 0, self.properties.y or 0)                -- Position the sprite
    self:add()                                                                 -- Add sprite to the display list
end
