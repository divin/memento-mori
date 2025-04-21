import "component"

--- Constants for accessing the Playdate SDK
--- These shorthand variables improve code readability and reduce typing
local pd <const> = playdate     -- Main playdate object
local ui <const> = pd.ui        -- UI components like gridview
local gfx <const> = pd.graphics -- Graphics functions and primitives

local defaults = {
    items = {},
    isVertical = true,
    cellWidth = 100,
    cellHeight = 30,
    width = 200,
    height = 100,
    x = 0,
    y = 0,
    centerX = 0,
    centerY = 0,
    padding = 0,
    drawCell = nil
}

--- Select Class
--- A customizable selection menu that can be displayed either vertically or horizontally.
--- Extends the sprite class and internally uses gridview to handle selection behavior.
class("Select").extends(Component)

--- Initialize a new Select component
--- @param args table A table of arguments to configure the selection menu
--- @param args.items table Array of items to display in the menu (default: {})
--- @param args.isVertical boolean? Whether the selection menu displays vertically (default: true)
--- @param args.cellWidth number? Width of each cell in pixels (default: 100)
--- @param args.cellHeight number? Height of each cell in pixels (default: 30)
--- @param args.width number? Total width of the selection menu (default: 200)
--- @param args.height number? Total height of the selection menu (default: 100)
--- @param args.x number? X position of the menu (default: 0)
--- @param args.y number? Y position of the menu (default: 0)
--- @param args.centerX number? X center point for the sprite (default: 0)
--- @param args.centerY number? Y center point for the sprite (default: 0)
--- @param args.padding number? Padding between cells (default: 0)
--- @param args.drawCell function? Custom function to draw each cell (optional)
--- @param args.isFocused boolean? Whether the selection menu is currently focused (default: false)
--- @param args.selection string? Initial selection of the provided items (optional)
function Select:init(properties)
    -- Call parent constructor first to set up the sprite
    Select.super.init(self, properties, defaults)

    self.items = properties.items or {}              -- Items to display in the selection menu
    self.isVertical = properties.isVertical ~= false -- Default to vertical if not specified
    self.cellWidth = properties.cellWidth or 100     -- Width of each cell
    self.cellHeight = properties.cellHeight or 30    -- Height of each cell
    self.padding = properties.padding or 0           -- Padding around each cell
    self.customDrawCell = properties.drawCell or nil -- Custom drawing function (optional)
    self.isFocused = properties.isFocused or false   -- Whether the selection menu is currently focused (optional)
    self.selection = properties.selection or nil     -- Initial selection (optional)

    -- Create the underlying gridview with appropriate dimensions
    -- For vertical lists, we use the full width (0) to make cells span the entire width
    -- This causes the gridview to automatically size cell width to fit available space
    if self.isVertical then
        self.gridview = ui.gridview.new(0, self.cellHeight)
    else
        self.gridview = ui.gridview.new(self.cellWidth, self.cellHeight)
    end

    self.gridview.scrollCellsToCenter = true

    -- Add padding to all sides of each cell (left, top, right, bottom)
    self.gridview:setCellPadding(self.padding, self.padding, self.padding, self.padding)

    -- Configure grid dimensions based on orientation
    self:setItems(self.items)

    -- Set the initial selection based on the provided selection
    self:setSelection(self.selection)

    -- Store reference to the Select instance for access within closure
    -- This is needed because 'self' will refer to gridview inside drawCell
    local selectInstance = self

    --- Define the cell drawing function for the gridview
    --- This function is called by the gridview for each visible cell
    --- @param section number The section index (unused in this implementation)
    --- @param row number The row index of the cell
    --- @param column number The column index of the cell
    --- @param selected boolean Whether this cell is currently selected
    --- @param x number The x position to draw the cell
    --- @param y number The y position to draw the cell
    --- @param width number The width of the cell
    --- @param height number The height of the cell
    function self.gridview:drawCell(section, row, column, selected, x, y, width, height)
        if selectInstance.customDrawCell then
            -- Use custom drawing function if provided
            selectInstance.customDrawCell(section, row, column, selected, x, y, width, height)
        else
            -- Default drawing implementation
            if selected then
                -- Fill selected cells with a solid rectangle
                gfx.fillRect(x, y, width, height)
            else
                -- Draw an outline for unselected cells
                gfx.drawRect(x, y, width, height)
            end
        end

        -- Get the correct item based on orientation
        local index = selectInstance.isVertical and row or column
        local item = selectInstance.items[index]

        if item then
            -- Note: textColor is defined but unused, could be used in future
            local textColor = selected and gfx.kColorWhite or gfx.kColorBlack

            -- Set appropriate draw mode based on selection state
            -- Selected text is white on black background, unselected is black on white
            -- gfx.setImageDrawMode(selected and gfx.kDrawModeFillWhite or gfx.kDrawModeCopy)

            -- Draw the item text centered within the cell with a small margin
            local padding = 8
            local textWidth, textHeight = gfx.getTextSizeForMaxWidth(tostring(item), width - padding)
            local textY = y + ((height - padding) / 2) - (textHeight / 2) + padding / 2
            gfx.drawTextInRect(tostring(item), x + padding / 2, textY, width - padding, height - padding,
                nil, nil, kTextAlignment.center)
        end
    end
end

--- Set the items to be displayed in the selection menu
--- @param items table Array of items to display
--- @return nil
function Select:setItems(items)
    self.items = items
    if self.isVertical then
        -- Vertical list has one column and multiple rows
        self.gridview:setNumberOfColumns(1)
        self.gridview:setNumberOfRows(#self.items)
    else
        -- Horizontal list has one row and multiple columns
        self.gridview:setNumberOfRows(1)
        self.gridview:setNumberOfColumns(#self.items)
    end
end

--- Set selection to a specific item
--- @param selection any The item to select
--- @return nil
function Select:setSelection(selection)
    if not selection then
        return
    end

    -- Find the index of the item in the list
    local index = table.indexOfElement(self.items, selection)
    if index then
        if self.isVertical then
            self.gridview:setSelection(1, index, 1)
            self.gridview:scrollCellToCenter(1, index, 1, true)
        else
            self.gridview:setSelection(1, 1, index)
            self.gridview:scrollCellToCenter(1, 1, index, true)
        end
    end
end

--- Reset the selection to the first item
--- @return nil
function Select:resetSelection()
    self.gridview:setSelection(1, 1, 1)
    self.gridview:scrollCellToCenter(1, 1, 1, true)
end

--- Get the current selection coordinates
--- @return number, number, number: The section, row, and column of the selected item
function Select:getSelection()
    return self.gridview:getSelection()
end

--- Select the next item in the list
--- @param wrapSelection boolean: Whether selection wraps at the end
--- @param scrollToSelection boolean: Whether to scroll to show the selection
--- @param animate boolean: Whether to animate the scroll
function Select:selectNext(wrapSelection, scrollToSelection, animate)
    if self.isVertical then
        -- In vertical mode, move to next row
        self.gridview:selectNextRow(wrapSelection, scrollToSelection, animate)
    else
        -- In horizontal mode, move to next column
        self.gridview:selectNextColumn(wrapSelection, scrollToSelection, animate)
    end
end

--- Select the previous item in the list
--- @param wrapSelection boolean: Whether selection wraps at the beginning
--- @param scrollToSelection boolean: Whether to scroll to show the selection
--- @param animate boolean: Whether to animate the scroll
function Select:selectPrevious(wrapSelection, scrollToSelection, animate)
    if self.isVertical then
        -- In vertical mode, move to previous row
        self.gridview:selectPreviousRow(wrapSelection, scrollToSelection, animate)
    else
        -- In horizontal mode, move to previous column
        self.gridview:selectPreviousColumn(wrapSelection, scrollToSelection, animate)
    end
end

--- Update the Select's visual representation
--- Called automatically by the Playdate runtime each frame
function Select:update()
    if self.isFocused then
        local crankTicks = pd.getCrankTicks(4)
        if pd.buttonJustReleased(pd.kButtonUp) or crankTicks == -1 then
            self:selectPrevious(true, true, true)
            SELECT:playAt(0, 0.5)
        elseif pd.buttonJustReleased(pd.kButtonDown) or crankTicks == 1 then
            self:selectNext(true, true, true)
            SELECT:playAt(0, 0.5)
        end
    end

    -- Only redraw if the gridview needs to be updated
    if self.gridview.needsDisplay then
        local width, height = self:getSize()

        -- Create a new image of appropriate size
        local image = gfx.image.new(width, height)

        -- Draw the gridview onto the image
        gfx.pushContext(image)
        self.gridview:drawInRect(0, 0, width, height)
        gfx.popContext()

        -- Update the sprite with the new image
        self:setImage(image)
    end
end
