
local wibox = require("wibox")
local awful = require("awful")

-- Path to your lock script
local lock_script = "locknow"

-- Font Awesome icon
local lock_icon = " "  -- Font Awesome lock icon

-- Create a widget with Font Awesome icon
local lock_widget = wibox.widget {
    {
        text = lock_icon,
        font = "Hack 12",  -- Adjust the size as needed
        widget = wibox.widget.textbox,
    },
    layout = wibox.layout.fixed.horizontal,
}

-- Define a function to execute the lock script and log debug info
local function lock_screen()
    awful.spawn.with_shell(lock_script)
end

-- Bind mouse buttons to the widget
lock_widget:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        lock_screen()
    end)
))

return lock_widget
