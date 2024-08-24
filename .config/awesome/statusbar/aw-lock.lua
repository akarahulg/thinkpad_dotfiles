
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")


-- Font Awesome icon
local lock_icon = " "   -- Font Awesome lock icon

-- Create a widget with Font Awesome icon
local power_widget = wibox.widget {
    {
        text = lock_icon,
        font = "Hack 12",  -- Adjust the size as needed
        widget = wibox.widget.textbox,
    },
    layout = wibox.layout.fixed.horizontal,
}

-- Define the dropdown menu items with custom icons and labels
local menu_items = {
    { " Lock", function() awful.spawn.with_shell('locknow') end },
    { " Suspend", function() awful.spawn.with_shell("systemctl suspend") end },
    { " Reboot", function() awful.spawn.with_shell("systemctl reboot") end },
    { " Poweroff", function() awful.spawn.with_shell("systemctl poweroff") end },
    { " Logout", function() awesome.quit() end },  -- Logout from AwesomeWM
}

-- Create the dropdown menu with simplified styling
local dropdown_menu = awful.menu({
    items = menu_items,
    theme = {
        width = 150,
        font = "Hack 12",  -- Font and size for menu items
        height = 20,  -- Height of menu items
        bg_normal = "#282A36",  -- Background color for menu items
        fg_normal = "#FFFFFF",  -- Text color for normal items
        bg_focus = "#1F778D",  -- Background color for focused item
        fg_focus = "#FFFFFF",  -- Text color for focused item
        border_width = 1,
        border_color = "#4C4C4C",
        shape = gears.shape.rounded_rect,  -- Rounded corners
    }
})

-- Bind mouse buttons to the widget
power_widget:buttons(awful.util.table.join(
    awful.button({}, 1, function()  -- Left click to show dropdown menu
        dropdown_menu:toggle()
    end)
))

return power_widget
