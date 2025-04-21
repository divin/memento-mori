-- Define shorthands
local pd <const> = playdate
local gfx <const> = pd.graphics

--- @class Birthday : _Sprite
class("Birthday").extends(gfx.sprite)

--- Initializes the birthday selection scene
--- @param country string The country selected in the previous scene
--- @param gender string The selected gender
--- @return nil
function Birthday:init(country, gender)
    Birthday.super.init(self)

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

    -- The selected country and gender
    self.country = country
    self.gender = gender

    -- The selected month, day, and year
    self.month = nil
    self.day = nil
    self.year = nil

    -- The text for the birthday selection
    text = "Select your birthday"
    width, height = gfx.getTextSize(text)
    self.text = playui.text(text, {
        x = (pd.display.getWidth() / 2) - (width / 2),
        y = 94 - (height / 2) - 16,
        width = width,
        height = height,
        font = PEDALLICA,
    })

    -- Parameters for the month, day, and year selections
    -- NOTE: I use a lot of hardcoded values here, it's not pretty but
    -- manually adjusted the values based on the design of the app
    local cellWidth = 44
    local gap = 24
    local totalWidth = cellWidth * 2 + 88 + gap * 2
    local x = (pd.display.getWidth() / 2) - (totalWidth / 2)
    local y = 94

    -- The month, day, and year selections
    self.months = range(1, 12, 1)
    self.monthSelection = playui.select({
        items = self.months,
        isVertical = true,
        cellHeight = 44,
        width = 44,
        height = 48,
        x = x,
        y = y,
        padding = 3,
        isFocused = true,
        drawCell = function(section, row, column, selected, x, y, width, height)
            if selected then
                gfx.drawRoundRect(x, y, width, height, 8)
            else
                gfx.drawRoundRect(x, y, width, height, 8)
            end
        end
    })

    text = "Month"
    width, height = gfx.getTextSize(text)
    self.monthText = playui.text(text, {
        x = x + (cellWidth / 2) - (width / 2) + 2,
        y = y + height + 40,
        width = width,
        height = height,
        font = PEDALLICA,
    })

    self.days = range(1, 31, 1)
    self.daySelection = playui.select({
        items = self.days,
        isVertical = true,
        cellHeight = 44,
        width = 44,
        height = 48,
        x = x + cellWidth + gap,
        y = y,
        padding = 3,
        isFocused = false,
        drawCell = function(section, row, column, selected, x, y, width, height)
            if selected then
                gfx.drawRoundRect(x, y, width, height, 8)
            else
                gfx.drawRoundRect(x, y, width, height, 8)
            end
        end
    })

    text = "Day"
    width, height = gfx.getTextSize(text)
    self.dayText = playui.text(text, {
        x = x + cellWidth + gap + (cellWidth / 2) - (width / 2) + 2,
        y = y + height + 40,
        width = width,
        height = height,
        font = PEDALLICA,
    })


    self.years = range(MIN_BIRTH_YEAR, MAX_BIRTH_YEAR, 1)
    self.yearSelection = playui.select({
        items = self.years,
        isVertical = true,
        cellHeight = 44,
        width = 88,
        height = 48,
        x = x + (cellWidth * 2) + gap * 2,
        y = y,
        padding = 3,
        isFocused = false,
        drawCell = function(section, row, column, selected, x, y, width, height)
            if selected then
                gfx.drawRoundRect(x, y, width, height, 8)
            else
                gfx.drawRoundRect(x, y, width, height, 8)
            end
        end
    })

    text = "Year"
    width, height = gfx.getTextSize(text)
    self.yearText = playui.text(text, {
        x = x + (cellWidth * 2) + gap * 2 + (88 / 2) - (width / 2),
        y = y + height + 40,
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
    self.upperTriangle:moveTo(76, 98)
    self.upperTriangle:add()

    image = gfx.image.new(12, 12)
    gfx.pushContext(image)
    gfx.fillTriangle(0, 0, 12, 0, 6, 12)
    gfx.popContext()
    self.lowerTriangle = gfx.sprite.new(image)
    self.lowerTriangle:setZIndex(1)
    self.lowerTriangle:setCenter(0.5, 1)
    self.lowerTriangle:moveTo(76, 94 + 48)
    self.lowerTriangle:add()

    -- Add scene
    self:setZIndex(-1)
    self:setCenter(0, 0)
    self:moveTo(0, 0)
    self:add()
end

--- Updates the birthday scene
--- @return nil
function Birthday:update()
    -- If month selection is focused
    if self.monthSelection.isFocused then
        if pd.buttonJustReleased(pd.kButtonA) then
            CONFIRM:playAt(0, 0.5)
            -- Get the selected month
            local _, row, _ = self.monthSelection:getSelection()
            self.month = self.months[row]

            -- Get the number of days in the selected month
            -- and update the day selection
            maxDays = MAX_DAYS_PER_MONTH[row]
            self.days = range(1, maxDays, 1)
            self.daySelection:setItems(self.days)

            -- Get the current selected day and adjust
            -- the selection if necessary
            _, row, _ = self.daySelection:getSelection()
            if row > #self.days then
                self.daySelection:setSelection(#self.days)
            end

            -- Move focus to the day selection
            self.monthSelection.isFocused = false
            self.daySelection.isFocused = true
            self.upperTriangle:moveBy(44 + 24, 0)
            self.lowerTriangle:moveBy(44 + 24, 0)
        elseif pd.buttonJustReleased(pd.kButtonB) then
            BACK:playAt(0, 0.5)
            SCENE_MANAGER:switchScene(Gender, self.country, self.gender)
        end
    elseif self.daySelection.isFocused then
        if pd.buttonJustReleased(pd.kButtonA) then
            CONFIRM:playAt(0, 0.5)
            -- Get the selected day
            local _, row, _ = self.daySelection:getSelection()
            self.day = self.days[row]

            -- Move focus to the year selection
            self.daySelection.isFocused = false
            self.yearSelection.isFocused = true
            self.upperTriangle:moveBy(44 + 24, 0)
            self.lowerTriangle:moveBy(44 + 24, 0)
        elseif pd.buttonJustReleased(pd.kButtonB) then
            BACK:playAt(0, 0.5)
            self.daySelection.isFocused = false
            self.monthSelection.isFocused = true
            self.upperTriangle:moveBy(-(44 + 24), 0)
            self.lowerTriangle:moveBy(-(44 + 24), 0)
        end
    elseif self.yearSelection.isFocused then
        if pd.buttonJustReleased(pd.kButtonA) then
            CONFIRM:playAt(0, 0.5)
            -- Get the selected year
            local _, row, _ = self.yearSelection:getSelection()
            self.year = self.years[row]

            local gender = (self.gender == "Diverse") and "Male" or self.gender
            SETTINGS = {
                country = self.country,
                gender = gender,
                month = self.month,
                day = self.day,
                year = self.year
            }
            pd.datastore.write(SETTINGS, "mmsettings")
            SCENE_MANAGER:switchScene(Game, self.country, gender, self.month, self.day, self.year)
        elseif pd.buttonJustReleased(pd.kButtonB) then
            BACK:playAt(0, 0.5)
            self.yearSelection.isFocused = false
            self.daySelection.isFocused = true
            self.upperTriangle:moveBy(-(44 + 24), 0)
            self.lowerTriangle:moveBy(-(44 + 24), 0)
        end
    end
end
