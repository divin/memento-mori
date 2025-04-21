import "component"

--- Constants for accessing the Playdate SDK
--- These shorthand variables improve code readability and reduce typing
local pd <const> = playdate     -- Main playdate object
local ui <const> = pd.ui        -- UI components like gridview
local gfx <const> = pd.graphics -- Graphics functions and primitives

local defaults = {}

--- Flex Class
--- @class Flex : Component
--- @classdesc A class that extends the gfx.sprite class to create a flexible grid view for displaying items.
--- This class is designed to be used with the Playdate SDK and provides a customizable grid view for displaying items.
class("Flex").extends(Component)

--- Initializes the Flex class
--- @param args table A table of arguments to configure the grid view
--- @param args.items table Array of items to display in the grid view (default: {})
function Flex:init(properties)
    -- Call parent constructor first to set up the sprite
    Flex.super.init(self, properties, defaults)

    self.items = properties.items or {}            -- Items to display in the grid view
    self.direction = properties.direction or "row" -- Direction of the grid view (row or column)
    self.align = properties.align or "start"       -- Alignment of items in the grid view
    self.justify = properties.justify or "start"   -- Justification of items in the grid view
    self.wrap = properties.wrap or "nowrap"        -- Whether to wrap items in the grid view
    self.gap = properties.gap or 0                 -- Gap between items in the grid view

    self:applyLayout()
end

function Flex:moveTo(x, y)
    Flex.super.moveTo(self, x, y)
    self:applyLayout()
end

--- Apply the flex layout to the items
function Flex:applyLayout()
    if self.direction == "row" then
        self:layoutRow()
    elseif self.direction == "column" then
        self:layoutColumn()
    end
end

--- Get x start position for the layout
--- @return number x The starting X position
function Flex:getXStartPosition()
    local x, _ = self:getPosition()
    local width, _ = self:getSize()
    local totalItemWidth = self:getTotalWidth()

    if self.justify == "center" then
        x = x + (width - totalItemWidth) / 2
    elseif self.justify == "end" then
        x = width - totalItemWidth
    end

    return x
end

--- Get y start position for the layout
--- @return number y The starting Y position
function Flex:getYStartPosition()
    local _, y = self:getPosition()
    local _, height = self:getSize()
    local totalHeight = self:getTotalHeight()

    if self.align == "center" then
        y = y + (height - totalHeight) / 2
    elseif self.align == "end" then
        y = height - totalHeight
    end

    return y
end

--- Get total height of the flex layout
--- @return number The total height of the flex layout
function Flex:getTotalHeight()
    local totalHeight = 0
    if self.direction == "column" then
        for _, item in ipairs(self.items) do
            local _, height = item:getSize()
            totalHeight = totalHeight + height + self.gap
        end
        totalHeight = totalHeight - self.gap -- Subtract the last gap
    else
        local maxHeight = 0
        for _, item in ipairs(self.items) do
            local _, height = item:getSize()
            if height > maxHeight then
                maxHeight = height
            end
        end
        totalHeight = maxHeight
    end
    return totalHeight
end

--- Get total width of the flex layout
--- @return number The total width of the flex layout
function Flex:getTotalWidth()
    local totalWidth = 0
    if self.direction == "row" then
        for _, item in ipairs(self.items) do
            local width, _ = item:getSize()
            totalWidth = totalWidth + width + self.gap
        end
        totalWidth = totalWidth - self.gap -- Subtract the last gap
    else
        local maxWidth = 0
        for _, item in ipairs(self.items) do
            local width, _ = item:getSize()
            if width > maxWidth then
                maxWidth = width
            end
        end
        totalWidth = maxWidth
    end

    return totalWidth
end

--- Layout items in a row
function Flex:layoutRow()
    local x = self:getXStartPosition()
    local y = self:getYStartPosition()
    for _, item in ipairs(self.items) do
        local width, height = item:getSize()
        item:moveTo(x, y)

        -- Calculate the next position based on the item's width and gap
        x = x + width + self.gap

        -- Check if we need to wrap to the next row
        if self.wrap == "wrap" and x > width then
            x = 0
            y = y + height + self.gap
        end
    end
end

--- Layout items in a column
function Flex:layoutColumn()
    local x = self:getXStartPosition()
    local y = self:getYStartPosition()
    for _, item in ipairs(self.items) do
        item:moveTo(x, y)
        local width, height = item:getSize()

        -- Calculate the next position based on the item's height and gap
        y = y + height + self.gap

        -- Check if we need to wrap to the next column
        if self.wrap == "wrap" and y > height then
            y = 0
            x = x + width + self.gap
        end
    end
end
