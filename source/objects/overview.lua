-- Define shorthands
local pd <const> = playdate
local ui <const> = pd.ui
local gfx <const> = pd.graphics

--- @class Overview : _Sprite
class("Overview").extends(gfx.sprite)

--- Initializes the overview
--- @param birthday table The birthday table
--- @param lifeExpectancy number The life expectancy
--- @return nil
function Overview:init(birthday, lifeExpectancy)
    Overview.super.init(self)

    -- Keep track of time
    self.lastTime = pd.getTime()

    -- Gridview
    local padding = 8
    self.gridview = ui.gridview.new(pd.display.getWidth(), pd.display.getHeight())
    self.gridview.scrollCellsToCenter = false
    self.gridview:setCellPadding(padding, padding, padding, padding)
    self.gridview:setNumberOfColumns(5)
    self.gridview:setNumberOfRows(1)

    function self.gridview:drawCell(section, row, column, selected, x, y, width, height)
        local text = nil
        local textX, textY = nil, nil
        local textWidth, textHeight = nil, nil

        local currentTime = pd.getTime()
        local yearsLeft = lifeExpectancy - (currentTime.year - birthday.year)
        local monthsLeft = (yearsLeft * 12) - (currentTime.month - birthday.month)
        local weeksLeft = (yearsLeft * 52) - (currentTime.month - birthday.month) * 4 -
            (currentTime.day - birthday.day) / 7
        local daysLeft = (yearsLeft * 365) - (currentTime.month - birthday.month) * 30 -
            (currentTime.day - birthday.day)
        local percentageLived = ((currentTime.year - birthday.year) * 365 + (currentTime.month - birthday.month) * 30 +
            (currentTime.day - birthday.day)) / (lifeExpectancy * 365) * 100

        yearsLeft = math.max(0, yearsLeft)
        monthsLeft = math.max(0, monthsLeft)
        weeksLeft = math.max(0, weeksLeft)
        daysLeft = math.max(0, daysLeft)
        percentageLived = math.min(100, math.max(0, percentageLived))

        if column == 1 and selected then
            -- Draw the years left
            text                  = "Years left"
            textWidth, textHeight = gfx.getTextSize(text)
            textX                 = (pd.display.getWidth() / 2) - (textWidth / 2)
            textY                 = 94 - (textHeight / 2) - 16
            gfx.drawTextInRect(text, textX, textY, textWidth, textHeight, nil, nil, kTextAlignment.center, PEDALLICA)

            text = string.format("%d", math.floor(yearsLeft))
            textWidth, textHeight = gfx.getTextSizeForMaxWidth(text, width - padding, nil, ASHEVILLE)
            textX = (pd.display.getWidth() / 2) - (textWidth / 2)
            textY = y + ((pd.display.getHeight() - padding) / 2) - (textHeight / 2) + padding / 2
            gfx.drawTextInRect(text, textX, textY, textWidth, textHeight, nil, nil, kTextAlignment.center, ASHEVILLE)
        elseif column == 2 and selected then
            -- Draw the months left
            text                  = "Months left"
            textWidth, textHeight = gfx.getTextSize(text)
            textX                 = (pd.display.getWidth() / 2) - (textWidth / 2)
            textY                 = 94 - (textHeight / 2) - 16
            gfx.drawTextInRect(text, textX, textY, textWidth, textHeight, nil, nil, kTextAlignment.center, PEDALLICA)

            text = string.format("%d", math.floor(monthsLeft))
            textWidth, textHeight = gfx.getTextSizeForMaxWidth(text, width - padding, nil, ASHEVILLE)
            textX = (pd.display.getWidth() / 2) - (textWidth / 2)
            textY = y + ((pd.display.getHeight() - padding) / 2) - (textHeight / 2) + padding / 2
            gfx.drawTextInRect(text, textX, textY, textWidth, textHeight, nil, nil, kTextAlignment.center, ASHEVILLE)
        elseif column == 3 and selected then
            -- Draw the weeks left
            text                  = "Weeks left"
            textWidth, textHeight = gfx.getTextSize(text)
            textX                 = (pd.display.getWidth() / 2) - (textWidth / 2)
            textY                 = 94 - (textHeight / 2) - 16
            gfx.drawTextInRect(text, textX, textY, textWidth, textHeight, nil, nil, kTextAlignment.center, PEDALLICA)

            text = string.format("%d", math.floor(weeksLeft))
            textWidth, textHeight = gfx.getTextSizeForMaxWidth(text, width - padding, nil, ASHEVILLE)
            textX = (pd.display.getWidth() / 2) - (textWidth / 2)
            textY = y + ((pd.display.getHeight() - padding) / 2) - (textHeight / 2) + padding / 2
            gfx.drawTextInRect(text, textX, textY, textWidth, textHeight, nil, nil, kTextAlignment.center, ASHEVILLE)
        elseif column == 4 and selected then
            -- Draw the days left
            text                  = "Days left"
            textWidth, textHeight = gfx.getTextSize(text)
            textX                 = (pd.display.getWidth() / 2) - (textWidth / 2)
            textY                 = 94 - (textHeight / 2) - 16
            gfx.drawTextInRect(text, textX, textY, textWidth, textHeight, nil, nil, kTextAlignment.center, PEDALLICA)

            text = string.format("%d", math.floor(daysLeft))
            textWidth, textHeight = gfx.getTextSizeForMaxWidth(text, width - padding, nil, ASHEVILLE)
            textX = (pd.display.getWidth() / 2) - (textWidth / 2)
            textY = y + ((pd.display.getHeight() - padding) / 2) - (textHeight / 2) + padding / 2
            gfx.drawTextInRect(text, textX, textY, textWidth, textHeight, nil, nil, kTextAlignment.center, ASHEVILLE)
        elseif column == 5 and selected then
            -- Draw the percentage of life lived
            text                  = "Percentage of life lived"
            textWidth, textHeight = gfx.getTextSize(text)
            textX                 = (pd.display.getWidth() / 2) - (textWidth / 2)
            textY                 = 94 - (textHeight / 2) - 16
            gfx.drawTextInRect(text, textX, textY, textWidth, textHeight, nil, nil, kTextAlignment.center, PEDALLICA)

            text = string.format("%.2f", percentageLived) .. "%"
            textWidth, textHeight = gfx.getTextSizeForMaxWidth(text, width - padding, nil, ASHEVILLE)
            textX = (pd.display.getWidth() / 2) - (textWidth / 2)
            textY = y + ((pd.display.getHeight() - padding) / 2) - (textHeight / 2) + padding / 2
            gfx.drawTextInRect(text, textX, textY, textWidth, textHeight, nil, nil, kTextAlignment.center, ASHEVILLE)
        end
    end

    -- Add scene
    self:setZIndex(0)
    self:setCenter(0, 0)
    self:moveTo(0, 0)
    self:add()
end

--- Updates the overview
--- @return nil
function Overview:update()
    -- Input handling
    if pd.buttonJustReleased(pd.kButtonRight) then
        SELECT:playAt(0, 0.5)
        self.gridview:selectNextColumn(true, true, true)
    elseif pd.buttonJustReleased(pd.kButtonLeft) then
        SELECT:playAt(0, 0.5)
        self.gridview:selectPreviousColumn(true, true, true)
    end

    -- Update time if needed
    local currentTime = pd.getTime()
    local needsUpdate = (currentTime.hour ~= self.lastTime.hour or currentTime.minute ~= self.lastTime.minute)
    self.lastTime = currentTime

    -- Only redraw if the gridview needs to be updated
    if self.gridview.needsDisplay or needsUpdate then
        local width, height = pd.display.getWidth(), pd.display.getHeight()

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
