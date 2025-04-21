-- Define shorthands
local pd <const> = playdate
local gfx <const> = pd.graphics

--- @class ButtonLayout : _Sprite
class("ButtonLayout").extends(gfx.sprite)

--- Initializes the default button layout
--- @return nil
function ButtonLayout:init()
    ButtonLayout.super.init(self)

    -- Constants
    local displayWidth <const> = pd.display.getWidth()
    local displayHeight <const> = pd.display.getHeight()
    local systemFont <const> = gfx.getSystemFont()
    -- Assuming FONT is defined elsewhere and accessible in this scope
    local customFont <const> = PEDALLICA
    local iconTextPadding <const> = 8
    local bottomMargin <const> = 8
    local rightMargin <const> = 8      -- Margin from the right edge
    local interElementGap <const> = 16 -- Gap between Back and Confirm groups

    -- Calculate dimensions for each element group
    -- Back Group ("Ⓑ Back")
    local backIconText = "Ⓑ"
    local backTextText = "Back"
    local backIconWidth, backIconHeight = gfx.getTextSize(backIconText, systemFont)
    local backTextWidth, backTextHeight = gfx.getTextSize(backTextText, customFont)
    -- local backTotalWidth = backIconWidth + iconTextPadding + backTextWidth -- Not directly needed for right-align calculation

    -- Confirm Group ("Ⓐ Confirm")
    local confirmIconText = "Ⓐ"
    local confirmTextText = "Confirm"
    local confirmIconWidth, confirmIconHeight = gfx.getTextSize(confirmIconText, systemFont)
    local confirmTextWidth, confirmTextHeight = gfx.getTextSize(confirmTextText, customFont)
    -- local confirmTotalWidth = confirmIconWidth + iconTextPadding + confirmTextWidth -- Not directly needed for right-align calculation

    -- Calculate Y positions (aligning bottom edges)
    local backIconY = displayHeight - bottomMargin - backIconHeight
    local backTextY = displayHeight - bottomMargin - backTextHeight
    local confirmIconY = displayHeight - bottomMargin - confirmIconHeight
    local confirmTextY = displayHeight - bottomMargin - confirmTextHeight

    -- Calculate X positions (aligning to the right)
    local confirmTextX = displayWidth - rightMargin - confirmTextWidth
    local confirmIconX = confirmTextX - iconTextPadding - confirmIconWidth

    local backTextX = confirmIconX - interElementGap - backTextWidth
    local backIconX = backTextX - iconTextPadding - backIconWidth

    -- Create UI elements using calculated positions
    -- Back Group
    local buttonB = playui.text(backIconText, {
        x = backIconX,
        y = backIconY,
        width = backIconWidth,
        height = backIconHeight,
        font = systemFont,
    })
    local textB = playui.text(backTextText, {
        x = backTextX,
        y = backTextY,
        width = backTextWidth,
        height = backTextHeight,
        font = customFont,
    })

    -- Confirm Group
    local buttonA = playui.text(confirmIconText, {
        x = confirmIconX,
        y = confirmIconY,
        width = confirmIconWidth,
        height = confirmIconHeight,
        font = systemFont,
    })
    local textA = playui.text(confirmTextText, {
        x = confirmTextX,
        y = confirmTextY,
        width = confirmTextWidth,
        height = confirmTextHeight,
        font = customFont,
    })

    -- Add scene
    self:setZIndex(0)
    self:setCenter(0, 0)
    self:moveTo(0, 0)
    self:add()
end
