-- Import libraries
import "CoreLibs/ui"
import "CoreLibs/crank"
import "CoreLibs/graphics"
import "CoreLibs/keyboard"

-- Import components
import "components/flex"
import "components/text"
import "components/select"

-- Interface
playui = {
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
    select = function(args)
        return Select(args)
    end,
    flex = function(args)
        return Flex(args)
    end,
    text = function(text, properties)
        return Text(text, properties)
    end,
}

playui.VERSION = "0.1.0"
