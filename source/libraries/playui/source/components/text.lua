import "component"

--- Constants for accessing the Playdate SDK
--- These shorthand variables improve code readability and reduce typing
local pd <const> = playdate     -- Main playdate object
local ui <const> = pd.ui        -- UI components like gridview
local gfx <const> = pd.graphics -- Graphics functions and primitives

--kTextAlignments = {
--left = "left",
--center = "center",
--right = "right"
--}

kTextWraps = {
    wrap = "wrap",
    nowrap = "nowrap"
}

local defaults = {
    font = nil,
    fontFamily = nil,
    flex = nil,
    wrap = kTextWraps.wrap,
    alignment = kTextAlignment.center,
    stroke = 0,
    color = nil
}

--- Text Class
--- @class Text : Component
class("Text").extends(Component)

function Text:init(text, properties)
    Text.super.init(self, properties, defaults)

    self.properties = properties or {}
    self.maxWidth = self.properties.maxWidth or math.huge
    self.maxHeight = self.properties.maxHeight or math.huge

    self:setText(text or "")
end

function Text:setText(text)
    self.text = text
    self:updateImage()
end

function Text:updateImage()
    local width, height = self:getSize()
    local image = gfx.imageWithText(self.text, width, height, nil, nil, nil, kTextAlignment.center, self.properties.font)
    self:setImage(image)
end
